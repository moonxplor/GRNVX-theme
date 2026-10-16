#define _GNU_SOURCE
#include <dlfcn.h>
#include <QResource>
#include <QtQml>
#include <QProcess>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QTimer>
#include <cstdio>
#include <cstring>
#include <errno.h>

extern char *program_invocation_short_name;

static bool is_plasmashell() {
    return program_invocation_short_name && (strcmp(program_invocation_short_name, "plasmashell") == 0);
}

static void register_rcc() {
    if (!is_plasmashell()) return;
    QResource::registerResource("/home/moonxplor/.local/share/plasma/overrides.rcc");
}

class DisplayAdjuster : public QObject {
    Q_OBJECT
    Q_PROPERTY(int contrast READ contrast WRITE setContrast NOTIFY contrastChanged)
    Q_PROPERTY(int sharpness READ sharpness WRITE setSharpness NOTIFY sharpnessChanged)
    Q_PROPERTY(int vividness READ vividness WRITE setVividness NOTIFY vividnessChanged)

public:
    static DisplayAdjuster* instance() {
        static DisplayAdjuster inst;
        return &inst;
    }

    DisplayAdjuster() {
        m_applyTimer = new QTimer(this);
        m_applyTimer->setSingleShot(true);
        m_applyTimer->setInterval(150);
        connect(m_applyTimer, &QTimer::timeout, this, &DisplayAdjuster::applyNow);
        loadSettings();
    }

    int contrast() const { return m_contrast; }
    int sharpness() const { return m_sharpness; }
    int vividness() const { return m_vividness; }

    void setContrast(int val) {
        if (m_contrast != val) {
            m_contrast = val;
            Q_EMIT contrastChanged();
            apply();
        }
    }

    void setSharpness(int val) {
        if (m_sharpness != val) {
            m_sharpness = val;
            Q_EMIT sharpnessChanged();
            apply();
        }
    }

    void setVividness(int val) {
        if (m_vividness != val) {
            m_vividness = val;
            Q_EMIT vividnessChanged();
            apply();
        }
    }

    Q_INVOKABLE void apply() {
        if (m_applyTimer) {
            m_applyTimer->start();
        } else {
            applyNow();
        }
    }

    void applyNow() {
        QStringList args;
        args << QStringLiteral("--contrast") << QString::number(m_contrast)
             << QStringLiteral("--sharpness") << QString::number(m_sharpness)
             << QStringLiteral("--vividness") << QString::number(m_vividness);
        QProcess::startDetached(QStringLiteral("/home/moonxplor/.local/bin/plasma-apply-display-adjustments"), args);
    }

Q_SIGNALS:
    void contrastChanged();
    void sharpnessChanged();
    void vividnessChanged();

private:
    void loadSettings() {
        m_contrast = 50;
        m_sharpness = 50;
        m_vividness = 50;

        QFile file(QStringLiteral("/home/moonxplor/.config/display-adjustments.json"));
        if (file.open(QIODevice::ReadOnly)) {
            QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
            if (doc.isObject()) {
                QJsonObject obj = doc.object();
                if (obj.contains(QStringLiteral("contrast"))) m_contrast = obj[QStringLiteral("contrast")].toInt(50);
                if (obj.contains(QStringLiteral("sharpness"))) m_sharpness = obj[QStringLiteral("sharpness")].toInt(50);
                if (obj.contains(QStringLiteral("vividness"))) m_vividness = obj[QStringLiteral("vividness")].toInt(50);
            }
        }
    }

    QTimer* m_applyTimer = nullptr;
    int m_contrast = 50;
    int m_sharpness = 50;
    int m_vividness = 50;
};

__attribute__((constructor))
static void on_load() {
    if (!is_plasmashell()) return;
    register_rcc();

    qmlRegisterSingletonType<DisplayAdjuster>("org.kde.plasma.private.displayadjuster", 1, 0, "DisplayAdjuster",
        [](QQmlEngine *, QJSEngine *) -> QObject * {
            return DisplayAdjuster::instance();
        });
}

typedef void* (*dlopen_func_t)(const char*, int);

extern "C" void* dlopen(const char* filename, int flags) {
    static dlopen_func_t real_dlopen = (dlopen_func_t)dlsym(RTLD_NEXT, "dlopen");
    if (!real_dlopen) {
        real_dlopen = (dlopen_func_t)dlsym(RTLD_DEFAULT, "dlopen");
    }
    void* handle = real_dlopen(filename, flags);
    if (is_plasmashell() && filename && strstr(filename, "systemtray.so")) {
        register_rcc();
    }
    return handle;
}

#include "libplasma_rcc_hook.moc"

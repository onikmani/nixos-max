# MAX Messenger for NixOS

Установка **MAX Messenger** на NixOS из официального Linux `.deb` пакета MAX.

Проект упаковывает официальный Debian-пакет MAX в Nix derivation и запускает приложение внутри FHS-окружения с необходимыми библиотеками Qt, X11/XCB, PipeWire, OpenGL, GTK и другими runtime-зависимостями.

## Проверено

Проект протестирован на:

* **NixOS 26.05 (Yarara)**
* **KDE Plasma 6**
* **x86_64-linux**
* **Nix 2.34.8**

Проверено:

* сборка `max.nix` проходит успешно;
* пакет MAX успешно собирается в `/nix/store`;
* команда `max` успешно запускается;
* графическое приложение MAX успешно запускается в KDE Plasma 6.

## Возможности

* MAX Messenger работает на NixOS.
* Не требуется вручную устанавливать `.deb`.
* Зависимости Linux-приложения предоставляются через Nix.
* Используется FHS environment для совместимости с бинарным Linux-приложением.
* Создаётся команда `max`.
* Создаётся `.desktop` файл для запуска MAX из меню приложений.
* Конкретная версия пакета фиксируется через SHA-256.

## Требования

* NixOS
* `nixpkgs`
* архитектура `x86_64-linux`
* включённая поддержка запуска графических приложений

## Быстрая установка

Клонировать репозиторий:

```bash
git clone https://github.com/onikmani/nixos-max.git
cd nixos-max
```

Собрать пакет:

```bash
nix-build ./max.nix
```

После успешной сборки запустить:

```bash
./result/bin/max
```

## Установка в NixOS

Можно добавить пакет непосредственно в `/etc/nixos/configuration.nix`.

Например:

```nix
environment.systemPackages = with pkgs; [
  # другие пакеты

  (pkgs.callPackage /home/onikmani/nixos-max/max.nix {})
];
```

Затем применить конфигурацию:

```bash
sudo nixos-rebuild switch
```

После этого:

```bash
max
```

будет доступен в системе.

## Если используется `pkexec`

В конфигурациях, где `sudo` не используется напрямую, можно применить:

```bash
pkexec nixos-rebuild switch
```

## Как это работает

Официальный `.deb` пакет MAX скачивается через `fetchurl`:

```nix
maxDeb = pkgs.fetchurl {
  url = "...";
  sha256 = "...";
};
```

Затем пакет распаковывается с помощью `dpkg`, а содержимое MAX помещается в Nix store.

Сам MAX запускается внутри `buildFHSEnvBubblewrap`, поскольку это готовое бинарное Linux-приложение, рассчитанное на традиционную FHS-структуру Linux.

В окружение добавлены необходимые библиотеки:

* Qt/WebEngine runtime
* X11
* XCB
* XKB
* OpenGL / Mesa
* DRM / GBM
* ALSA
* PulseAudio
* PipeWire
* GTK
* DBus
* Fontconfig
* NSS / NSPR
* libgcrypt / libgpg-error
* GDK Pixbuf

## Почему нужен FHS

Обычный NixOS не предоставляет `/usr/lib`, `/usr/lib64` и другие стандартные Linux-пути так, как ожидают бинарные приложения, собранные для Debian/Ubuntu.

MAX распространяется как готовый бинарный `.deb`, поэтому вместо пересборки приложения из исходников используется FHS-окружение.

Это позволяет MAX находить необходимые библиотеки и запускаться без изменения самого бинарного файла.

## Обновление MAX

При выходе новой версии MAX необходимо обновить:

```nix
version = "...";
```

URL `.deb`:

```nix
url = "...";
```

и SHA-256:

```nix
sha256 = "...";
```

После этого проверить сборку:

```bash
nix-build ./max.nix
```

и запустить:

```bash
./result/bin/max
```

## Важное замечание

Этот проект **не содержит бинарный пакет MAX**.

При сборке Nix скачивает официальный `.deb` с серверов MAX.

Официальные Linux-пакеты MAX:

https://download.max.ru/linux-repos

Официальный сайт загрузки MAX:

https://download.max.ru/

## Автор

**onikmani**

GitHub:

https://github.com/onikmani

Репозиторий:

https://github.com/onikmani/nixos-max

## Лицензия

Этот репозиторий содержит Nix-выражение для упаковки стороннего программного обеспечения.

Лицензия самого MAX определяется правообладателем MAX и не изменяется этим проектом.

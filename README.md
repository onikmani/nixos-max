# MAX Messenger для NixOS

Декларативный пакет MAX Messenger для NixOS.

Пакет использует официальный DEB-пакет MAX и автоматически
создаёт FHS-окружение с необходимыми библиотеками для запуска
Qt/WebEngine-приложения на NixOS.

## Установка

Скопировать `max.nix`:

    git clone https://github.com/onikmani/nixos-max.git
    cd nixos-max

Проверить сборку:

    nix-build ./max.nix

Запустить:

    ./result/bin/max

## Подключение к configuration.nix

Добавить в `environment.systemPackages`:

    (pkgs.callPackage /путь/к/max.nix {})

После этого применить конфигурацию:

    sudo nixos-rebuild switch

После установки команда:

    max

## Что входит

- официальный MAX DEB;
- FHS-окружение;
- Qt/X11/XCB библиотеки;
- libxkbfile;
- libxcb-cursor;
- PipeWire/ALSA;
- libgcrypt + libgpg-error;
- GTK/DBus;
- desktop-файл;
- запуск через обычную команду `max`.

## Версия

MAX 26.26.0

Источник:

https://download.max.ru/linux/deb/pool/main/m/max/MAX-26.26.0.76189.deb

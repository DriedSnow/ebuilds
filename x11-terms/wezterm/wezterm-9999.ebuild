# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Modded to be a live package

EAPI=8

inherit bash-completion-r1 desktop cargo git-r3 xdg-utils

DESCRIPTION="A GPU-accelerated cross-platform terminal emulator and multiplexer"
HOMEPAGE="https://wezfurlong.org/wezterm/"

EGIT_REPO_URI="https://github.com/wezterm/wezterm.git"
EGIT_BRANCH="main"
EGIT_SUBMODULES=( "*" )

EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"

LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions Artistic-2 BSD BSD-2 Boost-1.0 CC0-1.0 GPL-3 ISC LGPL-2.1 MIT MPL-2.0 Unicode-DFS-2016 Unlicense WTFPL-2 ZLIB"
SLOT="0"
KEYWORDS=""
IUSE="wayland"
RESTRICT=test

RDEPEND="
	dev-libs/openssl
	wayland? ( dev-libs/wayland )
	media-fonts/jetbrains-mono
	media-fonts/noto
	media-fonts/noto-emoji
	media-fonts/roboto
	media-libs/fontconfig
	media-libs/mesa
	sys-apps/dbus
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libxkbcommon[X,wayland?]
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-themes/hicolor-icon-theme
	x11-themes/xcursor-themes
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/cmake
	dev-vcs/git
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/bin/.*"

S="${EGIT_CHECKOUT_DIR}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	echo "git-main-gentoo" > .tag || die

	default
}

src_configure() {
	local myfeatures=(
		distro-defaults
		vendor-nerd-font-symbols-font
		$(usev wayland)
	)
	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile
}

src_install() {
	exeinto /usr/bin
	doexe "$(cargo_target_dir)/wezterm"
	doexe "$(cargo_target_dir)/wezterm-gui"
	doexe "$(cargo_target_dir)/wezterm-mux-server"
	doexe "$(cargo_target_dir)/strip-ansi-escapes"

	insinto /usr/share/icons/hicolor/128x128/apps
	newins assets/icon/terminal.png org.wezfurlong.wezterm.png

	newmenu assets/wezterm.desktop org.wezfurlong.wezterm.desktop

	insinto /usr/share/metainfo
	newins assets/wezterm.appdata.xml org.wezfurlong.wezterm.appdata.xml

	newbashcomp assets/shell-completion/bash ${PN}

	insopts -m 0644
	insinto /usr/share/zsh/site-functions
	newins assets/shell-completion/zsh _${PN}

	insopts -m 0644
	insinto /usr/share/fish/vendor_completions.d
	newins assets/shell-completion/fish ${PN}.fish
}

pkg_postinst() {
	xdg_icon_cache_update
	einfo "It may be necessary to configure wezterm to use a cursor theme, see:"
	einfo "https://wezfurlong.org/wezterm/faq.html?highlight=xcursor_theme#i-use-x11-or-wayland-and-my-mouse-cursor-theme-doesnt-seem-to-work"
}

pkg_postrm() {
	xdg_icon_cache_update
}

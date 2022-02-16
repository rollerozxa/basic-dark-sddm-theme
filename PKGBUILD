pkgname=sddm-theme-basic-dark
pkgver=r1.7514b35
pkgrel=1
pkgdesc="Basic Dark theme for SDDM"
arch=('any')
url="https://github.com/rollerozxa/basic-dark-sddm-theme"
license=('CCPL:cc-by-sa')
depends=('sddm')
makedepends=('git')
_theme_name='basicdark'
_repo_name='basic-dark-sddm-theme'
source=("git+https://github.com/rollerozxa/basic-dark-sddm-theme.git")
md5sums=('SKIP')

pkgver() {
	cd "${_repo_name}"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
	install -d "${pkgdir}"/usr/share/sddm/themes/"${_theme_name}"
	cp -r "${srcdir}/${_repo_name}"/* "${pkgdir}"/usr/share/sddm/themes/"${_theme_name}"/
}

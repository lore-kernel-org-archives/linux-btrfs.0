Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbcELOpo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 10:45:44 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: autogen: Make build success in CentOS 6
 and 7
To: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <61ca47efb3599997cf0eb7431f31e92f3819546a.1463049696.git.zhaolei@cn.fujitsu.com>
 <bbac238126b7efc3ae8307dbc65902634ff15c45.1463049696.git.zhaolei@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9620ebe4-e282-d35f-b99c-981b11957e05@suse.com>
Date: Thu, 12 May 2016 10:45:35 -0400
MIME-Version: 1.0
In-Reply-To: <bbac238126b7efc3ae8307dbc65902634ff15c45.1463049696.git.zhaolei@cn.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2JRht42A7kujqq6dND0nKgPr77fMewil1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2JRht42A7kujqq6dND0nKgPr77fMewil1
Content-Type: multipart/mixed; boundary="odT8rA1CIh9nsaxbpnJ9RRd9rq4R9fm1p"
From: Jeff Mahoney <jeffm@suse.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <9620ebe4-e282-d35f-b99c-981b11957e05@suse.com>
Subject: Re: [PATCH 2/3] btrfs-progs: autogen: Make build success in CentOS 6
 and 7
References: <61ca47efb3599997cf0eb7431f31e92f3819546a.1463049696.git.zhaolei@cn.fujitsu.com>
 <bbac238126b7efc3ae8307dbc65902634ff15c45.1463049696.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <bbac238126b7efc3ae8307dbc65902634ff15c45.1463049696.git.zhaolei@cn.fujitsu.com>

--odT8rA1CIh9nsaxbpnJ9RRd9rq4R9fm1p
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 5/12/16 6:42 AM, Zhao Lei wrote:
> btrfs-progs build failed in CentOS 6 and 7:
>  #./autogen.sh
>  ...
>  configure.ac:131: error: possibly undefined macro: PKG_CHECK_VAR
>       If this token and others are legitimate, please use m4_pattern_al=
low.
>       See the Autoconf documentation.
>  ...
>=20
> Seems PKG_CHECK_VAR is new in pkgconfig 0.28 (24-Jan-2013):
> http://redmine.audacious-media-player.org/boards/1/topics/736
>=20
> And the max available version for CentOS 7 in yum-repo and
> rpmfind.net is: pkgconfig-0.27.1-4.el7
> http://rpmfind.net/linux/rpm2html/search.php?query=3Dpkgconfig&submit=3D=
Search+...&system=3Dcentos&arch=3D
>=20
> I updated my pkgconfig to 0.30, but still failed at above error.
> (Maybe it is my setting problem)
>=20
> To make user in centos 6 and 7 building btrfs-progs without
> more changes, we can avoid using PKG_CHECK_VAR in following
> way found in:
> https://github.com/audacious-media-player/audacious-plugins/commit/f95a=
b6f939ecf0d9232b3165f9241d2ea9676b9e
>=20
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/configure.ac b/configure.ac
> index 4688bc7..a754990 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -128,7 +128,7 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
>  PKG_CHECK_MODULES(ZLIB, [zlib])
>  PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
> =20
> -PKG_CHECK_VAR([UDEVDIR], [udev], [udevdir])
> +UDEVDIR=3D"$(pkg-config udev --variable=3Dudevdir)"

You need, minimally, AC_SUBST(UDEVDIR) here as well.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--odT8rA1CIh9nsaxbpnJ9RRd9rq4R9fm1p--

--2JRht42A7kujqq6dND0nKgPr77fMewil1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXNJcSAAoJEB57S2MheeWyLCsP/2i6LcDuCPqxXbb3gAPfdmrF
Wse0p8L8csTSJqSq+1Ws/JBF9Gdr/Nfpv+g2JHOMuH+zBiQRyWmIS/OtHOBxFTT6
LOySdO2A5gDueoxVf9D7/CPT0fntd91sx5IPB9o3wt+Usk4Co8PQsxbtqrskP3Cg
r8anhrOwJXSbui7VC1kHdeAdWLgcSW0EvADPxNuYD+OOfLWZGEXWYqnI8AIuMwDI
uyctFC8ZF5UDMi3aOh0KuR0OAf5KnUUPUjZvqsw4BW7+GZSRUFfcNcZ9OCVIf3gg
DmWEZ3hUgpIjT2RlhAl/nwZeyTWpTmPZ0ehHZekAq23F72SAxeIeSaQHMMg5RPQP
uC6RF+uPzCjB+tiA4gk2vmdyFb3RglwX8l+pEFbNigjLyNif4xyeut81mhaaiJNU
FCHnRnRqTvmK8FlkHrLj575AajdxljlxEl2SALBAgF50a5ZPmo/5vVG8g9bNVpTz
o67yKKdmRHM8xgCxu8Eh6spBf5QAuVglfVFfN0QA3e53x49zn4CWXJ4UnxxHmVsT
Qh9zv729Bsx8LotvLhJtvso0HsRwZK7e1kpYTpDJZTpVpoQD3WRrEhL0nf2/GyY2
tlZz9kUoG8uC8a0XpxXLmiZdlTnq1CYVHXc9mveNdqOwtju4Iv1nQhr9NteR+C1s
won2yAEuGNbvTlquBTQ7
=+zOS
-----END PGP SIGNATURE-----

--2JRht42A7kujqq6dND0nKgPr77fMewil1--

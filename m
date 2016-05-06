Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758634AbcEFTaT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 May 2016 15:30:19 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 71D15ABF6
	for <linux-btrfs@vger.kernel.org>; Fri,  6 May 2016 19:30:17 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: udev: add rules for dm devices
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9075ce67-6d99-f096-8b70-fc5d872a1412@suse.com>
Date: Fri, 6 May 2016 15:30:14 -0400
MIME-Version: 1.0
In-Reply-To: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DWFLcQdasLLvV24xjWUqP28Qk7DENlt9T"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DWFLcQdasLLvV24xjWUqP28Qk7DENlt9T
Content-Type: multipart/mixed; boundary="PIhb6o4CvjBwsdSsbsrQ0FuEfFK55COEA"
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <9075ce67-6d99-f096-8b70-fc5d872a1412@suse.com>
Subject: Re: [PATCH] btrfs-progs: udev: add rules for dm devices
References: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>
In-Reply-To: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>

--PIhb6o4CvjBwsdSsbsrQ0FuEfFK55COEA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 5/6/16 3:27 PM, Jeff Mahoney wrote:
> Systemd's btrfs rule runs btrfs dev ready on each device
> as it's discovered.  The btrfs command is executed as a builtin
> command via an IMPORT{builtin} rule, which means it gets
> executed at rule evaluation time, not rule execution time.  That
> means that the device mapper links haven't been setup yet and the only
> nodes that can be depended upon are /dev/dm-#.  That we see
> /dev/mapper/name names in /proc/mounts is only because we replace the
> device name we have cached with the one passed in via mount.  If
> we have a multi-device file system and the primary device is removed,
> the remaining devices will show /dev/dm-#.  In addition, if the
> udev rule is executed again by someone generating a change event (e.g.
> partprobe), the names are also replaced by the /dev/dm-# names.
>=20
> This patch adds a new rule that adds a run rule that calls btrfs dev
> ready again using the device mapper links once they're created.

I did submit this initially to the systemd folks and they said it
belonged in the device-mapper package.  I'm not convinced.
Device-mapper has no business worrying about how to properly tell btrfs
about its friendly names.  We'll leave the debate of why it is that
systemd has any business implementing its own btrfs ready command and
using it to provide a udev rule but NOT this part of it for another day.

-Jeff


> ---
>  64-btrfs-dm.rules | 10 ++++++++++
>  Makefile.in       |  7 +++++++
>  configure.ac      |  2 ++
>  3 files changed, 19 insertions(+)
>  create mode 100644 64-btrfs-dm.rules
>=20
> diff --git a/64-btrfs-dm.rules b/64-btrfs-dm.rules
> new file mode 100644
> index 0000000..bbe1c35
> --- /dev/null
> +++ b/64-btrfs-dm.rules
> @@ -0,0 +1,10 @@
> +SUBSYSTEM!=3D"block", GOTO=3D"btrfs_end"
> +KERNEL!=3D"dm-[0-9]*", GOTO=3D"btrfs_end"
> +ACTION!=3D"add|change", GOTO=3D"btrfs_end"
> +ENV{ID_FS_TYPE}!=3D"btrfs", GOTO=3D"btrfs_end"
> +
> +# Once the device mapper symlink is created, tell btrfs about it
> +# so we get the friendly name in /proc/mounts (and tools that read it)=

> +ENV{DM_NAME}=3D=3D"?*", TEST=3D=3D"/dev/mapper/$env{DM_NAME}", RUN{bui=
ltin}+=3D"btrfs ready /dev/mapper/$env{DM_NAME}"
> +
> +LABEL=3D"btrfs_end"
> diff --git a/Makefile.in b/Makefile.in
> index 19697ff..d555f6a 100644
> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -83,11 +83,15 @@ libbtrfs_headers =3D send-stream.h send-utils.h sen=
d.h rbtree.h btrfs-list.h \
>  	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
>  TESTS =3D fsck-tests.sh convert-tests.sh
> =20
> +udev_rules =3D 64-btrfs-dm.rules
> +
>  prefix ?=3D @prefix@
>  exec_prefix =3D @exec_prefix@
>  bindir =3D @bindir@
>  libdir ?=3D @libdir@
>  incdir =3D @includedir@/btrfs
> +udevdir =3D @UDEVDIR@
> +udevruledir =3D ${udevdir}/rules.d
> =20
>  ifeq ("$(origin V)", "command line")
>    BUILD_VERBOSE =3D $(V)
> @@ -377,6 +381,9 @@ install: $(libs) $(progs_install) $(INSTALLDIRS)
>  	cp -a $(lib_links) $(DESTDIR)$(libdir)
>  	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
>  	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
> +ifneq ($(udevdir), "")
> +	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
> +endif
> =20
>  install-static: $(progs_static) $(INSTALLDIRS)
>  	for p in $(progs_static) ; do \
> diff --git a/configure.ac b/configure.ac
> index fc343ea..4af7474 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -124,6 +124,8 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
>  PKG_CHECK_MODULES(ZLIB, [zlib])
>  PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
> =20
> +PKG_CHECK_VAR([UDEVDIR], [udev], [udevdir])
> +
>  dnl lzo library does not provide pkg-config, let use classic way
>  AC_CHECK_LIB([lzo2], [lzo_version], [
>  	LZO2_LIBS=3D"-llzo2"
>=20


--=20
Jeff Mahoney
SUSE Labs


--PIhb6o4CvjBwsdSsbsrQ0FuEfFK55COEA--

--DWFLcQdasLLvV24xjWUqP28Qk7DENlt9T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXLPDGAAoJEB57S2MheeWyUykP/09tDXnE8QxcQjuM3FYQbdxv
74+FUoT1qJs8GeDDICVoGGj0a8tt6/QyixVI6m/Sf9AzQ9FRnmWv55makCnvLxg+
d6vPMnd/aN10CZViKHDjAAtHQU9i/CQBEq0zpFMEUjNvm6Fro/lskUFik5ZHYwBH
ud4aZKf818mVC1HAdQZG8MEMOFHgZqOHx3an+DrhePYlfbijEU+WBbOBGJZW/bgA
b43XRgLwU3DSHrvXzUHKqpdpXmYkY4LmEwVdY5KKE3pTnPQshUC7vA+vdCPWplVb
QeSTEEdopBPIVhFxff/TnhGE7xaeEjJEoHwDO4no0eE2/jbd/A+Sit4SfyLFIf6W
oDZZrAfryWtV7EgOwp6h0EzPkYFLp2wGpflds4zNzqwPiyC8pS90m30aMAquGbmm
82x0uCIVKnzkby2xUreXIPWSj+oqThI3CKdLfl5Qqw/7KJnUVMvzZ/p+cooT1gIO
VqZ0SiB1EEY5su3/k+aKsXMuA0aTxMjGcDV2L4pQuRKPkhx8uIPc35+XC7xGp8BF
MkbjtrBhb4ivq4QKle3KOzSp4zE9rylk5FJxrpn+C6b0drXtbAwKd/f7UfBdGNc9
JLACeNIRB7QDxDuR9kV6ybckYyUTn/84pmmgcy4Jx8zYOw+Fv9ZP/guQpDMFvi7e
muXtyP31zy6zA12ZXZyY
=2/nD
-----END PGP SIGNATURE-----

--DWFLcQdasLLvV24xjWUqP28Qk7DENlt9T--

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:45579 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbbDSMOo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 08:14:44 -0400
Date: Sun, 19 Apr 2015 17:05:03 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Lauri =?UTF-8?B?VsO1c2FuZGk=?= <lauri.vosandi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: optionally enforce chroot for btrfs
 receive
Message-ID: <20150419170503.4d888c04@natsu>
In-Reply-To: <1429443988-16001-1-git-send-email-lauri.vosandi@gmail.com>
References: <217a387d55b5828a82fadad98dd88a959e7a13ed.1429008167.git.lauri.vosandi@gmail.com>
	<1429443988-16001-1-git-send-email-lauri.vosandi@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dL=.zZoFKj7/4=IvVCMx_SI"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/dL=.zZoFKj7/4=IvVCMx_SI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Apr 2015 14:46:28 +0300
Lauri V=C3=B5sandi <lauri.vosandi@gmail.com> wrote:

> This patch forces btrfs receive to issue chroot before
> parsing the btrfs stream using command-line flag -C
> to confine the process and minimize damage that could
> be done via malicious btrfs stream.
>=20
> Signed-off-by: Lauri V=C3=B5sandi <lauri.vosandi@gmail.com>
> ---
>  cmds-receive.c | 38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)

No patch versions and changelogs between them?...

By now there are 4 versions of this patch with identical subject and vague
unclear differences in description and content.

Usually what you do is label each new one [PATCH v2] (v3, v4) and describe =
what
got changed on each iteration.

--=20
With respect,
Roman

--Sig_/dL=.zZoFKj7/4=IvVCMx_SI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUzme8ACgkQTLKSvz+PZwgIhQCeLhKPQhEhXB+z3f2tva55pY5s
QhUAn22TIAC9NAL9nIT3/bxN2vTC+LjM
=/kKe
-----END PGP SIGNATURE-----

--Sig_/dL=.zZoFKj7/4=IvVCMx_SI--

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:48037 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab3AYLzf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 06:55:35 -0500
Date: Fri, 25 Jan 2013 17:55:30 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
Message-ID: <20130125175530.75402fb5@natsu>
In-Reply-To: <1359113550-23962-1-git-send-email-gene@czarc.net>
References: <1359113550-23962-1-git-send-email-gene@czarc.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Von_62rMBifHYSH1TF1AHmT"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Von_62rMBifHYSH1TF1AHmT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jan 2013 06:32:30 -0500
Gene Czarcinski <gene@czarc.net> wrote:

> This patch hits a lot of files but adds little code.  It
> could be considered a bugfix,  Currently, when one of the
> btrfs user-space programs is executed by a regular user,
> the result if oftem a number of strange error messages
> which do not indicate the real problem.  This patch changes
> that situation.
>=20
> A test is performed as to whether the program is running
> as root.  If it is not, issue an error message and exit.
> Signed-off-by: Gene Czarcinski <gene@czarc.net>

$ ls -la /dev/sda
brw-rw---T 1 root disk 8, 0 Jan 15 12:11 /dev/sda

The user does not have to be root, they can be a member of the group "disk"=
 to
manage this device.

Also some or all of the tools accept not just a block device, but also a
regular file as their parameter.

Wouldn't it be better to check whether or not the running user has
*write access* to the device or file to be operated on, before failing?

> ---
>  btrfs-corrupt-block.c | 5 +++++
>  btrfs-image.c         | 5 +++++
>  btrfs-map-logical.c   | 5 +++++
>  btrfs-select-super.c  | 5 +++++
>  btrfs-show-super.c    | 5 +++++
>  btrfs-show.c          | 5 +++++
>  btrfs-vol.c           | 5 +++++
>  btrfs-zero-log.c      | 5 +++++
>  btrfs.c               | 6 ++++++
>  btrfsck.c             | 5 +++++
>  btrfsctl.c            | 5 +++++
>  btrfstune.c           | 5 +++++
>  calc-size.c           | 5 +++++
>  convert.c             | 6 ++++++
>  debug-tree.c          | 5 +++++
>  dir-test.c            | 5 +++++
>  find-root.c           | 5 +++++
>  ioctl-test.c          | 6 ++++++
>  mkfs.c                | 5 +++++
>  quick-test.c          | 6 ++++++
>  restore.c             | 5 +++++
>  21 files changed, 109 insertions(+)

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/Von_62rMBifHYSH1TF1AHmT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlECcrIACgkQTLKSvz+PZwiwnwCglgUER2g+RSIyaBukkGwnaWYk
7HwAniAiu7w6qj23jZyfPdiCbTO4UEsH
=9foj
-----END PGP SIGNATURE-----

--Sig_/Von_62rMBifHYSH1TF1AHmT--

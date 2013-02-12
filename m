Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:40126 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab3BLUIx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 15:08:53 -0500
Date: Wed, 13 Feb 2013 02:08:50 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What can I do to make btrfs work?
Message-ID: <20130213020850.77d5aca4@natsu>
In-Reply-To: <20130212185449.GA16773@rhmail.home.annexia.org>
References: <20130212185449.GA16773@rhmail.home.annexia.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0raN/+3V53iE+u2kLhL6/18"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/0raN/+3V53iE+u2kLhL6/18
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Feb 2013 18:54:49 +0000
"Richard W.M. Jones" <rjones@redhat.com> wrote:

> Btrfs has been broken for me for ages.  I first reported it on this
> list 5 months ago[1].  Below is a very simple reproducer that anyone
> can run.
>=20
> *NB* before you run this, adjust /dev/sda & /dev/sda1 to point to an
> unused block device!

I might be pointing out the most obvious here, but where does /dev/sda2 come
from?

Some more ideas for you to try

dd if=3D/dev/zero of=3D/dev/sda bs=3D1M count=3D1
blockdev --rereadpt /dev/sda

and then proceed again with your test loop.

> ----------------------------------------------------------------------
> #!/bin/sh -
> set -e
> while true; do
>   parted -s -- /dev/sda mklabel msdos
>   parted -s -- /dev/sda mkpart primary 64s -64s
>   wipefs -a /dev/sda1
>   mkfs.btrfs --label TEST /dev/sda1
>   mount /dev/sda1 /sysroot
               ^^^^^^^^^^^^^^^^^^^^^^ sda1=20
>   touch /sysroot/foo
>   mkdir /sysroot/bar
>   umount /sysroot
> done
> ----------------------------------------------------------------------
>=20
> On the latest 3.8.0 kernel, this fails immediately (at the mount), and
> on 3.7.x it usually fails after a very few iterations.  I see a
> variety of errors, but the latest kernel error is:
>=20
> [    8.474934] device label ROOT devid 1 transid 2 /dev/sda2
> [    8.570619] device label ROOT devid 1 transid 2 /dev/sda2
                                                          ^^^^ sda2?
> [    8.581891] btrfs: disk space caching is enabled
> [    8.594146] btrfs bad tree block start 0 4194304
> [    8.595144] btrfs: failed to read tree root on sda2
> [    8.605308] btrfs: open_ctree failed
>=20
> I would really like btrfs to work.  What can I do?
>=20
> Rich.
>=20
> [1] http://article.gmane.org/gmane.comp.file-systems.btrfs/20257
>=20


--=20
With respect,
Roman

--Sig_/0raN/+3V53iE+u2kLhL6/18
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEaoVIACgkQTLKSvz+PZwgt3ACeLXuq7tws8UOsuXbUG96HlSJd
iUIAoIbESI/vTCsguYpAfcDGQF/1e2Kg
=R7bb
-----END PGP SIGNATURE-----

--Sig_/0raN/+3V53iE+u2kLhL6/18--

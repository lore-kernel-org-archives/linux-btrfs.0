Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60126 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2FPLwH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jun 2012 07:52:07 -0400
Received: by wgbds11 with SMTP id ds11so317963wgb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jun 2012 04:52:04 -0700 (PDT)
Date: Sat, 16 Jun 2012 14:57:04 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: rupert THURNER <rupert.thurner@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: cannot remove files: "rm" gives "no space left on device",
 3.2.0-24, ubuntu
Message-ID: <20120616145704.039809d2@sf.home>
In-Reply-To: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com>
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WJU5FjlIcI4Jy8DrrWTfbVj"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/WJU5FjlIcI4Jy8DrrWTfbVj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 16 Jun 2012 13:16:09 +0200
rupert THURNER <rupert.thurner@gmail.com> wrote:

> how would i be able to delete something off this btrfs partition
> again? i saw the following messages in the archives which seem to be a
> little similar ... except a reboot and therfor a remount did not help:
> * http://article.gmane.org/gmane.linux.kernel/1265666/match=3Denospc
>=20
> rt@tv:~$ rm -rf /media/388gb-data/.Trash-1000/info/foto.trashinfo
> rm: cannot remove `/media/388gb-data/.Trash-1000/info/foto.trashinfo':
> No space left on device
>=20
> rt@tv:~$ btrfs filesystem df /media/388gb-data/
> Data: total=3D260.59GB, used=3D254.56GB
> System: total=3D32.00MB, used=3D24.00KB
> Metadata: total=3D128.00GB, used=3D120.01GB

Looks like there is a bit of space.
Try to mount with
    '-onospace_cache,clear_cache,enospc_debug'
and check if it still reports an ENOSPC error.

Will result in anything reported in 'dmesg' output?

--=20

  Sergei

--Sig_/WJU5FjlIcI4Jy8DrrWTfbVj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk/cdJsACgkQcaHudmEf86rFiwCbBQfHNFzQwxkKl/DzzIPIYnsg
jngAnRpMNKD9eivkK5IMhUdTy7amn/Sa
=pKAS
-----END PGP SIGNATURE-----

--Sig_/WJU5FjlIcI4Jy8DrrWTfbVj--

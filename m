Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:55312 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcAOJFo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 04:05:44 -0500
Date: Fri, 15 Jan 2016 14:05:39 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Recursive delete file from all subvolumes (snapshots)
Message-ID: <20160115140539.3afa66f0@natsu>
In-Reply-To: <15624885.ucZm0n36hp@discus>
References: <15624885.ucZm0n36hp@discus>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eNgU1.l6aolUKxiTmmIfSka"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/eNgU1.l6aolUKxiTmmIfSka
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Jan 2016 09:33:14 +0100
Wolfgang Mader <Wolfgang_Mader@brain-frog.de> wrote:

> I have a btrfs raid 10 from which I take hourly snapshots using snapper. =
Now,=20
> I wonder, if there is a way to delete a file together with all its occurr=
ences=20
> in all snapshots.
>=20
> My use case is, that the file I want to delete is large, and I want to fr=
ee its=20
> space on disk. Thus, I have to get rid of its "live" version but also of =
all=20
> references to it in snapshots.

E.g. if your file is at /path/to/file.dat, and your snapshot structure is=20
/snapshots/YYYY-MM-DD@time/, you would simply do:

rm /snapshots/*/path/to/file.dat

In fact this is what I often do with my timed snapshots when deleting some
files and wanting to recover free space immediately, not waiting for all th=
eir
snapshots to expire and get deleted by the usual time-based deletion rules.

If your snapshots are read-only it becomes more complex, but still doable.

--=20
With respect,
Roman

--Sig_/eNgU1.l6aolUKxiTmmIfSka
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlaYtmMACgkQTLKSvz+PZwi3RgCfQyXVrpYVRcG88kjh6m3ERTMQ
yV0AoImpeb/Kp5t2gpRpL/DTQopQI3th
=BqG/
-----END PGP SIGNATURE-----

--Sig_/eNgU1.l6aolUKxiTmmIfSka--

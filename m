Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:43044 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbcCIVgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 16:36:40 -0500
Date: Thu, 10 Mar 2016 02:36:27 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: dstat shows unexpected result for two disk RAID1
Message-ID: <20160310023627.2e915667@natsu>
In-Reply-To: <CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
 <CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/jfnEfMC+b5gkQegp.OZ9KWg"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/jfnEfMC+b5gkQegp.OZ9KWg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Mar 2016 15:25:19 -0500
Nicholas D Steeves <nsteeves@gmail.com> wrote:

> grr.  Gmail is terrible :-/
>=20
> I understood that a btrfs RAID1 would at best grab one block from sdb
> and then one block from sdd in round-robin fashion, or at worse grab
> one chunk from sdb and then one chunk from sdd.  Alternatively I
> thought that it might read from both simultaneously, to make sure that
> all data matches, while at the same time providing single-disk
> performance.  None of these was the case.  Running a single
> IO-intensive process reads from a single drive.

No RAID1 implementation reads from disks in a round-robin fashion, as that
would give terrible performance giving disks a constant seek load instead of
the normal linear read scenario.

As for reading at the same time, there's no reason to do that either, since
the data integrity is protected by checksums, and "the other" disk for a
particular data piece is being consulted only in case the checksum did not
match (or when you execute a 'scrub').

It's a known limitation that the disks are in effect "pinned" to running
processes, based on their process ID. One process reads from the same disk,
from the point it started and until it terminates. Other processes by luck =
may
read from a different disk, thus achieving load balancing. Or they may not,
and you will have contention with the other disk idling. This is unlike MD
RAID1, which knows to distribute read load dynamically to the least-utilized
array members.

Now if you want to do some more performance evaluation, check with your dst=
at
if both disks happen to *write* data in parallel, when you write to the arr=
ay,
as ideally they should. Last I checked they mostly didn't, and this almost
halved write performance on a Btrfs RAID1 compared to a single disk.

--=20
With respect,
Roman

--Sig_/jfnEfMC+b5gkQegp.OZ9KWg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbgl14ACgkQTLKSvz+PZwjTRACfecVUUgypfECOgEJps+bUWdP1
sO4An1vn5x9HMrm9Onpipo+9Jp9Kt42S
=5lD4
-----END PGP SIGNATURE-----

--Sig_/jfnEfMC+b5gkQegp.OZ9KWg--

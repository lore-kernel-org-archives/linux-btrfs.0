Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36707 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751476AbaL2CHI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 21:07:08 -0500
Date: Sun, 28 Dec 2014 21:07:05 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (no
 complete lockups, "just" tasks stuck for some time)
Message-ID: <20141229020705.GA17679@hungrycats.org>
References: <3738341.y7uRQFcLJH@merkaba>
 <20141227182846.GA11878@hungrycats.org>
 <20141227184017.GL25267@carfax.org.uk>
 <2138510.KXMt4iLDat@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
In-Reply-To: <2138510.KXMt4iLDat@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 27, 2014 at 08:23:59PM +0100, Martin Steigerwald wrote:
> My simple test case didn=B4t trigger it, and I so not have another twice =
160
> GiB available on this SSDs available to try with a copy of my home
> filesystem. Then I could safely test without bringing the desktop session=
 to
> an halt. Maybe someone has an idea on how to "enhance" my test case in
> order to reliably trigger the issue.
>=20
> It may be challenging tough. My /home is quite a filesystem. It has a mai=
ldir
> with at least one million of files (yeah, I am performance testing KMail =
and
> Akonadi as well to the limit!), and it has git repos and this one VM imag=
e,
> and the desktop search and the Akonadi database. In other words: It has
> been hit nicely with various mostly random I think workloads over the last
> about six months. I bet its not that easy to simulate that. Maybe some ru=
ns
> of compilebench to age the filesystem before the fio test?
>=20
> That said, BTRFS performs a lot better. The complete lockups without any
> CPU usage of 3.15 and 3.16 have gone for sure. Thats wonderful. But there
> is this kworker issue now. I noticed it that gravely just while trying to
> complete this tax returns stuff with the Windows XP VM. Otherwise it may
> have happened, I have seen some backtraces in kern.log, but it didn=B4t l=
ast
> for minutes. So this indeed is of less severity than the full lockups with
> 3.15 and 3.16.
>=20
> Zygo, was is the characteristics of your filesystem. Do you use
> compress=3Dlzo and skinny metadata as well? How are the chunks allocated?
> What kind of data you have on it?

compress-force (default zlib), no skinny-metadata.  Chunks are d=3Dsingle,
m=3Ddup.  Data is a mix of various desktop applications, most active
file sizes from a few hundred K to a few MB, maybe 300k-400k files.
No database or VM workloads.  Filesystem is 100GB and is usually between
98 and 99% full (about 1-2GB free).

I have another filesystem which has similar problems when it's 99.99%
full (it's 13TB, so 0.01% is 1.3GB).  That filesystem is RAID1 with
skinny-metadata and no-holes.

On various filesystems I have the above CPU-burning problem, a bunch of
irreproducible random crashes, and a hang with a kernel stack that goes
through SyS_unlinkat and btrfs_evict_inode.


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSgt0kACgkQgfmLGlazG5w0xgCg2opp0Ef3XbHLqHoCGyzP8kwV
NaUAnA+ncDp8PAGp/IEqfbt4u4j0HEuW
=bs5o
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--

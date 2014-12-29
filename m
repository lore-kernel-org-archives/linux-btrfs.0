Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35823 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaL2JcC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 04:32:02 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (no complete lockups, "just" tasks stuck for some time)
Date: Mon, 29 Dec 2014 10:32 +0100
Message-ID: <2191338.tRc7Jxvh05@merkaba>
In-Reply-To: <20141229020705.GA17679@hungrycats.org>
References: <3738341.y7uRQFcLJH@merkaba> <2138510.KXMt4iLDat@merkaba> <20141229020705.GA17679@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5538351.95m8ejtOc7"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart5538351.95m8ejtOc7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Sonntag, 28. Dezember 2014, 21:07:05 schrieb Zygo Blaxell:
> On Sat, Dec 27, 2014 at 08:23:59PM +0100, Martin Steigerwald wrote:
> > My simple test case didn=B4t trigger it, and I so not have another =
twice 160
> > GiB available on this SSDs available to try with a copy of my home
> > filesystem. Then I could safely test without bringing the desktop s=
ession to
> > an halt. Maybe someone has an idea on how to "enhance" my test case=
 in
> > order to reliably trigger the issue.
> >=20
> > It may be challenging tough. My /home is quite a filesystem. It has=
 a maildir
> > with at least one million of files (yeah, I am performance testing =
KMail and
> > Akonadi as well to the limit!), and it has git repos and this one V=
M image,
> > and the desktop search and the Akonadi database. In other words: It=
 has
> > been hit nicely with various mostly random I think workloads over t=
he last
> > about six months. I bet its not that easy to simulate that. Maybe s=
ome runs
> > of compilebench to age the filesystem before the fio test?
> >=20
> > That said, BTRFS performs a lot better. The complete lockups withou=
t any
> > CPU usage of 3.15 and 3.16 have gone for sure. Thats wonderful. But=
 there
> > is this kworker issue now. I noticed it that gravely just while try=
ing to
> > complete this tax returns stuff with the Windows XP VM. Otherwise i=
t may
> > have happened, I have seen some backtraces in kern.log, but it didn=
=B4t last
> > for minutes. So this indeed is of less severity than the full locku=
ps with
> > 3.15 and 3.16.
> >=20
> > Zygo, was is the characteristics of your filesystem. Do you use
> > compress=3Dlzo and skinny metadata as well? How are the chunks allo=
cated?
> > What kind of data you have on it?
>=20
> compress-force (default zlib), no skinny-metadata.  Chunks are d=3Dsi=
ngle,
> m=3Ddup.  Data is a mix of various desktop applications, most active
> file sizes from a few hundred K to a few MB, maybe 300k-400k files.
> No database or VM workloads.  Filesystem is 100GB and is usually betw=
een
> 98 and 99% full (about 1-2GB free).
>=20
> I have another filesystem which has similar problems when it's 99.99%=

> full (it's 13TB, so 0.01% is 1.3GB).  That filesystem is RAID1 with
> skinny-metadata and no-holes.
>=20
> On various filesystems I have the above CPU-burning problem, a bunch =
of
> irreproducible random crashes, and a hang with a kernel stack that go=
es
> through SyS_unlinkat and btrfs_evict_inode.

Zygo, thanks. That desktop filesystem sounds a bit similar to my usecas=
e,
with the interesting difference that you have no databases or VMs on it=
.

That said, I use the Windows XP rarely, but using it was what made the =
issue
so visible for me. Is your desktop filesystem on SSD?

Do you have the chance to extend one of the affected filesystems to che=
ck
my theory that this does not happen as long as BTRFS can still allocate=
 new
data chunks? If its right, your FS should be fluent again as long as yo=
u see
more than 1 GiB free

Label: none  uuid: 53bdf47c-4298-45bc-a30f-8a310c274069
        Total devices 2 FS bytes used 512.00KiB
        devid    1 size 10.00GiB used 6.53GiB path /dev/mapper/sata-btr=
fsraid1
        devid    2 size 10.00GiB used 6.53GiB path /dev/mapper/msata-bt=
rfsraid1

between "size" and "used" in btrfs fi sh. I suggest going with at least=
 2-3
GiB, as BTRFS may allocate just one chunk so quickly that you do not ha=
ve
the chance to recognize the difference.

Well, and if thats works for you, we are back to my recommendation:

More so than with other filesystems give BTRFS plenty of free space to
operate with. At best as much, that you always have a mininum of 2-3 Gi=
B
unused device space for chunk reservation left. One could even do some
Nagios/Icinga monitoring plugin for that :)

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart5538351.95m8ejtOc7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlShH5AACgkQmRvqrKWZhMfIWgCcDr5+NCRHiMnx/fZDUnbLAevQ
BqwAoLRVBC0JTL5DgLvkeJW8TJWlfaLm
=p9Cn
-----END PGP SIGNATURE-----

--nextPart5538351.95m8ejtOc7--


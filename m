Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout-xforward.gmx.net ([82.165.159.14]:57470 "EHLO
	mout-xforward.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbbHMJnq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 05:43:46 -0400
Received: from thetick ([93.181.44.4]) by mail.gmx.com (mrgmx001) with ESMTPSA
 (Nemesis) id 0LmK3e-1YrIzp3qqo-00ZxdF for <linux-btrfs@vger.kernel.org>; Thu,
 13 Aug 2015 11:23:40 +0200
Date: Thu, 13 Aug 2015 11:23:31 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: trim not working and irreparable errors from btrfsck
Message-ID: <20150813112331.297d15f6@thetick>
In-Reply-To: <B7F2379062E32745A8651FBDB20F64595D45D284@Server.waterlogic.com.au>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
	<5581ABA2.30906@gmail.com>
	<21893.29830.540787.159202@localhost.localdomain>
	<B7F2379062E32745A8651FBDB20F64595D45D284@Server.waterlogic.com.au>
Reply-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/3QldauDEbq+zaO60xq5ipyM"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/3QldauDEbq+zaO60xq5ipyM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sun, 21 Jun 2015 07:21:03 +0000
schrieb Paul Jones <paul@pauljones.id.au>:

> > -----Original Message-----
> > From: Lutz Euler [mailto:lutz.euler@freenet.de]
> > Sent: Sunday, 21 June 2015 12:11 AM
> > To: Christian; Paul Jones; Austin S Hemmelgarn
> > Cc: linux-btrfs@vger.kernel.org
> > Subject: RE: trim not working and irreparable errors from btrfsck
> >=20
> > Hi Christian, Paul and Austin,
> >=20
> > Christian wrote:
> > > However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be
> > > another problem. Is there a way to check if trim works?
> >=20
> > Paul wrote:
> > > I've got the same problem. I've got 2 SSDs with 2 partitions in RAID1,
> > > fstrim always works on the 2nd partition but not the first. There are
> > > no errors on either filesystem that I know of, but the first one is
> > > root so I can't take it offline to run btrfs check.
> >=20
> > Austin wrote:
> > > I'm seeing the same issue here, but with a Crucial brand SSD.
> > > Somewhat interestingly, I don't see any issues like this with BTRFS on
> > > top of LVM's thin-provisioning volumes, or with any other filesystems,
> > > so I think it has something to do with how BTRFS is reporting unused
> > > space or how it is submitting the discard requests.
> >=20
> > Probably you all suffer from the same problem I had a few years ago.
> > It is a bug in how btrfs implements fstrim.
> >=20
> > To check whether you are a victim of this bug simply run:
> >=20
> > # btrfs-debug-tree /dev/whatever | grep 'FIRST_CHUNK_TREE
> > CHUNK_ITEM'
> >=20
> > where /dev/whatever is a device of your filesystem, and interrupt after=
 the
> > first several output lines with C-c. (Officially the filesystem should =
be
> > unmounted when running btrfs-debug-tree, but that is not necessary as we
> > only read from it and the relevant data doesn't change very often.)
> >=20
> > You get something like:
> >=20
> >   item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
> >   item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12947816448)
> >   item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 14021558272)
> >   ...
> >=20
> > (This output is from an old version of btrfs-progs. I understand newer =
version
> > are more verbose, but you should nevertheless easily be able to interpr=
et
> > the output).
> >=20
> > If the first number different from 0 (here, the 12947816448) is larger =
than the
> > sum of the sizes of the devices the filesystem consists of, bingo.
> >=20
> > This has been discussed already in the past and there is a patch.
> >=20
> > Please see for the patch:
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40618.html
> >=20
> > and for the background:
> > http://comments.gmane.org/gmane.comp.file-systems.btrfs/15597
> >=20
> > Kind regards,
> >=20
> > Lutz Euler
>=20
> I tried the test and the numbers I was getting seemed reasonable, however=
 I went ahead and applied the patch anyway. Trim now works correctly!
>=20
> Thanks,
> Paul.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in

Speaking as a user, since "fstrim -av" still always outputs 0 bytes trimmed
on my system: what's the status of this?  Did anybody ever file a bug repor=
t?
There was also that other thread, "fstrim not working on one of three BTRFS
filesystems", that also never went anywhere.

I take it from this that my SSD has been running untrimmed for quite a while
now?

(FWIW, queued trim is blocked by my kernel (it's "forced_unqueued"), but fs=
trim
should still start an unqueued trim, right?)

# uname -a       =20
Linux thetick 4.1.4-gentoo #1 SMP PREEMPT Tue Aug 4 21:58:41 CEST 2015 x86_=
64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux
# btrfs --version
btrfs-progs v4.1.2
# btrfs filesystem show=20
Label: 'MARCEC_ROOT'  uuid: 0267d8b3-a074-460a-832d-5d5fd36bae64
        Total devices 1 FS bytes used 56.59GiB
        devid    1 size 107.79GiB used 69.03GiB path /dev/sda1

Label: 'MARCEC_STORAGE'  uuid: 472c9290-3ff2-4096-9c47-0612d3a52cef
        Total devices 2 FS bytes used 597.75GiB
        devid    1 size 931.51GiB used 600.03GiB path /dev/sdc
        devid    2 size 931.51GiB used 600.03GiB path /dev/sdb

Label: 'MARCEC_BACKUP'  uuid: f97b3cda-15e8-418b-bb9b-235391ef2a38
        Total devices 1 FS bytes used 807.59GiB
        devid    1 size 976.56GiB used 837.06GiB path /dev/sdd2

btrfs-progs v4.1.2
# btrfs filesystem df /
Data, single: total=3D65.00GiB, used=3D54.83GiB
System, single: total=3D32.00MiB, used=3D16.00KiB
Metadata, single: total=3D4.00GiB, used=3D1.76GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

Greetings
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/3QldauDEbq+zaO60xq5ipyM
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJVzGIaAAoJEL/Q5oYsiHj00bEP+gMz63rY4OSl0ZmkkqyW7FmN
2u6jJw4C5UO9bN2OIfqnf76TG/3MQ3Ivdf4EPUq6upWe/dchfafhYQpEOmVwirmq
myIcQ6XsHOpDc7ibvzCFVzGzUDdE3e5HjUiP/ZrzqaFwZmtkTTyHzkU24LiL6aeu
VOD/nufH/ccpicdWZzVgaklO1C/D+IIuxrt/UO89c5EUnKWHxUNud0R2Z8rAgWU7
l8RDHjYX81OfxGkUCx2Fhp/WxAgZjCZfFTYsU4vopQwnWNlDTbJRqXYmpBpK6b3Q
oUHwDOBjEzyTd0Ij6UAnmAGodZVIfiBMusCzCSZKlrNYTU3u59IzmOjpa7wyp76z
d0pxp49otNUDT7oPPQ01vI9clLvK3eyaMDY3wShjwlLCqYx3I0FlpBKrtkbfeW0G
sApmGUunzTFknqedlgnCGAcx1c1ZLUo7H2UIZQuv+50GB7eSd4MCPGkBKZaxjztr
00aBJtey+UyR5MVhvrYN0YB8IUxLytJcMGBQIm1p4QAUSbKdRoUYwJHvEQWL557N
1ElMPCFsjJ5dE/+kzvZ+4bX7Oh8dJffVK6UfD+tCaakE/+rwLkwTajHc+l2SE9hA
dv4IqMomBUaCiRyPBvlUmVUsWemLxm0gc9bL9wjlJkEYBdUyrFkKgBy5gNEgkvzW
42uX3X6HZqca3403KrwV
=NX3q
-----END PGP SIGNATURE-----

--Sig_/3QldauDEbq+zaO60xq5ipyM--

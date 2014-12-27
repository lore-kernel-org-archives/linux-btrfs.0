Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57230 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaL0LL2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 06:11:28 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 12:11:25 +0100
Message-ID: <2790499.1m3QJ8oJFe@merkaba>
In-Reply-To: <20141227093043.GJ25267@carfax.org.uk>
References: <3738341.y7uRQFcLJH@merkaba> <4232026.31LFOYpm2s@merkaba> <20141227093043.GJ25267@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1487190.UKqQ55o1b2"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1487190.UKqQ55o1b2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Samstag, 27. Dezember 2014, 09:30:43 schrieb Hugo Mills:
> >=20
> >
> > I only see the lockups of BTRFS is the trees *occupy* all space on =
the
> > device.
>    No, "the trees" occupy 3.29 GiB of your 5 GiB of mirrored metadata=

> space. What's more, balance does *not* balance the metadata trees. Th=
e
> remaining space -- 154.97 GiB -- is unstructured storage for file
> data, and you have some 13 GiB of that available for use.
>=20
>    Now, since you're seeing lockups when the space on your disks is
> all allocated I'd say that's a bug. However, you're the *only* person=

> who's reported this as a regular occurrence. Does this happen with al=
l
> filesystems you have, or just this one?

Okay, just about terms.

What I call trees is this:

merkaba:~> btrfs fi df /
Data, RAID1: total=3D27.99GiB, used=3D17.21GiB
System, RAID1: total=3D8.00MiB, used=3D16.00KiB
Metadata, RAID1: total=3D2.00GiB, used=3D596.12MiB
GlobalReserve, single: total=3D208.00MiB, used=3D0.00B

For me each one of "Data", "System", "Metadata" and "GlobalReserve" is =
what I=20
call a "tree".

How would you call it?

I always thought that BTRFS uses a tree structure not only for metadata=
, but=20
also for data. But I bet strictly spoken thats only to *manage* the chu=
nks it=20
allocates and what I see above is the actual chunk usage.

I.e. to get terms straight, how would you call it? I think my understan=
ding of=20
how BTRFS handles space allocation is quite correct, but I may use a te=
rm=20
incorrectly.

I read

> Data, RAID1: total=3D27.99GiB, used=3D17.21GiB

as:

I reserved 27,99 GiB for data chunks and used 17,21 GiB in these data c=
hunks=20
so far. So I have about 10,5 GiB free in these data chunks at the momen=
t and=20
all is good.

What it doesn=B4t tell me at all is how the allocated space is distribu=
ted onto=20
these chunks. I may be that some chunks are completely empty or not. It=
 may be=20
that each chunk has some space allocated to it but in total there is th=
at=20
amount of free space yet. I.e. it doesn=B4t tell me anything about the =
free=20
space fragmentation inside the chunks.

Yet I still hold my theory that in the case of heavily writing to a COW=
=B4d file=20
BTRFS seems to prefer to reserve new empty chunks on this /home filesys=
tem of=20
my laptop instead of trying to find free space in existing only partial=
ly empty=20
chunks. And the lockup only happens when it tries to do the latter. And=
 no, I=20
think it shouldn=B4t lockup then. I also think its a bug. I never said=20=

differently.

And yes, I only ever had this on my /home so far. Not on / which is als=
o RAID=20
1 and has all device space reserved for quite some time, not on /daten =
which=20
only holds large files and is single instead of RAID. Also not on the s=
erver,=20
but the server FS has lots of unallocated device space still, or on the=
 2 TiB=20
eSATA backup HD, also I do get the impression that BTRFS started to get=
 slower=20
there as well at least the rsync based backup script takes quite long=20=

meanwhile and I see rsync reading from backup BTRFS and in this case al=
most=20
fully ultilizing the disk for longer times. But unlike my /home the bac=
kup=20
disk has some timely widely distributed snaphots (about 2 week to 1 mon=
ths=20
intervalls, and about last half year).

Neither /home nor / on the SSD have snapshots at the moment. So this is=
=20
happening without snapshots.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart1487190.UKqQ55o1b2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSek90ACgkQmRvqrKWZhMfPygCfaVi2STMCO+6ZgTECvZ9uc7yf
nkkAn3TU9A4qxwA2z7aS2Mw+IBeGO/4o
=/Rd8
-----END PGP SIGNATURE-----

--nextPart1487190.UKqQ55o1b2--


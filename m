Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49345 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbbHETAk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 15:00:40 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Russell Coker <russell@coker.com.au>,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1: system stability
Date: Wed, 05 Aug 2015 21:00:25 +0200
Message-ID: <21803065.MYkXLzliko@merkaba>
In-Reply-To: <55C248B9.20003@gmail.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com> <201507222100.22471.russell@coker.com.au> <55C248B9.20003@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1454915.6KhYEC4KEt"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1454915.6KhYEC4KEt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Am Mittwoch, 5. August 2015, 13:32:41 schrieb Austin S Hemmelgarn:
> On 2015-07-22 07:00, Russell Coker wrote:
> > On Tue, 23 Jun 2015 02:52:43 AM Chris Murphy wrote:
> >> OK I actually don't know what the intended block layer behavior is=

> >> when unplugging a device, if it is supposed to vanish, or change s=
tate
> >> somehow so that thing that depend on it can know it's "missing" or=

> >> what. So the question here is, is this working as intended? If the=

> >> layer Btrfs depends on isn't working as intended, then Btrfs is
> >> probably going to do wild and crazy things. And I don't know that =
the
> >> part of the block layer Btrfs depends on for this is the same (or
> >> different) as what the md driver depends on.
> >=20
> > I disagree with that statement.  BTRFS should be expected to not do=
 wild
> > and crazy things regardless of what happens with block devices.
>=20
> I would generally agree with this, although we really shouldn't be do=
ing
> things like trying to handle hardware failures without user
> intervention.  If a block device disappears from under us, we should
> throw a warning and if it's the last device in the FS, kill anything
> that is trying to read or write to that FS.  At the very least, we
> should try to avoid hanging or panicking the system if all of the
> devices in an FS disappear out from under us.

The best solution I have ever seen for removable media is with AmigaOS.=
 You=20
remove a disk (or nowadays an usb stick) while it is being written to a=
nd=20
AmigaDOS/AmigaOS pops up a dialog window saying "You MUST insert volume=
=20
$VOLUMENAME again". And if you did, it just continued writing. I bet th=
is may=20
be difficult for do for Linux for all devices as unwritten changes pile=
 up in=20
memory until dirty limits are reached, unless one says "Okay, disk gone=
, we=20
block all processes writing to it immediately or quite soon", but for=20=

removable media I never saw anything with that amount of sanity. There =
was=20
some GSoC for NetBSD once to implement this, but I don=B4t know whether=
 its=20
implemented in there now. For AmigaOS and floppy disks with back then=20=

filesystem there was just one culprit: If you didn=B4t insert the disk =
again, it=20
was often broken beyond repair. For journaling or COW filesystem it wou=
ld just=20
be like in any other sudden stop to writes.

On Linux with eSATA I saw I can also replug the disk if I didn=B4t yet =
hit the=20
timeouts in block layer. After that the disk is gone.

Ciao,
=2D-=20
Martin
--nextPart1454915.6KhYEC4KEt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJVwl1VAAoJEHpbMXltm6AYLMsQAJnQ8bxp+XcDmiFAdG9sdXsR
QIMG3HBLjLTKqoUu1sLBP5DKXDWkqXZ0hUkzr3RW+QqIr0J0GKPLcr/Vvv8ft2Or
uZb78SrtHZMcmQEoMdS15XEfaKNhww9LMJENk7kakNE+vqDqsKNBzvREqS2/3pB6
nJJnscWvioq9/fz09eCDDvIT4lmLtD8zb3fWmEnP0k9fmrHglkSNCkCtMh/2PVYu
kIdxrQESLaSCtM/5vkwmoDFvN3aamUNrLp1g1MyyfeOOEbVNsM/T3kWnAAqQk3Nb
pS6PBZc1bV5WxKHBFHZxp+aERYU/qe1zKoW4hDCBsIA5KwPZqwdstTAxwdqJ7OJZ
E6XXO9enYT9xaKT3iJK4JE8s9GcpXrUIyw+8bIDXG+WYpYQh3BieyOM7BBX0o/JS
trKNCXuNYclnyrEcxn4tGlkGBvfBhPhQ8SFG8YWCgIUhsVsPH5q2XjX75uOD5Zvv
0tLr4Plxa3NB87xsSOHeV5RPjtHCf8AJ5IHsgE8gjq2Yg7u/dj2SWqLu+IbfD/w4
+8+f2K4M9w+sT7PGOjPXtNHaMO6SZLNpY0iFN0LZ41BNpeKfXiYvgPevr4rc5C/A
EdJeYNO2ES0vDa8sKJ9de2wgEOWnHOYxGV/1AGR0iKqwfkgh2JmORYOjwtzwAfhB
jlztKZr2blR/SfYvNwQA
=BGiA
-----END PGP SIGNATURE-----

--nextPart1454915.6KhYEC4KEt--


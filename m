Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52107 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbbLENhP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 08:37:15 -0500
Received: from thetick.localnet ([93.181.44.4]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MHnzh-1a8mSS0oY9-003aPS for
 <linux-btrfs@vger.kernel.org>; Sat, 05 Dec 2015 14:37:13 +0100
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: compression disk space saving - what are your results?
Date: Sat, 05 Dec 2015 14:37:05 +0100
Message-ID: <6329794.eixGOkx0p3@thetick>
In-Reply-To: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2160819.7KbyQApKBx"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2160819.7KbyQApKBx
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Wednesday 02 December 2015 18:46:30 Tomasz Chmielewski wrote:
>What are your disk space savings when using btrfs with compression?
>
>I have a 200 GB btrfs filesystem which uses compress=3Dzlib, only stor=
es
>text files (logs), mostly multi-gigabyte files.
>
>
>It's a "single" filesystem, so "df" output matches "btrfs fi df":
>
># df -h
>Filesystem      Size  Used Avail Use% Mounted on
>(...)
>/dev/xvdb       200G  124G   76G  62% /var/log/remote
>
>
># du -sh /var/log/remote/
>153G    /var/log/remote/
>
>
> From these numbers (124 GB used where data size is 153 GB), it appear=
s
>that we save around 20% with zlib compression enabled.
>Is 20% reasonable saving for zlib? Typically text compresses much bett=
er
>with that algorithm, although I understand that we have several
>limitations when applying that on a filesystem level.
>
>
>Tomasz Chmielewski
>http://wpkg.org

I have a total of three file systems that use compression, on a desktop=
 and a=20
laptop.  / on both uses compress=3Dlzo, and my backup drive uses compre=
ss=3Dzlib=20
(my RAID1 FS does not use compression).  My desktop looks like this:

% df -h
Dateisystem    Gr=C3=B6=C3=9Fe Benutzt Verf. Verw% Eingeh=C3=A4ngt auf
/dev/sda1       108G     79G   26G   76% /
[...]

For / I get a total of about 8G or at least 9% space saving:

# du -hsc /mnt/rootfs/*
71G     /mnt/rootfs/home
14G     /mnt/rootfs/rootfs
2,3G    /mnt/rootfs/var
87G     insgesamt

I write "at least" because this does not include snapshots.  On my lapt=
op the=20
difference is merely 1 GB (83 vs. 84 GB), but it was using the autodefr=
ag=20
mount option until yesterday (when I migrated it to an SSD using dd), w=
hich=20
probably accounts for a significant amount of wasted space.  I'll see h=
ow it=20
develops over the next two weeks, but I expect the ratio to become simi=
lar to=20
my desktop (probably less, since there is also a lot of music on there)=
.

I would love to answer the question for my backup drive, but du took to=
o long=20
(> 1 h) so I stopped it :-( .  I might try it again later, but no promi=
ses!

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup
--nextPart2160819.7KbyQApKBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWYuiGAAoJEL/Q5oYsiHj0kroQAM1aQ7lSox4PRUJ4T66Z8Mm9
26WkYQHWC7LpFBSdKZ2l87alseYmD6k2MUsKr73Pr5FWL3wp6ARTvnoJsSvIg2p3
zuJxgdhkm8Tre8u5uw9N4+KhKjREIzgsHwFwlIMJTWQM0d6yfzr1LXpPyJhsisJ4
1J6aJTW6/xRnZ7Kh8Z7fxn3huZbT87rnPODP5O8HxmLD1ZrOU4it6hGBk3jX1epU
V/2H1rKg+rhnawQmQ14MwrPsINQNdrShSup3n0gZfSCH3JfU2WAEOg/ap7nzqM9A
Fr/2mBX2QyoKZ9zc2+ab71XfaHGA74qNvVrhdVKnrCReaDTxh5NIOnPMMsRBxaBW
D1Hmy47XRf8KxL9DVqI6n0/jiR12EH1JdVxKICwg6hN+06mlQYu8d1kAESAhkjI1
1poyoahP8QgQTSs9UeOAKLuj78tJ6cyE6Aldw+ir0oKjflkIQs9Ha8EeGAE8SbP1
lyF8Ec2Pne8B2m/rCz2K2GKnICUAkCFGidvkDLeKNM5WLvjOc+Fo7Exn5OXUvDRl
6gU5fo4FrK41YUxCCeAMFbW4RHQ9pvvDMs7CFbYAf0HLpw5lhfYb7uhmWdeCU1do
KtWXZRDc6qLjEI82blpC7wZi/94OmRrcXJKhWnBRQ++myDFzzJMJ4zcajG0XBKvV
RMxEIwCm8BOvq90XediR
=TbnU
-----END PGP SIGNATURE-----

--nextPart2160819.7KbyQApKBx--


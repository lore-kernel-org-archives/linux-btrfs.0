Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [77.244.242.186] ([77.244.242.186]:53336 "EHLO bastet.luchs.at"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbbGMOP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 10:15:26 -0400
Date: Mon, 13 Jul 2015 16:14:07 +0200
From: =?iso-8859-15?Q?Ren=E9?= Pfeiffer <lynx@luchs.at>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs read-only after btrfs-convert from Ext4 & workaround
Message-ID: <20150713141406.ZC4247@many.eyes.bnd.bund.de>
References: <20150713012350.ZA6925@many.eyes.bnd.bund.de>
 <CAJCQCtRtndhZXaQgZ9gLi+iRjWT9Aakgm43KAiTuO-wvsqrgHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
In-Reply-To: <CAJCQCtRtndhZXaQgZ9gLi+iRjWT9Aakgm43KAiTuO-wvsqrgHw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OROCMA9jn6tkzFBc
Content-Type: multipart/mixed; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jul 12, 2015 at 2026 -0600, Chris Murphy appeared and said:
> On Sun, Jul 12, 2015 at 7:23 PM, Ren=E9 Pfeiffer <lynx@luchs.at> wrote:
> >...
> > Output of uname, btrfs, and the dmesg log is attached. Let me know if y=
ou
> > need anything else. The old Btrfs is still on another disk, and I can
> > extract information from it.
>=20
> If you can run 'btrfs check' on it (without repair) using btrfs-progs
> 4.0, and 3.19.1, and report the results of each, that would be really
> useful.

Here we go.

Best,
Ren=E9.

--=20
  )\._.,--....,'``.  fL  Let GNU/Linux work for you while you take a nap.
 /,   _.. \   _\  (`._ ,. R. Pfeiffer <lynx at luchs.at> + http://web.luchs=
=2Eat/
`._.-(,_..'--(,_..'`-.;.'  - System administration + Consulting + Teaching -
Got mail delivery problems?  http://web.luchs.at/information/blockedmail.php

--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrfs_check_3.19.1.txt"

Checking filesystem on /dev/mapper/oldcrypt
UUID: 703fc8b4-b2b9-470b-af2f-9aae9536c2fb
checking extents
checking free space cache
There is no free space entry for 163242479616-163242483712
There is no free space entry for 163242479616-167537278976
cache appears valid but isnt 162168569856
found 358532382931 bytes used err is -22
total csum bytes: 346644792
total tree bytes: 3568107520
total fs tree bytes: 3061465088
total extent tree bytes: 50102272
btree space waste bytes: 987626752
file data blocks allocated: 355459522560
 referenced 354990657536
btrfs-progs v3.19.1

--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="btrfs_check_4.0.txt"

Checking filesystem on /dev/mapper/oldcrypt
UUID: 703fc8b4-b2b9-470b-af2f-9aae9536c2fb
checking extents
checking free space cache
block group 162168569856 has wrong amount of free spacefailed to load free space cache for block group 162168569856
checking fs roots
root 5 inode 39321856 errors 200, dir isize wrong
root 5 inode 40898635 errors 200, dir isize wrong
found 358532382931 bytes used err is 1
total csum bytes: 346644792
total tree bytes: 3568107520
total fs tree bytes: 3061465088
total extent tree bytes: 50102272
btree space waste bytes: 987626752
file data blocks allocated: 355459522560
 referenced 354990657536
btrfs-progs v4.0

--PuGuTyElPB9bOcsM--

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREKAAYFAlWjx64ACgkQSPQ8C8rI6DuLAAD/cauzVbBTVst1capITN+dAmkD
vL4IUk3XUGNpDvb2POUA/0zTo5OB1ldTTcEQbOFaRMReTHKYdzJuHHD9Uk3hXFtQ
=Qi5T
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--

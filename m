Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from attic.omnifarious.org ([206.124.142.227]:38144 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3AOUya (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jan 2013 15:54:30 -0500
Date: Tue, 15 Jan 2013 12:44:36 -0800
From: hopper@omnifarious.org
To: linux-btrfs@vger.kernel.org
Subject: Rendering a btrfs filesystem unmountable with the btrfs command
Message-ID: <20130115204436.GC18291@omnifarious.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Xm/fll+QQv+hsKip"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Xm/fll+QQv+hsKip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

mkfs.btrfs /dev/sdb
mkdir /tmp/mnt
mount /dev/sdb /tmp/mnt
cd /tmp/mnt
btrfs quota enable .
btrfs subvol create foo
btrfs qgroup create 1/0
btrfs qgroup assign 0/257 1/0
btrfs subvol snapshot foo bar
btrfs qgroup assign 0/258 1/0
cd ..
umount /dev/sdb
mount /dev/sdb /tmp/mnt
# Still mountable!
cd mnt
btrfs qgroup destroy 1/0
cd ..
umount /dev/sdb
mount /dev/sdb /tmp/mnt
# Oops, no longer mountable, even in recovery mode!

Help!  BTW, I'm not a mailing list subscriber.

Thanks,
--=20
"They who can give up essential liberty to obtain a little temporary
 safety, deserve neither liberty nor safety." -- Benjanmin Franklin
-- Eric Hopper (http://www.omnifarious.org/~hopper) --

--Xm/fll+QQv+hsKip
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQGcBAEBCAAGBQJQ9b+0AAoJEA0oytveg7KquHUMAIhsX3zrbY/UJbGHvf1AHWtu
Di3RRNnTKp+SO830twS8wVPdAexb7kr/0zy3iNAkrnQWYI/ghsLebvZCea77PQ3E
9pbtRTTXHs4aKhDtG2TSOlx2KN/DSFAi0+hhPJyhcpZPvYzHL0+8d2xeHilAw1ZX
ljmywM1hdSjXcqs1ckIBGzLA/BF9xVYUWII/NwriBZRACcR4FwCWQlFFhN3tH0wj
Ui2YTnuq40y5S+YiI1y1dvr1/hhWisrtaPo2JRXWOumWGMMc2Vj6j6cwl74eYduB
wN1871Z6LdllVR8QWN5B9b0pjbi0ZQJJLgAl0e5qMAbqD3coyhI5y0YoOWZT0aQ3
GAlhtZOqNkqWH9e4qP8QHIpQBTOqarZmesMlMbp68VcvFTu9oT4Xgy5HZLJoMW3A
9TtXHCvNwBAPWVQPxn66VK1PWsZ8K3V7Dc/6ckCrKOOCX3lzKBcqu9KNLOlxHRZ0
4TRt5BftAlcew2+e0wBoucEvMx1hZJAKsvennZjBrA==
=tEaR
-----END PGP SIGNATURE-----

--Xm/fll+QQv+hsKip--

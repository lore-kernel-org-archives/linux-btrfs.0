Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:39359 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbaF0T1W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 15:27:22 -0400
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by mari.romanrm.net (Postfix) with ESMTPS id 8852525020
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 19:27:14 +0000 (UTC)
Date: Sat, 28 Jun 2014 01:27:10 +0600
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: "nossd" option ignored
Message-ID: <20140628012710.620102ef@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AQA=FTNeZRp1_sTF=bKm9AF"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/AQA=FTNeZRp1_sTF=bKm9AF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

With kernel 3.14.5...

$ sudo umount /mnt/net/alpha/11
umount: /mnt/net/alpha/11: not mounted

$ sudo mount -o inode_cache,space_cache,compress=3Dlzo,noatime,nossd,skip_b=
alance /dev/nbd11 /mnt/net/alpha/11

$ sudo mount | grep nbd11
/dev/nbd11 on /mnt/net/alpha/11 type btrfs (rw,noatime,compress=3Dlzo,ssd,s=
pace_cache,inode_cache,skip_balance)

$ dmesg | tail
...
[1353819.363462] BTRFS: device fsid 8cf8eff9-fd5a-4b6f-bb85-3f2df2f63c99 de=
vid 1 transid 25041 /dev/nbd11
[1353819.364668] BTRFS info (device nbd11): enabling inode map caching
[1353819.364674] BTRFS info (device nbd11): disk space caching is enabled
[1353821.784617] BTRFS: detected SSD devices, enabling SSD mode

--
I'm certain the "nossd" option used to work (prevent the SSD mode) with this
exact same configuration on older kernels. Any idea why it doesn't now?

--=20
With respect,
Roman

--Sig_/AQA=FTNeZRp1_sTF=bKm9AF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOtxY4ACgkQTLKSvz+PZwjILwCfYg4cS6cQBLshY+DEY9zOaV3D
ja4AoI4ru4HeaqhpUnBWONlnFjhJdaMp
=JpR4
-----END PGP SIGNATURE-----

--Sig_/AQA=FTNeZRp1_sTF=bKm9AF--

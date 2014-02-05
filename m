Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:53330 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbaBEUP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 15:15:26 -0500
Received: from natsu (unknown [IPv6:fd39::a60:6eff:fef3:b5b3])
	by luka.romanrm.net (Postfix) with ESMTPS id 28D3D40074
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Feb 2014 20:15:23 +0000 (UTC)
Date: Thu, 6 Feb 2014 02:15:16 +0600
From: Roman Mamedov <rm@romanrm.net>
To: linux-btrfs@vger.kernel.org
Subject: Provide a better free space estimate on RAID1
Message-ID: <20140206021516.304732cd@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QgWDeS2=Mnt30ZhiRLTW_+7"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/QgWDeS2=Mnt30ZhiRLTW_+7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On a freshly-created RAID1 filesystem of two 1TB disks:

# df -h /mnt/p2/
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       1.8T  1.1M  1.8T   1% /mnt/p2

I cannot write 2TB of user data to that RAID1, so this estimate is clearly
misleading. I got tired of looking at the bogus disk free space on all my
RAID1 btrfs systems, so today I decided to do something about this:

--- fs/btrfs/super.c.orig	2014-02-06 01:28:36.636164982 +0600
+++ fs/btrfs/super.c	2014-02-06 01:28:58.304164370 +0600
@@ -1481,6 +1481,11 @@
 	}
=20
 	kfree(devices_info);
+
+	if (type & BTRFS_BLOCK_GROUP_RAID1) {
+		do_div(avail_space, min_stripes);
+	}
+ =20
 	*free_bytes =3D avail_space;
 	return 0;
 }


After:

# df -h /mnt/p2/
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       1.8T  1.1M  912G   1% /mnt/p2

Until per-subvolume RAID profiles are implemented, this estimate will be
correct, and even after, it should be closer to the truth than assuming the
user will fill their RAID1 FS only with subvolumes of single or raid0 profi=
les.

If anyone likes feel free to reimplement my PoC patch in a better way, e.g.
integrate this into the calculation 'while' block of that function immediat=
ely
before it (logic of which I couldn't yet grasp due to it lacking comments),
and not just tacked onto the tail of it.

--=20
With respect,
Roman

--Sig_/QgWDeS2=Mnt30ZhiRLTW_+7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLym9UACgkQTLKSvz+PZwgr9gCfYg1g8uh/IsxfOMRyfZzK8OOk
2ygAnjiRheweCcXKfRTeBWkQWwEuzWtu
=kqhu
-----END PGP SIGNATURE-----

--Sig_/QgWDeS2=Mnt30ZhiRLTW_+7--

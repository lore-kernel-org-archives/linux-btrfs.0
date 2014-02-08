Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from luka.romanrm.net ([213.163.64.74]:42722 "EHLO luka.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaBHLVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 06:21:45 -0500
Date: Sat, 8 Feb 2014 17:21:42 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Roman Mamedov <rm@romanrm.net>
Cc: Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        kreijack@libero.it, Brendan Hide <brendan@swiftspirit.co.za>,
        linux-btrfs@vger.kernel.org
Subject: Re: Provide a better free space estimate on RAID1
Message-ID: <20140208172142.44243c67@natsu>
In-Reply-To: <20140207120812.43dc7982@natsu>
References: <20140206021516.304732cd@natsu>
	<52F33BE7.4020708@swiftspirit.co.za>
	<20140206184502.128b7dbe@natsu>
	<52F3E86B.4030805@libero.it>
	<20140207104005.7bd1438a@natsu>
	<1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com>
	<20140207120812.43dc7982@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k4/7hO5FQzdIdVY8qPtH.xW"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/k4/7hO5FQzdIdVY8qPtH.xW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Feb 2014 12:08:12 +0600
Roman Mamedov <rm@romanrm.net> wrote:

> > Earlier conventions would have stated Size ~900GB, and Avail ~900GB. Bu=
t that's not exactly true either, is it?
>=20
> Much better, and matching the user expectations of how RAID1 should behav=
e,
> without a major "gotcha" blowing up into their face the first minute they=
 are
> trying it out. In fact next step that I planned would be finding how to a=
djust
> also Size and Used on all my machines to show what you just mentioned.

OK done; again, this is just what I will personally use from now on (and for
anyone who finds this helpful).

----

--- fs/btrfs/super.c.orig	2014-02-06 01:28:36.636164982 +0600
+++ fs/btrfs/super.c	2014-02-08 17:16:50.361931959 +0600
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
@@ -1491,8 +1496,10 @@
 	struct btrfs_super_block *disk_super =3D fs_info->super_copy;
 	struct list_head *head =3D &fs_info->space_info;
 	struct btrfs_space_info *found;
+	u64 total_size;
 	u64 total_used =3D 0;
 	u64 total_free_data =3D 0;
+	u64 type;
 	int bits =3D dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid =3D (__be32 *)fs_info->fsid;
 	int ret;
@@ -1512,7 +1519,13 @@
 	rcu_read_unlock();
=20
 	buf->f_namelen =3D BTRFS_NAME_LEN;
-	buf->f_blocks =3D btrfs_super_total_bytes(disk_super) >> bits;
+	total_size =3D btrfs_super_total_bytes(disk_super);
+	type =3D btrfs_get_alloc_profile(fs_info->tree_root, 1);
+	if (type & BTRFS_BLOCK_GROUP_RAID1) {
+		do_div(total_size, 2);
+		do_div(total_used, 2);
+	}
+	buf->f_blocks =3D total_size >> bits;
 	buf->f_bfree =3D buf->f_blocks - (total_used >> bits);
 	buf->f_bsize =3D dentry->d_sb->s_blocksize;
 	buf->f_type =3D BTRFS_SUPER_MAGIC;


----

2x1TB RAID1 with a 1GB file:

Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       912G  1.1G  911G   1% /mnt/p2


--=20
With respect,
Roman

--Sig_/k4/7hO5FQzdIdVY8qPtH.xW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlL2E0YACgkQTLKSvz+PZwgS6ACgjZ0fJgedjuxObwLX8FKErHa4
HiEAnAjI0jgLWrafZPLS9k60aaUwo6ik
=UUFy
-----END PGP SIGNATURE-----

--Sig_/k4/7hO5FQzdIdVY8qPtH.xW--

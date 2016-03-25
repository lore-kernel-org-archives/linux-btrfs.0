Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:34745 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbcCYOx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:53:27 -0400
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: [PATCH] delete obsolete function btrfs_print_tree()
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <56F550DD.1030200@googlemail.com>
Date: Fri, 25 Mar 2016 15:53:17 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9bvILXL7uF7kICMeOeeoPQ8F0L3eWATiH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9bvILXL7uF7kICMeOeeoPQ8F0L3eWATiH
Content-Type: multipart/mixed; boundary="tw4cKQdINOpVLn8vE9gLRP06kkuXGNKT3"
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger.hoffstaette@googlemail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <56F550DD.1030200@googlemail.com>
Subject: [PATCH] delete obsolete function btrfs_print_tree()

--tw4cKQdINOpVLn8vE9gLRP06kkuXGNKT3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dan Carpenter's static checker recently found missing IS_ERR handling
in print-tree.c:btrfs_print_tree(). While looking into this I found that
this function is no longer called anywhere and was moved to btrfs-progs
long ago. It can simply be removed.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Holger Hoffst=C3=A4tte <holger.hoffstaette@googlemail.com>=

---
 fs/btrfs/print-tree.c | 38 --------------------------------------
 fs/btrfs/print-tree.h |  1 -
 2 files changed, 39 deletions(-)

diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 147dc6c..dc28db8 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -328,41 +328,3 @@ void btrfs_print_leaf(struct btrfs_root *root, struc=
t extent_buffer *l)
 		};
 	}
 }
-
-void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
-{
-	int i; u32 nr;
-	struct btrfs_key key;
-	int level;
-
-	if (!c)
-		return;
-	nr =3D btrfs_header_nritems(c);
-	level =3D btrfs_header_level(c);
-	if (level =3D=3D 0) {
-		btrfs_print_leaf(root, c);
-		return;
-	}
-	btrfs_info(root->fs_info, "node %llu level %d total ptrs %d free spc %u=
",
-		btrfs_header_bytenr(c), level, nr,
-		(u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
-	for (i =3D 0; i < nr; i++) {
-		btrfs_node_key_to_cpu(c, &key, i);
-		printk(KERN_INFO "\tkey %d (%llu %u %llu) block %llu\n",
-		       i, key.objectid, key.type, key.offset,
-		       btrfs_node_blockptr(c, i));
-	}
-	for (i =3D 0; i < nr; i++) {
-		struct extent_buffer *next =3D read_tree_block(root,
-					btrfs_node_blockptr(c, i),
-					btrfs_node_ptr_generation(c, i));
-		if (btrfs_is_leaf(next) &&
-		   level !=3D 1)
-			BUG();
-		if (btrfs_header_level(next) !=3D
-		       level - 1)
-			BUG();
-		btrfs_print_tree(root, next);
-		free_extent_buffer(next);
-	}
-}
diff --git a/fs/btrfs/print-tree.h b/fs/btrfs/print-tree.h
index 7faddfa..9dd56b9 100644
--- a/fs/btrfs/print-tree.h
+++ b/fs/btrfs/print-tree.h
@@ -19,5 +19,4 @@
 #ifndef __PRINT_TREE_
 #define __PRINT_TREE_
 void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l);=

-void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c);=

 #endif
--=20
2.7.4


--tw4cKQdINOpVLn8vE9gLRP06kkuXGNKT3--

--9bvILXL7uF7kICMeOeeoPQ8F0L3eWATiH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlb1UOQACgkQD4E0Cdjc7s1QBwCffuo5nzlbswGLeyocKUYTfrVF
X/gAoKNtkzdLDJPWUQGCbS+W4QjrZlwa
=u0k5
-----END PGP SIGNATURE-----

--9bvILXL7uF7kICMeOeeoPQ8F0L3eWATiH--

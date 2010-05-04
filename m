From: Alex Brandt <alunduil@alunduil.com>
Subject: boot fsck of btrfs
Date: Mon, 3 May 2010 19:39:43 -0500
Message-ID: <201005031939.47927.alunduil@alunduil.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3444347.MYcfSrnGoT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3444347.MYcfSrnGoT
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Qz23LhIgNIQ55PW"
Content-Transfer-Encoding: 7bit


--Boundary-01=_Qz23LhIgNIQ55PW
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I found recently that when I enabled the boot time check of the btrfs=20
filesystem that: one, there was no fsck.btrfs so it wasn't getting=20
called; and two, the parameters that were being passed were not being=20
handled appropriately by btrfsck.

I have created a hack that allows the second problem to be bypassed but=20
wanted to get a little more guidance on how I could improve btrfsck as=20
well as make it compliant with the fsck interface that /etc/init.d/fsck=20
of various distributions expects.

What options make sense?  What options could we potentially have?  Is=20
there an issue tracker somewhere that would outline this or where I could=20
create issues to keep track of this?

Would a modular design of the userspace utilities be frowned upon even if=20
they were statically linked?  Any suggestions or ideas would be welcome.

I've attached the patch I applied to btrfsck (which is by no means a=20
solution).

Regards,

Alex Brandt
=2D-=20
B.S. Physics & Computer Science
Minnesota State University Moorhead
http://www.alunduil.com

--Boundary-01=_Qz23LhIgNIQ55PW
Content-Type: text/x-patch;
  charset="UTF-8";
  name="btrfsck_boot.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="btrfsck_boot.patch"

diff --git a/btrfsck.c b/btrfsck.c
index 73f1836..b3fabcc 100644
=2D-- a/btrfsck.c
+++ b/btrfsck.c
@@ -1847,7 +1847,7 @@ static int all_backpointers_checked(struct extent_rec=
ord *rec, int print_errs)
 					(unsigned long long)rec->start,
 					back->full_backref ?
 					"parent" : "root",
=2D					back->full_backref ?=20
+					back->full_backref ?
 					(unsigned long long)dback->parent:
 					(unsigned long long)dback->root,
 					(unsigned long long)dback->owner,
@@ -1941,7 +1941,7 @@ static int check_owner_ref(struct btrfs_root *root,
 		btrfs_item_key_to_cpu(buf, &key, 0);
 	else
 		btrfs_node_key_to_cpu(buf, &key, 0);
=2D=09
+
 	btrfs_init_path(&path);
 	path.lowest_level =3D level + 1;
 	ret =3D btrfs_search_slot(NULL, ref_root, &key, &path, 0, 0);
@@ -2047,7 +2047,7 @@ static struct data_backref *find_data_backref(struct =
extent_record *rec,
 		if (!node->is_data)
 			continue;
 		back =3D (struct data_backref *)node;
=2D		if (parent > 0) {=20
+		if (parent > 0) {
 			if (!node->full_backref)
 				continue;
 			if (parent =3D=3D back->parent)
@@ -2583,7 +2583,7 @@ static int run_next_block(struct btrfs_root *root,
 				ref =3D btrfs_item_ptr(buf, i,
 						struct btrfs_shared_data_ref);
 				add_data_backref(extent_cache,
=2D					key.objectid, key.offset, 0, 0, 0,=20
+					key.objectid, key.offset, 0, 0, 0,
 					btrfs_shared_data_ref_count(buf, ref),
 					0);
 				continue;
@@ -2626,7 +2626,7 @@ static int run_next_block(struct btrfs_root *root,
 					     ptr, size, 0, 0, 1, 0);
 			BUG_ON(ret);
=20
=2D			add_tree_backref(extent_cache, ptr, parent,=20
+			add_tree_backref(extent_cache, ptr, parent,
 					 owner, 1);
=20
 			if (level > 1) {
@@ -2815,13 +2815,18 @@ int main(int ac, char **av)
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
 	int ret;
+    int i;
=20
 	if (ac < 2)
 		print_usage();
=20
 	radix_tree_init();
 	cache_tree_init(&root_cache);
=2D	root =3D open_ctree(av[1], 0, 0);
+
+    for (i =3D 1; !strncmp("-", av[i], 1) && i < ac; ++i);
+    if (i >=3D ac)
+        print_usage();
+	root =3D open_ctree(av[i], 0, 0);
=20
 	if (root =3D=3D NULL)
 		return 1;

--Boundary-01=_Qz23LhIgNIQ55PW--

--nextPart3444347.MYcfSrnGoT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkvfbNMACgkQvpZ9jByxpSdMUQCggYcNSmwPzP3iSYGwWXrYzW5S
FPMAn01zxiKSX30DUbUknhbRcm5Q1xG+
=KFCX
-----END PGP SIGNATURE-----

--nextPart3444347.MYcfSrnGoT--

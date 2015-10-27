Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbbJ0WZT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 18:25:19 -0400
From: Neil Brown <neil@brown.name>
To: Chris Mason <clm@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Date: Wed, 28 Oct 2015 07:25:10 +0900
Cc: Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] make btrfs subvol mounts appear in /proc/mounts
Message-ID: <87oafkc5kp.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


If you create a subvolume in btrfs and access it (by name) without
mounting it, then the subvolume looks like a separate mount to some
extent, returning a different st_dev to stat(), but it doesn't look like
a separate mount in that it isn't listed in /proc/mounts. This
inconsistency can confuse tools.

This patch causes these subvolumes to become separate mounts by using
the VFS' automount functionality, much like NFS uses automount when it
discovered mountpoints on the server.

The VFS currently makes it impossible to auto-mount a directory on to itself
(i.e. a bind mount).  For NFS this isn't a problem as a new superblock
is created for the child filesystem so there are two separate dentries
(and inodes) for the one directory: one in the parent filesystem, one in
the child (note that the two superblocks share a common connection to
the server so there is still a lot of commonality).

BTRFS has chosen instead to use a single superblock for all subvolumes.
This results in a single dentry for the subvol-root.  A dentry which
must be auto-mounted on itself.

This creates 2 problems.
Firstly, we want to be selective about when the dentry triggers an
automount.  When the dentry is not the root of a vfsmount, we do want to
trigger an automount.  When it is the root, we don't.
I have modified follow_managed() to understand that if ->d_manage()
returns 1, then an automount should be suppressed when
  path->mnt->mnt_root =3D=3D path->dentry.

Secondly, finish_automount() explicitly tests for the case of mounting a
dentry on top of itself and fails with -ELOOP.  I've changed this to
only fail if the mounted-on directory is the root in its own vfsmount.
So now mounting a dentry on itself can be OK, but mounting the same
dentry on top of that will cause -ELOOP.

With those two VFS changes, it is straight forward to enable automounts for
btrfs subvolumes and to use clone_private_mount to create the required
vfsmount.

I have not added infrastructure to time-out the submounts after a period
of inactivity in the way that NFS does.  If that is desirable (I'm not
sure of the benefits) it can easily be added as a subsequent patch.

If this approach is acceptable, I will resubmit addressing any issues
raised and with proper updates for the automount documentation.

Thanks for any comments,
NeilBrown


diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 611b66d73e80..e96c53590f72 100644
=2D-- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5621,6 +5621,23 @@ static void btrfs_dentry_release(struct dentry *dent=
ry)
 	kfree(dentry->d_fsdata);
 }
=20
+static int btrfs_dentry_manage(struct dentry *dentry, bool in_rcu)
+{
+	/* This is a 'rebind automount'.  So only trigger automount
+	 * when the dentry isn't the root of a mountpoint.
+	 */
+	return 1;
+}
+
+static struct vfsmount *btrfs_dentry_automount(struct path *path)
+{
+	struct vfsmount *mnt;
+	mnt =3D clone_private_mount(path);
+	if (!IS_ERR(mnt))
+		mntget(mnt);
+	return mnt;
+}
+
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentr=
y,
 				   unsigned int flags)
 {
@@ -5633,6 +5650,8 @@ static struct dentry *btrfs_lookup(struct inode *dir,=
 struct dentry *dentry,
 		else
 			return ERR_CAST(inode);
 	}
+	if (inode && inode->i_ino =3D=3D BTRFS_FIRST_FREE_OBJECTID)
+		dentry->d_flags |=3D DCACHE_MANAGE_TRANSIT | DCACHE_NEED_AUTOMOUNT;
=20
 	return d_splice_alias(inode, dentry);
 }
@@ -9990,4 +10009,6 @@ static const struct inode_operations btrfs_symlink_i=
node_operations =3D {
 const struct dentry_operations btrfs_dentry_operations =3D {
 	.d_delete	=3D btrfs_dentry_delete,
 	.d_release	=3D btrfs_dentry_release,
+	.d_manage	=3D btrfs_dentry_manage,
+	.d_automount	=3D btrfs_dentry_automount,
 };
diff --git a/fs/namei.c b/fs/namei.c
index 33e9495a3129..07e4bbbadae1 100644
=2D-- a/fs/namei.c
+++ b/fs/namei.c
@@ -1178,6 +1178,7 @@ static int follow_managed(struct path *path, struct n=
ameidata *nd)
 	       unlikely(managed !=3D 0)) {
 		/* Allow the filesystem to manage the transit without i_mutex
 		 * being held. */
+		ret =3D 0;
 		if (managed & DCACHE_MANAGE_TRANSIT) {
 			BUG_ON(!path->dentry->d_op);
 			BUG_ON(!path->dentry->d_op->d_manage);
@@ -1207,7 +1208,12 @@ static int follow_managed(struct path *path, struct =
nameidata *nd)
=20
 		/* Handle an automount point */
 		if (managed & DCACHE_NEED_AUTOMOUNT) {
=2D			ret =3D follow_automount(path, nd, &need_mntput);
+			if (ret =3D=3D 1 && path->mnt->mnt_root =3D=3D path->dentry) {
+				/* only automount when not the root */
+				ret =3D 0;
+				break;
+			} else
+				ret =3D follow_automount(path, nd, &need_mntput);
 			if (ret < 0)
 				break;
 			continue;
@@ -1219,7 +1225,7 @@ static int follow_managed(struct path *path, struct n=
ameidata *nd)
=20
 	if (need_mntput && path->mnt =3D=3D mnt)
 		mntput(path->mnt);
=2D	if (ret =3D=3D -EISDIR)
+	if (ret =3D=3D -EISDIR || ret > 0)
 		ret =3D 0;
 	if (need_mntput)
 		nd->flags |=3D LOOKUP_JUMPED;
diff --git a/fs/namespace.c b/fs/namespace.c
index 0570729c87fd..adfcb125bef0 100644
=2D-- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2431,7 +2431,8 @@ int finish_automount(struct vfsmount *m, struct path =
*path)
 	BUG_ON(mnt_get_count(mnt) < 2);
=20
 	if (m->mnt_sb =3D=3D path->mnt->mnt_sb &&
=2D	    m->mnt_root =3D=3D path->dentry) {
+	    m->mnt_root =3D=3D path->dentry &&
+	    path->mnt->mnt_root =3D=3D path->dentry) {
 		err =3D -ELOOP;
 		goto fail;
 	}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWL/nGAAoJEDnsnt1WYoG5qBkP/04gREHHA13My5Fpa9+HHwzO
aHWY/rS9dayaTwglTKYaUwrY6trh5z3VdoOVVbTqldol2yP7kgRiWiHyWgyf3qVv
5UHYc994nWVUxPBbMuXygF5eqaR/kxZtb80qhxKJn2LeVrx1SUDyCdMWsmnoBYgh
WzKKlUKuvVf1fTrVq5VZ6ueipXWsteH1IeyyL7Mb4DmNZ0Ocksrv1UC9Wpvaq28P
2EtzdFBRv3TVzxQRtjho3E5yQQPuwnkLzfM0aFLCXQtXUQ1MubrifyNx8w4RczSt
/hiUoIyymqgIC8032eTkI9HWAHzJOLLA+iQMfW2AHH6k254UXk49aNrCxWbkKfiv
rbjWnNAEqrZA7pINLXzfsPutvmOJcXOLGtWW6keqo4uUmb1mI5mmpug2Yj92xL+w
U01ZEu5A1Gu4GZ++NB8hqAmi0+JX+Y+CiA+WXRwlERVu4K882Us6MPeoHzDjLXIh
z078LGs0+3cWGC7z249B1bq99c3RmCquqiQCub6fuuf7Li8l9Fgw3tYIrE5cIhCL
vXmN0uKeHu9pA2ywEF1RwGJueqc4UjVjWAdkB8ARhvM0Px7m2Ery1jabuAw/8aBC
wUK2jvHniiR6YKmATiOMkIiFUEiJCRmgDwplWMN4ACGli9J8DwN6ZrCay+vzc6gj
2KxcwrhzyQjQScIwnxyP
=eBEi
-----END PGP SIGNATURE-----
--=-=-=--

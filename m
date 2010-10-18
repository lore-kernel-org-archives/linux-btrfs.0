From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [RFC] Allow to exec "btrfs subvolume delete" by a non root user
Date: Mon, 18 Oct 2010 20:04:51 +0200
Message-ID: <201010182004.59352.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1559022.dJCM3C7bBv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1559022.dJCM3C7bBv
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all

like my previous patch, this one allow to remove a subvolume by an ordinary
 user. Instead of adding this capability to the rmdir(2) syscall, I update =
the
BTRFS_IOC_SNAP_DESTROY ioctl, relaxing the rules to be execute.
The checks are the ones performed by the rmdir(2) syscall. So a=20
subvolume must be empty to be removed by a non-root user. I think that this
 increases a lot the usefulness of the snapshot/subvolume.

It is possible to pull the code from the branch named "rm-subvolume-not-roo=
t"=20
of the following repository:

      http://cassiopea.homelinux.net/git/btrfs-unstable.git =20

Comments are welcome.

Reagrds
G.Baroncelli

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..5bbb6bc 100644
=2D-- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -395,6 +395,76 @@ fail:
 	return ret;
 }
=20
+/*  copy of check_sticky in fs/namei.c()=20
+* It's inline, so penalty for filesystems that don't use sticky bit is
+* minimal.
+*/
+static inline int btrfs_check_sticky(struct inode *dir, struct inode *inod=
e)
+{
+	uid_t fsuid =3D current_fsuid();
+
+	if (!(dir->i_mode & S_ISVTX))
+		return 0;
+	if (inode->i_uid =3D=3D fsuid)
+		return 0;
+	if (dir->i_uid =3D=3D fsuid)
+		return 0;
+	return !capable(CAP_FOWNER);
+}
+
+/*  copy of may_delete in fs/namei.c()=20
+ *	Check whether we can remove a link victim from directory dir, check
+ *  whether the type of victim is right.
+ *  1. We can't do it if dir is read-only (done in permission())
+ *  2. We should have write and exec permissions on dir
+ *  3. We can't remove anything from append-only dir
+ *  4. We can't do anything with immutable dir (done in permission())
+ *  5. If the sticky bit on dir is set we should either
+ *	a. be owner of dir, or
+ *	b. be owner of victim, or
+ *	c. have CAP_FOWNER capability
+ *  6. If the victim is append-only or immutable we can't do antyhing with
+ *     links pointing to it.
+ *  7. If we were asked to remove a directory and victim isn't one - ENOTD=
IR.
+ *  8. If we were asked to remove a non-directory and victim isn't one - E=
ISDIR.
+ *  9. We can't remove a root or mountpoint.
+ * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
+ *     nfs_async_unlink().
+ */
+
+static int btrfs_may_delete(struct inode *dir,struct dentry *victim,int is=
dir)
+{
+	int error;
+
+	if (!victim->d_inode)
+		return -ENOENT;
+
+	BUG_ON(victim->d_parent->d_inode !=3D dir);
+	audit_inode_child(victim, dir);
+
+	error =3D inode_permission(dir, MAY_WRITE | MAY_EXEC);
+	if (error)
+		return error;
+	if (IS_APPEND(dir))
+		return -EPERM;
+	if (btrfs_check_sticky(dir, victim->d_inode)||
+		IS_APPEND(victim->d_inode)||
+	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
+		return -EPERM;
+	if (isdir) {
+		if (!S_ISDIR(victim->d_inode->i_mode))
+			return -ENOTDIR;
+		if (IS_ROOT(victim))
+			return -EBUSY;
+	} else if (S_ISDIR(victim->d_inode->i_mode))
+		return -EISDIR;
+	if (IS_DEADDIR(dir))
+		return -ENOENT;
+	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
+		return -EBUSY;
+	return 0;
+}
+
 /* copy of may_create in fs/namei.c() */
 static inline int btrfs_may_create(struct inode *dir, struct dentry *child)
 {
@@ -1227,9 +1297,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct f=
ile *file,
 	int ret;
 	int err =3D 0;
=20
=2D	if (!capable(CAP_SYS_ADMIN))
=2D		return -EPERM;
=2D
 	vol_args =3D memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args))
 		return PTR_ERR(vol_args);
@@ -1259,6 +1326,20 @@ static noinline int btrfs_ioctl_snap_destroy(struct =
file *file,
 	}
=20
 	inode =3D dentry->d_inode;
+	if (!capable(CAP_SYS_ADMIN)){
+		/* regolar user */
+		/* check if subvolume is empty */
+		if (inode->i_size > BTRFS_EMPTY_DIR_SIZE){
+			err =3D -ENOTEMPTY;
+			goto out_dput;
+		}
+		/* check if subvolume may be deleted by a non-root user */=09
+		if (btrfs_may_delete(dir, dentry, 1)){
+			err =3D -EPERM;
+			goto out_dput;
+		}
+	}
+
 	if (inode->i_ino !=3D BTRFS_FIRST_FREE_OBJECTID) {
 		err =3D -EINVAL;
 		goto out_dput;



=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1559022.dJCM3C7bBv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMvIxDvwTxYT3FBRIRAvgaAKCAfrqfTty77SIZ1HUIzO2kr013AACcDCni
wwvTNU84xicwH199PENRcgM=
=1Hl0
-----END PGP SIGNATURE-----

--nextPart1559022.dJCM3C7bBv--

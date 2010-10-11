From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH V2] Removing a subvolume by an ordinary user
Date: Mon, 11 Oct 2010 20:08:19 +0200
Message-ID: <201010112008.31736.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1623000.Uuu3XikxLm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1623000.Uuu3XikxLm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

enclosed you can find a patch which permits to remove a volume via the=20
rmdir(2) syscall by an ordinary user.=20
The rules for a subvolume removal are the same ones of a directory:
=2D the user must have the write permission on the parent directory
=2D the subvolume must be empty

The mains differences between calling rmdir(2) on a subvolume and calling t=
he=20
BTRFS_IOC_SNAP_DESTROY ioctl are:

=2D rmdir(2) requires the subvolume to be empty (the user has to empty the=
=20
subvolume before removing it, like the rm -rf command does)
=2D rmdir(2) is a synchronous operation (instead BTRFS_IOC_SNAP_DESTROY wor=
ks=20
in background)

The previous statements have the following (nice) consequences:
=2D the CAP_ADMIN capability is not required anymore to remove a subvolume.=
=20
BTRFS_IOC_SNAP_DESTROY requires CAP_ADMIN because the subvolume removal is
performed in background so it would not be possible to return an error if=20
the user has not the privilege of removing a file.
=2D when the rmdir(2) syscall returns the space is really freed, and there =
is=20
no necessity to create another API to wait the ends of the=20
BTRFS_IOC_SNAP_DESTROY ioctl.

The only advantage of the BTRFS_IOC_SNAP_DESTROY ioctl is its greater speed
in removing a not empty subvolume.

I simplify the code respect my previous post, removing a un-needed call to =
the
function may_destroy_subvol().=20

You can pull the code from the branch named "rmdir-subvolume" of the follow=
ing
repository:

	http://cassiopea.homelinux.net/git/btrfs-unstable.git =20

As usual, comments are welcome

Regards
G.Baroncelli

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f08427c..0df2fb0 100644
=2D-- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2944,6 +2944,84 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *t=
rans,
 	return 0;
 }
=20
+static noinline int btrfs_snap_destroy(struct inode *dir,
+				       struct dentry *dentry)
+{
+
+	struct inode *inode;
+	struct btrfs_root *root =3D BTRFS_I(dir)->root;
+	struct btrfs_root *dest =3D NULL;
+	struct btrfs_trans_handle *trans;
+	int ret;
+	int err =3D 0;
+
+	if (IS_ERR(dentry)) {
+		err =3D PTR_ERR(dentry);
+		goto out;
+	}
+
+	if (!dentry->d_inode) {
+		err =3D -ENOENT;
+		goto out;
+	}
+
+	inode =3D dentry->d_inode;
+	if (inode->i_ino !=3D BTRFS_FIRST_FREE_OBJECTID) {
+		err =3D -EINVAL;
+		goto out;
+	}
+
+	dest =3D BTRFS_I(inode)->root;
+
+	down_write(&root->fs_info->subvol_sem);
+
+	/* remove this check because the directory is empty.
+	 * err =3D may_destroy_subvol(dest);
+	 * if (err)
+	 *	goto out_up_write;
+	 */
+
+	trans =3D btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans)) {
+		err =3D PTR_ERR(trans);
+		goto out_up_write;
+	}
+	trans->block_rsv =3D &root->fs_info->global_block_rsv;
+
+	ret =3D btrfs_unlink_subvol(trans, root, dir,
+				dest->root_key.objectid,
+				dentry->d_name.name,
+				dentry->d_name.len);
+	BUG_ON(ret);
+
+	btrfs_record_root_in_trans(trans, dest);
+
+	memset(&dest->root_item.drop_progress, 0,
+		sizeof(dest->root_item.drop_progress));
+	dest->root_item.drop_level =3D 0;
+	btrfs_set_root_refs(&dest->root_item, 0);
+
+	if (!xchg(&dest->orphan_item_inserted, 1)) {
+		ret =3D btrfs_insert_orphan_item(trans,
+					root->fs_info->tree_root,
+					dest->root_key.objectid);
+		BUG_ON(ret);
+	}
+
+	ret =3D btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+	inode->i_flags |=3D S_DEAD;
+out_up_write:
+	up_write(&root->fs_info->subvol_sem);
+	if (!err) {
+		shrink_dcache_sb(root->fs_info->sb);
+		btrfs_invalidate_inodes(dest);
+		/*d_delete(dentry);*/
+	}
+out:
+	return err;
+}
+
 static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode =3D dentry->d_inode;
@@ -2952,10 +3030,12 @@ static int btrfs_rmdir(struct inode *dir, struct de=
ntry *dentry)
 	struct btrfs_trans_handle *trans;
 	unsigned long nr =3D 0;
=20
=2D	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE ||
=2D	    inode->i_ino =3D=3D BTRFS_FIRST_FREE_OBJECTID)
+	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
=20
+	if (inode->i_ino =3D=3D BTRFS_FIRST_FREE_OBJECTID)
+		return btrfs_snap_destroy(dir, dentry);
+
 	trans =3D __unlink_start_trans(dir, dentry);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);


=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart1623000.Uuu3XikxLm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMs1KUvwTxYT3FBRIRAtf8AJ9AO1FMk7pZlStCIH9CXfkU/bI40gCfZknf
/BQyisuG919Jt+NFiU4wXX4=
=Mcvb
-----END PGP SIGNATURE-----

--nextPart1623000.Uuu3XikxLm--

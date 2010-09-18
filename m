From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] Removing a subvolume by an ordinary user
Date: Sat, 18 Sep 2010 15:15:15 +0200
Message-ID: <201009181515.23436.kreijack@libero.it>
References: <6546544.196961284637653794.JavaMail.defaultUser@defaultHost>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart40152792.dfPOXLRzTS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6546544.196961284637653794.JavaMail.defaultUser@defaultHost>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart40152792.dfPOXLRzTS
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

enclosed you can find a patch which permits to remove a volume via the=20
rmdir(2) syscall by an ordinary user.=20
The rules for a subvolume removal are the same ones of a directory:
=2D the user shall have the write permission on the parent directory
=2D the subvolume shall be empty

Comments are welcome

Reagrds
G.Baroncelli

NB: this is code is not fully tested, handle with care.

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f08427c..47d11d8 100644
=2D-- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2944,6 +2944,86 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *t=
rans,
 	return 0;
 }
=20
+int may_destroy_subvol(struct btrfs_root *root);
+static noinline int btrfs_snap_destroy(struct inode *dir,
+				       struct dentry *dentry)
+
+{
+
+	struct inode *inode;
+	struct btrfs_root *root =3D BTRFS_I(dir)->root;
+	struct btrfs_root *dest =3D NULL;
+	struct btrfs_trans_handle *trans;
+
+	int ret;
+	int err =3D 0;
+
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
+	err =3D may_destroy_subvol(dest);
+	if (err)
+		goto out_up_write;
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
@@ -2952,10 +3032,12 @@ static int btrfs_rmdir(struct inode *dir, struct de=
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
@@ -4242,7 +4324,6 @@ static int btrfs_real_readdir(struct file *filp, void=
 *dirent,
 			over =3D filldir(dirent, name_ptr, name_len,
 				       found_key.offset, location.objectid,
 				       d_type);
=2D
 skip:
 			if (name_ptr !=3D tmp_name)
 				kfree(name_ptr);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..a7b242e 100644
=2D-- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -855,7 +855,7 @@ out:
 /*
  * helper to check if the subvolume references other subvolumes
  */
=2Dstatic noinline int may_destroy_subvol(struct btrfs_root *root)
+int may_destroy_subvol(struct btrfs_root *root)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;




=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.=
it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart40152792.dfPOXLRzTS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBMlLtjvwTxYT3FBRIRAm9+AJ9WzKjfxR/gc70+koEc0aWlrh0LqACfaWIY
jTZC2T5fq5oIfwwJXALrDv4=
=0TFF
-----END PGP SIGNATURE-----

--nextPart40152792.dfPOXLRzTS--

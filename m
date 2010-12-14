From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [PATCH] BTRFS_IOC_TREE_SEARCH: store and use the last key found
Date: Tue, 14 Dec 2010 20:05:43 +0100
Message-ID: <201012142005.51289.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2717381.eeGUKD5D5o";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2717381.eeGUKD5D5o
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

following the thread about the BTRFS_IOC_TREE_SEARCH ioctl [1], I made a pa=
tch=20
which try to address the problem of restarting the ioctl.

In the current solution is the application during the restart of the search=
 to=20
fill the min_* fields in the "struct btrfs_ioctl_search_key". In general th=
e=20
values set are the last one returned "+1". But doing so we reduce the=20
"acceptance criteria window".

I propose to add three more fields in the struct btrfs_ioctl_search_key:

+       /* starting search key fields */
+       __u32 start_type;
+       __u64 start_objectid;
+       __u64 start_offset;
=20
Is resposibility of the program to fill these fields during the begin of th=
e=20
search. If these are 0, the code set these to the min_* values.
At the end of the search the kernel code stores the last key found + 1, in=
=20
accordance of the "acceptance criteria". So for the next search these field=
s=20
are "ready to use".

I didn't increase the size of the "struct btrfs_ioctl_search_key", because =
I=20
used some un-used fields.=20
I left the old code untouched, and I added another IOCTL, putting a warning=
 in=20
the old one. If we accept to break the binary compatibility we can reuse th=
e=20
old IOCTL.

This patch is complementary to the Li Zefan ones [1], so for the best=20
correctness both have to be applied.

Comments are welcome
Regards
G.Baroncelli

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f87552a..52075ed 100644
=2D-- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1134,11 +1134,11 @@ advance_key:
 	if (key->offset < (u64)-1 && key->offset < sk->max_offset)
 		key->offset++;
 	else if (key->type < (u8)-1 && key->type < sk->max_type) {
=2D		key->offset =3D 0;
+		key->offset =3D sk->min_offset;
 		key->type++;
 	} else if (key->objectid < (u64)-1 && key->objectid < sk-
>max_objectid) {
=2D		key->offset =3D 0;
=2D		key->type =3D 0;
+		key->offset =3D sk->min_offset;
+		key->type =3D sk->min_type;
 		key->objectid++;
 	} else
 		ret =3D 1;
@@ -1180,9 +1180,9 @@ static noinline int search_ioctl(struct inode *inode,
 		}
 	}
=20
=2D	key.objectid =3D sk->min_objectid;
=2D	key.type =3D sk->min_type;
=2D	key.offset =3D sk->min_offset;
+	key.objectid =3D max(sk->start_objectid, sk->min_objectid);
+	key.type =3D max(sk->start_type,sk->min_type);
+	key.offset =3D max(sk->start_offset, sk->min_offset);
=20
 	max_key.objectid =3D sk->max_objectid;
 	max_key.type =3D sk->max_type;
@@ -1207,6 +1207,11 @@ static noinline int search_ioctl(struct inode *inode,
 	}
 	ret =3D 0;
 err:
+	/* save the key for an hypothetic next iteration */
+	sk->start_objectid =3D key.objectid;
+	sk->start_type =3D key.type;
+	sk->start_offset =3D key.offset;
+
 	sk->nr_items =3D num_found;
 	btrfs_free_path(path);
 	return ret;
@@ -1234,6 +1239,39 @@ static noinline int btrfs_ioctl_tree_search(struct f=
ile=20
*file,
 	return ret;
 }
=20
+static noinline int btrfs_ioctl_tree_search_old(struct file *file,
+					   void __user *argp)
+{
+	struct btrfs_ioctl_search_args *args;
+	struct inode *inode;
+	int ret;
+
+	printk(KERN_WARNING "BTRFS: Pid=3D%d(%s) is using the buggy "
+			"BTRFS_IOC_TREE_SEARCH_V0 ioctl\n",=20
+			current->pid, current->comm);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	args =3D memdup_user(argp, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
+
+	inode =3D fdentry(file)->d_inode;
+
+	/* for compatibility */
+	args->key.start_objectid =3D 0;
+	args->key.start_type =3D 0;
+	args->key.start_offset =3D 0;
+
+	ret =3D search_ioctl(inode, args);
+	if (ret =3D=3D 0 && copy_to_user(argp, args, sizeof(*args)))
+		ret =3D -EFAULT;
+	kfree(args);
+	return ret;
+}
+
+
 /*
  * Search INODE_REFs to identify path name of 'dirid' directory
  * in a 'tree_id' tree. and sets path name to 'name'.
@@ -2286,6 +2324,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_trans_start(file);
 	case BTRFS_IOC_TRANS_END:
 		return btrfs_ioctl_trans_end(file);
+	case BTRFS_IOC_TREE_SEARCH_V0:
+		return btrfs_ioctl_tree_search_old(file, argp);
 	case BTRFS_IOC_TREE_SEARCH:
 		return btrfs_ioctl_tree_search(file, argp);
 	case BTRFS_IOC_INO_LOOKUP:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index c344d12..41dfde8 100644
=2D-- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -74,12 +74,12 @@ struct btrfs_ioctl_search_key {
 	 */
 	__u32 nr_items;
=20
=2D	/* align to 64 bits */
=2D	__u32 unused;
+	/* starting search key fields */
+	__u32 start_type;
+	__u64 start_objectid;
+	__u64 start_offset;
=20
 	/* some extra for later */
=2D	__u64 unused1;
=2D	__u64 unused2;
 	__u64 unused3;
 	__u64 unused4;
 };
@@ -182,7 +182,12 @@ struct btrfs_ioctl_space_args {
 				struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG_RANGE _IOW(BTRFS_IOCTL_MAGIC, 16, \
 				struct btrfs_ioctl_defrag_range_args)
=2D#define BTRFS_IOC_TREE_SEARCH _IOWR(BTRFS_IOCTL_MAGIC, 17, \
+
+/* buggy, don't use */
+
+#define BTRFS_IOC_TREE_SEARCH_V0 _IOWR(BTRFS_IOCTL_MAGIC, 17, \
+				   struct btrfs_ioctl_search_args)
+#define BTRFS_IOC_TREE_SEARCH_V1 _IOWR(BTRFS_IOCTL_MAGIC, 25, \
 				   struct btrfs_ioctl_search_args)
 #define BTRFS_IOC_INO_LOOKUP _IOWR(BTRFS_IOCTL_MAGIC, 18, \
 				   struct btrfs_ioctl_ino_lookup_args)


[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07513.html

=2D-=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.i=
t>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

--nextPart2717381.eeGUKD5D5o
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBNB8AHvwTxYT3FBRIRAlXOAJ9FFQrPjqyO2Ah02RuO1Y0A01sSxQCfY2Vx
k6qw0dN7/QqrfkEud/SCPyw=
=EyNE
-----END PGP SIGNATURE-----

--nextPart2717381.eeGUKD5D5o--

From: Josef Bacik <josef@redhat.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Fri, 11 May 2012 09:31:25 -0400
Message-ID: <20120511133124.GB2089@localhost.localdomain>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
 <20120424152141.GB3326@localhost.localdomain>
 <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
 <20120510203523.GD2061@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Christian Brunner <christian@brunner-muc.de>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120510203523.GD2061@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2012 at 04:35:23PM -0400, Josef Bacik wrote:
> On Fri, Apr 27, 2012 at 01:02:08PM +0200, Christian Brunner wrote:
> > Am 24. April 2012 18:26 schrieb Sage Weil <sage@newdream.net>:
> > > On Tue, 24 Apr 2012, Josef Bacik wrote:
> > >> On Fri, Apr 20, 2012 at 05:09:34PM +0200, Christian Brunner wrot=
e:
> > >> > After running ceph on XFS for some time, I decided to try btrf=
s again.
> > >> > Performance with the current "for-linux-min" branch and big me=
tadata
> > >> > is much better. The only problem (?) I'm still seeing is a war=
ning
> > >> > that seems to occur from time to time:
> > >
> > > Actually, before you do that... we have a new tool,
> > > test_filestore_workloadgen, that generates a ceph-osd-like worklo=
ad on the
> > > local file system. =A0It's a subset of what a full OSD might do, =
but if
> > > we're lucky it will be sufficient to reproduce this issue. =A0Som=
ething like
> > >
> > > =A0test_filestore_workloadgen --osd-data /foo --osd-journal /bar
> > >
> > > will hopefully do the trick.
> > >
> > > Christian, maybe you can see if that is able to trigger this warn=
ing?
> > > You'll need to pull it from the current master branch; it wasn't =
in the
> > > last release.
> >=20
> > Trying to reproduce with test_filestore_workloadgen didn't work for
> > me. So here are some instructions on how to reproduce with a minima=
l
> > ceph setup.
> >=20
> > You will need a single system with two disks and a bit of memory.
> >=20
> > - Compile and install ceph (detailed instructions:
> > http://ceph.newdream.net/docs/master/ops/install/mkcephfs/)
> >=20
> > - For the test setup I've used two tmpfs files as journal devices. =
To
> > create these, do the following:
> >=20
> > # mkdir -p /ceph/temp
> > # mount -t tmpfs tmpfs /ceph/temp
> > # dd if=3D/dev/zero of=3D/ceph/temp/journal0 count=3D500 bs=3D1024k
> > # dd if=3D/dev/zero of=3D/ceph/temp/journal1 count=3D500 bs=3D1024k
> >=20
> > - Now you should create and mount btrfs. Here is what I did:
> >=20
> > # mkfs.btrfs -l 64k -n 64k /dev/sda
> > # mkfs.btrfs -l 64k -n 64k /dev/sdb
> > # mkdir /ceph/osd.000
> > # mkdir /ceph/osd.001
> > # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sda /cep=
h/osd.000
> > # mount -o noatime,space_cache,inode_cache,autodefrag /dev/sdb /cep=
h/osd.001
> >=20
> > - Create /etc/ceph/ceph.conf similar to the attached ceph.conf. You
> > will probably have to change the btrfs devices and the hostname
> > (os39).
> >=20
> > - Create the ceph filesystems:
> >=20
> > # mkdir /ceph/mon
> > # mkcephfs -a -c /etc/ceph/ceph.conf
> >=20
> > - Start ceph (e.g. "service ceph start")
> >=20
> > - Now you should be able to use ceph - "ceph -s" will tell you abou=
t
> > the state of the ceph cluster.
> >=20
> > - "rbd create -size 100 testimg" will create an rbd image on the ce=
ph cluster.
> >=20
> > - Compile my test with "gcc -o rbdtest rbdtest.c -lrbd" and run it
> > with "./rbdtest testimg".
> >=20
> > I can see the first btrfs_orphan_commit_root warning after an hour =
or
> > so... I hope that I've described all necessary steps. If there is a
> > problem just send me a note.
> >=20
>=20
> Well I feel like an idiot, I finally get it to reproduce, go look at =
where I
> want to put my printks and theres the problem staring me right in the=
 face.
> I've looked seriously at this problem 2 or 3 times and have missed th=
is every
> single freaking time.  Here is the patch I'm trying, please try it on=
 yours to
> make sure it fixes the problem.  It takes like 2 hours for it to repr=
oduce for
> me so I won't be able to fully test it until tomorrow, but so far it =
hasn't
> broken anything so it should be good.  Thanks,
>=20

That previous patch was against btrfs-next, this patch is against 3.4-r=
c6 if you
are on mainline.  Thanks,

Josef


diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 9b9b15f..54af1fa 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -57,9 +57,6 @@ struct btrfs_inode {
 	/* used to order data wrt metadata */
 	struct btrfs_ordered_inode_tree ordered_tree;
=20
-	/* for keeping track of orphaned inodes */
-	struct list_head i_orphan;
-
 	/* list of all the delalloc inodes in the FS.  There are times we nee=
d
 	 * to write all the delalloc pages to disk, and this list is used
 	 * to walk them all.
@@ -156,6 +153,7 @@ struct btrfs_inode {
 	unsigned dummy_inode:1;
 	unsigned in_defrag:1;
 	unsigned delalloc_meta_reserved:1;
+	unsigned has_orphan_item:1;
=20
 	/*
 	 * always compress this one file
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8fd7233..aad2600 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1375,7 +1375,7 @@ struct btrfs_root {
 	struct list_head root_list;
=20
 	spinlock_t orphan_lock;
-	struct list_head orphan_list;
+	atomic_t orphan_inodes;
 	struct btrfs_block_rsv *orphan_block_rsv;
 	int orphan_item_inserted;
 	int orphan_cleanup_state;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a7ffc88..ff3bf4b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1153,7 +1153,6 @@ static void __setup_root(u32 nodesize, u32 leafsi=
ze, u32 sectorsize,
 	root->orphan_block_rsv =3D NULL;
=20
 	INIT_LIST_HEAD(&root->dirty_list);
-	INIT_LIST_HEAD(&root->orphan_list);
 	INIT_LIST_HEAD(&root->root_list);
 	spin_lock_init(&root->orphan_lock);
 	spin_lock_init(&root->inode_lock);
@@ -1166,6 +1165,7 @@ static void __setup_root(u32 nodesize, u32 leafsi=
ze, u32 sectorsize,
 	atomic_set(&root->log_commit[0], 0);
 	atomic_set(&root->log_commit[1], 0);
 	atomic_set(&root->log_writers, 0);
+	atomic_set(&root->orphan_inodes, 0);
 	root->log_batch =3D 0;
 	root->log_transid =3D 0;
 	root->last_log_commit =3D 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 61b16c6..78ce750 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2072,12 +2072,12 @@ void btrfs_orphan_commit_root(struct btrfs_tran=
s_handle *trans,
 	struct btrfs_block_rsv *block_rsv;
 	int ret;
=20
-	if (!list_empty(&root->orphan_list) ||
+	if (atomic_read(&root->orphan_inodes) ||
 	    root->orphan_cleanup_state !=3D ORPHAN_CLEANUP_DONE)
 		return;
=20
 	spin_lock(&root->orphan_lock);
-	if (!list_empty(&root->orphan_list)) {
+	if (atomic_read(&root->orphan_inodes)) {
 		spin_unlock(&root->orphan_lock);
 		return;
 	}
@@ -2134,8 +2134,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *t=
rans, struct inode *inode)
 		block_rsv =3D NULL;
 	}
=20
-	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+	if (!BTRFS_I(inode)->has_orphan_item) {
+		BTRFS_I(inode)->has_orphan_item =3D 1;
 #if 0
 		/*
 		 * For proper ENOSPC handling, we should do orphan
@@ -2148,6 +2148,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *t=
rans, struct inode *inode)
 			insert =3D 1;
 #endif
 		insert =3D 1;
+		atomic_inc(&root->orphan_inodes);
 	}
=20
 	if (!BTRFS_I(inode)->orphan_meta_reserved) {
@@ -2195,9 +2196,8 @@ int btrfs_orphan_del(struct btrfs_trans_handle *t=
rans, struct inode *inode)
 	int release_rsv =3D 0;
 	int ret =3D 0;
=20
-	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		list_del_init(&BTRFS_I(inode)->i_orphan);
+	if (BTRFS_I(inode)->has_orphan_item) {
+		BTRFS_I(inode)->has_orphan_item =3D 0;
 		delete_item =3D 1;
 	}
=20
@@ -2205,7 +2205,6 @@ int btrfs_orphan_del(struct btrfs_trans_handle *t=
rans, struct inode *inode)
 		BTRFS_I(inode)->orphan_meta_reserved =3D 0;
 		release_rsv =3D 1;
 	}
-	spin_unlock(&root->orphan_lock);
=20
 	if (trans && delete_item) {
 		ret =3D btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
@@ -2215,6 +2214,9 @@ int btrfs_orphan_del(struct btrfs_trans_handle *t=
rans, struct inode *inode)
 	if (release_rsv)
 		btrfs_orphan_release_metadata(inode);
=20
+	if (trans && delete_item)
+		atomic_dec(&root->orphan_inodes);
+
 	return 0;
 }
=20
@@ -2352,9 +2354,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
 		 */
-		spin_lock(&root->orphan_lock);
-		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
-		spin_unlock(&root->orphan_lock);
+		atomic_inc(&root->orphan_inodes);
+		BTRFS_I(inode)->has_orphan_item =3D 1;
=20
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
@@ -3671,7 +3672,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
=20
 	if (root->fs_info->log_root_recovering) {
-		BUG_ON(!list_empty(&BTRFS_I(inode)->i_orphan));
+		BUG_ON(!BTRFS_I(inode)->has_orphan_item);
 		goto no_delete;
 	}
=20
@@ -6914,6 +6915,7 @@ struct inode *btrfs_alloc_inode(struct super_bloc=
k *sb)
 	ei->dummy_inode =3D 0;
 	ei->in_defrag =3D 0;
 	ei->delalloc_meta_reserved =3D 0;
+	ei->has_orphan_item =3D 0;
 	ei->force_compress =3D BTRFS_COMPRESS_NONE;
=20
 	ei->delayed_node =3D NULL;
@@ -6927,7 +6929,6 @@ struct inode *btrfs_alloc_inode(struct super_bloc=
k *sb)
 	mutex_init(&ei->log_mutex);
 	mutex_init(&ei->delalloc_mutex);
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
-	INIT_LIST_HEAD(&ei->i_orphan);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
 	RB_CLEAR_NODE(&ei->rb_node);
@@ -6972,13 +6973,11 @@ void btrfs_destroy_inode(struct inode *inode)
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 	}
=20
-	spin_lock(&root->orphan_lock);
-	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+	if (BTRFS_I(inode)->has_orphan_item) {
 		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
 		       (unsigned long long)btrfs_ino(inode));
-		list_del_init(&BTRFS_I(inode)->i_orphan);
+		atomic_dec(&root->orphan_inodes);
 	}
-	spin_unlock(&root->orphan_lock);
=20
 	while (1) {
 		ordered =3D btrfs_lookup_first_ordered_extent(inode, (u64)-1);
--
To unsubscribe from this list: send the line "unsubscribe ceph-devel" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

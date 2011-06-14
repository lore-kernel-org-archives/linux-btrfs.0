From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: bug caused by removal of trans_mutex? (Was: Re: kernel BUG at fs/btrfs/extent-tree.c:6164!)
Date: Tue, 14 Jun 2011 11:24:45 +0800
Message-ID: <BANLkTik9NcRhK9MS6G8aVxY9xvgXfpR=hA@mail.gmail.com>
References: <4DEC90CB.4050609@jp.fujitsu.com>
	<4DEDB7AF.2060308@cn.fujitsu.com>
	<4DEDBE4B.2020403@jp.fujitsu.com>
	<4DEDC293.30105@jp.fujitsu.com>
	<4DEDE03B.9050907@jp.fujitsu.com>
	<4DEDE328.5060405@cn.fujitsu.com>
	<1307461229-sup-9822@shiny>
	<4DEF04CF.8010502@jp.fujitsu.com>
	<4DF5B889.5080202@cn.fujitsu.com>
	<BANLkTi=m2CkcSQNPNja=A7eG62vLstM1sw@mail.gmail.com>
	<1307994828-sup-6461@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	liubo <liubo2009@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307994828-sup-6461@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2011 at 3:55 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Yan, Zheng's message of 2011-06-13 10:58:35 -0400:
>> The usage of trans_mutex in relocation code is subtle. It controls
>> interaction of relocation
>> with transaction start, transaction commit and snapshot creation.
>> Simple replacing
>> trans_mutex with trans_lock is wrong.
>
> So, I've got a mutex around the reloc_root here and that was almost b=
ut
> not quite enough. =A0It looks like the biggest problem is that we nee=
d to
> wait in btrfs_record_root_in_trans for anyone inside merge_reloc_root=
s.
>
> I'm surviving much longer with a patch in place that synchronizes
> btrfs_record_root_in_trans better.
>
> Zheng if you have other comments on the locking please let me know.
>

following untested patch may help.
---
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 378b5b4..0b20dda 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -951,6 +951,7 @@ struct btrfs_fs_info {
 	struct mutex cleaner_mutex;
 	struct mutex chunk_mutex;
 	struct mutex volume_mutex;
+	struct mutex reloc_mutex;
 	/*
 	 * this protects the ordered operations list only while we are
 	 * processing all of the entries on it.  This way we make
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f68c68..28f8b11 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1714,6 +1714,7 @@ struct btrfs_root *open_ctree(struct super_block =
*sb,
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->volume_mutex);
+	mutex_init(&fs_info->reloc_mutex);
 	init_rwsem(&fs_info->extent_commit_sem);
 	init_rwsem(&fs_info->cleanup_work_sem);
 	init_rwsem(&fs_info->subvol_sem);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b1ef27c..620e4af 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1330,18 +1330,20 @@ int btrfs_init_reloc_root(struct
btrfs_trans_handle *trans,
 			  struct btrfs_root *root)
 {
 	struct btrfs_root *reloc_root;
-	struct reloc_control *rc =3D root->fs_info->reloc_ctl;
+	struct reloc_control *rc;
 	int clear_rsv =3D 0;

+	mutex_lock(&root->fs_info->reloc_mutex);
 	if (root->reloc_root) {
 		reloc_root =3D root->reloc_root;
 		reloc_root->last_trans =3D trans->transid;
-		return 0;
+		goto unlock;
 	}

+	rc =3D root->fs_info->reloc_ctl;
 	if (!rc || !rc->create_reloc_tree ||
 	    root->root_key.objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID)
-		return 0;
+		goto unlock;

 	if (!trans->block_rsv) {
 		trans->block_rsv =3D rc->block_rsv;
@@ -1353,6 +1355,8 @@ int btrfs_init_reloc_root(struct
btrfs_trans_handle *trans,

 	__add_reloc_root(reloc_root);
 	root->reloc_root =3D reloc_root;
+unlock:
+	mutex_unlock(&root->fs_info->reloc_mutex);
 	return 0;
 }

@@ -1367,8 +1371,9 @@ int btrfs_update_reloc_root(struct
btrfs_trans_handle *trans,
 	int del =3D 0;
 	int ret;

+	mutex_lock(&root->fs_info->reloc_mutex);
 	if (!root->reloc_root)
-		return 0;
+		goto unlock;

 	reloc_root =3D root->reloc_root;
 	root_item =3D &reloc_root->root_item;
@@ -1390,6 +1395,8 @@ int btrfs_update_reloc_root(struct
btrfs_trans_handle *trans,
 	ret =3D btrfs_update_root(trans, root->fs_info->tree_root,
 				&reloc_root->root_key, root_item);
 	BUG_ON(ret);
+unlock:
+	mutex_unlock(&root->fs_info->reloc_mutex);
 	return 0;
 }

@@ -2142,10 +2149,10 @@ int prepare_to_merge(struct reloc_control *rc, =
int err)
 	u64 num_bytes =3D 0;
 	int ret;

-	spin_lock(&root->fs_info->trans_lock);
+	mutex_lock(&root->fs_info->reloc_mutex);
 	rc->merging_rsv_size +=3D root->nodesize * (BTRFS_MAX_LEVEL - 1) * 2;
 	rc->merging_rsv_size +=3D rc->nodes_relocated * 2;
-	spin_unlock(&root->fs_info->trans_lock);
+	mutex_unlock(&root->fs_info->reloc_mutex);
 again:
 	if (!err) {
 		num_bytes =3D rc->merging_rsv_size;
@@ -2214,9 +2221,9 @@ int merge_reloc_roots(struct reloc_control *rc)
 	int ret;
 again:
 	root =3D rc->extent_root;
-	spin_lock(&root->fs_info->trans_lock);
+	mutex_lock(&root->fs_info->reloc_mutex);
 	list_splice_init(&rc->reloc_roots, &reloc_roots);
-	spin_unlock(&root->fs_info->trans_lock);
+	mutex_unlock(&root->fs_info->reloc_mutex);

 	while (!list_empty(&reloc_roots)) {
 		found =3D 1;
@@ -3590,17 +3597,17 @@ next:
 static void set_reloc_control(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info =3D rc->extent_root->fs_info;
-	spin_lock(&fs_info->trans_lock);
+	mutex_lock(&fs_info->reloc_mutex);
 	fs_info->reloc_ctl =3D rc;
-	spin_unlock(&fs_info->trans_lock);
+	mutex_unlock(&fs_info->reloc_mutex);
 }

 static void unset_reloc_control(struct reloc_control *rc)
 {
 	struct btrfs_fs_info *fs_info =3D rc->extent_root->fs_info;
-	spin_lock(&fs_info->trans_lock);
+	mutex_lock(&fs_info->reloc_mutex);
 	fs_info->reloc_ctl =3D NULL;
-	spin_unlock(&fs_info->trans_lock);
+	mutex_unlock(&fs_info->reloc_mutex);
 }

 static int check_extent_flags(u64 flags)
@@ -4335,16 +4342,16 @@ void btrfs_reloc_pre_snapshot(struct
btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending,
 			      u64 *bytes_to_reserve)
 {
-	struct btrfs_root *root;
+	struct btrfs_root *root =3D pending->root;
 	struct reloc_control *rc;

-	root =3D pending->root;
+	mutex_lock(&root->fs_info->reloc_mutex);
 	if (!root->reloc_root)
-		return;
+		goto unlock;

 	rc =3D root->fs_info->reloc_ctl;
 	if (!rc->merge_reloc_tree)
-		return;
+		goto unlock;

 	root =3D root->reloc_root;
 	BUG_ON(btrfs_root_refs(&root->root_item) =3D=3D 0);
@@ -4359,6 +4366,8 @@ void btrfs_reloc_pre_snapshot(struct
btrfs_trans_handle *trans,
 	 * reserve extra space.
 	 */
 	*bytes_to_reserve +=3D rc->nodes_relocated;
+unlock:
+	mutex_unlock(&root->fs_info->reloc_mutex);
 }

 /*
@@ -4374,8 +4383,9 @@ void btrfs_reloc_post_snapshot(struct
btrfs_trans_handle *trans,
 	struct reloc_control *rc;
 	int ret;

+	mutex_lock(&root->fs_info->reloc_mutex);
 	if (!root->reloc_root)
-		return;
+		goto unlock;

 	rc =3D root->fs_info->reloc_ctl;
 	rc->merging_rsv_size +=3D rc->nodes_relocated;
@@ -4398,4 +4408,6 @@ void btrfs_reloc_post_snapshot(struct
btrfs_trans_handle *trans,
 		ret =3D clone_backref_node(trans, rc, root, reloc_root);
 		BUG_ON(ret);
 	}
+unlock:
+	mutex_unlock(&root->fs_info->reloc_mutex);
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

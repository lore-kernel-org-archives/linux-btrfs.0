From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2271!
Date: Wed, 25 May 2011 15:25:41 -0400
Message-ID: <4DDD57B5.4070309@redhat.com>
References: <383ECFA9-9E51-4CCD-BE24-21FD30813217@gmx.net> <4DC0170C.8000906@redhat.com> <63FD432D-9173-40E4-9A82-711C8C625B0E@gmx.net> <4DDAB207.6060500@redhat.com> <8E5549B7-EBD9-4D7C-87FA-4C49D1C453F8@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Marco Neubauer <icetea1@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8E5549B7-EBD9-4D7C-87FA-4C49D1C453F8@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/24/2011 02:55 PM, Marco Neubauer wrote:
> 
> Am 23.05.2011 um 21:14 schrieb Josef Bacik:
> 
>> On 05/22/2011 07:13 AM, Marco Neubauer wrote:
>>>
>>> Am 03.05.2011 um 16:54 schrieb Josef Bacik:
>>>
>>>> On 04/27/2011 02:52 PM, Marco Neubauer wrote:
>>>>> Hi,
>>>>>
>>>>> this is happening mostly every night. I can't reproduce it right now.
>>>>> vanilla kernel 2.6.38.4
>>>>>
>>>>
>>>> Can you update to a newer kernel, this should be fixed there.  Thanks,
>>>
>>> It's happening again.
>>>
>>> ------------[ cut here ]------------
>>
>> Can you apply this patch and reproduce and send me the output so I can
>> figure
>> out whats going wrong?  Thanks,
> 

Hrm well that's doubly weird, the root should be right so it should be
able to find the orphan item to delete it for the bad inode, and why the
hell are we looping on that orphan item?  Remove the previous patch I
gave you and apply this one instead and run with this please and provide
me the log.  Sorry in advance, it will likely give you a giant log file
again.  Thanks,

Josef

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4bc852d..d85a309 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -149,6 +149,7 @@ struct btrfs_inode {
 	unsigned ordered_data_close:1;
 	unsigned orphan_meta_reserved:1;
 	unsigned dummy_inode:1;
+	unsigned orphaned:1;

 	/*
 	 * always compress this one file
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5fa0ae7..a49f848 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2314,6 +2314,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 	key.offset = (u64)-1;

 	while (1) {
+		int new;
+
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
@@ -2340,6 +2342,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		if (btrfs_key_type(&found_key) != BTRFS_ORPHAN_ITEM_KEY)
 			break;

+		printk(KERN_ERR "found orphan item for %llu on %llu\n",
+		       found_key.offset, root->root_key.objectid);
+
 		/* release the path since we're done with it */
 		btrfs_release_path(root, path);

@@ -2351,12 +2356,15 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		found_key.objectid = found_key.offset;
 		found_key.type = BTRFS_INODE_ITEM_KEY;
 		found_key.offset = 0;
-		inode = btrfs_iget(root->fs_info->sb, &found_key, root, NULL);
+		inode = btrfs_iget(root->fs_info->sb, &found_key, root, &new);
 		if (IS_ERR(inode)) {
 			ret = PTR_ERR(inode);
 			goto out;
 		}
+		printk(KERN_ERR "lookup of inode was%s from disk",
+		       new ? "" : " not");

+		BTRFS_I(inode)->orphaned = 1;
 		/*
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
@@ -2372,6 +2380,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 * do a destroy_inode
 		 */
 		if (is_bad_inode(inode)) {
+			printk(KERN_ERR "%llu is a bad inode, root is %llu\n",
+			       inode->i_ino, BTRFS_I(inode)->root->root_key.objectid);
 			trans = btrfs_start_transaction(root, 0);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
@@ -2385,7 +2395,10 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)

 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
+			printk(KERN_ERR "inode needs to be truncated\n");
 			if (!S_ISREG(inode->i_mode)) {
+				printk(KERN_ERR "file mode is %lu, nlink is "
+				       "%lu\n", inode->i_mode, inode->i_nlink);
 				WARN_ON(1);
 				iput(inode);
 				continue;
@@ -2393,6 +2406,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			nr_truncate++;
 			ret = btrfs_truncate(inode);
 		} else {
+			printk(KERN_ERR "inode needs to be unlinked\n");
 			nr_unlink++;
 		}

@@ -3755,10 +3769,18 @@ void btrfs_evict_inode(struct inode *inode)

 	truncate_inode_pages(&inode->i_data, 0);
 	if (inode->i_nlink && (btrfs_root_refs(&root->root_item) != 0 ||
-			       root == root->fs_info->tree_root))
+			       root == root->fs_info->tree_root)) {
+		if (BTRFS_I(inode)->orphaned)
+		printk(KERN_ERR "inode->i_nlink=%d, btrfs_root_refs=%d, "
+		       "root==tree_root=%s\n", inode->i_nlink,
+		       btrfs_root_refs(&root->root_item),
+		       (root == root->fs_info->tree_root) ? "yes" : "no");
 		goto no_delete;
+	}

 	if (is_bad_inode(inode)) {
+		if (BTRFS_I(inode)->orphaned)
+			printk(KERN_ERR "bad inode\n");
 		btrfs_orphan_del(NULL, inode);
 		goto no_delete;
 	}
@@ -3771,6 +3793,8 @@ void btrfs_evict_inode(struct inode *inode)
 	}

 	if (inode->i_nlink > 0) {
+		if (BTRFS_I(inode)->orphaned)
+			printk(KERN_ERR "inode->i_nlink=%d\n", inode->i_nlink);
 		BUG_ON(btrfs_root_refs(&root->root_item) != 0);
 		goto no_delete;
 	}
@@ -3805,6 +3829,8 @@ void btrfs_evict_inode(struct inode *inode)
 	if (ret == 0) {
 		ret = btrfs_orphan_del(trans, inode);
 		BUG_ON(ret);
+	} else if (BTRFS_I(inode)->orphaned) {
+		printk(KERN_ERR "truncate failed %d\n", ret);
 	}

 	nr = trans->blocks_used;
@@ -6859,6 +6885,7 @@ struct inode *btrfs_alloc_inode(struct super_block
*sb)
 	ei->ordered_data_close = 0;
 	ei->orphan_meta_reserved = 0;
 	ei->dummy_inode = 0;
+	ei->orphaned = 0;
 	ei->force_compress = BTRFS_COMPRESS_NONE;

 	inode = &ei->vfs_inode;
@@ -6942,12 +6969,16 @@ free:
 int btrfs_drop_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret = 0;

 	if (btrfs_root_refs(&root->root_item) == 0 &&
 	    root != root->fs_info->tree_root)
-		return 1;
+		ret = 1;
 	else
-		return generic_drop_inode(inode);
+		ret = generic_drop_inode(inode);
+	if (BTRFS_I(inode)->orphaned)
+		printk(KERN_ERR "drop is %d\n", ret);
+	return ret;
 }

 static void init_once(void *foo)

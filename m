From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs panic - BUG: soft lockup - CPU#0 stuck for 61s!
	[fs_mark:4573]
Date: Wed, 4 Jun 2008 16:12:00 -0400
Message-ID: <20080604201200.GB26959@think.oraclecorp.com>
References: <4844336F.1010807@redhat.com> <20080604012701.GC7805@think.oraclecorp.com> <4846F102.3000801@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4846F102.3000801@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 04, 2008 at 03:46:10PM -0400, Ric Wheeler wrote:
> Chris Mason wrote:
>> On Mon, Jun 02, 2008 at 01:52:47PM -0400, Ric Wheeler wrote:
>>   
>>> I can reliably get btrfs to panic by running my fs_mark code on a 
>>> newly  created file system with lots of threads on an 8-way box. If 
>>> this is too  aggressive, let me know ;-)
>>>
>>> Here is a summary of the panic:
>>>     
>>
>> I think this is due to a corruption on the data=ordered list.  I'm
>> testing a patch out here.
>>
>> -chris
>>   
> I can test it tomorrow if you send it on... Thanks!

Patch is below, but I don't have access to my test rig so I haven't
hammered on it yet.  I'm willing to corrupt Ric's test box, but everyone
else may want to wait ;)

-chris

diff -r 0b4ab489ffe1 file.c
--- a/file.c	Tue May 27 10:55:43 2008 -0400
+++ b/file.c	Wed Jun 04 16:10:40 2008 -0400
@@ -980,7 +980,7 @@ out_nolock:
 
 static int btrfs_release_file (struct inode * inode, struct file * filp)
 {
-	btrfs_del_ordered_inode(inode);
+	btrfs_del_ordered_inode(inode, 0);
 	return 0;
 }
 
diff -r 0b4ab489ffe1 inode.c
--- a/inode.c	Tue May 27 10:55:43 2008 -0400
+++ b/inode.c	Wed Jun 04 16:10:40 2008 -0400
@@ -861,7 +861,7 @@ static int btrfs_unlink(struct inode *di
 		 * we don't need to worry about
 		 * data=ordered
 		 */
-		btrfs_del_ordered_inode(inode);
+		btrfs_del_ordered_inode(inode, 0);
 	}
 
 	btrfs_end_transaction(trans, root);
@@ -3352,6 +3352,7 @@ void btrfs_destroy_inode(struct inode *i
 	WARN_ON(!list_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
 
+	btrfs_del_ordered_inode(inode, 1);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
diff -r 0b4ab489ffe1 ordered-data.c
--- a/ordered-data.c	Tue May 27 10:55:43 2008 -0400
+++ b/ordered-data.c	Wed Jun 04 16:10:40 2008 -0400
@@ -254,7 +254,7 @@ static void __btrfs_del_ordered_inode(st
 	return;
 }
 
-void btrfs_del_ordered_inode(struct inode *inode)
+void btrfs_del_ordered_inode(struct inode *inode, int force)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 root_objectid = root->root_key.objectid;
@@ -263,8 +263,8 @@ void btrfs_del_ordered_inode(struct inod
 		return;
 	}
 
-	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
-	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
+	if (!force && (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK)))
 		return;
 
 	spin_lock(&root->fs_info->new_trans_lock);
diff -r 0b4ab489ffe1 ordered-data.h
--- a/ordered-data.h	Tue May 27 10:55:43 2008 -0400
+++ b/ordered-data.h	Wed Jun 04 16:10:40 2008 -0400
@@ -38,6 +38,6 @@ int btrfs_find_first_ordered_inode(struc
 int btrfs_find_first_ordered_inode(struct btrfs_ordered_inode_tree *tree,
 				       u64 *root_objectid, u64 *objectid,
 				       struct inode **inode);
-void btrfs_del_ordered_inode(struct inode *inode);
+void btrfs_del_ordered_inode(struct inode *inode, int force);
 int btrfs_ordered_throttle(struct btrfs_root *root, struct inode *inode);
 #endif

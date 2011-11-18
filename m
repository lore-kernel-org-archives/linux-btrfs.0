From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198
 btrfs_orphan_commit_root+0xa8/0xc0
Date: Fri, 18 Nov 2011 14:52:27 -0500
Message-ID: <20111118195226.GB1811@localhost.localdomain>
References: <4EBA54F2.3030801@unilogicnetworks.net>
 <20111109153552.GB1810@localhost.localdomain>
 <4EBBBFFA.5090000@unilogicnetworks.net>
 <20111114160342.GB1947@localhost.localdomain>
 <4EC2B9E7.7020609@unilogicnetworks.net>
 <20111115192926.GB1944@localhost.localdomain>
 <4EC2C940.40605@unilogicnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Stefan Kleijkers <stefan@unilogicnetworks.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC2C940.40605@unilogicnetworks.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 15, 2011 at 09:19:12PM +0100, Stefan Kleijkers wrote:
> Hello Josef,
> 
> You can find the complete dmesg paste on: http://pastebin.com/R4dFfSdQ
> 
> But I doubt it will add more information.
> 

Sorry I forgot about you :).  Here is a new debug patch, it will print something
out right before it panics so make sure to get that info, and it will also be
spitting stuff out to the trace buffer.  So make sure you have tracing enabled,
usually distros mount debugfs so you can cd /sys/kernel/debug/tracing and cat
trace and you should see something.  When it panics cat trace > somefile and
send me the file and the dmesg so I can figure out what went wrong.  Thanks,

Josef


diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 24cfd10..d887608 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3762,6 +3762,11 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 	spin_lock(&block_rsv->lock);
 	if (num_bytes == (u64)-1)
 		num_bytes = block_rsv->size;
+	if (unlikely(block_rsv->size < num_bytes)) {
+		printk(KERN_ERR "block rsv %p has size %Lu, want to take "
+		       "away %Lu\n", block_rsv, block_rsv->size, num_bytes);
+		BUG();
+	}
 	block_rsv->size -= num_bytes;
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
@@ -4064,6 +4069,8 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	 * when we are truly done with the orphan item.
 	 */
 	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	trace_printk("Reserved %Lu bytes for inode %Lu on rsv %p\n",
+		     num_bytes, btrfs_ino(inode), dst_rsv);
 	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
 }
 
@@ -4071,6 +4078,8 @@ void btrfs_orphan_release_metadata(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	trace_printk("Releaseing %Lu bytes for inode %Lu on rsv %p\n",
+		     num_bytes, btrfs_ino(inode), root->orphan_block_rsv);
 	btrfs_block_rsv_release(root, root->orphan_block_rsv, num_bytes);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e16215f..38a4efb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1994,6 +1994,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	spin_lock(&root->orphan_lock);
 	if (!root->orphan_block_rsv) {
+		trace_printk("Added new orphan rsv %p for root %Lu\n",
+			     block_rsv, root->objectid);
 		root->orphan_block_rsv = block_rsv;
 	} else if (block_rsv) {
 		btrfs_free_block_rsv(root, block_rsv);
@@ -2002,6 +2004,8 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	if (list_empty(&BTRFS_I(inode)->i_orphan)) {
 		list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+		trace_printk("Added inode %Lu to orphan list for %Lu\n",
+			     btrfs_ino(inode), root->objectid);
 #if 0
 		/*
 		 * For proper ENOSPC handling, we should do orphan
@@ -2019,6 +2023,9 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (!BTRFS_I(inode)->orphan_meta_reserved) {
 		BTRFS_I(inode)->orphan_meta_reserved = 1;
 		reserve = 1;
+	} else {
+		trace_printk("Didn't do reservation for inode %Lu on %Lu\n",
+			     btrfs_ino(inode), root->objectid);
 	}
 	spin_unlock(&root->orphan_lock);
 
@@ -2056,6 +2063,8 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	spin_lock(&root->orphan_lock);
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+		trace_printk("Removed inode %Lu from orphan list for %Lu\n",
+			     btrfs_ino(inode), root->objectid);
 		list_del_init(&BTRFS_I(inode)->i_orphan);
 		delete_item = 1;
 	}
@@ -2063,6 +2072,9 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	if (BTRFS_I(inode)->orphan_meta_reserved) {
 		BTRFS_I(inode)->orphan_meta_reserved = 0;
 		release_rsv = 1;
+	} else {
+		trace_printk("Inode %Lu didn't release metadata\n",
+			     btrfs_ino(inode));
 	}
 	spin_unlock(&root->orphan_lock);
 

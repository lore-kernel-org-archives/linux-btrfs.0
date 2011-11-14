From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198
 btrfs_orphan_commit_root+0xa8/0xc0
Date: Mon, 14 Nov 2011 11:03:42 -0500
Message-ID: <20111114160342.GB1947@localhost.localdomain>
References: <4EBA54F2.3030801@unilogicnetworks.net>
 <20111109153552.GB1810@localhost.localdomain>
 <4EBBBFFA.5090000@unilogicnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Stefan Kleijkers <stefan@unilogicnetworks.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EBBBFFA.5090000@unilogicnetworks.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2011 at 01:13:46PM +0100, Stefan Kleijkers wrote:
> Hello Josef,
> 
> I have a workload running at the moment and I'm seeing a lot of
> these (paste 1) messages in dmesg, this is the 3.1 kernel with your
> patch applied.
> 
> At the end I see a couple of the old warnings (paste 2).
> 
> Futhermore it looks like after a while the speed of the filesystem
> decreases. I have a workload with 20 rsyncs and a total of about
> 1.5T data. I don't make it to have a full run.
> 

Hmm well thats interesting, and you'd think that would tell me what was wrong
but I'm still confused :).  Give this debug patch a whirl (unapply the last one
I gave you and apply this one instead) and send me your dmesg if you get any of
the new warnings.  Thanks,

Josef

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 634608d..395a746 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -74,6 +74,7 @@ struct btrfs_inode {
 
 	/* the space_info for where this inode's data allocations are done */
 	struct btrfs_space_info *space_info;
+	struct btrfs_block_rsv *rsv;
 
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
 	 * enough field for this.
@@ -140,7 +141,7 @@ struct btrfs_inode {
 	 */
 	unsigned outstanding_extents;
 	unsigned reserved_extents;
-
+	unsigned orphan_count;
 	/*
 	 * ordered_data_close is set by truncate when a file that used
 	 * to have good data has been truncated to zero.  When it is set
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fa4f602..c73f4b1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3721,6 +3721,7 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 	spin_lock(&block_rsv->lock);
 	if (num_bytes == (u64)-1)
 		num_bytes = block_rsv->size;
+	BUG_ON(block_rsv->size < num_bytes);
 	block_rsv->size -= num_bytes;
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e16215f..f59231c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2018,8 +2018,11 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	if (!BTRFS_I(inode)->orphan_meta_reserved) {
 		BTRFS_I(inode)->orphan_meta_reserved = 1;
+		BTRFS_I(inode)->rsv = root->orphan_block_rsv;
 		reserve = 1;
 	}
+	WARN_ON(BTRFS_I(inode)->orphan_count);
+	BTRFS_I(inode)->orphan_count++;
 	spin_unlock(&root->orphan_lock);
 
 	/* grab metadata reservation from transaction handle */
@@ -2061,9 +2064,12 @@ int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
 	}
 
 	if (BTRFS_I(inode)->orphan_meta_reserved) {
+		WARN_ON(BTRFS_I(inode)->rsv != root->orphan_block_rsv);
 		BTRFS_I(inode)->orphan_meta_reserved = 0;
 		release_rsv = 1;
 	}
+	WARN_ON(!BTRFS_I(inode)->orphan_count);
+	BTRFS_I(inode)->orphan_count--;
 	spin_unlock(&root->orphan_lock);
 
 	if (trans && delete_item) {
@@ -6629,6 +6635,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	spin_lock_init(&ei->lock);
 	ei->outstanding_extents = 0;
 	ei->reserved_extents = 0;
+	ei->orphan_count = 0;
 
 	ei->ordered_data_close = 0;
 	ei->orphan_meta_reserved = 0;
@@ -6638,6 +6645,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	ei->delayed_node = NULL;
+	ei->rsv = NULL;
 
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree);

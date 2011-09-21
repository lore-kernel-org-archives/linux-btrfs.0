From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Wed, 21 Sep 2011 16:18:29 -0400
Message-ID: <4E7A4695.9080106@redhat.com>
References: <20110921185350.GA6618@kashmir>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110921185350.GA6618@kashmir>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/21/2011 02:53 PM, Mathieu Chouquet-Stringer wrote:
> 	Hello all,
> 
> I've been using BTRFS for quite some time on this laptop and I just
> recompiled the latest kernel from git (3.1.0-rc6-00247-g38867a2).  After
> a couple minutes, I hit this bug twice (this a hand written transcript,
> pics here [1]) kernel BUG at fs/btrfs/inode.c:785!
> 
> stack being:
> 
> _raw_spin_unlock_irqrestore
> __wake_up
> btrfs_tree_read_unlock_blocking
> free_extent_buffer
> run_delalloc_nocow
> run_dellaloc_range
> free_extent_state
> find_lock_delalloc_range.constrpop
> __extent_writepage
> ...
> 
> Note the stack trace is exactly the same in these two crashes.  Since
> google found nothing, I'm asking for your help!
> 
> Looking at the source, line 785 is function cow_file_range, code:
> BUG_ON(btrfs_is_free_space_inode(root, inode));
> 
> My fs (a simple partition on a OCZ-VERTEX2 ssd) is mounted with the
> following options:
> ssd,discard,autodefrag
> 
> with disk space caching as it had been added earlier:
> btrfs: disk space caching is enabled
> Btrfs detected SSD devices, enabling SSD mode
> 
> Anything I could do to help debug this one?

Yup, can you apply this patch and reproduce?  It will print out some
debug info before the --- cut here --- line, which is what I need.  Thanks,

Josef

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b128fa0..66ba0a7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -782,7 +782,12 @@ static noinline int cow_file_range(struct inode *inode,
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	int ret = 0;

-	BUG_ON(btrfs_is_free_space_inode(root, inode));
+	if (btrfs_is_free_space_inode(root, inode)) {
+		printk(KERN_ERR "trying to write to free space inode, "
+		       "isize=%Lu, start=%Lu, end=%Lu\n", i_size_read(inode),
+		       start, end);
+		BUG_ON(btrfs_is_free_space_inode(root, inode));
+	}
 	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;

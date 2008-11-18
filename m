From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [DEBUG PATCH] for anybody who gets a panic due to ENOSPC
Date: Tue, 18 Nov 2008 11:30:09 -0500
Message-ID: <20081118163007.GA1425@unused.rdu.redhat.com>
References: <4922214A.5090904@cs.drexel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jbacik@redhat.com, linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4922214A.5090904@cs.drexel.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 17, 2008 at 08:58:34PM -0500, Lee Trager wrote:
> I still get a kernel panic with both of your patches installed. When I
> checked with df the file system is about 65% full. But even if it was
> full it shouldn't cause a kernel panic.
> 
> Lee
>

Hrm this is frustrating, I can't figure out whats going wrong and I can't
reproduce this here, I just keep hitting a reall ENOSPC.  Please run with this
patch and send me the output.  Thanks much,

Josef

 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6eb56a0..a24e368 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2898,6 +2898,18 @@ static int noinline find_free_extent(struct btrfs_trans_handle *trans,
 			break;
 		}
 new_group:
+		if (loop == 2) {
+			spin_lock(&block_group->lock);
+			printk(KERN_ERR "block_group %Lu didn't have what we "
+			       "needed.  %Lu total, %Lu used, %Lu pinned, %Lu "
+			       "reserved.  Dumping free space\n",
+			       block_group->key.objectid,
+			       block_group->key.offset,
+			       btrfs_block_group_used(&block_group->item),
+			       block_group->pinned, block_group->reserved);
+			spin_unlock(&block_group->lock);
+			btrfs_dump_free_space(block_group, 0);
+		}
 		mutex_unlock(&block_group->alloc_mutex);
 new_group_no_lock:
 		/* don't try to compare new allocations against the
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f4926c0..3699656 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -402,8 +402,8 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes)
 			count++;
-		//printk(KERN_INFO "offset=%Lu, bytes=%Lu\n", info->offset,
-		//       info->bytes);
+		printk(KERN_INFO "offset=%Lu, bytes=%Lu\n", info->offset,
+		       info->bytes);
 	}
 	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
 	       "\n", count);

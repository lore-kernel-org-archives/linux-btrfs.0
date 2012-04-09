From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Revert "Btrfs: increase the global block reserve estimates"
Date: Mon, 09 Apr 2012 09:37:08 +0800
Message-ID: <4F823D44.5070200@cn.fujitsu.com>
References: <1333928451-26468-1-git-send-email-dsterba@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333928451-26468-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2012 07:40 AM, David Sterba wrote:
> This reverts commit 5500cdbe14d7435e04f66ff3cfb8ecd8b8e44ebf.
> 
> We had numerous reports of premature ENOSPC that were bisected to this
> patch. Reverting will not break things but a warning in 'use_block_rsv'
> may show up in the syslog.
> 
> There's no alternative fix in sight and the ENOSPC problem affects all
> 3.3 btrfs users during normal filesystem use.
> 

Hi David,

(add cc Josef)

The whole thing is about our overcommit stuff, that is,
since we are not able to get _precise_ number of reservation right now, we usually
reserve more than what we need.
For this, we've done overcommit dance (thanks for Josef's work!) but it's still not
enough for our reservation when we still have some disk space.

I'm ok with this revert, but since we don't use up all the reserved space in most time,
I assume the following can be an alternative, thanks,

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..1b692c2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3844,6 +3844,7 @@ again:
 
 		spin_lock(&root->fs_info->free_chunk_lock);
 		avail = root->fs_info->free_chunk_space;
+		spin_unlock(&root->fs_info->free_chunk_lock);
 
 		/*
 		 * If we have dup, raid1 or raid10 then only half of the free
@@ -3854,17 +3855,6 @@ again:
 			       BTRFS_BLOCK_GROUP_RAID10))
 			avail >>= 1;
 
-		/*
-		 * If we aren't flushing don't let us overcommit too much, say
-		 * 1/8th of the space.  If we can flush, let it overcommit up to
-		 * 1/2 of the space.
-		 */
-		if (flush)
-			avail >>= 3;
-		else
-			avail >>= 1;
-		 spin_unlock(&root->fs_info->free_chunk_lock);
-
 		if (used + num_bytes < space_info->total_bytes + avail) {
 			space_info->bytes_may_use += orig_bytes;
 			trace_btrfs_space_reservation(root->fs_info,

From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: make sure to update total_bitmaps when freeing
 cache V2
Date: Fri, 24 Jun 2011 17:58:20 +0200
Message-ID: <20110624155820.GQ12709@twin.jikos.cz>
References: <1308858866-24124-1-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308858866-24124-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2011 at 03:54:26PM -0400, Josef Bacik wrote:
> A user reported this bug again where we have more bitmaps than we are supposed
> to.  This is because we failed to load the free space cache, but don't update
> the ctl->total_bitmaps counter when we remove entries from the tree.  This patch
> fixes this problem and we should be good to go again.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> V1->V2: made the patch actually correct
>  fs/btrfs/free-space-cache.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 3c1a047..e7987f9 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1843,7 +1843,11 @@ void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
>  	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
>  		info = rb_entry(node, struct btrfs_free_space, offset_index);
>  		unlink_free_space(ctl, info);
> -		kfree(info->bitmap);
> +		if (info->bitmap) {
> +			kfree(info->bitmap);
> +			ctl->total_bitmaps--;
> +			ctl->op->recalc_thresholds(ctl);
> +		}

this was a result of incorrect merge resolution in
0965537308ac3b267ea16e731bd73870a51c53b8:

additions:

+       while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
+               info = rb_entry(node, struct btrfs_free_space, offset_index);
+               unlink_free_space(ctl, info);
+               kfree(info->bitmap);
+               kmem_cache_free(btrfs_free_space_cachep, info);
+               if (need_resched()) {
+                       spin_unlock(&ctl->tree_lock);
+                       cond_resched();
+                       spin_lock(&ctl->tree_lock);
+               }
+       }

and removals:

-       while ((node = rb_last(&block_group->free_space_offset)) != NULL) {
-               info = rb_entry(node, struct btrfs_free_space, offset_index);
-               if (!info->bitmap) {
-                       unlink_free_space(block_group, info);
-                       kmem_cache_free(btrfs_free_space_cachep, info);
-               } else {
-                       free_bitmap(block_group, info);
-               }
-
-               if (need_resched()) {
-                       spin_unlock(&block_group->tree_lock);
-                       cond_resched();
-                       spin_lock(&block_group->tree_lock);
-               }
-       }


see the free_bitmap disappear? Please use this helper in your patch.

(And no, I was not keeping this for myself until now, I saw this code recently
but did not notice there's a bug, your patch just rang a bell)


david

>  		kmem_cache_free(btrfs_free_space_cachep, info);
>  		if (need_resched()) {
>  			spin_unlock(&ctl->tree_lock);
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

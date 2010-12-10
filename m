From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: do not BUG if we fail to remove the orphan item
 for dead snapshots
Date: Fri, 10 Dec 2010 15:16:15 +0800
Message-ID: <4D01D3BF.2010702@cn.fujitsu.com>
References: <1291829142-22255-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291829142-22255-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

01:25, Josef Bacik wrote:
> Not being able to delete an orphan item isn't a horrible thing.  The worst that
> happens is the next time around we try and do the orphan cleanup and we can't
> find the referenced object and just delete the item and move on.  Thanks,
> 

Would be better to add code comment? Otherwise later people may wonder why
the return value is not checked and see it as a bug.

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/extent-tree.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8aed05e..8c26441 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6354,7 +6354,6 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
>  		if (ret > 0) {
>  			ret = btrfs_del_orphan_item(trans, tree_root,
>  						    root->root_key.objectid);
> -			BUG_ON(ret);
>  		}
>  	}
>  

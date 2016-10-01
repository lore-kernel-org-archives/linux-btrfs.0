Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbcJAXGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 1 Oct 2016 19:06:07 -0400
Date: Sun, 2 Oct 2016 01:06:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, y2038@lists.linaro.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: Use ktime_get_real_ts for root ctime
Message-ID: <20161001230603.GA6576@suse.cz>
Reply-To: dsterba@suse.cz
References: <1475342614-18439-1-git-send-email-deepa.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1475342614-18439-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 01, 2016 at 10:23:34AM -0700, Deepa Dinamani wrote:
> btrfs_root_item maintains the ctime for root updates.
> This is not part of vfs_inode.
> 
> Since current_time() uses struct inode* as an argument
> as Linus suggested, this cannot be used to update root
> times unless, we modify the signature to use inode.
> 
> Since btrfs uses nanosecond time granularity, it can also
> use ktime_get_real_ts directly to obtain timestamp for
> the root. It is necessary to use the timespec time api
> here because the same btrfs_set_stack_timespec_*() apis
> are used for vfs inode times as well. These can be
> transitioned to using timespec64 when btrfs internally
> changes to use timespec64 as well.
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: David Sterba <dsterba@suse.com>

Acked-by: David Sterba <dsterba@suse.com>

> Cc: Josef Bacik <jbacik@fb.com>
> Cc: linux-btrfs@vger.kernel.org
> ---
> Changes from previous version:
> * Separated from the current_time() api series.
> * Moved ktime_get_real_ts() outside of spin lock.
> 
> fs/btrfs/root-tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 0912960..17e5a5f 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -505,8 +505,9 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
>  			     struct btrfs_root *root)
>  {
>  	struct btrfs_root_item *item = &root->root_item;
> -	struct timespec ct = current_fs_time(root->fs_info->sb);
> +	struct timespec ct;
>  
> +	ktime_get_real_ts(&ct);
>  	spin_lock(&root->root_item_lock);
>  	btrfs_set_root_ctransid(item, trans->transid);
>  	btrfs_set_stack_timespec_sec(&item->ctime, ct.tv_sec);
> -- 
> 2.7.4
> 
> 

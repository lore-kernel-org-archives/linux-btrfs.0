Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbbA3S4H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 13:56:07 -0500
Date: Fri, 30 Jan 2015 19:56:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 7/9] btrfs: Move btrfs_sysfs_remove_one(fs_info)
 before transcation thread cleanup.
Message-ID: <20150130185605.GT3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-8-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-8-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:52PM +0800, Qu Wenruo wrote:
> Since btrfs sysfs interfaces can start new transaction, we need to do it
> before transaction thread cleanup.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v5:
>   Newly introduced.
> ---
>  fs/btrfs/disk-io.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f4d168d..7c185a0 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3630,6 +3630,12 @@ void close_ctree(struct btrfs_root *root)
>  	fs_info->closing = 1;
>  	smp_mb();
>  
> +	/*
> +	 * Remove btrfs sysfs interfaces first,
> +	 * since it can start new transaction.

Please use the whole width of the line to format comments.


> +	 */
> +	btrfs_sysfs_remove_one(fs_info);
> +
>  	/* wait for the uuid_scan task to finish */
>  	down(&fs_info->uuid_tree_rescan_sem);
>  	/* avoid complains from lockdep et al., set sem back to initial state */

A few lines below, there are

btrfs_pause_balance
btrfs_dev_replace_suspend_for_unmount
btrfs_scrub_cancel

scrub and balance seem ok regarding sysfs, but dev-replace may replace
the sysfs entries if btrfs_dev_replace_finishing is called between

btrfs_sysfs_remove_one
...
btrfs_dev_replace_finishing <- wants to add/remove sysfs entries
...
btrfs_dev_replace_suspend_for_unmount

But all uses of sysfs objects or the btrfs_kobj objects do a NULL check
first and don't continue so this is safe and IMO best what we can have
to keep the code sane and lets us tear down sysfs exactly where you've
put it.

Reviewed-by: David Sterba <dsterba@suse.cz>

> @@ -3673,8 +3679,6 @@ void close_ctree(struct btrfs_root *root)
>  		       percpu_counter_sum(&fs_info->delalloc_bytes));
>  	}
>  
> -	btrfs_sysfs_remove_one(fs_info);
> -
>  	btrfs_free_fs_roots(fs_info);
>  
>  	btrfs_put_block_group_cache(fs_info);

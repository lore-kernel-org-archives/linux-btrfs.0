Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18447 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964835AbdKPXaI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 18:30:08 -0500
Date: Thu, 16 Nov 2017 15:29:59 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] btrfs: reoder btrfs_transaction members for better
 packing
Message-ID: <20171116232959.GC23614@dhcp-whq-twvpn-1-vpnpool-10-159-142-193.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <cover.1510767175.git.dsterba@suse.com>
 <968af0bfaca921b5879c297e3f5b8037377bc672.1510767175.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <968af0bfaca921b5879c297e3f5b8037377bc672.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 15, 2017 at 06:42:06PM +0100, David Sterba wrote:
> There are now 20 bytes of holes, we can reduce that to 4 by minor
> changes. Moving 'aborted' to the status and flags is also more logical,
> similar for num_dirty_bgs. The size goes from 432 to 416.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/transaction.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 1805fd101767..6beee072b1bd 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -58,6 +58,7 @@ struct btrfs_transaction {
>  
>  	/* Be protected by fs_info->trans_lock when we want to change it. */
>  	enum btrfs_trans_state state;
> +	int aborted;
>  	struct list_head list;
>  	struct extent_io_tree dirty_pages;
>  	unsigned long start_time;
> @@ -70,7 +71,6 @@ struct btrfs_transaction {
>  	struct list_head dirty_bgs;
>  	struct list_head io_bgs;
>  	struct list_head dropped_roots;
> -	unsigned int num_dirty_bgs;
>  
>  	/*
>  	 * we need to make sure block group deletion doesn't race with
> @@ -79,11 +79,11 @@ struct btrfs_transaction {
>  	 */
>  	struct mutex cache_write_mutex;
>  	spinlock_t dirty_bgs_lock;
> +	unsigned int num_dirty_bgs;
>  	/* Protected by spin lock fs_info->unused_bgs_lock. */
>  	struct list_head deleted_bgs;
>  	spinlock_t dropped_roots_lock;
>  	struct btrfs_delayed_ref_root delayed_refs;
> -	int aborted;
>  	struct btrfs_fs_info *fs_info;
>  };
>  
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

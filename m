Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755256AbeAIQzX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 11:55:23 -0500
Date: Tue, 9 Jan 2018 17:53:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, wqu@suse.com
Subject: Re: [PATCH 1/3] btrfs: define SUPER_FLAG_METADUMP_V2
Message-ID: <20180109165315.GP13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180109010543.16053-1-anand.jain@oracle.com>
 <20180109010543.16053-2-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180109010543.16053-2-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 09:05:41AM +0800, Anand Jain wrote:
> btrfs-progs uses super flag bit BTRFS_SUPER_FLAG_METADUMP_V2 (1ULL << 34).
> So just define that in kernel so that we know its been used.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c              | 3 ++-
>  include/uapi/linux/btrfs_tree.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a69e5944dc08..7cd4935f690f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -61,7 +61,8 @@
>  				 BTRFS_HEADER_FLAG_RELOC |\
>  				 BTRFS_SUPER_FLAG_ERROR |\
>  				 BTRFS_SUPER_FLAG_SEEDING |\
> -				 BTRFS_SUPER_FLAG_METADUMP)
> +				 BTRFS_SUPER_FLAG_METADUMP |\
> +				 BTRFS_SUPER_FLAG_METADUMP_V2)
>  
>  static const struct extent_io_ops btree_extent_io_ops;
>  static void end_workqueue_fn(struct btrfs_work *work);
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index 6d6e5da51527..38ab0e06259a 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -456,6 +456,7 @@ struct btrfs_free_space_header {
>  
>  #define BTRFS_SUPER_FLAG_SEEDING	(1ULL << 32)
>  #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
> +#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
>  
>  
>  /*
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

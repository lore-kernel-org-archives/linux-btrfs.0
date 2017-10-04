Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752203AbdJDOvK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 10:51:10 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7CC6CACF0
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Oct 2017 14:51:09 +0000 (UTC)
Date: Wed, 4 Oct 2017 16:49:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Use DIV_ROUND_UP rathen than opencoding it
Message-ID: <20171004144927.GD3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1506606499-15127-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506606499-15127-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 28, 2017 at 04:48:19PM +0300, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e2d7e86b51d1..9e67616892cd 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2896,9 +2896,8 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes)
>  	num_csums_per_leaf = div64_u64(csum_size,
>  			(u64)btrfs_super_csum_size(fs_info->super_copy));
>  	num_csums = div64_u64(csum_bytes, fs_info->sectorsize);
> -	num_csums += num_csums_per_leaf - 1;
> -	num_csums = div64_u64(num_csums, num_csums_per_leaf);
> -	return num_csums;
> +
> +	return DIV_ROUND_UP(num_csums, num_csums_per_leaf);

DIV_ROUND_UP ends up as plain division (/) so this will not work on
32bit. We need to keep it opencoded, or convert all the relevant
variabless to 32bit first.

#define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))

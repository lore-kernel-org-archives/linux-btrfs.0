Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54683 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932468AbeCLRAy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Mar 2018 13:00:54 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7E3B0ABE1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Mar 2018 17:00:53 +0000 (UTC)
Date: Mon, 12 Mar 2018 17:58:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Use sizeof directly instead of a constant variable
Message-ID: <20180312165831.GA32007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520873548-26667-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1520873548-26667-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 12, 2018 at 06:52:28PM +0200, Nikolay Borisov wrote:
> The kernel would like to have all stack VLA usage removed[1].
> Unfortunately using an integer constant variable as the size of an
> array is still considered a VLA. Instead let's use directly sizeof(var)
> which removes the VLA usage. Use the occasion to remove csum_size
> altogether and use sizeof() also for the size passed to memcmp

The point of csum_size here is to define once, use everywhere, so we
don't have to opencode sizeof. To avoid the 'not really a VLA', we can
rewrite that.

> 
> [1]: https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/disk-io.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 3809d6d66f6a..6247162e334a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -403,8 +403,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  
>  	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
>  		u32 crc = ~(u32)0;
> -		const int csum_size = sizeof(crc);
> -		char result[csum_size];
> +		char result[sizeof(crc)];
>  
>  		/*
>  		 * The super_block structure does not span the whole
> @@ -415,7 +414,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>  				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
>  		btrfs_csum_final(crc, result);
>  
> -		if (memcmp(raw_disk_sb, result, csum_size))
> +		if (memcmp(raw_disk_sb, result, sizeof(crc)))

sizeof(result) would be better here as it's clear what we're going to
memcpy, while 'crc' is define somewhere above.

>  			ret = 1;
>  	}
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

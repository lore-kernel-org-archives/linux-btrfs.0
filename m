Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:39353 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdESSNs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 14:13:48 -0400
Date: Fri, 19 May 2017 11:10:10 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: work around maybe-uninitialized warning
Message-ID: <20170519181009.GA10137@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170518133351.1867577-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170518133351.1867577-1-arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 03:33:29PM +0200, Arnd Bergmann wrote:
> A rewrite of btrfs_submit_direct_hook appears to have introduced a warning:
> 
> fs/btrfs/inode.c: In function 'btrfs_submit_direct_hook':
> fs/btrfs/inode.c:8467:14: error: 'bio' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Where the 'bio' variable was previously initialized unconditionally, it
> is now set in the "while (submit_len > 0)" loop that would never execute
> if submit_len is zero.
> 
> Assuming this cannot happen in practice, we can avoid the warning
> by simply replacing the while{} loop with a do{}while() loop so
> the compiler knows that it will always be entered at least once.
>

Thanks for the fix.  I think it's a false positve one and I've updated it in v2
with a 'struct bio *bio = NULL' to make compiler happy, could you please help
reveiw it?

Thanks,
-liubo

> Fixes: 0fd27e06c61b ("Btrfs: use bio_clone_bioset_partial to simplify DIO submit")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> ---
>  fs/btrfs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8c37b4fa4cbb..c62cf9593cb3 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8497,7 +8497,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  	/* bio split */
>  	ASSERT(map_length <= INT_MAX);
>  	atomic_inc(&dip->pending_bios);
> -	while (submit_len > 0) {
> +	do {
>  		clone_len = min_t(int, submit_len, map_length);
>  
>  		/*
> @@ -8540,7 +8540,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  				      start_sector << 9, &map_length, NULL, 0);
>  		if (ret)
>  			goto out_err;
> -	}
> +	} while (submit_len > 0);
>  
>  submit:
>  	ret = __btrfs_submit_dio_bio(bio, inode, file_offset, skip_sum,
> -- 
> 2.9.0
> 

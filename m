Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdLKXJB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 18:09:01 -0500
Date: Mon, 11 Dec 2017 14:57:56 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove pair of bio_get/put in btrfs_schedule_bio
Message-ID: <20171211225756.GA6827@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1513003128-15489-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513003128-15489-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 11, 2017 at 04:38:48PM +0200, Nikolay Borisov wrote:
> This code was added in 492bb6deee34 ("Btrfs: Hold a reference on bios
> during submit_bio, add some extra bio checks"). However, holding a
> reference on a bio is necessary only if it's going to be referenced
> after the submit_bio returns and the bio is completed. In this
> particular instance this is not the case so there is no need to hold
> an extra reference since we directly return.
>

Looks good.  If possible, please also drop other unnecessary bio_get()
in btrfs.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/volumes.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 49810b70afd3..13827ff648ec 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6069,9 +6069,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_device *device,
>  
>  	/* don't bother with additional async steps for reads, right now */
>  	if (bio_op(bio) == REQ_OP_READ) {
> -		bio_get(bio);
>  		btrfsic_submit_bio(bio);
> -		bio_put(bio);
>  		return;
>  	}
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

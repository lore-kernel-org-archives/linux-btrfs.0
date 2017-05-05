Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750778AbdEEQww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 12:52:52 -0400
Date: Fri, 5 May 2017 18:52:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: tolerate errors if we have retried successfully
Message-ID: <20170505165245.GF10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492132316-3076-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492132316-3076-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 13, 2017 at 06:11:56PM -0700, Liu Bo wrote:
> With raid1 profile, dio read isn't tolerating IO errors if read length is
> less than the stripe length (64K).

Can you please write more details why this is true? Some pointers to
code etc, I'm lost. Eg. where the errors is tolerated. Thanks.

> This fixes the problem by setting bio's error to 0 if a good copy has been
> found.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/inode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 632b616..4e1398e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8113,8 +8113,11 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
>  	int err = bio->bi_error;
>  
> -	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
> +	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
>  		err = btrfs_subio_endio_read(inode, io_bio, err);
> +		if (!err)
> +			bio->bi_error = 0;
> +	}
>  
>  	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
>  		      dip->logical_offset + dip->bytes - 1);
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

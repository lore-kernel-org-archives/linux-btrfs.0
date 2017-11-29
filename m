Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28128 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751785AbdK2Tbc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 14:31:32 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vATJVUF0013596
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 19:31:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vATJVUWk003011
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 19:31:30 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vATJVUl8022143
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 19:31:30 GMT
Date: Wed, 29 Nov 2017 11:26:43 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: submit a normal bio for the mirror read
Message-ID: <20171129192643.GB22726@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171129071115.7399-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171129071115.7399-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 29, 2017 at 03:11:14PM +0800, Anand Jain wrote:
> When the fist mirror failed to read we submit bio again to read from the
> 2nd mirror, however during this, we also set the flag REQ_FAILFAST_DEV
> which indicates to the underlying block device driver not to perform the
> default IO retry (sd, 5 counts), and thus command will be failed and
> returned at the first failed attempt.
>
> On the contrary, in fact, it should have been other way around that is,
> as 2nd mirror being the last copy of the data, it should rather try
> equally hard to make this read cmd successful and at the same time with
> or without REQ_FAILFAST_DEV there is no performance benefits if the
> command is successful in the first attempt itself.
> 

There are some misunderstanding in the above commit log.

FAILFAST is only set for the validation phrase, i.e. retry read on the
same failed mirror.  When it comes to the 2nd mirror,
failed_bio->bi_vcnt becomes 1 so FAILFAST is not set any more.  IOW,
FAILFAST is only set when narrowing read failures to each 4K block, so
a quick retry is reasonable because anyway we have another mirror to
read.  You may want to check the comments in btrfs_check_repairable().

thanks,

-liubo

> The only benefit which would be achieved with REQ_FAILFAST_DEV is that
> when both the copies encounter failed read, then for the applications,
> the EIO will be reported roughly 40% faster (since it saves 4 retries).
> But when first mirror has failed whats more important will be to make
> a successful read from the 2nd mirror.
> 
> And for the DUP case where both the copies are on the same disk, this
> makes to retry 5 times on 2 different LBA/sector but on the same disk,
> which probably is not a good idea if your test case involves pulling
> out the disk. But as of now we don't have a way to tell the block layer
> how critical a read is, so that block layer can accommodate the retry
> dynamically.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d8eb457f2a70..29c03fb4d5af 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2388,9 +2388,6 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
>  		return -EIO;
>  	}
>  
> -	if (failed_bio->bi_vcnt > 1)
> -		read_mode |= REQ_FAILFAST_DEV;
> -
>  	phy_offset >>= inode->i_sb->s_blocksize_bits;
>  	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
>  				      start - page_offset(page),
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

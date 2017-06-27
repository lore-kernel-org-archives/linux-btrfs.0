Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36309 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdF0TJd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 15:09:33 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5RJ9W6u026503
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 19:09:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v5RJ9WDV005499
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 19:09:32 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v5RJ9V1e025997
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 19:09:32 GMT
Date: Tue, 27 Jun 2017 12:07:13 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: convert: do not clear header rev
Message-ID: <20170627190712.GC1886@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170626235502.26267-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170626235502.26267-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 26, 2017 at 05:55:02PM -0600, Liu Bo wrote:
> So btrfs_set_header_flags() vs btrfs_set_header_flag, the difference is sort of
> similar to "=" vs "|=", when creating and initialising a new extent buffer,
> convert uses the former one which clears header_rev by accident.
>

Here is the regression test script,

mkfs.ext4 -F /disk
btrfs-convert -d /disk
mount /disk /mnt
xfs_io -f -c "pwrite 0 4K" /mnt/foobar
umount /disk

---------------
It'd end up with 'unable to find ref blabla" shown in dmesg log.

thanks,
-liubo

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  convert/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/convert/common.c b/convert/common.c
> index 40bf32c..f0dd2cf 100644
> --- a/convert/common.c
> +++ b/convert/common.c
> @@ -167,7 +167,7 @@ static int setup_temp_extent_buffer(struct extent_buffer *buf,
>  	btrfs_set_header_generation(buf, 1);
>  	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
>  	btrfs_set_header_owner(buf, owner);
> -	btrfs_set_header_flags(buf, BTRFS_HEADER_FLAG_WRITTEN);
> +	btrfs_set_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN);
>  	write_extent_buffer(buf, chunk_uuid, btrfs_header_chunk_tree_uuid(buf),
>  			    BTRFS_UUID_SIZE);
>  	write_extent_buffer(buf, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

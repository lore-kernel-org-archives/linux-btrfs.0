Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38905 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751445AbdF0BmM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 21:42:12 -0400
Subject: Re: [PATCH] Btrfs-progs: convert: do not clear header rev
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <20170626235502.26267-1-bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d2c0ac22-df72-55a0-0db3-de545f2f07cf@cn.fujitsu.com>
Date: Tue, 27 Jun 2017 09:42:08 +0800
MIME-Version: 1.0
In-Reply-To: <20170626235502.26267-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/27/2017 07:55 AM, Liu Bo wrote:
> So btrfs_set_header_flags() vs btrfs_set_header_flag, the difference is sort of
> similar to "=" vs "|=", when creating and initialising a new extent buffer,
> convert uses the former one which clears header_rev by accident.

Thanks for catching this one.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>   convert/common.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/convert/common.c b/convert/common.c
> index 40bf32c..f0dd2cf 100644
> --- a/convert/common.c
> +++ b/convert/common.c
> @@ -167,7 +167,7 @@ static int setup_temp_extent_buffer(struct extent_buffer *buf,
>   	btrfs_set_header_generation(buf, 1);
>   	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
>   	btrfs_set_header_owner(buf, owner);
> -	btrfs_set_header_flags(buf, BTRFS_HEADER_FLAG_WRITTEN);
> +	btrfs_set_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN);
>   	write_extent_buffer(buf, chunk_uuid, btrfs_header_chunk_tree_uuid(buf),
>   			    BTRFS_UUID_SIZE);
>   	write_extent_buffer(buf, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
> 



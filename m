Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25659 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755823AbcE0BiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 21:38:16 -0400
Subject: Re: [PATCH 1/2] Btrfs-progs: make convert to allocate space from the
 desired type of block group
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
CC: <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <7cdcb731-ef9a-a967-0218-31476d40c8d3@cn.fujitsu.com>
Date: Fri, 27 May 2016 09:38:09 +0800
MIME-Version: 1.0
In-Reply-To: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

Since btrfs-convert has been reworked to use a completely new method to 
do such allocation, now it doesn't need any custom_alloc_extent() function.

And its new chunk lay out is designed to only put metadata chunk into 
large enough unused space, and data chunks will cover all used space.

So there is no need for such patch AFAIK.

And the new convert is already in devel branch.

Thanks,
Qu

Liu Bo wrote on 2016/05/26 18:26 -0700:
> During btrfs-convert, it can allocate space from METADATA block
> group for data, which is not supposed to be correct, although it
> doesn't cause any serious problem except eating METADATA space
>  more quickly.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  btrfs-convert.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index b49775c..550aa8f 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -364,6 +364,12 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
>  			continue;
>  		}
>
> +		if ((!!metadata) !=
> +		    (!!(cache->flags & BTRFS_BLOCK_GROUP_METADATA))) {
> +			last = cache->key.objectid + cache->key.offset;
> +			continue;
> +		}
> +
>  		if (metadata) {
>  			BUG_ON(num_bytes != root->nodesize);
>  			if (check_crossing_stripes(start, num_bytes)) {
>



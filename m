Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63480 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752337AbeAaIeV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 03:34:21 -0500
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>
Subject: RE: [PATCH] btrfs: volumes: Cleanup stripe size calculation
Date: Wed, 31 Jan 2018 08:34:14 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D016B1262F7@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180131061634.17383-1-wqu@suse.com>
In-Reply-To: <20180131061634.17383-1-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org]
> On Behalf Of Qu Wenruo
> Sent: Wednesday, January 31, 2018 2:17 PM
> To: linux-btrfs@vger.kernel.org; dsterba@suse.cz
> Subject: [PATCH] btrfs: volumes: Cleanup stripe size calculation
> 
> Cleanup the following things:
> 1) open coded SZ_16M round up
> 2) use min() to replace open-coded size comparison
> 3) code style
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c index
> cb0a8d27661b..90ad716d2b50 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4761,18 +4761,17 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle
> *trans,
>  	 * and compare that answer with the max chunk size
>  	 */
>  	if (stripe_size * data_stripes > max_chunk_size) {
> -		u64 mask = (1ULL << 24) - 1;
> -
>  		stripe_size = div_u64(max_chunk_size, data_stripes);
> 
>  		/* bump the answer up to a 16MB boundary */
> -		stripe_size = (stripe_size + mask) & ~mask;
> +		stripe_size = round_up(stripe_size, SZ_16M);
> 
> -		/* but don't go higher than the limits we found
> +		/*
> +		 * but don't go higher than the limits we found
>  		 * while searching for free extents
>  		 */
> -		if (stripe_size > devices_info[ndevs-1].max_avail)
> -			stripe_size = devices_info[ndevs-1].max_avail;
> +		stripe_size = min(devices_info[ndevs - 1].max_avail,
> +				  stripe_size);
>  	}
> 
>  	stripe_size = div_u64(stripe_size, dev_stripes);
> --

Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>



> 2.16.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm

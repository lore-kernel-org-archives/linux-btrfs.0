Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8040 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754035AbeGFE5N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jul 2018 00:57:13 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 4/4] btrfs-progs: check/original: Don't overwrite return
 value when we failed to repair
Date: Fri, 6 Jul 2018 04:57:06 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A299F3@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180705073731.18459-1-wqu@suse.com>
 <20180705073731.18459-5-wqu@suse.com>
In-Reply-To: <20180705073731.18459-5-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Thursday, July 05, 2018 3:38 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 4/4] btrfs-progs: check/original: Don't overwrite return value when we failed to repair
> 
> In check_inode_recs(), for repair mode we always reset @ret to 0.
> It makes no sense and later we check@ret to determine if the repair is
> successful.
> 
> Fix it by removing the offending overwrite.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  check/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 2b5abb2d025b..08476968aaba 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -2764,7 +2764,6 @@ static int check_inode_recs(struct btrfs_root *root,
>  				free_inode_rec(rec);
>  				continue;
>  			}
> -			ret = 0;
>  		}
> 
>  		if (!(repair && ret == 0))
> --

Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>


> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36373 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750884AbdJZIfd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 04:35:33 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "dsterba@suse.cz" <dsterba@suse.cz>
Subject: RE: [PATCH] btrfs-progs: convert: Open the fs readonly for rollback
Date: Thu, 26 Oct 2017 08:35:29 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01479E236E@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20171026072837.27460-1-wqu@suse.com>
In-Reply-To: <20171026072837.27460-1-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Thursday, October 26, 2017 3:29 PM
> To: linux-btrfs@vger.kernel.org
> Cc: dsterba@suse.cz
> Subject: [PATCH] btrfs-progs: convert: Open the fs readonly for rollback
> 
> For rollback, we only needs to open the fs to check if it meets the condition to rollback.
> And this RW read makes us failed to rollback btrfs with v2 space cache.
> 
> In fact, we don't even start a transaction during rollback.
> 
> So open the fs RO for rollback, to avoid v2 space cache problem.
> 
> Reported-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  convert/main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/convert/main.c b/convert/main.c index 882daf7ced53..3ec10f233915 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1529,7 +1529,13 @@ static int do_rollback(const char *devname)
>  		goto free_mem;
>  	}
>  	fsize = lseek(fd, 0, SEEK_END);
> -	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
> +
> +	/*
> +	 * For rollback, we don't really need write anything into btrfs,
> +	 * so open it RO.
> +	 * The write part will happen after we close the btrfs.
> +	 */
> +	root = open_ctree_fd(fd, devname, 0, 0);
>  	if (!root) {
>  		error("unable to open ctree");
>  		ret = -EIO;

Reviewed-by: Gu JinXiang <gujx@cn.fujitsu.com>
Tested-by: Gu JinXiang <gujx@cn.fujitsu.com>

> --
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm

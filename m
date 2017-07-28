Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:63934 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751633AbdG1BZ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 21:25:26 -0400
Subject: Re: [PATCH 2/5] btrfs-progs: convert: add missing newlines for
 printfs
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20170727154723.2208-1-jeffm@suse.com>
 <20170727154723.2208-3-jeffm@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4bfc08eb-b34d-7b87-7fc6-94c3f3df2cff@gmx.com>
Date: Fri, 28 Jul 2017 09:24:46 +0800
MIME-Version: 1.0
In-Reply-To: <20170727154723.2208-3-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月27日 23:47, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> There are two printfs with missing newlines that end up making the
> output wonky.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Those are the only two missing newline in convert/.
No missing.

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

Thanks,
Qu

> ---
>   convert/main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/convert/main.c b/convert/main.c
> index c56382e..01657a6 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1285,7 +1285,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
>   		goto fail;
>   	}
>   
> -	printf("creating btrfs metadata");
> +	printf("creating btrfs metadata\n");
>   	ctx.max_copy_inodes = (cctx.inodes_count - cctx.free_inodes_count);
>   	ctx.cur_copy_inodes = 0;
>   
> @@ -1348,7 +1348,7 @@ static int do_convert(const char *devname, u32 convert_flags, u32 nodesize,
>   	close_ctree(root);
>   	close(fd);
>   
> -	printf("conversion complete");
> +	printf("conversion complete\n");
>   	return 0;
>   fail:
>   	clean_convert_context(&cctx);
> 

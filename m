Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:40210 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbbAIIpO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 03:45:14 -0500
Message-ID: <54AF9509.3030702@huawei.com>
Date: Fri, 9 Jan 2015 16:44:57 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix typo of variable in scrub_stripe
References: <201501090837.AA00007@WIN-R1VKH1IH438.jp.fujitsu.com>
In-Reply-To: <201501090837.AA00007@WIN-R1VKH1IH438.jp.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 09 Jan 2015 17:37:52 +0900, Tsutomu Itoh wrote:
> The address that should be freed is not 'ppath' but 'path'.
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com> 
> ---
>  fs/btrfs/scrub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index f2bb13a..403fbdb 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3053,7 +3053,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>  
>  	ppath = btrfs_alloc_path();
>  	if (!ppath) {
> -		btrfs_free_path(ppath);
> +		btrfs_free_path(path);

My bad. Thanks to fix it.

Reviewed-by: Miao Xie <miaoxie@huawei.com>

>  		return -ENOMEM;
>  	}
>  
> 


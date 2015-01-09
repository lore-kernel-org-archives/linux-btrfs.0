Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:26069 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbbAIFb4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 00:31:56 -0500
Message-ID: <54AF67B9.7020703@huawei.com>
Date: Fri, 9 Jan 2015 13:31:37 +0800
From: Miao Xie <miaoxie@huawei.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix raid56 scrub failed in xfstests btrfs/072
References: <1420767580-19380-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1420767580-19380-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="gbk"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 09 Jan 2015 09:39:40 +0800, Gui Hecheng wrote:
> The xfstests btrfs/072 reports uncorrectable read errors in dmesg,
> because scrub forgets to use commit_root for parity scrub routine
> and scrub attempts to scrub those extents items whose contents are
> not fully on disk.
> 
> To fix it, we just add the @search_commit_root flag back.

Reviewed-by: Miao Xie <miaoxie@huawei.com>

> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index f2bb13a..aa8ff75 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3065,6 +3065,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>  	path->search_commit_root = 1;
>  	path->skip_locking = 1;
>  
> +	ppath->search_commit_root = 1;
> +	ppath->skip_locking = 1;
>  	/*
>  	 * trigger the readahead for extent tree csum tree and wait for
>  	 * completion. During readahead, the scrub is officially paused
> 


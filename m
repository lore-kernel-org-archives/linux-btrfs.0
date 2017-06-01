Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18616 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdFADa2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 23:30:28 -0400
Subject: Re: [PATCH 2/3] btrfs: switch kmallocs to GFP_KERNEL in lzo/zlib
 alloc_workspace
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496245064.git.dsterba@suse.com>
 <b00f101454e17051d005f9fb28224b665c339cf1.1496245064.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <489acb80-2dac-5de6-af24-aed8c6176645@oracle.com>
Date: Thu, 1 Jun 2017 11:36:29 +0800
MIME-Version: 1.0
In-Reply-To: <b00f101454e17051d005f9fb28224b665c339cf1.1496245064.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/31/17 23:41, David Sterba wrote:
> As alloc_workspace is now protected by memalloc_nofs where needed,
> we can switch the kmalloc to use GFP_KERNEL.
>
> Signed-off-by: David Sterba <dsterba@suse.com>


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

> ---
>  fs/btrfs/lzo.c  | 2 +-
>  fs/btrfs/zlib.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index a554856a5f8a..c556f3f3fbf0 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -51,7 +51,7 @@ static struct list_head *lzo_alloc_workspace(void)
>  {
>  	struct workspace *workspace;
>
> -	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
> +	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
>  	if (!workspace)
>  		return ERR_PTR(-ENOMEM);
>
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index d5446e18bb59..c1db7572283b 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -53,14 +53,14 @@ static struct list_head *zlib_alloc_workspace(void)
>  	struct workspace *workspace;
>  	int workspacesize;
>
> -	workspace = kzalloc(sizeof(*workspace), GFP_NOFS);
> +	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
>  	if (!workspace)
>  		return ERR_PTR(-ENOMEM);
>
>  	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
>  			zlib_inflate_workspacesize());
>  	workspace->strm.workspace = vmalloc(workspacesize);
> -	workspace->buf = kmalloc(PAGE_SIZE, GFP_NOFS);
> +	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!workspace->strm.workspace || !workspace->buf)
>  		goto fail;
>
>

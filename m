Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40519 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdFAH6o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 03:58:44 -0400
Subject: Re: [PATCH 1/5] btrfs: replace opencoded kvzalloc with the helper
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496252765.git.dsterba@suse.com>
 <002ad26cc203ff949f1da74733766e20f9111b94.1496252765.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <abbc29d6-eff6-7a9d-4361-9c67249307a6@oracle.com>
Date: Thu, 1 Jun 2017 16:04:47 +0800
MIME-Version: 1.0
In-Reply-To: <002ad26cc203ff949f1da74733766e20f9111b94.1496252765.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index e8185c83f667..924b1d941b53 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -6389,13 +6389,10 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>
>  	alloc_size = sizeof(struct clone_root) * (arg->clone_sources_count + 1);
>
> -	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL | __GFP_NOWARN);
> +	sctx->clone_roots = kzalloc(alloc_size, GFP_KERNEL);


  Should be kvzalloc ?

Thanks, Anand


>  	if (!sctx->clone_roots) {
> -		sctx->clone_roots = vzalloc(alloc_size);
> -		if (!sctx->clone_roots) {
> -			ret = -ENOMEM;
> -			goto out;
> -		}
> +		ret = -ENOMEM;
> +		goto out;
>  	}
>
>  	alloc_size = arg->clone_sources_count * sizeof(*arg->clone_sources);
>

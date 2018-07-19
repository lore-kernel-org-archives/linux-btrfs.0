Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731751AbeGSQ11 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:27:27 -0400
Subject: Re: [PATCH 07/22] btrfs: don't leak ret from do_chunk_alloc
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-7-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <298c8490-7868-9e28-76aa-260fdc8c1d22@suse.com>
Date: Thu, 19 Jul 2018 18:43:39 +0300
MIME-Version: 1.0
In-Reply-To: <20180719145006.17532-7-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.07.2018 17:49, Josef Bacik wrote:
> If we're trying to make a data reservation and we have to allocate a
> data chunk we could leak ret == 1, as do_chunk_alloc() will return 1 if
> it allocated a chunk.  Since the end of the function is the success path
> just return 0.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

The logic flow in this function is a steaming pile of turd and is in
dire need of refactoring...
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 523bc197c40b..6de9a180abdd 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4360,7 +4360,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
>  				      data_sinfo->flags, bytes, 1);
>  	spin_unlock(&data_sinfo->lock);
>  
> -	return ret;
> +	return 0;
>  }
>  
>  int btrfs_check_data_free_space(struct inode *inode,
> 

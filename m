Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38865 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752003AbeCNPJt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:09:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7A42AE0C
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 15:09:48 +0000 (UTC)
Subject: Re: [PATCH] btrfs: add missing initialization in btrfs_check_shared
To: Edmund Nadolski <enadolski@suse.com>, linux-btrfs@vger.kernel.org
References: <20180314150311.20152-1-enadolski@suse.com>
 <20180314150311.20152-2-enadolski@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <f471fca5-d24b-799a-03a5-f9492752e09d@suse.com>
Date: Wed, 14 Mar 2018 17:09:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180314150311.20152-2-enadolski@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.03.2018 17:03, Edmund Nadolski wrote:
> btrfs_check_shared calls find_parent_nodes in a loop. In each
> iteration it passes in a share_check struct to request a check for
> a shared extent.  The share_check::share_count must be re-initialized
> to zero for each iteration in order to avoid using a stale count
> value from the previous iteration, thus causing a false
> shared extent indication.
> 
> Signed-off-by: Edmund Nadolski <enadolski@suse.com>

Is there a particular commit which introduced this regression (i.e. one
of the backref walking series)? It would be useful to know so that this
can be tagged with a Fixes: tag and perhaps stable.

Also your cover letter should go as a changelog in the patch so that we
have a proper history of how this fix came to be :)

> ---
>  fs/btrfs/backref.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 4e89598..4a33448 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1519,6 +1519,7 @@ int btrfs_check_shared(struct btrfs_root *root, u64 inum, u64 bytenr)
>  		if (!node)
>  			break;
>  		bytenr = node->val;
> +		shared.share_count = 0;
>  		cond_resched();
>  	}
>  
> 

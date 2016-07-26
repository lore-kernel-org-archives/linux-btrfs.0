Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbcGZPmG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 11:42:06 -0400
Date: Tue, 26 Jul 2016 17:41:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: backref: Fix soft lockup in __merge_refs function
Message-ID: <20160726154150.GH30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160720070418.3380-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160720070418.3380-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 20, 2016 at 03:04:18PM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/backref.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 8bb3509..4197610d 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -589,6 +589,7 @@ static void __merge_refs(struct list_head *head, int mode)
>  
>  			list_del(&ref2->list);
>  			kmem_cache_free(btrfs_prelim_ref_cache, ref2);
> +			cond_resched();

For a potentially long loop it's a good idea to add the cond resched,

Reviewed-by: David Sterba <dsterba@suse.com>

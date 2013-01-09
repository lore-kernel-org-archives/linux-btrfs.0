Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab3AIKsb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jan 2013 05:48:31 -0500
Date: Wed, 9 Jan 2013 11:48:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] Btrfs: remove unnecessary cur_trans set before goto
 loop in join_transaction
In-Reply-To: <505FAD9B.7010006@gmail.com>
Message-ID: <alpine.LNX.2.00.1301091147540.12134@pobox.suse.cz>
References: <505FAD9B.7010006@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 24 Sep 2012, Wang Sheng-Hui wrote:

> In the big loop, cur_trans will be set fs_info->running_transaction
> before it's used. And after kmem_cache_free it and goto loop, it will
> be setup again. No need to setup it immediately after freed.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/transaction.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 469a8b6..675d813 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -98,7 +98,6 @@ loop:
>  		 * to redo the trans_no_join checks above
>  		 */
>  		kmem_cache_free(btrfs_transaction_cachep, cur_trans);
> -		cur_trans = fs_info->running_transaction;
>  		goto loop;
>  	} else if (fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
>  		spin_unlock(&fs_info->trans_lock);

This is Obviously Correct(TM) :-) and doesn't seem to have been picked up 
by btrfs maintainers. I am picking it up now.

-- 
Jiri Kosina
SUSE Labs

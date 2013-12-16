Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab3LPPAl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:00:41 -0500
Date: Mon, 16 Dec 2013 16:00:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] Btrfs: remove btrfs_end_transaction_dmeta()
Message-ID: <20131216150040.GG6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
 <1386929381-3483-4-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386929381-3483-4-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 06:09:39PM +0800, Miao Xie wrote:
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/delayed-inode.c | 2 +-
>  fs/btrfs/transaction.c   | 6 ------
>  fs/btrfs/transaction.h   | 2 --
>  3 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 5229106..7d55443 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1302,7 +1302,7 @@ again:
>  	__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
>  
>  	trans->block_rsv = block_rsv;
> -	btrfs_end_transaction_dmeta(trans, root);
> +	btrfs_end_transaction(trans, root);

Can you please briefly explain why?

thanks,
david

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbbBZW3D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Feb 2015 17:29:03 -0500
Date: Thu, 26 Feb 2015 23:29:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: Fix NO_SPACE bug caused by delayed-iput
Message-ID: <20150226222901.GB8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1424920823-12176-1-git-send-email-zhaolei@cn.fujitsu.com>
 <1424920823-12176-2-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424920823-12176-2-git-send-email-zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 26, 2015 at 11:20:23AM +0800, Zhaolei wrote:
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2068,8 +2068,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  
>  	kmem_cache_free(btrfs_trans_handle_cachep, trans);
>  
> -	if (current != root->fs_info->transaction_kthread)
> +	if (current != root->fs_info->transaction_kthread) {
>  		btrfs_run_delayed_iputs(root);

Using a mutex for this kind of synchronization is not entirely correct
though it works.

> +		/* make sure that all running delayed iput are done */
> +		down_write(&root->fs_info->delayed_iput_sem);
> +		up_write(&root->fs_info->delayed_iput_sem);

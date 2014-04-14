Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbaDNQrF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 12:47:05 -0400
Date: Mon, 14 Apr 2014 18:47:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] Btrfs: make sure there are not any read requests before
 stopping workers
Message-ID: <20140414164703.GP29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1397042602-23205-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1397042602-23205-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 09, 2014 at 07:23:22PM +0800, Wang Shilong wrote:
> In close_ctree(), after we have stopped all workers,there maybe still
> some read requests(for example readahead) to submit and this *maybe* trigger
> an oops that user reported before:
> 
> kernel BUG at fs/btrfs/async-thread.c:619!
> 
> By hacking codes, i can reproduce this problem with one cpu available.
> We fix this potential problem by invalidating all btree inode pages before
> stopping all workers.
> 
> Thanks to Miao for pointing out this problem.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

This is for 3.15-rc

> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3619,6 +3619,11 @@ int close_ctree(struct btrfs_root *root)
>  
>  	btrfs_free_block_groups(fs_info);
>  
> +	/*
> +	 * we must make sure there is not any read request to
> +	 * submit after we stopping all workers.
> +	 */
> +	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
>  	btrfs_stop_all_workers(fs_info);
>  
>  	free_root_pointers(fs_info, 1);

Now this shutdown sequence almost matches the one from open_ctree.

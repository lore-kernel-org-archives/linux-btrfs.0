Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbbEZRGz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 13:06:55 -0400
Date: Tue, 26 May 2015 19:06:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] btrfs: Fix xfstests btrfs/070
Message-ID: <20150526170652.GP23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <af458385e2759893000ccd9b5160350312de928c.1432273487.git.zhaolei@cn.fujitsu.com>
 <24319912bdbd15dbb0a2a2d9299733edf606c552.1432273488.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <24319912bdbd15dbb0a2a2d9299733edf606c552.1432273488.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subject should reflect the problem being fixed.

On Fri, May 22, 2015 at 01:46:54PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> xfstests btrfs/070 sometimes failed.
> In my test machine, its fail rate is about 30%.
> In another vm(vmware), its fail rate is about 50%.
> 
> Reason:
> btrfs/070 do replace and defrag with fsstress simultaneously,
> after above operation, checksum error is found by scrub.
> Actually, it have no relationship with defrag operation, only
> replace with fsstress can trigger this bug.
> New data writen to target device have possibility rewrited by
> old data from source device by replace code in debug, and can
> be fixed by set chunk to ro in replace operation.

Please improve the description, this is very condensed and unclear how
exactly does the read-only/read-write changes happen.

> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3446,6 +3446,23 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
>  		if (!cache)
>  			goto skip;
>  
> +		/*
> +		 * we need call btrfs_inc_block_group_ro() with scrubs_paused,
> +		 * to avoid deadlock caused by:
> +		 * btrfs_inc_block_group_ro()
> +		 * -> btrfs_wait_for_commit()
> +		 * -> btrfs_commit_transaction()
> +		 * -> btrfs_scrub_pause()
> +		 */
> +		atomic_inc(&fs_info->scrubs_paused);
> +		wake_up(&fs_info->scrub_pause_wait);
> +		btrfs_inc_block_group_ro(root, cache);
> +		mutex_lock(&fs_info->scrub_lock);
> +		__scrub_blocked_if_needed(fs_info);
> +		atomic_dec(&fs_info->scrubs_paused);
> +		mutex_unlock(&fs_info->scrub_lock);
> +		wake_up(&fs_info->scrub_pause_wait);

Please put that into a helper, similar to scrub_blocked_if_needed .

> +
>  		dev_replace->cursor_right = found_key.offset + length;
>  		dev_replace->cursor_left = found_key.offset;
>  		dev_replace->item_needs_writeback = 1;

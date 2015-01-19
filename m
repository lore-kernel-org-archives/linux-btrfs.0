Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbbASOGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 09:06:43 -0500
Date: Mon, 19 Jan 2015 15:06:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen fs
 to avoid deadlock.
Message-ID: <20150119140640.GB13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 19, 2015 at 03:42:41PM +0800, Qu Wenruo wrote:
> The fix is to check if the fs is frozen, if the fs is frozen, just
> return and waiting for the next transaction.
> 
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1000,6 +1000,14 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  			 */
>  			if (fs_info->pending_changes == 0)
>  				return 0;
> +			/*
> +			 * Test if the fs is frozen, or start_trasaction
> +			 * will deadlock on itself.
> +			 */
> +			if (__sb_start_write(sb, SB_FREEZE_FS, false))
> +				__sb_end_write(sb, SB_FREEZE_FS);
> +			else
> +				return 0;

I'm not sure this is the right fix. We should use either
mnt_want_write_file or sb_start_write around the start/commit functions.
The fs may be frozen already, but we also have to catch transition to
that state, or RO remount.

Also, returning 0 is not right, the ioctl actually skipped the expected
work.

>  			trans = btrfs_start_transaction(root, 0);
>  		} else {
>  			return PTR_ERR(trans);

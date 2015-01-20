Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042AbbATRNp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 12:13:45 -0500
Date: Tue, 20 Jan 2015 18:13:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        miaoxie@huawei.com, clm@fb.com
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen fs
 to avoid deadlock.
Message-ID: <20150120171344.GH13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421653361-18630-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 19, 2015 at 03:42:41PM +0800, Qu Wenruo wrote:
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

The more I look into that the more I think that the first fix is the
right one.

Has been pointed out in this thread, it is ok to skip processing the
pending changes if the filesystem is frozen.

The pending changes have to flushed from sync (by design), we cannot use
mnt_want_write or the sb_start* protections that.

The btrfs_freeze callback can safely do the last commit, that's under
s_umount held by vfs::freeze_super. Then any other new transaction would
block. Any other call to btrfs_sync_fs will not find any active
transaction and with this patch will not start one. Sounds safe to me.

I think the right level to check is SB_FREEZE_WRITE though, to stop any
potential writes as soon as possible and when the s_umount lock is still
held in vfs::freeze_super.

I'll collect the relevant patches and will send it for review.


>  			trans = btrfs_start_transaction(root, 0);
>  		} else {
>  			return PTR_ERR(trans);

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbbATPxS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 10:53:18 -0500
Date: Tue, 20 Jan 2015 16:53:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH RFC v2 0/5] Fix bugs introduced by the new pending changes
Message-ID: <20150120155316.GF13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421744737-16586-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 05:05:32PM +0800, Qu Wenruo wrote:
> Commit 572d9ab7845ea0e0 ("btrfs: add support for processing pending
> changes") introduced several bugs which will eventually cause a
> deadlock.
> 
> The deadlock can be triggered by fstests/generic/068 with inode_cache
> mount option.
> 
> The deadlock happens in the following flow:
> moutn with inode_cache -> freeze fs -> sync -> unfreeze.
> 
> Sync_fs stack:				Thaw_fs stack:
> (Holding s_umount)			(Waiting s_umount)
> |- btrfs_sync_fs()
>    |- start_transaction()
>       (Waiting thaw_fs to unfreeze the fs)
> 
> The problem has several causes:
> 1) Cmpxchg in btrfs_apply_pending_changes() doesn't work
> Cmpxchg in btrfs_apply_pending_changes() will only clear
> fs_info->pending_changes if it is already 0.
> So fs_info->pending_changes will never cleared, and every sync_fs() on
> frozen btrfs will try to start a new transaction and deadlock.
> 
> So patch 1 fixes it by using xchg() other than cmpxchg().

Right, that's a silly mistake.

> 2) btrfs_freeze() doesn't handle and clear pending_changes

I don't se a major problem to delay the pending changes, ie. do not
start a new transaction (like the IOC_SYNC does). This would be handled
after thawing and the next full transaction commit.

We could flush the pending changes from the freeze callback, this adds
not much extra work but could mean that some user-triggered change hits
the disk before the filesystem becomes frozen.

> If btrfs start a transaction if there are pending changes but no running
> transaction,

> sync should never start a transaction on frozen fs.

I agree with that and this is the actual bug I see here.

> (Except the following sysfs case)
> 
> So patch 2~3 fixes it by adding pending changes handler in
> btrfs_freeze().
>
> 3) Changes through sysfs interface can create pending changes without
>    waiting for unfreezing.

The sysfs callbacks were changed so they do not trigger any writes, just
make a note for later. There's no difference regarding freezing.

> Since sysfs changes doesn't go through normal open routine,
> which will initiate sb_start_*write() and waiting for unfreezing,
> changes through sysfs like changing label will set
> fs_info->pending_changes to non-zero, and later sync_fs will deadlock
> again.
> 
> So patch 4~5 reverts the commits relating patches to fix such problem.

I don't agree with the reverts for obvious reasons, that's just changing
one buggy behaviour with another one.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46603 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab3BFPOO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 10:14:14 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 41B789A0358
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Feb 2013 08:14:14 -0700 (MST)
Date: Wed, 6 Feb 2013 10:14:11 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted subvolume reappears and other cleaner issues
Message-ID: <20130206151411.GE26092@localhost.localdomain>
References: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 06:03:06AM -0700, Alex Lyakas wrote:
> Hi,
> I want to check if any of the below issues are worth/should be  fixed:
> 
> # btrfs_ioctl_snap_destroy() does not commit a transaction. As a
> result, user can ask to delete a subvol, he receives "ok" back. Even
> if user does "btrfs sub list",
> he will not see the deleted subvol (even though the transaction was
> not committed yet). But if a crash happens, ORPHAN_ITEM will not
> re-appear after crash.
> So after crash, the subvolume still exists perfectly fine (happened
> couple of times here).

Same thing happens to normal unlinks, I don't see a reason to have different
rules for subvols.

> 
> # btrfs_drop_snapshot() does not commit a transaction after
> btrfs_del_orphan_item(). So if the subvol deletion completed in one go
> (did not have to detach and re-attach to transaction, thus committing
> the ORPHAN_ITEM and drop_progress/level), then after crash ORPHAN_ITEM
> will not be in the tree, and subvolume still exists.
> 

Again same thing happens with normal files.

> # btrfs_drop_snapshot() checks btrfs_should_end_transaction(), and
> then does btrfs_end_transaction_throttle() and
> btrfs_start_transaction(). However, it looks like it can rejoin the
> same transaction if transaction was not not blocked yet. Minor issue,
> perhaps?

No if we didn't block then its ok and we wait longer, we only throttle to give
the transaction stuff a chance to commit, so if the join logic decides its ok to
go on then we're good.

> 
> # umount may get delayed because of pending-for-deletion subvolumes:
> btrfs_commit_super() locks the cleaner_mutex, so it will wait for the
> cleaner to complete.
> On the other hand, cleaner will not give up until it completes
> processing all its splice. If currently cleaner is not running, then
> btrfs_commit_super()
> calls btrfs_clean_old_snapshots() directly. So does it make sense:
> - btrfs_commit_super() will not call btrfs_clean_old_snapshots()
> - close_ctree() calls kthread_stop(cleaner_kthread) early, and cleaner
> thread periodically checks if it needs to exit

I don't quite follow this, but sure?  Thanks,

Josef

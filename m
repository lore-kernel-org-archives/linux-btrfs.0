Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54284 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3BFIns (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2013 03:43:48 -0500
Received: by mail-wg0-f43.google.com with SMTP id e12so875452wge.34
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2013 00:43:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
References: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
Date: Wed, 6 Feb 2013 10:43:46 +0200
Message-ID: <CAOcd+r2ep_zj6sOcbD5Te1a8TxcJgfM3OZP7yew8O9BSm3R9tQ@mail.gmail.com>
Subject: Re: Deleted subvolume reappears and other cleaner issues
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can anyone please comment on below?

On Thu, Jan 31, 2013 at 3:03 PM, Alex Lyakas
<alex.btrfs@zadarastorage.com> wrote:
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
>
> # btrfs_drop_snapshot() does not commit a transaction after
> btrfs_del_orphan_item(). So if the subvol deletion completed in one go
> (did not have to detach and re-attach to transaction, thus committing
> the ORPHAN_ITEM and drop_progress/level), then after crash ORPHAN_ITEM
> will not be in the tree, and subvolume still exists.
>
> # btrfs_drop_snapshot() checks btrfs_should_end_transaction(), and
> then does btrfs_end_transaction_throttle() and
> btrfs_start_transaction(). However, it looks like it can rejoin the
> same transaction if transaction was not not blocked yet. Minor issue,
> perhaps?
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
>
> Thanks,
> Alex.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42962 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3AaNDI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 08:03:08 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so2754748wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 05:03:07 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 31 Jan 2013 15:03:06 +0200
Message-ID: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
Subject: Deleted subvolume reappears and other cleaner issues
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I want to check if any of the below issues are worth/should be  fixed:

# btrfs_ioctl_snap_destroy() does not commit a transaction. As a
result, user can ask to delete a subvol, he receives "ok" back. Even
if user does "btrfs sub list",
he will not see the deleted subvol (even though the transaction was
not committed yet). But if a crash happens, ORPHAN_ITEM will not
re-appear after crash.
So after crash, the subvolume still exists perfectly fine (happened
couple of times here).

# btrfs_drop_snapshot() does not commit a transaction after
btrfs_del_orphan_item(). So if the subvol deletion completed in one go
(did not have to detach and re-attach to transaction, thus committing
the ORPHAN_ITEM and drop_progress/level), then after crash ORPHAN_ITEM
will not be in the tree, and subvolume still exists.

# btrfs_drop_snapshot() checks btrfs_should_end_transaction(), and
then does btrfs_end_transaction_throttle() and
btrfs_start_transaction(). However, it looks like it can rejoin the
same transaction if transaction was not not blocked yet. Minor issue,
perhaps?

# umount may get delayed because of pending-for-deletion subvolumes:
btrfs_commit_super() locks the cleaner_mutex, so it will wait for the
cleaner to complete.
On the other hand, cleaner will not give up until it completes
processing all its splice. If currently cleaner is not running, then
btrfs_commit_super()
calls btrfs_clean_old_snapshots() directly. So does it make sense:
- btrfs_commit_super() will not call btrfs_clean_old_snapshots()
- close_ctree() calls kthread_stop(cleaner_kthread) early, and cleaner
thread periodically checks if it needs to exit

Thanks,
Alex.

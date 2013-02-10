Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53835 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786Ab3BJTaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Feb 2013 14:30:12 -0500
Received: by mail-wi0-f171.google.com with SMTP id hn17so2488191wib.10
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2013 11:30:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130206151411.GE26092@localhost.localdomain>
References: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
	<20130206151411.GE26092@localhost.localdomain>
Date: Sun, 10 Feb 2013 21:30:10 +0200
Message-ID: <CAOcd+r1ZT4-iH76fhQTBibHfPLWeyKb0CzQGEYV52qFL6HjuoQ@mail.gmail.com>
Subject: Re: Deleted subvolume reappears and other cleaner issues
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your comments, Josef.

Another thing that confuses me is that there are some cases, in which
btrfs_drop_snapshot() has a failure, but still returns 0, like for
example, if btrfs_del_root() fails. (For cases when
btrfs_drop_snapshot() returns non-zero there is a BUG_ON).
So in this case for me __btrfs_abort_transaction() sees that
trans->blocks_used==0, so it doesn't call __btrfs_std_error, which
would further force the filesystem to become RO. So after that
btrfs_drop_snapshot successfully completes, and, basically, nobody
will retry the subvol deletion. In addition, in this case, after
couple of seconds the machine completely freezes for me. I have not
yet succeeded to determine why.

Thanks,
Alex.


On Wed, Feb 6, 2013 at 5:14 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Thu, Jan 31, 2013 at 06:03:06AM -0700, Alex Lyakas wrote:
>> Hi,
>> I want to check if any of the below issues are worth/should be  fixed:
>>
>> # btrfs_ioctl_snap_destroy() does not commit a transaction. As a
>> result, user can ask to delete a subvol, he receives "ok" back. Even
>> if user does "btrfs sub list",
>> he will not see the deleted subvol (even though the transaction was
>> not committed yet). But if a crash happens, ORPHAN_ITEM will not
>> re-appear after crash.
>> So after crash, the subvolume still exists perfectly fine (happened
>> couple of times here).
>
> Same thing happens to normal unlinks, I don't see a reason to have different
> rules for subvols.
>
>>
>> # btrfs_drop_snapshot() does not commit a transaction after
>> btrfs_del_orphan_item(). So if the subvol deletion completed in one go
>> (did not have to detach and re-attach to transaction, thus committing
>> the ORPHAN_ITEM and drop_progress/level), then after crash ORPHAN_ITEM
>> will not be in the tree, and subvolume still exists.
>>
>
> Again same thing happens with normal files.
>
>> # btrfs_drop_snapshot() checks btrfs_should_end_transaction(), and
>> then does btrfs_end_transaction_throttle() and
>> btrfs_start_transaction(). However, it looks like it can rejoin the
>> same transaction if transaction was not not blocked yet. Minor issue,
>> perhaps?
>
> No if we didn't block then its ok and we wait longer, we only throttle to give
> the transaction stuff a chance to commit, so if the join logic decides its ok to
> go on then we're good.
>
>>
>> # umount may get delayed because of pending-for-deletion subvolumes:
>> btrfs_commit_super() locks the cleaner_mutex, so it will wait for the
>> cleaner to complete.
>> On the other hand, cleaner will not give up until it completes
>> processing all its splice. If currently cleaner is not running, then
>> btrfs_commit_super()
>> calls btrfs_clean_old_snapshots() directly. So does it make sense:
>> - btrfs_commit_super() will not call btrfs_clean_old_snapshots()
>> - close_ctree() calls kthread_stop(cleaner_kthread) early, and cleaner
>> thread periodically checks if it needs to exit
>
> I don't quite follow this, but sure?  Thanks,
>
> Josef

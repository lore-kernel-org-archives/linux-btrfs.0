Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:39793 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757523AbeD0T3Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 15:29:25 -0400
Received: by mail-it0-f66.google.com with SMTP id c3-v6so3127493itj.4
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 12:29:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180427155608.GC21272@twin.jikos.cz>
References: <20180426192351.473-1-jeffm@suse.com> <20180427155608.GC21272@twin.jikos.cz>
From: Noah Massey <noah.massey@gmail.com>
Date: Fri, 27 Apr 2018 15:28:44 -0400
Message-ID: <CADfjVrh0NozrDu=tzAS+pgksrZOzt2QxXYV_vOOo8csXpzkf-Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: David Sterba <dsterba@suse.cz>, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 11:56 AM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Apr 26, 2018 at 03:23:49PM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Commit d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
>> fixed the issue with BTRFS_IOC_QUOTA_RESCAN_WAIT being racy, but
>> ended up reintroducing the hang-on-unmount bug that the commit it
>> intended to fix addressed.
>>
>> The race this time is between qgroup_rescan_init setting
>> ->qgroup_rescan_running = true and the worker starting.  There are
>> many scenarios where we initialize the worker and never start it.  The
>> completion btrfs_ioctl_quota_rescan_wait waits for will never come.
>> This can happen even without involving error handling, since mounting
>> the file system read-only returns between initializing the worker and
>> queueing it.
>>
>> The right place to do it is when we're queuing the worker.  The flag
>> really just means that btrfs_ioctl_quota_rescan_wait should wait for
>> a completion.
>>
>> This patch introduces a new helper, queue_rescan_worker, that handles
>> the ->qgroup_rescan_running flag, including any races with umount.
>>
>> While we're at it, ->qgroup_rescan_running is protected only by the
>> ->qgroup_rescan_mutex.  btrfs_ioctl_quota_rescan_wait doesn't need
>> to take the spinlock too.
>>
>> Fixes: d2c609b834d6 (Btrfs: fix qgroup rescan worker initialization)
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>
> I've added this to misc-next as I'd like to push it to the next rc. The
> Fixes is fixed.
>

I don't see it pushed to misc-next yet, but based on f89fbcd776, could
you update the reference in the first line of the commit to match the
Fixes line?

Thanks,
Noah

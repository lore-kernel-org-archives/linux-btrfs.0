Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727584AbeGSODT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 10:03:19 -0400
Date: Thu, 19 Jul 2018 15:20:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PULL] uuid_mutex fixes and cleanups part2
Message-ID: <20180719132003.GO26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180718041024.9089-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180718041024.9089-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 12:10:24PM +0800, Anand Jain wrote:
> These patches we sent independently before and are in the mailing list.
> They have been tested successfully using the xfstests. The cyclical
> lockdep warning aren't due to these set of patches and they (2) can be
> ignored as they are harmless because the threads involved are
> ioctl/commit and mount thread which lockdep thinks is warn-able can't
> co-exist in the same time space. So this set is ready to be pulled in.
> Thanks.
> 
>   git@github.com:asj/btrfs-devel.git misc-next-jul18
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please note that this not a URL that I could pull, this scheme is used
for the write acces based on SSH.

The branch name should describe the contents of the branch and be
versioned, not date based.

> 1/7 has been discussed and reviewed at length, which is drop the
> unnecessary uuid_mutex in the btrfs_free_extra_devids().
> 
> 2/7 fixes the race which syzbot reported.
> 
> 3/7 as when we sprout we hijack the seed fs_devices, we are bringing
> back the seed fs_devices using the clone_fs_devices() instead we could
> use our btrfs_scan_one_device() which makes the sprout-ing operation
> much cleaner.
> 
> 4-7/7 are a simple cleanup patches.
> 
> Anand Jain (7):
> 1. btrfs: drop uuid_mutex in btrfs_free_extra_devids()
> 2. btrfs: fix race between free_stale_devices and close_fs_devices
> 3. btrfs: do device clone using the btrfs_scan_one_device
> 4. btrfs: use the assigned fs_devices instead of the dereference
> 5. btrfs: warn for num_devices below 0
> 6. btrfs: add helper btrfs_num_devices() to deduce num_devices
> 7. btrfs: add helper function check device delete able

I've commented in to the patches posted to mailinglist. I'll consider 1
and 2 for merge, need to look up the previous discussions again to
refresh the details. 4 is in misc-next and the rest has comments.

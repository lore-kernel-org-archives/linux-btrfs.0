Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbcCQHXn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 03:23:43 -0400
Date: Thu, 17 Mar 2016 15:23:39 +0800
From: Eryu Guan <eguan@redhat.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, chandan@mykolab.com
Subject: Re: [RFC PATCH] btrfs/066: Fix race condition by making 'subvolume
 stress' task to exit gracefully
Message-ID: <20160317072339.GW11419@eguan.usersys.redhat.com>
References: <1458195269-965-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458195269-965-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2016 at 11:44:29AM +0530, Chandan Rajendra wrote:
> The following scenario can occur when running btrfs/066,
> 
>   Task A                                Task B                     Task C
> 
>   run_test()
>   - Execute _btrfs_stress_subvolume()
>     in a background shell.
>                                         _btrfs_stress_subvolme()
>                                           ...
>                                         - fork & exec "mount"
>                                                	      		   Mount subvolume on directory in $TEST_DIR
>   - Wait for fsstress to finish                                    do_mount()
>   - kill shell process executing                                   - btrfs_mount()
>     _btrfs_stress_subvolume()
>     i.e. Task B.
>   - Init process becomes the parent
>     of "subvolume mount" task
>     i.e. Task C.
>   - In case subvolume is mounted
>     (which is not the case),
>     unmount it.
>                                                                    - Complete mounting subvolume
> 
> Hence on the completion of one iteration of run_test(), the subvolume
> created inside the filesystem on $SCRATCH_DEV continues to be mounted on
> $TEST_DIR/$seq.mnt. Subsequent invocations of run_test() (called for
> remaining Btrfs profile configs) fail during _scratch_pool_mkfs.
> 
> Instead of killing the 'subvolume stress' task, This commit uses a named
> pipe to inform the 'subvolume stress' task to break out of the infinite
> loop and exit.

A named pipe seems too heavy and complicated to me. How about breaking
out the loop in _btrfs_stress_subvolume on the existence of some file?
e.g.

_btrfs_stress_subvolume():
	...
	local stop_file=$5
	while [ ! -e $stop_file ]; do
	...
	done

run_test():
	...
	local stop_file=$TEST_DIR/$seq.stop.$$
	...
	# make sure the stop sign is not there
	rm -f $stop_file
	_btrfs_stress_subvolume $SCRATCH_DEV $SCRATCH_MNT subvol_$$ $subvol_mnt $stop_file &
	...
	wait $fsstress_pid
	touch $stop_file
	kill $scrub_pid
	wait

I didn't test it, as I can't reproduce the race, but I guess it should
work :)

Thanks,
Eryu

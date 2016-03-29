Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:35488 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbcC2RbF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 13:31:05 -0400
Received: by mail-qg0-f51.google.com with SMTP id y89so18039340qge.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 10:31:04 -0700 (PDT)
Subject: Re: [PATCH v2 00/15] Introduce device state 'failed', Hot spare and
 Auto replace
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Cc: clm@fb.com, dsterba@suse.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56FABBA5.4090402@gmail.com>
Date: Tue, 29 Mar 2016 13:30:13 -0400
MIME-Version: 1.0
In-Reply-To: <1459261349-32206-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-29 10:22, Anand Jain wrote:
> Thanks for various comments, tests and feedback.
>
> Background: Hot spare and Auto replace:
>   Hot spare is predominately used to mitigate or narrow the time
>   window of a storage in degraded mode during which any further disk
>   failure might lead to a catastrophic data loss. Data center
>   storage generally will have couple of disks reserved as spares
>   on the storage. Mainly this is an enterprise storage feature
>   rather than a FS feature, I believe people acquainted with
>   enterprise storage use cases will appreciate the need of it and
>   so most/all of the enterprise storage has hot spare feature.
>
> Btrfs device states:
>   This patch-set adds 'failed' state and makes provision to use
>   'offline' state as two new device states. So to summarize
>   various device states and their meanings..
>
>   /* missing: device wasn't found at the time of mount */
>   int missing;
>
>   /*
>    * failed: device confirmed to have experienced critical
>    * io failure
>    */
>   int failed;
>
>   /*
>    * offline: When there is no confirmation that a disk has
>    * failed. But an interim communication breakdown
>    * and not necessarily a candidate for the device replace.
>    * Device might be online after user intervention or after
>    * block transport layer error recovery.
>    */
>   int offline;
>
>
> Device state transition Tuning and visualization:
>   Sysfs interfaces are planned to provide the required tuning for
>   device state transition sensitivities and visualization of device
>   states. However sysfs framework which could provide such an interface
>   is being reviewed/tested and not yet ready as of now. So for the
>   testing and debug of these features here I have used an update
>   version of the procfs patch which is in the ML.
>
>        [PATCH] btrfs: debug: procfs-devlist: introduce procfs interface for
> the device list for debugging
>
>   I find the above patch very useful and stable as compared to sysfs
> to visualize the device state.
>
> This patch set does not depend on any of the sysfs patches as such.
>
> Cross compatibility:
>   Adds a new incompatibility feature flags
>   (BTRFS_FEATURE_INCOMPAT_SPARE_DEV) to manage the spare device
>   when older kernels are used. So it is tested to be work fine
>   with older kernel/prog versions.
>
>
> Auto replace:
>   Replace happens automatically, that is when there is any write
>   failed or flush failed, the device will be marked as failed, which
>   will stop any further IO attempt to that device. And in the next
>   commit cycle the auto replace will pick the spare device to
>   replace the failed device. And so the btrfs volume is back to a
>   healthy state.
>
> Per FSID spare vs Global spare:
>   As of now only global hot spare is supported, that is hot spare(s)
>   are for all the btrfs FS in the system. However future there will
>   be a fs_info->no_auto_replace tunable which can be tuned by the user
>   to limit the use of global spare.
>
>
> Example use case:
>   Here below is an example use case of the hot spare setup.
>
>   Add a spare device:
>          btrfs spare add /dev/sde -f
>
>   If there is a spare device which is already added before the,
>   just run
>
>          btrfs dev scan [/dev/sde]
>
>   Which will register the spare device to the kernel.
>
>          btrfs fi show
>           Label: none uuid: 52f170c1-725c-457d-8cfd-d57090460091
>            Total devices 2 FS bytes used 112.00KiB
>            devid 1 size 2.00GiB used 417.50MiB path /dev/sdc
>            devid 2 size 2.00GiB used 417.50MiB path /dev/sdd
>
>          Global spare
>            device size 3.00GiB path /dev/sde
>
>
> Patches:
>
> Kernel:
>   First, it needs, Qu's per chunk missing device patchset, which is
>   part of the set.
>
>   Next patches 6/12 brings in support to manage the transition of
>   devices from online (no state) to offline OR failed state dynamically.
>   On top of static device state like the current "missing" state.
>
>   Next patches 7-11/12 adds support for Spare device. For kernel without
>   spare feature the spare device is kept away. And when the kernel
>   supports the spare device, it will inhibit from mounting it. Further
>   these patch set provides helper function to pick a spare device and
>   release a spare device back to the spare device pool.
>
>   Patch 11/12 provides function for auto replace, this is mainly
>   from the existing replace code.
>   Last 12/15, uses all these facilities, picks a failed device and
>   triggers a auto replace in a kthread (casualty_kthread())
>
>
> Progs:
>   Needs below 4 patches which will add sub cli 'spare' to manage
>   the spare device. As of now deleting a spare device has to be
>   managed using wipefs. However in the long run we would a proper
>   btrfs command to do that job.
>
>
> V1->V2:
> Kernel:
>   (Based on tests and commets provided in the ML)
>   a. Now transition_kthread() wakes up the casualty_kthread to check
>      for device states. Instead of doing that in the transition_kthread()
>      itself. Cleaner and less pressure on transition_kthread().
>   b. Dropped
>       [PATCH 05/15] btrfs: optimize btrfs_check_degradable() for calls outside of barrier
>      as it was wrong patch and the optimization was incomplete.
>   c. Merged patches
>      btrfs: check for failed device and hot replace
>        to
>      btrfs: check device for critical errors and mark failed
>      in an effort to make the changes as in a above.
>
> Progs:
>   a. Added to call btrfs_register_one_device() when doing btrfs
>      spare add
>
>
> Anand Jain (7):
>    btrfs: introduce device dynamic state transition to offline or failed
>    btrfs: introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV
>    btrfs: add check not to mount a spare device
>    btrfs: support btrfs dev scan for spare device
>    btrfs: provide framework to get and put a spare device
>    btrfs: introduce helper functions to perform hot replace
>    btrfs: check device for critical errors and mark failed
>
> Qu Wenruo (5):
>    btrfs: Introduce a new function to check if all chunks a OK for
>      degraded mount
>    btrfs: Do per-chunk check for mount time check
>    btrfs: Do per-chunk degraded check for remount
>    btrfs: Allow barrier_all_devices to do per-chunk device check
>    btrfs: Cleanup num_tolerated_disk_barrier_failures
>
>   fs/btrfs/ctree.h       |   8 +-
>   fs/btrfs/dev-replace.c |  24 +++++
>   fs/btrfs/dev-replace.h |   1 +
>   fs/btrfs/disk-io.c     | 256 +++++++++++++++++++++++++++++++++--------------
>   fs/btrfs/disk-io.h     |   4 +-
>   fs/btrfs/super.c       |  20 +++-
>   fs/btrfs/volumes.c     | 263 +++++++++++++++++++++++++++++++++++++++++++++----
>   fs/btrfs/volumes.h     |  27 +++++
>   8 files changed, 504 insertions(+), 99 deletions(-)
>
> Anand Jain (4):
>    btrfs-progs: Introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV SB flags
>    btrfs-progs: Introduce btrfs spare subcommand
>    btrfs-progs: add fi show for spare
>    btrfs-progs: add global spare device list to filesystem show
>
>   Android.mk        |   2 +-
>   Makefile.in       |   3 +-
>   btrfs.c           |   1 +
>   cmds-filesystem.c |   9 ++
>   cmds-spare.c      | 292 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   commands.h        |   2 +
>   ctree.h           |   4 +-
>   utils.h           |   1 +
>   volumes.c         |   4 +
>   volumes.h         |   2 +
>   10 files changed, 317 insertions(+), 3 deletions(-)
>   create mode 100644 cmds-spare.c
>
I can't provide the same degree of testing this time that I did for the 
previous version (the system I had set up with my normal testing harness 
is offline for the foreseeable future).  That said, I've built and 
booted a kernel with these patches in a VM on my laptop and tested the 
new functionality, and everything appears to work like it's supposed to 
without breaking any existing code, so for the patch-set as a whole:

Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

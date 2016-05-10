Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28322 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbcEJOB4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:01:56 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH v6 00/13] Introduce device state 'failed', spare device and auto replace
Date: Tue, 10 May 2016 22:01:37 +0800
Message-Id: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for various comments, tests and feedback.

Background: Spare device and Auto replace:
 Spare device is predominately used to mitigate or narrow the time
 window of a degraded raid mode, as because during which any further
 disk failure would lead to a catastrophic data loss. Data center
 storage generally will have couple of disks reserved as spares
 on their storage, so that it will automatically kickin to resilver
 the storage pool so that the pool is back to a healthy state.
 Mainly this is an storage feature rather than a FS feature,
 I believe people acquainted with enterprise storage use cases
 will appreciate the need of it, and so most/all of the enterprise
 storage has spare device feature.

Btrfs device states:
 This patch-set adds 'failed' state and makes provision to use
 'offline' state as two new device states. So to summarize
 various device states and their meanings..

 /* missing: device wasn't found at the time of mount */
 int missing;

 /*
  * failed: device confirmed to have experienced critical
  * io failure
  */
 int failed;

 /*
  * offline: When there is no confirmation that a disk has
  * failed. But an interim communication breakdown
  * and not necessarily a candidate for the device replace.
  * Device might be online after user intervention or after
  * block transport layer error recovery.
  */
 int offline;


Device state transition tuning and visualization:
 Sysfs interfaces are planned to provide the required tuning for
 device state transition, sensitivities and visualization of device
 states. However sysfs framework which could provide such an interface
 is being reviewed/tested and not yet ready as of now. So for the
 testing and debug of these features here I have used an update
 version of the procfs patch which is in the ML.

  [PATCH] btrfs: debug: procfs-devlist: introduce procfs interface for
the device list for debugging

 I find the above patch very useful, easy to use (as compared to
 sysfs to visualize the device state) and stable.

This patch set does not depend on any of the sysfs patches as such.

Backward compatibility:
 Adds a new incompatibility feature flags
 (BTRFS_FEATURE_INCOMPAT_SPARE_DEV) to manage the spare device
 when older kernels are used. So it is tested to be work fine
 with older kernel/prog versions.


Auto replace:
 Replace happens automatically, that is when there is any write
 failed or flush failed, the device will be marked as failed, which
 will stop any further IO attempt to that device. And in the next
 commit cycle the auto replace will pick the spare device to
 replace the failed device. And so the btrfs volume is back to a
 healthy state.
 As of now if auto replace fails, spare device is out of the kernel
 device list. If user wants to give a 2nd try then, they should run
 btrfs dev scan again. And the degraded vol will continue to look
 for the spare device. 

Per FSID spare vs Global spare:
 As of now only global spare is supported, that is spare(s)
 are for all the btrfs FS in the system. However future there will
 be a fs_info->no_auto_replace tunable which can be tuned by the user
 to limit the use of global spare.
 We need to think about the implementation of per-FSID spare which I
 hope will solve the problem incompatible spare disk.

Monitoring/tuning:
 The policy tuning/configuring/notification is planned to be through
 sysfs interface, However to implement this, we need the existing
 sysfs-volume patches to be integrated.

Further:
 As of now btrfs-progs is using poors man method to identify
 and clean a spare device, however an ioctl could do better
 job.

Example use case:
 Here below is an example use case of the spare setup.

 Add a spare device:
        btrfs spare add /dev/sde -f

 If there is a spare device which is already added before the,
 just run

        btrfs dev scan [/dev/sde]

 Which will register the spare device to the kernel.

        btrfs fi show
         Label: none uuid: 52f170c1-725c-457d-8cfd-d57090460091
          Total devices 2 FS bytes used 112.00KiB
          devid 1 size 2.00GiB used 417.50MiB path /dev/sdc
          devid 2 size 2.00GiB used 417.50MiB path /dev/sdd

        Global spare
          device size 3.00GiB path /dev/sde


Patches:

Kernel:
 First, it needs, Qu's per chunk missing device patchset, which is
 part of the set.

 Next patches 6-9 adds support for Spare device. For kernel without
 spare feature the spare device is kept away. And when the kernel
 supports the spare device, it will inhibit from mounting it. Further
 these patch set provides helper function to pick a spare device and
 release a spare device back to the spare device pool.

 Patch 10 provides helper function to auto replace.
 Patch 11 provides helper function to bring a device to failed state.
 Patch 12 marks a device as failed based on flush and write errors,
  and avoids any further IO to it.
 Last 13 triggers auto replace.

Progs:
 Needs below 4 patches which will add sub cli 'spare' to manage
 the spare device. As of now deleting a spare device has to be
 managed using wipefs. However in the long run we would a proper
 btrfs command to do that job.



Changelog:
---------
v5->v6:
Kernel:
  a. Rebased del by id changes.
  b. Fix the case where the fail monitor would clash with user initated
     device operation.
  c. Cover page updated on ML Q and A. Mainly on configuring/tuning/
     monitoring and condition on what happens when auto replace fails.

Progs:
  None.

v4->v5:
Kernel:
  a. Originally we had bugs as fixed in the patches below
     [PATCH] btrfs: s_bdev is not null after missing replace
     [PATCH] btrfs: cleanup assigning next active device with a check
     Incorporate those changes at force close device.

  b. Fixup
      btrfs: Introduce a new function to check if all chunks a OK for degraded mount
     as in
      [PATCH] btrfs: fix btrfs_check_degradable() to free extent map

Progs:
  None.

v3->v4:
Kernel:
 a.
  Mainly bug fixes. Thanks to Yauhen for the bug reports.
  Fixed the issue of bdev not being null. Also fixed the
  issue where auto replace didn't check for
  mutually_exclusive_operation_running. In this process,
  the function force_device_close() is changed quite a
  bit, mainly bdev is copied and nulled within the lock
  context, and later close on the copied bdev is called.
 b.
  changed the wording hot spare to spare device, as some of
  the legacy raid setup would need a perticular device
  order for some reasons. So the hot spare would copy
  back the replace target to the replaced disk. However
  we don't need such a setup in modern hw and btrfs won't
  do that way. To avoid any confusion I won't use the term
  hot spare here.

progs:
 No change. Same as v2.

V2->V3:
Kernel:
  Thanks to Yauhen and Austin for the review comments.
  Again split Patch 11 and 12 which was merged in V2 for better.
  Patch numbers are reordered (sorry about that) but for better.
  Fix rcu issue in btrfs_get_spare_device(), we don't need rcu
   as its under uuid_mutex
  Fix rcu issue and to check for replace lock at
   btrfs_auto_replace_start()
  Cleanup old: casualty_kthread() new: health_kthread() with
    changes as per
    838fe188 'btrfs: cleaner_kthread() doesn't need explicit freeze'
    (thanks Yauhen)
  Yauhen reported this issue:
	When a disk is removed through the virtualbox interface.
	BUG: unable to handle kernel NULL pointer dereference at 0000000000000548
	IP: generic_make_request_checks+0x4d/0x910
	::
 	bvec_alloc+0x5e/0x100
	generic_make_request+0x24/0x290
	submit_bio+0x67/0x140
	finish_rmw+0x409/0x570 [btrfs]
	full_stripe_write+0xa5/0xb0 [btrfs]
	raid56_parity_write+0xf5/0x180 [btrfs]
	btrfs_map_bio+0x105/0x300 [btrfs]
	btrfs_get_extent+0x83/0xb20 [btrfs]

	Status: So far the raid group profile would adapt to lower suitable
	group profile when device is missing/failed. This appears to
	be not happening with RAID56 OR there are stale IO which wasn't
	flushed out. Anyway to have this fixed I am moving the patch
	  btrfs: introduce device dynamic state transition to offline or failed
	to the top in v3,
	But firstly we need a reliable test case, or a very carefully
	crafted test case which can create this situation.

Progs:
  No change, same as V2.

V1->V2:
Kernel:
 (Based on tests and commets provided in the ML)
 a. Now transition_kthread() wakes up the casualty_kthread to check
    for device states. Instead of doing that in the transition_kthread()
    itself. Cleaner and less pressure on transition_kthread().
 b. Dropped
     [PATCH 05/15] btrfs: optimize btrfs_check_degradable() for calls outside of barrier
    as it was wrong patch and the optimization was incomplete.
 c. Merged patches
    btrfs: check for failed device and hot replace
      to
    btrfs: check device for critical errors and mark failed
    in an effort to make the changes as in a above.

Progs:
 a. Added to call btrfs_register_one_device() when doing btrfs
    spare add

Anand Jain (8):
  btrfs: introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV
  btrfs: add check not to mount a spare device
  btrfs: support btrfs dev scan for spare device
  btrfs: provide framework to get and put a spare device
  btrfs: introduce helper functions to perform hot replace
  btrfs: introduce device dynamic state transition to offline or failed
  btrfs: check device for critical errors and mark failed
  btrfs: check for failed device and hot replace

Qu Wenruo (5):
  btrfs: Introduce a new function to check if all chunks a OK for
    degraded mount
  btrfs: Do per-chunk check for mount time check
  btrfs: Do per-chunk degraded check for remount
  btrfs: Allow barrier_all_devices to do per-chunk device check
  btrfs: Cleanup num_tolerated_disk_barrier_failures

 fs/btrfs/ctree.h       |  11 +-
 fs/btrfs/dev-replace.c |  43 ++++++++
 fs/btrfs/dev-replace.h |   1 +
 fs/btrfs/disk-io.c     | 231 ++++++++++++++++++++++++++++-------------
 fs/btrfs/disk-io.h     |   2 -
 fs/btrfs/super.c       |  16 ++-
 fs/btrfs/volumes.c     | 277 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h     |  27 +++++
 8 files changed, 509 insertions(+), 99 deletions(-)

-- 
2.7.0


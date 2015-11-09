Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31908 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbbKIK5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:57:35 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9AvYOJ014973
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvYIA011648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:34 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AvXBa003417
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:57:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/15] btrfs: Hot spare and Auto replace
Date: Mon,  9 Nov 2015 18:56:14 +0800
Message-Id: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These set of patches provides btrfs hot spare and auto replace support
for you review and comments.

First, here below are the simple example steps to configure the same:

Add a spare device:
    btrfs spare add /dev/sde -f

OR if there is a spare device which is already added before the, just
run

    btrfs dev scan [/dev/sde]

this will register the spare device to the kernel.

    btrfs fi show
    Label: none  uuid: 52f170c1-725c-457d-8cfd-d57090460091
	Total devices 2 FS bytes used 112.00KiB
	devid    1 size 2.00GiB used 417.50MiB path /dev/sdc
	devid    2 size 2.00GiB used 417.50MiB path /dev/sdd

    Global spare
	device size 3.00GiB path /dev/sde

Thats it.

Auto replace:
 Replace happens automatically, that is when there is any write
 failed or flush failed, the device will be marked as failed, which
 will stop any further IO attempt to that device. And in the next commit
 thread cycle the auto replace will pick the spare device (/dev/sde is
 above example) to replace the failed device. And so the btrfs volume is
 back to a healthy state.


Its btrfs Global spare:
 as of now only global hot spare is supported, that is hot spare(s)
 are for all the btrfs FS in the system.

No spare when device failed:
 It would scan for spare device at the rate of transaction commit
 and will trigger the auto replace when ever spare device is added.

Priority:
 In some future work there can be some chronological order to pick
 a spare and the failed device.


Patches:

Kernel:
First, it needs, Qu's per chunk missing device patchset,
which is part of the set here and also there is a light optimization
(patch 5/15) which was required as part of this enhancement.

Next patches 7,8/15 brings in support, to manage the transition of
devices from online (no state) to offline OR failed state dynamically.
On top of static device state like the current "missing" state.

Patch 9/15 fixes a bug where in we should have blocked the incompatible
feature at the device scan/add level instead/also at in the mount level.
This is because we don't have to bring a device into the device list,
if it is incompatible.

Next patches 10,11,12,13/15 adds support for Spare device. For the
details on how to add a spare device kindly see further below.
For kernel with out spare feature supported the spare device
is kept away. And when the kernel supports the spare device, it will
inhibit from mounting it. Further these patch set provides helper
function to pick a spare device and release a spare device back to
the spare device pool.

Patch 14/15 provides function for auto replace, this is mainly
from the existing replace code, and in the long run I see opportunity
to merge these code with the replace code that is triggered from
the user spare.

Last 15/15, uses all these facilities, picks a failed device and
triggers a auto replace in a kthread (casualty_kthread())


Progs:
Would need 4 patches as listed below.


Known Bug:

As now I see below stale kmem cache during module unload. Which
I am digging.
------
BUG btrfs_path (Not tainted): Objects remaining in btrfs_path on kmem_cache_close()
------

Anand Jain (10):
  btrfs: optimize btrfs_check_degradable() for calls outside of barrier
  btrfs: introduce device dynamic state transition to offline or failed
  btrfs: check device for critical errors and mark failed
  btrfs: block incompatible optional features at scan
  btrfs: introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV
  btrfs: add check not to mount a spare device
  btrfs: support btrfs dev scan for spare device
  btrfs: provide framework to get and put a spare device
  btrfs: introduce helper functions to perform hot replace
  btrfs: check for failed device and hot replace

Qu Wenruo (5):
  btrfs: Introduce a new function to check if all chunks a OK for
    degraded mount
  btrfs: Do per-chunk check for mount time check
  btrfs: Do per-chunk degraded check for remount
  btrfs: Allow barrier_all_devices to do per-chunk device check
  btrfs: Cleanup num_tolerated_disk_barrier_failures

 fs/btrfs/ctree.h       |   7 +-
 fs/btrfs/dev-replace.c | 116 ++++++++++++++++++++
 fs/btrfs/dev-replace.h |   1 +
 fs/btrfs/disk-io.c     | 211 +++++++++++++++++++++++-------------
 fs/btrfs/disk-io.h     |   2 -
 fs/btrfs/super.c       |  20 +++-
 fs/btrfs/transaction.c |   3 +-
 fs/btrfs/volumes.c     | 283 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/volumes.h     |  27 +++++
 9 files changed, 571 insertions(+), 99 deletions(-)

-- 
2.4.1


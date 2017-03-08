Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15282 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752181AbdCHCnO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 21:43:14 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>,
        <kilobyte@angband.pl>, <demfloro@demfloro.ru>
Subject: [PATCH v3 0/7] Chunk level degradable check
Date: Wed, 8 Mar 2017 10:41:17 +0800
Message-ID: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs currently uses num_tolerated_disk_barrier_failures to do global
check for tolerated missing device.

Although the one-size-fit-all solution is quite safe, it's too strict
if data and metadata has different duplication level.

For example, if one use Single data and RAID1 metadata for 2 disks, it
means any missing device will make the fs unable to be degraded
mounted.

But in fact, some times all single chunks may be in the existing
device and in that case, we should allow it to be rw degraded mounted.

Such case can be easily reproduced using the following script:
 # mkfs.btrfs -f -m raid1 -d sing /dev/sdb /dev/sdc
 # wipefs -f /dev/sdc
 # mount /dev/sdb -o degraded,rw

If using btrfs-debug-tree to check /dev/sdb, one should find that the
data chunk is only in sdb, so in fact it should allow degraded mount.

This patchset will introduce a new per-chunk degradable check for
btrfs, allow above case to succeed, and it's quite small anyway.

And enhance kernel error message for missing device, at least kernel
can know what's making mount failed, other than meaningless
"failed to read system chunk/chunk tree -5".

v2:
  Update after almost 2 years.
  Add the last patch to enhance the kernel output, so user can know
  it's missing devices prevent btrfs to mount.
v3:
  Remove one duplicated missing device output
  Use the advice from Anand Jain, not to add new members in btrfs_device,
  but use a new structure extra_rw_degrade_errors, to record error when
  sending down/waiting device.

Sorry Dmitrii Tcvetkov and Adam Borowski, I'm afraid I can't add your
tested-by tags in v3, as the 4th and 4th patches have quite a big change,
so you may need to retest the new patchset.
Sorry for the trouble.

Qu Wenruo (7):
  btrfs: Introduce a function to check if all chunks a OK for degraded
    rw mount
  btrfs: Do chunk level rw degrade check at mount time
  btrfs: Do chunk level degradation check for remount
  btrfs: Introduce extra_rw_degrade_errors parameter for
    btrfs_check_rw_degradable
  btrfs: Allow barrier_all_devices to do chunk level device check
  btrfs: Cleanup num_tolerated_disk_barrier_failures
  btrfs: Enhance missing device kernel message

 fs/btrfs/ctree.h   |   2 -
 fs/btrfs/disk-io.c |  87 ++++++------------------------
 fs/btrfs/disk-io.h |   2 -
 fs/btrfs/super.c   |   5 +-
 fs/btrfs/volumes.c | 156 ++++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/volumes.h |  37 +++++++++++++
 6 files changed, 188 insertions(+), 101 deletions(-)

-- 
2.12.0




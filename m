Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29541 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755818AbbIUCMr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 22:12:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 0/5] Btrfs: Per-chunk degradable check
Date: Mon, 21 Sep 2015 10:10:38 +0800
Message-ID: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs currently uses num_tolerated_disk_barrier_failures to do global
check for tolerated missing device.

Although the one-size-fit-all solution is quite safe, it's too strict if
data and metadata has different duplication level.

For example, if one use Single data and RAID1 metadata for 2 disks, it
means any missing device will make the fs unable to be degraded mounted.

But in fact, some times all single chunks may be in the existing device
and in that case, we should allow it to be rw degraded mounted.

Such case can be easily reproduced using the following script:
 # mkfs.btrfs -f -m raid1 -d sing /dev/sdb /dev/sdc
 # wipefs -f /dev/sdc
 # mount /dev/sdb -o degraded,rw

If using btrfs-debug-tree to check /dev/sdb, one should find that the
data chunk is only in sdb, so in fact it should allow degraded mount.

This patchset will introduce a new per-chunk degradable check for btrfs,
allow above case to succeed, and it's quite small anyway.

Also, it provides the possibility for later enhancement, like
automatically add 'degraded' mount option if possible.

Cc: Anand Jain <anand.jain@oracle.com>

Qu Wenruo (5):
  btrfs: Introduce a new function to check if all chunks a OK for
    degraded     mount
  btrfs: Do per-chunk check for mount time check
  btrfs: Do per-chunk degraded check for remount
  btrfs: Allow barrier_all_devices to do per-chunk device check
  btrfs: Cleanup num_tolerated_disk_barrier_failures

 fs/btrfs/ctree.h   |  2 --
 fs/btrfs/disk-io.c | 87 ++++++++++--------------------------------------------
 fs/btrfs/disk-io.h |  2 --
 fs/btrfs/super.c   | 11 ++++---
 fs/btrfs/volumes.c | 84 +++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |  5 ++++
 6 files changed, 94 insertions(+), 97 deletions(-)

-- 
2.5.2


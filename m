Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45032 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbcD1DGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 23:06:43 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 0/2] [RFC] btrfs: create degraded-RAID1 chunks
Date: Thu, 28 Apr 2016 11:06:18 +0800
Message-Id: <1461812780-538-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the comments that commit[1] deleted

- /*
- * we add in the count of missing devices because we want
- * to make sure that any RAID levels on a degraded FS
- * continue to be honored.
- *

appear to me that automatic reduced-chunk-allocation
when RAID1 is degraded wasn't in the original design.

which also introduced unpleasant things like automatically
allocating single chunks when RAID1 is mounted in degraded
mode, which will hinder further RAID1 mount in degraded
mode.

For example:
mkfs.btrfs -f -d raid1 -m raid1 /dev/sdc /dev/sdd
modprobe -r btrfs && modprobe btrfs
mount -o degraded /dev/sdc /btrfs
btrfs fi df /btrfs
Data, RAID1: total=409.56MiB, used=64.00KiB
Data, single: total=416.00MiB, used=128.00KiB
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=32.00MiB, used=0.00B
Metadata, RAID1: total=409.56MiB, used=112.00KiB
Metadata, single: total=256.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B
mount -o degraded /dev/sdc /btrfs <-- fails

So I am proposing to revert this commit [1].

And now to fix the original issue that is - chunk allocation
fails when RAID1 is degraded, The reason for the problem
seems to be that we had the devs_min attribute for RAID1
set wrongly. Correcting this also means that its time to
fix the RAID1 fixmes in the functions __btrfs_alloc_chunk()
patch [2] does that, and is for review.

Limited tested. For your review comments. Thanks.


[1]
------------------------------
commit 95669976bd7d30ae265db938ecb46a6b7f8cb893

Btrfs: don't consider the missing device when allocating new chunks

The original code allocated new chunks by the number of the writable
devices and missing devices to make sure that any RAID levels on a
degraded FS continue to be honored, but it introduced a problem that
it stopped us to allocating new chunks, the steps to reproduce is
following:

# mkfs.btrfs -m raid1 -d raid1 -f <dev0> <dev1>
# mkfs.btrfs -f <dev1> //Removing <dev1> from the original fs
# mount -o degraded <dev0> <mnt>
# dd if=/dev/null of=<mnt>/tmpfile bs=1M

It is because we allocate new chunks only on the writable devices,
if we take the number of missing devices into account, and want to
allocate new chunks with higher RAID level, we will fail because we
don't have enough writable device. Fix it by ignoring the number
of missing devices when allocating new chunks.
-----------------


[2]
[PATH] btrfs: create degraded-RAID1 chunks


Anand Jain (2):
  btrfs: create degraded-RAID1 chunks
  revert: Btrfs: don't consider the missing device when allocating new
    chunks

 fs/btrfs/extent-tree.c | 17 +++++++++++++++--
 fs/btrfs/volumes.c     | 38 +++++++++++++++++++++++++++++++++-----
 2 files changed, 48 insertions(+), 7 deletions(-)

-- 
2.7.0


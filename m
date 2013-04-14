Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35262 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3DNLOK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Apr 2013 07:14:10 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3EBE9PB021576
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Apr 2013 11:14:09 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3EBE8Ar017168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Apr 2013 11:14:09 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3EBE8eQ017165
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Apr 2013 11:14:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] Online data deduplication
Date: Sun, 14 Apr 2013 19:14:15 +0800
Message-Id: <1365938057-17722-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the second attempt for online data deduplication.

NOTE: This leads to a FORMAT CHANGE, DO NOT use it on real data!

Data deduplication is a specialized data compression technique for eliminating
duplicate copies of repeating data.[1]

This patch set is also related to "Content based storage" in project ideas[2].

For more implementation details, please refer to PATCH 1.

PATCH 2 is a hang fix when deduplication is on.

TODO:
* a bit-to-bit comparison callback.
* a IOCTL for enabling deduplication.

All comments are welcome!

v2:
* To avoid enlarging the file extent item's size, add another index key used for
  freeing dedup extent.
* Freeing dedup extent is now like how we delete checksum.
* Add support for alternative deduplicatin blocksize larger than PAGESIZE.
* Add a mount option to set deduplication blocksize.
* Add support for those writes that are smaller than deduplication blocksize.

=====================
HOW To turn deduplication on:

There are 2 steps you need to do before using it,
1) mount /dev/disk /mnt_of_your_btrfs -o dedup
2) btrfs filesystem sync /mnt_of_your_btrfs
(For simplicity, I hack 'btrfs fi sync' to enable deduplication...)

Here is an example:
1) mkfs.btrfs /dev/sdb1
2) mount /dev/sdb1 /mnt/btrfs -o dedup
   (or mount /dev/sdb1 /mnt/btrfs -o dedup_blocksize=4k)
3) btrfs filesystem sync /mnt/btrfs
4) btrfs fi df /mnt/btrfs
   Data: total=8.00MB, used=256.00KB

5) dd if=/dev/zero of=/mnt/btrfs/foo bs=4K count=1; sync
6) dd if=/dev/zero of=/mnt/btrfs/foo bs=1M count=10; sync
7) btrfs fi df /mnt/btrfs
   Data: total=1.01GB, used=260.00KB

So 4K+10M has been written, but used=256.00KB -> used=260.00KB,
only 4KB is used!
=====================

Liu Bo (2):
  Btrfs: online data deduplication
  Btrfs: skip merge part for delayed data refs

 fs/btrfs/ctree.h        |   45 ++++++
 fs/btrfs/delayed-ref.c  |    7 +
 fs/btrfs/disk-io.c      |   34 +++++-
 fs/btrfs/extent-tree.c  |    7 +
 fs/btrfs/extent_io.c    |    8 +-
 fs/btrfs/extent_io.h    |   11 ++
 fs/btrfs/extent_map.h   |    1 +
 fs/btrfs/file-item.c    |  231 ++++++++++++++++++++++++++++++
 fs/btrfs/inode.c        |  364 +++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/ioctl.c        |   34 +++++-
 fs/btrfs/ordered-data.c |   29 ++++-
 fs/btrfs/ordered-data.h |    9 ++
 fs/btrfs/super.c        |   25 +++-
 13 files changed, 769 insertions(+), 36 deletions(-)

-- 
1.7.7


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37946 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3EAQ1n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 12:27:43 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r41GRfM3028180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 1 May 2013 16:27:42 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r41GRfUk000634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 1 May 2013 16:27:41 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r41GRfh5001161
	for <linux-btrfs@vger.kernel.org>; Wed, 1 May 2013 16:27:41 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v3 0/2] Online data deduplication
Date: Thu,  2 May 2013 00:27:36 +0800
Message-Id: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NOTE: This leads to a FORMAT CHANGE, DO NOT use it on real data!

Data deduplication is a specialized data compression technique for eliminating
duplicate copies of repeating data.[1]

This patch set is also related to "Content based storage" in project ideas[2].

PATCH 1 is a hang fix when deduplication is on, but it's also useful with no
deduplication in practice use.

For more implementation details, please refer to PATCH 2.

TODO:
* a bit-to-bit comparison callback.

All comments are welcome!

[1]: http://en.wikipedia.org/wiki/Data_deduplication
[2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage


v3:
  * add COMPRESS support
  * add a real ioctl to enable dedup feature
  * change the maximum allowed dedup blocksize to 128k because of compressed
    range limit
v2:
  * To avoid enlarging the file extent item's size, add another index key used
    for freeing dedup extent.
  * Freeing dedup extent is now like how we delete checksum.
  * Add support for alternative deduplicatin blocksize larger than PAGESIZE.
  * Add a mount option to set deduplication blocksize.
  * Add support for those writes that are smaller than deduplication blocksize.

=====================
HOW To turn deduplication on:

There are 2 steps you need to do before using it,
1) mount /dev/disk /mnt_of_your_btrfs -o dedup
   (or mount /dev/disk /mnt_of_your_btrfs -o dedup_bs=128K)
2) btrfs filesystem dedup-register /mnt_of_your_btrfs
=====================

Liu Bo (2):
  Btrfs: skip merge part for delayed data refs
  Btrfs: online data deduplication

 fs/btrfs/ctree.h           |   54 ++++
 fs/btrfs/delayed-ref.c     |    7 +
 fs/btrfs/disk-io.c         |   34 +++-
 fs/btrfs/extent-tree.c     |    7 +
 fs/btrfs/extent_io.c       |   27 ++-
 fs/btrfs/extent_io.h       |   15 ++
 fs/btrfs/file-item.c       |  242 ++++++++++++++++++
 fs/btrfs/inode.c           |  583 ++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/ioctl.c           |   38 +++
 fs/btrfs/ordered-data.c    |   30 ++-
 fs/btrfs/ordered-data.h    |   11 +-
 fs/btrfs/super.c           |   27 ++-
 include/uapi/linux/btrfs.h |    1 +
 13 files changed, 990 insertions(+), 86 deletions(-)

-- 
1.7.7


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49576 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3ENMJ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 08:09:28 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jbacik@fusionio.com, g2p.code@gmail.com
Subject: [RFC PATCH V4 0/2] Online data deduplication
Date: Tue, 14 May 2013 20:08:52 +0800
Message-Id: <1368533335-19381-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Data deduplication is a specialized data compression technique for eliminating
duplicate copies of repeating data.[1]

This patch set is also related to "Content based storage" in project ideas[2].

PATCH 1 is a hang fix with deduplication on, but it's also useful with no
deduplication in practice use.

For more implementation details, please refer to PATCH 2.

Plus, there is also a btrfs-progs patch which helps to enable/disable dedup
feature.

TODO:
* a bit-to-bit comparison callback.

All comments are welcome!

[1]: http://en.wikipedia.org/wiki/Data_deduplication
[2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage

v4:
  * add INCOMPAT flag so that old kernel won't mount with a dedup btrfs.
  * elaborate error handling.
  * address a compress bug.
  * address an issue of dedup flag on extent state tree.
  * add new dedup ioctl interface.
v3:
  * add COMPRESS support
  * add a real ioctl to enable dedup feature
  * change the maximum allowed dedup blocksize to 128k because of compression
    range limit
v2:
  * To avoid enlarging the file extent item's size, add another index key used
    for freeing dedup extent.
  * Freeing dedup extent is now like how we delete checksum.
  * Add support for alternative deduplicatin blocksize larger than PAGESIZE.
  * Add a mount option to set deduplication blocksize.
  * Add support for those writes that are smaller than deduplication blocksize.

-----------------------------------------------------------
* HOW To turn deduplication on:

There are 2 steps you need to do before using it,
1) mount /dev/disk /mnt_of_your_btrfs -o dedup
   (or mount /dev/disk /mnt_of_your_btrfs -o dedup_bs=128K)
2) btrfs dedup register /mnt_of_your_btrfs
-----------------------------------------------------------
* HOW To turn deduplication off:

Just mount your btrfs without "-o dedup" or "-o dedup_bs=xxxK"
-----------------------------------------------------------
* HOW To disable deduplication completely:

There are 2 steps you need to do before using it,
1) mount your btrfs WITHOUT "-o dedup" or "-o dedup_bs=xxxK"

2) btrfs dedup unregister /mnt_fs_your_btrfs
(NOTE: 'unregister' won't work unless you do step 1 FIRSTLY.)
-----------------------------------------------------------

Liu Bo (2):
  Btrfs: skip merge part for delayed data refs
  Btrfs: online data deduplication

 fs/btrfs/ctree.h           |   63 +++++
 fs/btrfs/delayed-ref.c     |    7 +
 fs/btrfs/disk-io.c         |   34 +++-
 fs/btrfs/extent-tree.c     |    9 +
 fs/btrfs/extent_io.c       |   29 ++-
 fs/btrfs/extent_io.h       |   16 ++
 fs/btrfs/file-item.c       |  274 +++++++++++++++++++
 fs/btrfs/inode.c           |  630 ++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/ioctl.c           |   93 +++++++
 fs/btrfs/ordered-data.c    |   34 ++-
 fs/btrfs/ordered-data.h    |   11 +-
 fs/btrfs/super.c           |   27 ++-
 include/uapi/linux/btrfs.h |    5 +
 13 files changed, 1141 insertions(+), 91 deletions(-)

-- 
1.7.7


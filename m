Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29970 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaDIHJY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 03:09:24 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [RFC PATCH v9 00/16] Online(inband) data deduplication
Date: Wed,  9 Apr 2014 15:08:28 +0800
Message-Id: <1397027325-27151-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This the 9th attempt for in-band data dedupe.

Data deduplication is a specialized data compression technique for eliminating
duplicate copies of repeating data.[1]

This patch set is also related to "Content based storage" in project ideas[2],
it introduces inband data deduplication for btrfs and dedup/dedupe is for short.

* PATCH 1 is a speed-up improvement, which is about dedup and quota.

* PATCH 2-5 is the preparation work for dedup implementation.

* PATCH 6 shows how we implement dedup feature.

* PATCH 7 fixes a backref walking bug with dedup.

* PATCH 8 fixes a free space bug of dedup extents on error handling.

* PATCH 9 adds the ioctl to control dedup feature.

* PATCH 10 targets delayed refs' scalability problem of deleting refs, which is 
  uncovered by the dedup feature.

* PATCH 11-16 fixes bugs of dedupe including race bug, deadlock, abnormal
  transaction abortion and crash.

* btrfs-progs patch(PATCH 17) which offers all details about how to control the
  dedup feature on progs side.

I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
mount and scratch_mount.


***NOTE***
Known bugs:
* Mounting with options "flushoncommit" and enabling dedupe feature will end up
  with _deadlock_.


TODO:
* a bit-to-bit comparison callback.

All comments are welcome!


[1]: http://en.wikipedia.org/wiki/Data_deduplication
[2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage

v9:
- fix a deadlock and a crash reported by users.
- fix the metadata ENOSPC problem with dedup again.

v8:
- fix the race crash of dedup ref again.
- fix the metadata ENOSPC problem with dedup.

v7:
- rebase onto the lastest btrfs
- break a big patch into smaller ones to make reviewers happy.
- kill mount options of dedup and use ioctl method instead.
- fix two crash due to the special dedup ref

For former patch sets:
v6: http://thread.gmane.org/gmane.comp.file-systems.btrfs/27512
v5: http://thread.gmane.org/gmane.comp.file-systems.btrfs/27257
v4: http://thread.gmane.org/gmane.comp.file-systems.btrfs/25751
v3: http://comments.gmane.org/gmane.comp.file-systems.btrfs/25433
v2: http://comments.gmane.org/gmane.comp.file-systems.btrfs/24959

Liu Bo (16):
  Btrfs: disable qgroups accounting when quata_enable is 0
  Btrfs: introduce dedup tree and relatives
  Btrfs: introduce dedup tree operations
  Btrfs: introduce dedup state
  Btrfs: make ordered extent aware of dedup
  Btrfs: online(inband) data dedup
  Btrfs: skip dedup reference during backref walking
  Btrfs: don't return space for dedup extent
  Btrfs: add ioctl of dedup control
  Btrfs: improve the delayed refs process in rm case
  Btrfs: fix a crash of dedup ref
  Btrfs: fix deadlock of dedup work
  Btrfs: fix transactin abortion in __btrfs_free_extent
  Btrfs: fix wrong pinned bytes in __btrfs_free_extent
  Btrfs: use total_bytes instead of bytes_used for global_rsv
  Btrfs: fix dedup enospc problem

 fs/btrfs/backref.c           |   9 +
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |  86 ++++++
 fs/btrfs/delayed-ref.c       |  26 +-
 fs/btrfs/delayed-ref.h       |   3 +
 fs/btrfs/disk-io.c           |  37 +++
 fs/btrfs/extent-tree.c       | 235 +++++++++++++---
 fs/btrfs/extent_io.c         |  22 +-
 fs/btrfs/extent_io.h         |  16 ++
 fs/btrfs/file-item.c         | 244 +++++++++++++++++
 fs/btrfs/inode.c             | 635 ++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/ioctl.c             | 167 ++++++++++++
 fs/btrfs/ordered-data.c      |  44 ++-
 fs/btrfs/ordered-data.h      |  13 +-
 fs/btrfs/qgroup.c            |   3 +
 fs/btrfs/relocation.c        |   3 +
 fs/btrfs/transaction.c       |  41 +++
 fs/btrfs/transaction.h       |   1 +
 include/trace/events/btrfs.h |   3 +-
 include/uapi/linux/btrfs.h   |  11 +
 20 files changed, 1470 insertions(+), 131 deletions(-)

-- 
1.8.2.1

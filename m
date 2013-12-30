Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17549 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3L3INM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:12 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [RFC PATCH v8 00/14] Online(inband) data deduplication
Date: Mon, 30 Dec 2013 16:12:40 +0800
Message-Id: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Here is the New Year patch bomb :-)

Data deduplication is a specialized data compression technique for eliminating
duplicate copies of repeating data.[1]

This patch set is also related to "Content based storage" in project ideas[2],
it introduces inband data deduplication for btrfs and dedup/dedupe is for short.

PATCH 1 is a hang fix with deduplication on, but it's also useful without
dedup in practice use.

PATCH 2 and 3 are targetting delayed refs' scalability problems, which are
uncovered by the dedup feature.

PATCH 4 is a speed-up improvement, which is about dedup and quota.

PATCH 5-8 is the preparation work for dedup implementation.

PATCH 9 shows how we implement dedup feature.

PATCH 10 fixes a backref walking bug with dedup.

PATCH 11 fixes a free space bug of dedup extents on error handling.

PATCH 12 adds the ioctl to control dedup feature.

PATCH 13 fixes the metadata ENOSPC problem with dedup which has been there
WAY TOO LONG.

PATCH 14 fixes a race bug on dedup writes.

And there is also a btrfs-progs patch(PATCH 15) which offers all details about
how to control the dedup feature.

I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
mount and scratch_mount.

TODO:
* a bit-to-bit comparison callback.

All comments are welcome!


[1]: http://en.wikipedia.org/wiki/Data_deduplication
[2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage

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

Liu Bo (14):
  Btrfs: skip merge part for delayed data refs
  Btrfs: improve the delayed refs process in rm case
  Btrfs: introduce a head ref rbtree
  Btrfs: disable qgroups accounting when quata_enable is 0
  Btrfs: introduce dedup tree and relatives
  Btrfs: introduce dedup tree operations
  Btrfs: introduce dedup state
  Btrfs: make ordered extent aware of dedup
  Btrfs: online(inband) data dedup
  Btrfs: skip dedup reference during backref walking
  Btrfs: don't return space for dedup extent
  Btrfs: add ioctl of dedup control
  Btrfs: fix dedupe 'ENOSPC' problem
  Btrfs: fix a crash of dedup ref

 fs/btrfs/backref.c           |   9 +
 fs/btrfs/ctree.c             |   2 +-
 fs/btrfs/ctree.h             |  86 ++++++
 fs/btrfs/delayed-ref.c       | 161 +++++++----
 fs/btrfs/delayed-ref.h       |   8 +
 fs/btrfs/disk-io.c           |  40 +++
 fs/btrfs/extent-tree.c       | 208 ++++++++++++--
 fs/btrfs/extent_io.c         |  22 +-
 fs/btrfs/extent_io.h         |  16 ++
 fs/btrfs/file-item.c         | 244 +++++++++++++++++
 fs/btrfs/inode.c             | 635 ++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/ioctl.c             | 167 ++++++++++++
 fs/btrfs/ordered-data.c      |  38 ++-
 fs/btrfs/ordered-data.h      |  13 +-
 fs/btrfs/qgroup.c            |   3 +
 fs/btrfs/relocation.c        |   3 +
 fs/btrfs/transaction.c       |   4 +-
 include/trace/events/btrfs.h |   3 +-
 include/uapi/linux/btrfs.h   |  11 +
 19 files changed, 1501 insertions(+), 172 deletions(-)

-- 
1.8.2.1


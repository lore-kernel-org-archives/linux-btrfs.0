Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30964 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3JNFBB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:01 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E50xNT032680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:00 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E50wB2029675
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:00:59 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E50wFJ029151
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:00:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v7 00/13] Online(inband) data deduplication
Date: Mon, 14 Oct 2013 12:59:42 +0800
Message-Id: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Data deduplication is a specialized data compression technique for eliminating
duplicate copies of repeating data.[1]

This patch set is also related to "Content based storage" in project ideas[2].

PATCH 1 is a hang fix with deduplication on, but it's also useful without
dedup in practice use.

PATCH 2 and 3 are targetting delayed refs' scalability problems, which are
uncovered by the dedup feature.

PATCH 4 is a speed-up improvement, which is about dedup and quota.

PATCH 5-8 is the preparation for dedup implementation.

PATCH 9 shows how we implement dedup feature.

PATCH 10 fixes a backref walking bug with dedup.

PATCH 11 fixes a free space bug of dedup extents on error handling.

PATCH 12 fixes a race bug on dedup writes.

PATCH 13 adds the ioctl to control dedup feature.

And there is also a btrfs-progs patch(PATCH 14) which involves all details of
how to control dedup feature.

I've tested this with xfstests by adding a inline dedup 'enable & on' in xfstests'
mount and scratch_mount.

TODO:
* a bit-to-bit comparison callback.

All comments are welcome!


[1]: http://en.wikipedia.org/wiki/Data_deduplication
[2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage

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



Liu Bo (13):
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
  Btrfs: fix a crash of dedup ref
  Btrfs: add ioctl of dedup control

 fs/btrfs/backref.c           |    9 +
 fs/btrfs/ctree.c             |    2 +-
 fs/btrfs/ctree.h             |   85 ++++++
 fs/btrfs/delayed-ref.c       |  159 +++++++----
 fs/btrfs/delayed-ref.h       |    8 +
 fs/btrfs/disk-io.c           |   45 +++
 fs/btrfs/extent-tree.c       |  190 +++++++++++--
 fs/btrfs/extent_io.c         |   22 ++-
 fs/btrfs/extent_io.h         |   15 +
 fs/btrfs/file-item.c         |  230 +++++++++++++++
 fs/btrfs/inode.c             |  641 +++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/ioctl.c             |  167 +++++++++++
 fs/btrfs/ordered-data.c      |   38 ++-
 fs/btrfs/ordered-data.h      |   13 +-
 fs/btrfs/qgroup.c            |    3 +
 fs/btrfs/relocation.c        |    3 +
 fs/btrfs/transaction.c       |    4 +-
 include/trace/events/btrfs.h |    3 +-
 include/uapi/linux/btrfs.h   |   11 +
 19 files changed, 1478 insertions(+), 170 deletions(-)

-- 
1.7.7


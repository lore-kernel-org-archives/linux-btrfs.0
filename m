Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49480 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3HHIf5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 04:35:57 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r788ZuQ4021743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:35:56 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r788ZtfO024858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:35:55 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r788ZsL9012512
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 08:35:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v6 0/5] Online data deduplication
Date: Thu,  8 Aug 2013 16:35:40 +0800
Message-Id: <1375950946-5470-1-git-send-email-bo.li.liu@oracle.com>
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

PATCH 5 is full of real things, all details about implementation of dedup.

Plus, there is also a btrfs-progs patch which helps to enable/disable dedup
feature.

TODO:
* a bit-to-bit comparison callback.

All comments are welcome!

[1]: http://en.wikipedia.org/wiki/Data_deduplication
[2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage

v5->v6:
- remove BUG_ON()s and use proper error handling.
- make dedup hash endian safe on disk.
- refractor dedup tree item.
- fix a bug of deleting file extents with dedup disabled.
- some cleanups
- add manpage for dedup subcommand.

v4->v5:
- go back to one dedup key with a special backref for dedup tree because
  the disk format understands backref well.
- fix a fsync hang with dedup enabled.
- rebase onto the latest btrfs.


Liu Bo (5):
  Btrfs: skip merge part for delayed data refs
  Btrfs: improve the delayed refs process in rm case
  Btrfs: introduce a head ref rbtree
  Btrfs: disable qgroups accounting when quata_enable is 0
  Btrfs: online data deduplication

 fs/btrfs/backref.c         |    9 +
 fs/btrfs/ctree.c           |    2 +-
 fs/btrfs/ctree.h           |   82 ++++++
 fs/btrfs/delayed-ref.c     |  159 +++++++----
 fs/btrfs/delayed-ref.h     |    8 +
 fs/btrfs/disk-io.c         |   31 ++
 fs/btrfs/extent-tree.c     |  190 +++++++++++--
 fs/btrfs/extent_io.c       |   29 ++-
 fs/btrfs/extent_io.h       |   16 +
 fs/btrfs/file-item.c       |  211 ++++++++++++++
 fs/btrfs/inode.c           |  673 +++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/ioctl.c           |   93 ++++++
 fs/btrfs/ordered-data.c    |   38 ++-
 fs/btrfs/ordered-data.h    |   13 +-
 fs/btrfs/qgroup.c          |    3 +
 fs/btrfs/relocation.c      |    3 +
 fs/btrfs/super.c           |   27 ++-
 fs/btrfs/transaction.c     |    4 +-
 include/uapi/linux/btrfs.h |    5 +
 19 files changed, 1420 insertions(+), 176 deletions(-)

-- 
1.7.7


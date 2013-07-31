Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19127 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3GaPiD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 11:38:03 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6VFc2od005702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:03 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc1Mr027026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:01 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFc029028051
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:00 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v5 0/5] Online data deduplication
Date: Wed, 31 Jul 2013 23:37:40 +0800
Message-Id: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
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
 fs/btrfs/ctree.h           |   59 ++++
 fs/btrfs/delayed-ref.c     |  141 +++++++----
 fs/btrfs/delayed-ref.h     |    8 +
 fs/btrfs/disk-io.c         |   30 ++
 fs/btrfs/extent-tree.c     |  196 ++++++++++++--
 fs/btrfs/extent_io.c       |   29 ++-
 fs/btrfs/extent_io.h       |   16 ++
 fs/btrfs/file-item.c       |  217 +++++++++++++++
 fs/btrfs/inode.c           |  637 ++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/ioctl.c           |   93 +++++++
 fs/btrfs/ordered-data.c    |   36 ++-
 fs/btrfs/ordered-data.h    |   11 +-
 fs/btrfs/qgroup.c          |    6 +
 fs/btrfs/relocation.c      |    3 +
 fs/btrfs/super.c           |   27 ++-
 fs/btrfs/transaction.c     |    4 +-
 include/uapi/linux/btrfs.h |    5 +
 18 files changed, 1356 insertions(+), 171 deletions(-)

-- 
1.7.7


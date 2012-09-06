Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758039Ab2IFKou (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A0XCg017429
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:00:34 +0800
Message-ID: <50487434.1010305@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:00:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 0/12] random bug fixes
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset contains 12 bug-fix patches.
- 01-03, 05-09 fix some bugs of the snapshot creation.
- 04 just improves the memory allocation of the ordered data extent object.
- 10 fixes a bug of the tree log that we forgot to protect ->log_batch.
- 11 improve error path handle, makes it show more information to the users
- 12 fixes the problem that fallocate() reserved less space than it need.

And in this patchset, 06, 09-12 are new patches. The others are old ones,
but I updated them according to the comment of David. Thanks, David.

In order to avoid the confusion of the version number, I marked all the patches
as V4 (The version number of the old version is confused, the version number
of two patches is v3, the others is v1).

Beside that, we can pull this patchset from the URL

	git://github.com/miaoxie/linux-btrfs.git for-merge

Thanks
Miao
---
Miao Xie (12):
      Btrfs: fix error path in create_pending_snapshot()
      Btrfs: fix full backref problem when inserting shared block reference
      Btrfs: fix file extent discount problem in the snapshot
      Btrfs: use a slab for ordered extents allocation
      Btrfs: fix wrong orphan count of the fs/file tree
      Btrfs: add a new "type" field into the block reservation structure
      Btrfs: fix corrupted metadata in the snapshot
      Btrfs: fix the snapshot that should not exist
      Btrfs: fix wrong size for the reservation of the snapshot creation
      Btrfs: fix unprotected ->log_batch
      Btrfs: output more information when aborting a unused transaction handle
      Btrfs: fix wrong size for the reservation when doing file pre-allocation.

 fs/btrfs/ctree.h         |   18 ++++++--
 fs/btrfs/delayed-inode.c |    5 +-
 fs/btrfs/disk-io.c       |   17 ++++---
 fs/btrfs/extent-tree.c   |   14 +++---
 fs/btrfs/file.c          |    8 ++--
 fs/btrfs/inode.c         |   33 ++++++++------
 fs/btrfs/ioctl.c         |    5 +-
 fs/btrfs/ordered-data.c  |   85 ++++++++++++++++-------------------
 fs/btrfs/ordered-data.h  |    9 ++++
 fs/btrfs/relocation.c    |    3 +-
 fs/btrfs/super.c         |   17 ++++++-
 fs/btrfs/transaction.c   |  108 ++++++++++++++++++++++++++++++---------------
 fs/btrfs/tree-log.c      |   12 ++---
 13 files changed, 203 insertions(+), 131 deletions(-)

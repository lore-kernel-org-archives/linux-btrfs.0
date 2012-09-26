Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab2IZLWT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 07:22:19 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8QBM3Uk025477
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 19:22:03 +0800
Message-ID: <5062E563.7090105@cn.fujitsu.com>
Date: Wed, 26 Sep 2012 19:22:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC][PATCH V2 0/4] Btrfs: introduce extent buffer cache to btrfs
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset introduce extent buffer cache to btrfs. The basic idea
is to reduce the search time and the contentions of the extent buffer
lock by re-using the last search result.

I ran stress.sh, xfstests and some other tools to test it, all of them
worked well.

As a performance improvement patchset, of course we did performance test.
Because this patchset is to improve the b+ tree search, in other words,
it improves the performance of the metadata operations, we use file creation
test to measure it. So we ran 10 tasks, and all of them created 100000 files
in their own directories at the same time. As the result, we found this patchset
makes btrfs ~20% faster(98s -> 77s).

we can pull this patchset from the URL

	git://github.com/miaoxie/linux-btrfs.git extent-buffer-cache

Thanks
Miao
---
Miao Xie (4):
      Btrfs: restructure btrfs_search_slot()
      Btrfs: introduce extent buffer cache for each i-node
      Btrfs: introduce extent buffer cache for delayed inode
      Btrfs: introduce extent buffer cache for delayed reference

 fs/btrfs/acl.c           |    1 -
 fs/btrfs/btrfs_inode.h   |    6 +-
 fs/btrfs/compression.c   |    1 -
 fs/btrfs/ctree.c         |  598 ++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/ctree.h         |   32 +++-
 fs/btrfs/delayed-inode.c |   23 ++
 fs/btrfs/dir-item.c      |    2 +
 fs/btrfs/disk-io.c       |    2 +-
 fs/btrfs/export.c        |    1 -
 fs/btrfs/extent-tree.c   |    6 +
 fs/btrfs/extent_io.c     |    9 +-
 fs/btrfs/extent_io.h     |   38 +++
 fs/btrfs/file-item.c     |    4 +-
 fs/btrfs/file.c          |    5 +-
 fs/btrfs/inode-item.c    |   10 +-
 fs/btrfs/inode.c         |   36 +++-
 fs/btrfs/ioctl.c         |    1 -
 fs/btrfs/ordered-data.c  |    1 -
 fs/btrfs/relocation.c    |    1 -
 fs/btrfs/send.c          |    1 -
 fs/btrfs/super.c         |    1 -
 fs/btrfs/transaction.c   |   11 +
 fs/btrfs/transaction.h   |    4 +-
 fs/btrfs/tree-log.c      |    6 +-
 fs/btrfs/xattr.c         |    2 +-
 25 files changed, 651 insertions(+), 151 deletions(-)

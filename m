From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [GIT PULL] [RFC PATCH 0/4] btrfs: Implement delayed directory name
 index insertion and deletion
Date: Wed, 01 Dec 2010 16:09:17 +0800
Message-ID: <4CF602AD.8020205@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Compare with Ext3/4, the performance of file creation and deletion on btrfs is
very poor. the reason is that btrfs must do a lot of b+ tree insertions, such as
inode item, directory name item, directory name index and so on.

If we can do some delayed b+ tree insertion or deletion, we can improve the
performance, so we made this patch which implemented delayed directory name
index insertion and deletion.

Beside that, we found we must map the page every time we want to set a member
variable of the inode item, it is inefficient. We just do it at first to reduce
the times of mmap(). By this way, we can also improve the performance of file
creation and deletion.

I did a quick test by the benchmark tool[1] and found we can improve the
performance of file creation by ~11%, and file deletion by ~14%.

Before applying this patch:
Create files:
	Total files: 50000
	Total time: 1.188547
	Average time: 0.000024
Delete files:
	Total files: 50000
	Total time: 1.662012
	Average time: 0.000033

After applying this patch:
Create files:
	Total files: 50000
	Total time: 1.057432
	Average time: 0.000021
Delete files:
	Total files: 50000
	Total time: 1.422851
	Average time: 0.000028

You can also try out the patchset by pulling:
	git://repo.or.cz/linux-btrfs-devel.git perf-improve

[1] http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3

---
 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/btrfs_inode.h       |    2 +
 fs/btrfs/ctree.c             |   13 +-
 fs/btrfs/ctree.h             |   21 +-
 fs/btrfs/delayed-dir-index.c |  790 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/delayed-dir-index.h |   92 +++++
 fs/btrfs/dir-item.c          |   61 +++-
 fs/btrfs/extent-tree.c       |   21 ++
 fs/btrfs/inode.c             |  189 +++++++---
 fs/btrfs/transaction.c       |    9 +
 fs/btrfs/transaction.h       |    2 +
 11 files changed, 1117 insertions(+), 85 deletions(-)

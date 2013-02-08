Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab3BHHD1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 02:03:27 -0500
Message-ID: <5114A36B.5070108@cn.fujitsu.com>
Date: Fri, 08 Feb 2013 15:04:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH V2 2/2] Btrfs: implement unlocked dio write
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This idea is from ext4. By this patch, we can make the dio write parallel,
and improve the performance. But because we can not update isize without
i_mutex, the unlocked dio write just can be done in front of the EOF.

We needn't worry about the race between dio write and truncate, because the
truncate need wait untill all the dio write end.

And we also needn't worry about the race between dio write and punch hole,
because we have extent lock to protect our operation.

I ran fio to test the performance of this feature.

== Hardware ==
CPU: Intel(R) Core(TM)2 Duo CPU     E7500  @ 2.93GHz
Mem: 2GB
SSD: Intel X25-M 120GB (Test Partition: 60GB)

== config file ==
[global]
ioengine=psync
direct=1
bs=4k
size=32G
runtime=60
directory=/mnt/btrfs/
filename=testfile
group_reporting
thread

[file1]
numjobs=1 # 2 4
rw=randwrite

== result (KBps) ==
write	1	2	4
lock	24936	24738	24726
nolock	24962	30866	32101

== result (iops) ==
write	1	2	4
lock	6234	6184	6181
nolock	6240	7716	8025

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- don't do nolocked DIO write if it is beyond the EOF 
---
 fs/btrfs/inode.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a49be05..2948123 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6622,28 +6622,36 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	struct inode *inode = file->f_mapping->host;
 	size_t count = 0;
 	int flags = 0;
-	bool wakeup = false;
+	bool wakeup = true;
+	bool relock = false;
 	ssize_t ret;
 
 	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
 			    offset, nr_segs))
 		return 0;
 
+	atomic_inc(&inode->i_dio_count);
+	smp_mb__after_atomic_inc();
+
 	if (rw & WRITE) {
 		count = iov_length(iov, nr_segs);
+		/*
+		 * If the write DIO is beyond the EOF, we need update
+		 * the isize, but it is protected by i_mutex. So we can
+		 * not unlock the i_mutex at this case.
+		 */
+		if (offset + count <= inode->i_size) {
+			mutex_unlock(&inode->i_mutex);
+			relock = true;
+		}
 		ret = btrfs_delalloc_reserve_space(inode, count);
 		if (ret)
-			return ret;
-	} else {
-		atomic_inc(&inode->i_dio_count);
-		smp_mb__after_atomic_inc();
-		if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
-				      &BTRFS_I(inode)->runtime_flags))) {
-			inode_dio_done(inode);
-			flags = DIO_LOCKING | DIO_SKIP_HOLES;
-		} else {
-			wakeup = true;
-		}
+			goto out;
+	} else if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
+				     &BTRFS_I(inode)->runtime_flags))) {
+		inode_dio_done(inode);
+		flags = DIO_LOCKING | DIO_SKIP_HOLES;
+		wakeup = false;
 	}
 
 	ret = __blockdev_direct_IO(rw, iocb, inode,
@@ -6662,8 +6670,11 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		}
 		btrfs_delalloc_release_metadata(inode, 0);
 	}
+out:
 	if (wakeup)
 		inode_dio_done(inode);
+	if (relock)
+		mutex_lock(&inode->i_mutex);
 
 	return ret;
 }
-- 
1.6.5.2

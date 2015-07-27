Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62325 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbbG0G3g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 02:29:36 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6R6RfAa003799
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 14:27:41 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/7] btrfs-progs: Fix wrong address accessing by subthread in btrfs-convert
Date: Mon, 27 Jul 2015 14:27:48 +0800
Message-ID: <5e15e8e8a85b4877cb913d0e437d2a9b48c85594.1437977968.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
References: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

btrfs-convert sometimes show 'Assertion failed' in converting a nearly blank
file system, as:
  create btrfs filesystem:
          blocksize: 4096
          nodesize:  16384
          features:  extref, skinny-metadata (default)
  creating btrfs metadata.

  creating ext2fs image file.
  trans 7 running 5
  ctree.c:363: btrfs_cow_block: Assertion `1` failed.
  btrfs-convert(btrfs_cow_block+0x92)[0x40acaf]
  btrfs-convert(btrfs_search_slot+0x1cb)[0x40c50f]
  btrfs-convert(btrfs_csum_file_block+0x20f)[0x41d83a]
  btrfs-convert[0x43422d]
  btrfs-convert[0x4342cd]
  btrfs-convert[0x4345ca]
  btrfs-convert[0x434767]
  btrfs-convert[0x435770]
  btrfs-convert[0x439748]
  btrfs-convert(main+0x13f8)[0x43b09d]
  /lib64/libc.so.6(__libc_start_main+0xfd)[0x335e01ecdd]
  btrfs-convert[0x407649]

Reason is complex:
1: main thread allocated a block of memory,
   shared with sub thread
2: main thread killed sub thread, and free above memory
3: main thread malloc a new one(in same address),
   and use it
4: sub thread(which is not really quit), write into
   this address, and caused this bug.

By adding some debug lines into code, we can see following output:
  create btrfs filesystem:
          blocksize: 4096
          nodesize:  16384
          features:  extref, skinny-metadata (default)
  creating btrfs metadata.
  1:  ctx(0x7ffe1abde230)->info=0xc65b80
  2:  task_period_start: will create periodic.timer_fd
  3:  task_stop: info->periodic.timer_fd = NULL
  4:  task_stop: begin pthread_cancel info->id=-1746053376
  5:  task_stop: done pthread_cancel ret=0
  6:  task_stop: begin info->postfn
  7:  task_period_stop: periodic.timer_fd NULL
  8:  task_stop: done info->postfn
  9:  task_stop: done all
  10: creating ext2fs image file.
  trans 7 running 5
  11: task_period_start: create periodic.timer_fd done info->periodic.timer_fd(0xc65b80)=7
  12: btrfs_cow_block: root->fs_info->generation(0xc63568) = 5 trans->transid(0xc65b80)=7
  13: ctree.c:368: btrfs_cow_block: Assertion `1` failed.
  ./btrfs-convert(btrfs_cow_block+0xda)[0x40ad37]
  ./btrfs-convert(btrfs_search_slot+0x1cb)[0x40c5b4]
  ./btrfs-convert(btrfs_insert_empty_items+0xac)[0x40d9f6]
  ./btrfs-convert(btrfs_record_file_extent+0xc0)[0x4183fe]
  ./btrfs-convert[0x435796]
  ./btrfs-convert[0x439b0c]
  ./btrfs-convert(main+0x13f8)[0x43b45d]
  /lib64/libc.so.6(__libc_start_main+0xfd)[0x335e01ecdd]
  ./btrfs-convert[0x407689]
  Conclusion:
  a: subthread should exit before step 5, but it is still running
     in step 11
  b: task_stop() hadn't close periodic.timer_fd in step3,
     because periodic.timer_fd is not initialized yet.
  c. address of 0xc65b80 is overwrited by subthread in step 11,
     but this address is freed and re-malloc by main thread
     before step 10, and used for trans->transid.
  d: trans->transid which is overwrite by subthread caused error
     in step 13.

Fix:
  pthread_cancel() only send a cancellation request to the thread,
  thread will quit in next cancellation point by default.
  To make sub thread quit in time, this patch add pthread_join()
  after pthread_cancel() call.
  And to make pthread_join() works, pthread_detach() is removed.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 task-utils.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/task-utils.c b/task-utils.c
index 10e3f0f..0390a69 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -50,9 +50,7 @@ int task_start(struct task_info *info)
 	ret = pthread_create(&info->id, NULL, info->threadfn,
 			     info->private_data);
 
-	if (ret == 0)
-		pthread_detach(info->id);
-	else
+	if (ret)
 		info->id = -1;
 
 	return ret;
@@ -66,8 +64,10 @@ void task_stop(struct task_info *info)
 	if (info->periodic.timer_fd)
 		close(info->periodic.timer_fd);
 
-	if (info->id > 0)
+	if (info->id > 0) {
 		pthread_cancel(info->id);
+		pthread_join(info->id, NULL);
+	}
 
 	if (info->postfn)
 		info->postfn(info->private_data);
-- 
1.8.5.1


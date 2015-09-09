Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32797 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755669AbbIINeE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 09:34:04 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t89DXlZ7017482
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 21:33:47 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: Fix infinite loop of btrfs-image
Date: Wed, 9 Sep 2015 21:32:21 +0800
Message-ID: <1cb14fe54e546b530d0f3991062ff8bca5cc3394.1441805445.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bug:
 # btrfs-image -t0 -c9 /dev/sda6 /tmp/btrfs_image.img
 (hang)
 # btrfs-image -r -t0 /tmp/btrfs_image.img /dev/sda6
 (hang)

Reason:
 Program need to create at least 1 thread for compress/decompress.
 but if user specify -t0 in argument, it overwrite the default value
 of 1, then the program really created 0 thread, and caused above
 error.

Fix:
 We can add a check, to make program not allow -t0 argument,
 but there are still exist another problem.
 for ex, in node with 4 cpus:
 btrfs-image -c9 -t1: 4 threads (1 means use nr_cpus)
             -c9 -t2: 2 threads
             -c9 -t3: 3 threads
             ...
 (-t1 have more threads than -t2 and -t3)

 So we change to use value of 0 as "use nr_cpus threads", then:
 btrfs-image [no -t arg]: use nr_cpus threads
             -t0:         use nr_cpus threads
             -t val:      use val threads.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-image.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index f48d81a..7f49cce 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2690,7 +2690,7 @@ int main(int argc, char *argv[])
 {
 	char *source;
 	char *target;
-	u64 num_threads = 1;
+	u64 num_threads = 0;
 	u64 compress_level = 0;
 	int create = 1;
 	int old_restore = 0;
@@ -2786,7 +2786,8 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (num_threads == 1 && compress_level > 0) {
+	if ((compress_level > 0 || create == 0) &&
+	    num_threads == 0) {
 		num_threads = sysconf(_SC_NPROCESSORS_ONLN);
 		if (num_threads <= 0)
 			num_threads = 1;
-- 
1.8.5.1


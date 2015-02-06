Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39153 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753939AbbBFInQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 03:43:16 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t168gT81028727
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Feb 2015 16:42:29 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs: Fix out-of-space bug caused by searching commit_root in find_free_dev_extent()
Date: Fri, 6 Feb 2015 16:42:01 +0800
Message-ID: <1423212122-12952-2-git-send-email-zhaolei@cn.fujitsu.com>
In-Reply-To: <1423212122-12952-1-git-send-email-zhaolei@cn.fujitsu.com>
References: <1423212122-12952-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Btrfs will report NO_SPACE when we create and remove files for several times:
1: Create a single-dev btrfs fs with default option
2: Write a file into it to take up most fs space
3: Delete above file
4: Wait about 100s to let chunk removed
5: goto 2

Script is like following:
 #!/bin/bash

 # Recommend 1.2G space, too large disk will make test slow
 DEV="/dev/sda16"
 MNT="/mnt/tmp"

 dev_size="$(lsblk -bn -o SIZE "$DEV")" || exit 2
 file_size_m=$((dev_size * 75 / 100 / 1024 / 1024))

 echo "Loop write ${file_size_m}M file on $((dev_size / 1024 / 1024))M dev"

 for ((i = 0; i < 10; i++)); do umount "$MNT" 2>/dev/null; done
 echo "mkfs $DEV"
 mkfs.btrfs -f "$DEV" >/dev/null || exit 2
 echo "mount $DEV $MNT"
 mount "$DEV" "$MNT" || exit 2

 for ((loop_i = 0; loop_i < 20; loop_i++)); do
     echo
     echo "loop $loop_i"

     echo "dd file..."
     cmd=(dd if=/dev/zero of="$MNT"/file0 bs=1M count="$file_size_m")
     "${cmd[@]}" 2>/dev/null || {
         # NO_SPACE error triggered
         echo "dd failed: ${cmd[*]}"
         exit 1
     }

     echo "rm file..."
     rm -f "$MNT"/file0 || exit 2

     for ((i = 0; i < 10; i++)); do
         df "$MNT" | tail -1
         sleep 10
     done
 done

Reason:
Btrfs get free disk space by calling find_free_dev_extent() when
re-create chunk for write, but current code set search_commit_root
flag in searching tree, so disk spaces which was freed from dev_tree
but not commited can not get from find_free_dev_extent(), then
btrfs report NO_SPACE on above case.

Fix:
Remove "path->search_commit_root = 1" in find_free_dev_extent().

Tested by above script, and confirmed action with many printk.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 50c5a87..5cd0930 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1147,7 +1147,6 @@ again:
 	}
 
 	path->reada = 2;
-	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
 	key.objectid = device->devid;
-- 
1.8.5.1


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63885 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754813AbbBFInP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 03:43:15 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t168gTQc028731
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Feb 2015 16:42:29 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Set hole_size to free space in case of contains_pending_extent
Date: Fri, 6 Feb 2015 16:42:02 +0800
Message-ID: <1423212122-12952-3-git-send-email-zhaolei@cn.fujitsu.com>
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
When we get a free space segment with pending_extent in
find_free_dev_extent(), we need bypass pending_extent segment in
front and continue to use free space segment in tail.
But current code ignored whole dev_extent, and cause NO_SPACE in
some case.

Fix:
Adjust hole_size to real free space value instead of 0 in
find_free_dev_extent().

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cd0930..0cc9422 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1194,8 +1194,12 @@ again:
 			 */
 			if (contains_pending_extent(trans, device,
 						    &search_start,
-						    hole_size))
-				hole_size = 0;
+						    hole_size)) {
+				if (search_start > key.offset)
+					hole_size = 0;
+				else
+					hole_size = key.offset - search_start;
+			}
 
 			if (hole_size > max_hole_size) {
 				max_hole_start = search_start;
-- 
1.8.5.1


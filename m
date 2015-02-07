Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28643 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755184AbbBGNzB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Feb 2015 08:55:01 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t17DsDAl005442
	for <linux-btrfs@vger.kernel.org>; Sat, 7 Feb 2015 21:54:13 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2] btrfs: Fix out-of-space bug
Date: Sat, 7 Feb 2015 21:53:48 +0800
Message-ID: <1423317228-5307-1-git-send-email-zhaolei@cn.fujitsu.com>
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
It is triggered by commit: 47ab2a6c689913db23ccae38349714edf8365e0a
which is used to remove empty block groups automatically, but the
reason is not in that patch. Code before works well because btrfs
don't need to create and delete chunks so many times with high
complexity.

Reason1:
 Btrfs get free disk space by calling find_free_dev_extent() when
 re-create chunk for write, but current code set search_commit_root
 flag in searching tree, so disk spaces which was freed from dev_tree
 but not commited can not get from find_free_dev_extent(), then
 btrfs report NO_SPACE on above case.
 Fixed by this patch.

Reason2:
 When we remove some continuous chunks but leave other chunks after,
 these disk space should be used by chunk-recreating, but in current
 code, only first create will successed.
 Fixed by Forrest Liu <forrestl@synology.com> in:
 Btrfs: fix find_free_dev_extent() malfunction in case device tree has hole

Reason3:
 contains_pending_extent() return wrong value in calculation.
 Fixed by Forrest Liu <forrestl@synology.com> in:
 Btrfs: fix find_free_dev_extent() malfunction in case device tree has hole

Changelog v1->v2:
 V1 will introduce a new bug when create a metadata bg in space of
 old data bg which was just removed, noticed by:
 Filipe David Manana <fdmanana@gmail.com>
 V2 fix this bug by commit transaction after remove block grops.

Tested for severial times by above script.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a684086..67c85ff 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9653,6 +9653,10 @@ next:
 		spin_lock(&fs_info->unused_bgs_lock);
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);
+	trans = btrfs_join_transaction(root);
+	if (!IS_ERR(trans))
+		btrfs_commit_transaction(trans, root);
+
 }
 
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
-- 
1.8.5.1


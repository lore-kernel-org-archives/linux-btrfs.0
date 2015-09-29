Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39889 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965164AbbI2Nx2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 09:53:28 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8TDqx2F021221
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 21:52:59 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Fix lost-data-profile caused by balance bg
Date: Tue, 29 Sep 2015 21:51:43 +0800
Message-ID: <1a179aa4a1d534e4b31d0978e72a7a391f9b408d.1443534660.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <585889cfca0895674926445c0a8caa84f8fc6184.1443534660.git.zhaolei@cn.fujitsu.com>
References: <585889cfca0895674926445c0a8caa84f8fc6184.1443534660.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reproduce:
 (In integration-4.3 branch)

 TEST_DEV=(/dev/vdg /dev/vdh)
 TEST_DIR=/mnt/tmp

 umount "$TEST_DEV" >/dev/null
 mkfs.btrfs -f -d raid1 "${TEST_DEV[@]}"

 mount -o nospace_cache "$TEST_DEV" "$TEST_DIR"
 btrfs balance start -dusage=0 $TEST_DIR
 btrfs filesystem usage $TEST_DIR

 dd if=/dev/zero of="$TEST_DIR"/file count=100
 btrfs filesystem usage $TEST_DIR

Result:
 We can see "no data chunk" in first "btrfs filesystem usage":
 # btrfs filesystem usage $TEST_DIR
 Overall:
    ...
 Metadata,single: Size:8.00MiB, Used:0.00B
    /dev/vdg        8.00MiB
 Metadata,RAID1: Size:122.88MiB, Used:112.00KiB
    /dev/vdg      122.88MiB
    /dev/vdh      122.88MiB
 System,single: Size:4.00MiB, Used:0.00B
    /dev/vdg        4.00MiB
 System,RAID1: Size:8.00MiB, Used:16.00KiB
    /dev/vdg        8.00MiB
    /dev/vdh        8.00MiB
 Unallocated:
    /dev/vdg        1.06GiB
    /dev/vdh        1.07GiB

 And "data chunks changed from raid1 to single" in second
 "btrfs filesystem usage":
 # btrfs filesystem usage $TEST_DIR
 Overall:
    ...
 Data,single: Size:256.00MiB, Used:0.00B
    /dev/vdh      256.00MiB
 Metadata,single: Size:8.00MiB, Used:0.00B
    /dev/vdg        8.00MiB
 Metadata,RAID1: Size:122.88MiB, Used:112.00KiB
    /dev/vdg      122.88MiB
    /dev/vdh      122.88MiB
 System,single: Size:4.00MiB, Used:0.00B
    /dev/vdg        4.00MiB
 System,RAID1: Size:8.00MiB, Used:16.00KiB
    /dev/vdg        8.00MiB
    /dev/vdh        8.00MiB
 Unallocated:
    /dev/vdg        1.06GiB
    /dev/vdh      841.92MiB

Reason:
 btrfs balance delete last data chunk in case of no data in
 the filesystem, then we can see "no data chunk" by "fi usage"
 command.

 And when we do write operation to fs, the only available data
 profile is 0x0, result is all new chunks are allocated single type.

Fix:
 Allocate a data chunk explicitly in balance operation, to reserve
 at least one data chunk in the filesystem.

Test:
 Test by above script, and confirmed the logic by debug output.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fc73586..3d5e41e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3277,6 +3277,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	u64 limit_data = bctl->data.limit;
 	u64 limit_meta = bctl->meta.limit;
 	u64 limit_sys = bctl->sys.limit;
+	int chunk_reserved = 0;
 
 	/* step one make some room on all the devices */
 	devices = &fs_info->fs_devices->devices;
@@ -3387,6 +3388,24 @@ again:
 			goto loop;
 		}
 
+		if (!chunk_reserved) {
+			trans = btrfs_start_transaction(chunk_root, 0);
+			if (IS_ERR(trans)) {
+				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+				ret = PTR_ERR(trans);
+				goto error;
+			}
+
+			ret = btrfs_force_chunk_alloc(trans, chunk_root, 1);
+			if (ret < 0) {
+				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
+				goto error;
+			}
+
+			btrfs_end_transaction(trans, chunk_root);
+			chunk_reserved = 1;
+		}
+
 		ret = btrfs_relocate_chunk(chunk_root,
 					   found_key.offset);
 		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
-- 
1.8.5.1


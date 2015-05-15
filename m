Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48596 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753482AbbEOGig (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 02:38:36 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Fix a bug which makes unfinished fsid change unrecoverable.
Date: Fri, 15 May 2015 14:36:35 +0800
Message-ID: <1431671795-30516-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This bug is found by making break point after change_fsid_prepare() and
then kill the unfinished change, then try to restore the unfinished fsid
change.

If fsid change is canceled, open_ctree will still fail even with
IGNORE_FSID_MIMATCH open ctree flag, since it can't find device with
mismatched fsid, making it unable to restoring.

Now add ignore_fsid_mismatch judgment in btrfs_find_device() to fix the
bug and allow later restore to work as expected.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index 14ce33e..f7462c5 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1510,7 +1510,8 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 	cur_devices = root->fs_info->fs_devices;
 	while (cur_devices) {
 		if (!fsid ||
-		    !memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
+		    (!memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE) ||
+		     root->fs_info->ignore_fsid_mismatch)) {
 			device = __find_device(&cur_devices->devices,
 					       devid, uuid);
 			if (device)
-- 
2.4.0


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54734 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112AbbANHAi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 02:00:38 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0E6q6M4015742
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 14:52:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix wrong return value when executing 'fi show' on umounted device.
Date: Wed, 14 Jan 2015 14:50:40 +0800
Message-ID: <1421218240-13159-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When executing 'btrfs fi show' on unmounted device, even no problem
happens, the return value is still 1 not 0.

The problem lies in search_umounted_fs_uuids(), where when it finds the
given uuid, it should return 1, but later uuid copy overwrites the return
value, causing it always return 0 under that case.

Fix it by pass found as pointer, and return value only indicates
whether anything wrong happens, whether found or not is stored in the
new parameter.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a3cf114..30a7cc4 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -700,7 +700,7 @@ static int has_seed_devices(struct btrfs_fs_devices *fs_devices)
 }
 
 static int search_umounted_fs_uuids(struct list_head *all_uuids,
-				    char *search)
+				    char *search, int *found)
 {
 	struct btrfs_fs_devices *cur_fs, *fs_copy;
 	struct list_head *fs_uuids;
@@ -717,7 +717,8 @@ static int search_umounted_fs_uuids(struct list_head *all_uuids,
 		if (search) {
 			if (uuid_search(cur_fs, search) == 0)
 				continue;
-			ret = 1;
+			if (found)
+				*found = 1;
 		}
 
 		/* skip all fs already shown as mounted fs */
@@ -922,8 +923,8 @@ devs_only:
 		return 1;
 	}
 
-	found = search_umounted_fs_uuids(&all_uuids, search);
-	if (found < 0) {
+	ret = search_umounted_fs_uuids(&all_uuids, search, &found);
+	if (ret < 0) {
 		fprintf(stderr,
 			"ERROR: %d while searching target device\n", ret);
 		return 1;
-- 
2.2.1


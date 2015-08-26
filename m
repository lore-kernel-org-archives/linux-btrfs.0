Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64775 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589AbbHZOFU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 10:05:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7QE5AF7026810
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 22:05:10 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 4/4] btrfs-progs: Simplify all-subvolumn-clean condition for wait_for_subvolume_cleaning
Date: Wed, 26 Aug 2015 22:03:39 +0800
Message-ID: <26cc4d36b398b1bb582532db5cd8e65019e1e812.1440597812.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
References: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of using a dirty-subvolumn-counter in old code, this patch
turn to use a simple and direct way:
  If (not dirty-subvolumn found in current loop) {
      return all_clean;
  }

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-subvolume.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 0b398f0..20e2c01 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -67,11 +67,11 @@ static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
 		int sleep_interval)
 {
 	int ret;
-	int remaining;
+	int dirty_cnt;
 	int i;
 
-	remaining = count;
 	while (1) {
+		dirty_cnt = 0;
 		for (i = 0; i < count; i++) {
 			if (!ids[i])
 				continue;
@@ -80,22 +80,21 @@ static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
 				fprintf(stderr,
 					"ERROR: can't perform the search - %s\n",
 					strerror(-ret));
-				goto out;
+				return ret;
 			}
 			if (ret) {
 				printf("Subvolume id %llu is gone\n", ids[i]);
 				ids[i] = 0;
-				remaining--;
+			} else {
+				dirty_cnt++;
 			}
 		}
-		if (!remaining)
+		if (dirty_cnt == 0)
 			break;
 		sleep(sleep_interval);
 	}
 
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
 static const char * const subvolume_cmd_group_usage[] = {
-- 
1.8.5.1


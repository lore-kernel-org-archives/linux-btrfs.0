Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15597 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756561AbbHZOFU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 10:05:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7QE5Ahd026807
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 22:05:10 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs-progs: Fix wrong return value of wait_for_subvolume_cleaning()
Date: Wed, 26 Aug 2015 22:03:38 +0800
Message-ID: <75136f5acd2273246f1f240505a62de222372084.1440597812.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
References: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reproduce:
 # btrfs subvolume sync /mnt/btrfs
 Subvolume id 323 is gone
 # echo $?
 1
 #

Reason:
 wait_for_subvolume_cleaning() return !0 in right case, because
 value of ret is set to "is subvolume clean" state before return.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-subvolume.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 0d83bd5..0b398f0 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -66,7 +66,7 @@ static int is_subvolume_cleaned(int fd, u64 subvolid)
 static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
 		int sleep_interval)
 {
-	int ret = 0;
+	int ret;
 	int remaining;
 	int i;
 
@@ -92,6 +92,8 @@ static int wait_for_subvolume_cleaning(int fd, int count, u64 *ids,
 			break;
 		sleep(sleep_interval);
 	}
+
+	ret = 0;
 out:
 	return ret;
 }
-- 
1.8.5.1


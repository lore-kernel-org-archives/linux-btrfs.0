Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26105 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030667AbaGCJfl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 05:35:41 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s639Zc1Y009566
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 17:35:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] btrfs-progs: Fix malloc size for superblock.
Date: Thu, 3 Jul 2014 17:36:38 +0800
Message-ID: <1404380198-25948-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1404380198-25948-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

recover_prepare() in chunk-recover.c alloc memory which only contains
sizeof(struct btrfs_super_block). This will cause glibc malloc error
after superblock csum is calculated.

Use BTRFS_SUPER_INFO_SIZE to fix the bug.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 chunk-recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index c8badf9..7dfaf82 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1345,7 +1345,7 @@ static int recover_prepare(struct recover_control *rc, char *path)
 		return -1;
 	}
 
-	sb = malloc(sizeof(struct btrfs_super_block));
+	sb = malloc(BTRFS_SUPER_INFO_SIZE);
 	if (!sb) {
 		fprintf(stderr, "allocating memory for sb failed.\n");
 		ret = -ENOMEM;
-- 
2.0.1


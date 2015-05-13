Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933333AbbEMJSR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 05:18:17 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH 1/4] btrfs-progs: Remove non-exist csum size.
Date: Wed, 13 May 2015 17:15:33 +0800
Message-ID: <1431508536-7275-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs only support CRC32 as checksum algorithm.
But in btrfs_csum_sizes array, we have an extra 0 at tail, causing
csum_type 1 can still be considered as supported csum type.

Fix it by removing the tailing 0.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 10dc838..af70c6f 100644
--- a/ctree.h
+++ b/ctree.h
@@ -149,7 +149,7 @@ struct btrfs_free_space_ctl;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-static int btrfs_csum_sizes[] = { 4, 0 };
+static int btrfs_csum_sizes[] = { 4 };
 
 /* four bytes for CRC32 */
 #define BTRFS_CRC32_SIZE 4
-- 
2.4.0


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23100 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755066AbbEECzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2015 22:55:19 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: Fix superblock csum type check.
Date: Tue, 5 May 2015 10:53:15 +0800
Message-ID: <1430794395-5846-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Old csum type check is wrong and can't catch csum_type 1(not supported).

Fix it to avoid hostile 0 division.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
   Discard a unrelated format change.
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f9c89ca..745b5e7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -174,7 +174,7 @@ struct btrfs_ordered_sum;
 /* csum types */
 #define BTRFS_CSUM_TYPE_CRC32	0
 
-static int btrfs_csum_sizes[] = { 4, 0 };
+static int btrfs_csum_sizes[] = { 4 };
 
 /* four bytes for CRC32 */
 #define BTRFS_EMPTY_DIR_SIZE 0
-- 
2.3.7


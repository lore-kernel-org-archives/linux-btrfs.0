Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12484 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751080AbdBXF4I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 00:56:08 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
CC: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 2/9] btrfs-progs: Introduce macro to calculate backup superblock offset
Date: Fri, 24 Feb 2017 13:52:25 +0800
Message-ID: <20170224055232.4140-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
References: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new macro, BTRFS_SB_OFFSET() to calculate backup superblock
offset, this is handy if one wants to initialize static array at
declaration time.

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 disk-io.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/disk-io.h b/disk-io.h
index c4afea3f..08ee5cee 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -98,11 +98,17 @@ enum btrfs_read_sb_flags {
 	SBREAD_PARTIAL		= (1 << 1),
 };
 
+/*
+ * Use macro to define mirror super block position,
+ * so we can use it in static array initialization
+ */
+#define BTRFS_SB_MIRROR_OFFSET(mirror)	((u64)(SZ_16K) << \
+		(BTRFS_SUPER_MIRROR_SHIFT * (mirror)))
+
 static inline u64 btrfs_sb_offset(int mirror)
 {
-	u64 start = SZ_16K;
 	if (mirror)
-		return start << (BTRFS_SUPER_MIRROR_SHIFT * mirror);
+		return BTRFS_SB_MIRROR_OFFSET(mirror);
 	return BTRFS_SUPER_INFO_OFFSET;
 }
 
-- 
2.11.1




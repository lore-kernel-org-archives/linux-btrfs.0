Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbaC0PTj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 11:19:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6944DAC86
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 15:19:38 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: make device discard process interruptible
Date: Thu, 27 Mar 2014 16:19:37 +0100
Message-Id: <1395933577-32330-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ioctl for the whole range is not interruptible, which can be
annoying when the discard is not wanted but user forgets to use the -K
option.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 utils.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 013d74f9a0cd..3e9c527a492c 100644
--- a/utils.c
+++ b/utils.c
@@ -52,8 +52,10 @@
 #define BLKDISCARD	_IO(0x12,119)
 #endif
 
-static int
-discard_blocks(int fd, u64 start, u64 len)
+/*
+ * Discard the given range in one go
+ */
+static int discard_range(int fd, u64 start, u64 len)
 {
 	u64 range[2] = { start, len };
 
@@ -62,6 +64,26 @@ discard_blocks(int fd, u64 start, u64 len)
 	return 0;
 }
 
+/*
+ * Discard blocks in the given range in 1G chunks, the process is interruptible
+ */
+static int discard_blocks(int fd, u64 start, u64 len)
+{
+	while (len > 0) {
+		/* 1G granularity */
+		u64 chunk_size = min_t(u64, len, 1*1024*1024*1024);
+		int ret;
+
+		ret = discard_range(fd, start, chunk_size);
+		if (ret)
+			return ret;
+		len -= chunk_size;
+		start += chunk_size;
+	}
+
+	return 0;
+}
+
 static u64 reference_root_table[] = {
 	[1] =	BTRFS_ROOT_TREE_OBJECTID,
 	[2] =	BTRFS_EXTENT_TREE_OBJECTID,
-- 
1.9.0


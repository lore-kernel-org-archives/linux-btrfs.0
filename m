Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:56555 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752271AbdKXEKS (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 23 Nov 2017 23:10:18 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/3] btrfs: Introduce macros to handle bytes and sector conversion
Date: Fri, 24 Nov 2017 12:10:06 +0800
Message-Id: <20171124041008.32656-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since block I/O is always done in unit of 512 bytes, add BI_SECTOR_SIZE
and BI_SECTOR_SHIFT macros and to_sector() and to_bytes() for later
use.

Although the best position to define such things should be bvec.h, and
to_sector() to_bytes() are also defined in device-mapper.h, there are
a lot of code defining their own SECTOR_SIZE and to_bytes() in
device-mapper is not using u64 (unsigned long long) but unsigned long,
which doesn't fit btrfs usage.

So define btrfs' own macros and inlined converters.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8fc690384c58..8f6f57167661 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3734,4 +3734,17 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
 #endif
 	return 0;
 }
+
+#define BI_SECTOR_SHIFT		(9)
+#define BI_SECTOR_SIZE		(1 << BI_SECTOR_SHIFT)
+
+static inline u64 to_bytes(sector_t n)
+{
+	return ((u64)n << BI_SECTOR_SHIFT);
+}
+
+static inline sector_t to_sector(u64 n)
+{
+	return (n >> BI_SECTOR_SHIFT);
+}
 #endif
-- 
2.15.0


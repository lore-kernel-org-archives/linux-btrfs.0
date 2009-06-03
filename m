From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] add comments for extent_fiemap
Date: Wed,  3 Jun 2009 10:52:37 +0800
Message-ID: <1243997557-5961-1-git-send-email-bergwolf@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, Peng Tao <bergwolf@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This also explains btrfs fiemap ioctl() return values, especially the positive
return value, which may confuse users.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 fs/btrfs/extent_io.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6826018..287896e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2828,6 +2828,11 @@ out:
 	return sector;
 }
 
+/*
+ * Get the extents count of a file and map the extent to a user-supplied extent
+ * array. Returns 0 on success, 1 when the user-supplied extents array is full,
+ * and negetive values on failure.
+ */
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent)
 {
-- 
1.6.2.GIT


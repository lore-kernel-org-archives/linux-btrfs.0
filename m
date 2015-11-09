Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbbKIKqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Nov 2015 05:46:21 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: fix signed overflows in btrfs_sync_file
Date: Mon,  9 Nov 2015 11:44:45 +0100
Message-Id: <1447065885-24451-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The calculation of range length in btrfs_sync_file leads to signed
overflow. This was caught by PaX gcc SIZE_OVERFLOW plugin.

https://forums.grsecurity.net/viewtopic.php?f=1&t=4284

The fsync call passes 0 and LLONG_MAX, the range length does not fit to
loff_t and overflows, but the value is converted to u64 so it silently
works as expected.

The minimal fix is a typecast to u64, switching functions to take
(start, end) instead of (start, len) would be more intrusive.

Coccinelle script found that there's one more opencoded calculation of
the length.

<smpl>
@@
loff_t start, end;
@@
* end - start
</smpl>

CC: stable@vger.kernel.org
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/file.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8c6f247ba81d..d70399dbb364 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1868,8 +1868,13 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct btrfs_log_ctx ctx;
 	int ret = 0;
 	bool full_sync = 0;
-	const u64 len = end - start + 1;
+	u64 len;
 
+	/*
+	 * The range length can be represented by u64, we have to do the typecasts
+	 * to avoid signed overflow if it's [0, LLONG_MAX] eg. from fsync()
+	 */
+	len = (u64)end - (u64)start + 1;
 	trace_btrfs_sync_file(file, datasync);
 
 	/*
@@ -2057,8 +2062,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 			}
 		}
 		if (!full_sync) {
-			ret = btrfs_wait_ordered_range(inode, start,
-						       end - start + 1);
+			ret = btrfs_wait_ordered_range(inode, start, len);
 			if (ret) {
 				btrfs_end_transaction(trans, root);
 				goto out;
-- 
2.6.2


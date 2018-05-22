Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:40498 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753085AbeEVWCX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 18:02:23 -0400
Received: by mail-pf0-f195.google.com with SMTP id f189-v6so9429858pfa.7
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 15:02:23 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 2/2] Btrfs: fix dedupe vs chattr NODATASUM race
Date: Tue, 22 May 2018 15:02:13 -0700
Message-Id: <29b3345dbf525eafe3f00f65398c254b005cb95c.1527026445.git.osandov@fb.com>
In-Reply-To: <cover.1527026445.git.osandov@fb.com>
References: <cover.1527026445.git.osandov@fb.com>
In-Reply-To: <cover.1527026445.git.osandov@fb.com>
References: <cover.1527026445.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

In btrfs_extent_same(), we must check the NODATASUM flag while the
inodes are locked. Otherwise, it's possible that btrfs_ioctl_setflags()
will change the flags after we check. This was correct until a recent
change.

Fixes: 0a38effca37c ("Btrfs: split btrfs_extent_same")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 784e267aad32..c2263bf4d6f5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3586,12 +3586,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	if (olen == 0)
 		return 0;
 
-	/* don't make the dst file partly checksummed */
-	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
-	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
-		return -EINVAL;
-	}
-
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
 	if (chunk_count == 0)
@@ -3624,6 +3618,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	else
 		btrfs_double_inode_lock(src, dst);
 
+	/* don't make the dst file partly checksummed */
+	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
+	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; i < chunk_count; i++) {
 		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
 					      dst, dst_loff, &cmp);
-- 
2.17.0


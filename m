Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40837 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaDXNPy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 09:15:54 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so2191294wgh.28
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 06:15:53 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: correctly set profile flags on seqlock retry
Date: Thu, 24 Apr 2014 15:15:29 +0100
Message-Id: <1398348929-1827-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1398348929-1827-1-git-send-email-fdmanana@gmail.com>
References: <1398348929-1827-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we had to retry on the profiles seqlock (due to a concurrent write), we
would set bits on the input flags that corresponded both to the current
profile and to previous values of the profile.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/extent-tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 678cb35..5590af9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3543,11 +3543,13 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	return extended_to_chunk(flags | tmp);
 }
 
-static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
+static u64 get_alloc_profile(struct btrfs_root *root, u64 orig_flags)
 {
 	unsigned seq;
+	u64 flags;
 
 	do {
+		flags = orig_flags;
 		seq = read_seqbegin(&root->fs_info->profiles_lock);
 
 		if (flags & BTRFS_BLOCK_GROUP_DATA)
-- 
1.9.1


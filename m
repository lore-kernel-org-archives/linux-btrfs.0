Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2660 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754755AbaI3Cj0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 22:39:26 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8U2dQhs011252
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 10:39:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Don't return any fs_info that contain NULL tree_root or fs_root.
Date: Tue, 30 Sep 2014 10:39:22 +0800
Message-ID: <1412044762-2480-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
btrfsck will segfault if it fails to open the fs tree or tree root.

[REPRODUCER]
Execute btrfsck on a highly damaged btrfs image.
fsfuzz can be used to make a junk btrfs image.

[REASON]
Current open_ctree() in btrfs-progs support OPEN_CTREE_PARTIAL flag to
allow return fs_info even some of the trees is missing.

However it is too loose and even allows fs_info containing no tree to be
returned.

And when it happens, fs_info->fs_root is NULL,
close_ctree(fs_info->fs_root) will cause the access to NULL pointer and
segfault.

[FIX]
This patch will add checks for fs_info->tree_root and fs_info->fs_root
before return fs_info.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 26a532e..21a3083 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1134,7 +1134,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	return fs_info;
 
 out_failed:
-	if (flags & OPEN_CTREE_PARTIAL)
+	if (flags & OPEN_CTREE_PARTIAL &&
+	    fs_info->tree_root && fs_info->fs_root)
 		return fs_info;
 out_chunk:
 	btrfs_release_all_roots(fs_info);
-- 
2.1.1


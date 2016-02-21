Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37858 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbcBUA43 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 19:56:29 -0500
From: Simon Quigley <tsimonq2@ubuntu.com>
To: clm@fb.com, joe@perches.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Quigley <tsimonq2@ubuntu.com>
Subject: [PATCH] btrfs: backref: Fixed checkpatch warning of over 80
Date: Sat, 20 Feb 2016 18:56:18 -0600
Message-Id: <1456016178-4560-1-git-send-email-tsimonq2@ubuntu.com>
In-Reply-To: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
References: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

checkpatch.pl reported a warning of over 80 characters on line 1833

Adjusted to put &extref and &offset on a different line

Signed-off-by: Simon Quigley <tsimonq2@ubuntu.com>
---
 fs/btrfs/backref.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f6dac40..956fffa 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1830,8 +1830,8 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 	unsigned long ptr;
 
 	while (1) {
-		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &extref,
-					    &offset);
+		ret = btrfs_find_one_extref(fs_root, inum, offset, path,
+							&extref, &offset);
 		if (ret < 0)
 			break;
 		if (ret) {
-- 
2.7.0


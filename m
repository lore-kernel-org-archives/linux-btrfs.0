Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33905 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947493AbcBTSRp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 13:17:45 -0500
From: Simon Quigley <tsimonq2@ubuntu.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Quigley <tsimonq2@ubuntu.com>
Subject: [PATCH] btrfs: backref: Fixed checkpatch warning of over 80 characters
Date: Sat, 20 Feb 2016 12:17:38 -0600
Message-Id: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

checkpatch.pl reported a warning of over 80 characters on line 1833

Fixed by splitting up into multiple lines, no build errors afterwards

Signed-off-by: Simon Quigley <tsimonq2@ubuntu.com>
---
 fs/btrfs/backref.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f6dac40..d097777 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1830,7 +1830,11 @@ static int iterate_inode_extrefs(u64 inum, struct btrfs_root *fs_root,
 	unsigned long ptr;
 
 	while (1) {
-		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &extref,
+		ret = btrfs_find_one_extref(fs_root,
+						inum,
+						offset,
+						path,
+						&extref,
 					    &offset);
 		if (ret < 0)
 			break;
-- 
2.7.0


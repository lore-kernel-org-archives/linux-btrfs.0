Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([125.16.236.4]:37529 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbbLOKD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 05:03:27 -0500
Received: from localhost
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 15 Dec 2015 15:33:23 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 17F651258059
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 15:33:48 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBFA3ILY7340446
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 15:33:19 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBFA22bM026248
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 15:32:03 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz,
        chandan@mykolab.com
Subject: [PATCH] Btrfs-progs: ftw_add_entry_size: Round up file size to sectorsize
Date: Tue, 15 Dec 2015 15:32:00 +0530
Message-Id: <1450173720-25543-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ftw_add_entry_size() assumes 4k as the block size of the underlying filesystem
and hence the file sizes computed is incorrect for non-4k sectorsized
filesystems. Fix this by rounding up file sizes to sectorsize.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 mkfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index c58ab2f..88c2289 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1031,16 +1031,15 @@ out:
  * This ignores symlinks with unreadable targets and subdirs that can't
  * be read.  It's a best-effort to give a rough estimate of the size of
  * a subdir.  It doesn't guarantee that prepopulating btrfs from this
- * tree won't still run out of space. 
- *
- * The rounding up to 4096 is questionable.  Previous code used du -B 4096.
+ * tree won't still run out of space.
  */
 static u64 global_total_size;
+static u64 fs_block_size;
 static int ftw_add_entry_size(const char *fpath, const struct stat *st,
 			      int type)
 {
 	if (type == FTW_F || type == FTW_D)
-		global_total_size += round_up(st->st_size, 4096);
+		global_total_size += round_up(st->st_size, fs_block_size);
 
 	return 0;
 }
@@ -1060,6 +1059,7 @@ static u64 size_sourcedir(char *dir_name, u64 sectorsize,
 			allocated_meta_size / default_chunk_size;
 
 	global_total_size = 0;
+	fs_block_size = sectorsize;
 	ret = ftw(dir_name, ftw_add_entry_size, 10);
 	dir_size = global_total_size;
 	if (ret < 0) {
-- 
2.1.0


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3K0RS4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 12:18:56 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: arjan@linux.intel.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: call endmntent in btrfs_scan_kernel
Date: Wed, 27 Nov 2013 18:18:38 +0100
Message-Id: <1385572718-3133-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scan_kernel() does a getmntent() but never releases the
filedescriptor it gets back from that.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64711

Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-filesystem.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 8296fa1ebb44..8e4754f84647 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -449,11 +449,12 @@ static int btrfs_scan_kernel(void *search)
 		ret = get_fs_info(mnt->mnt_dir, &fs_info_arg,
 				&dev_info_arg);
 		if (ret)
-			return ret;
+			goto out;
 
 		if (get_label_mounted(mnt->mnt_dir, label)) {
 			kfree(dev_info_arg);
-			return 1;
+			ret = 1;
+			goto out;
 		}
 		if (search && !match_search_item_kernel(fs_info_arg.fsid,
 					mnt->mnt_dir, label, search)) {
@@ -472,11 +473,14 @@ static int btrfs_scan_kernel(void *search)
 			close(fd);
 		kfree(dev_info_arg);
 		if (search)
-			return 0;
+			ret = 0;
 	}
 	if (search)
-		return 1;
-	return 0;
+		ret = 1;
+
+out:
+	endmntent(f);
+	return ret;
 }
 
 static const char * const cmd_show_usage[] = {
-- 
1.8.4.3


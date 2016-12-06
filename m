Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36591 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751779AbcLFEgh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 23:36:37 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: recursive defrag cleanup duplicate code
Date: Tue,  6 Dec 2016 12:39:38 +0800
Message-Id: <20161206043938.3249-2-anand.jain@oracle.com>
In-Reply-To: <20161206043938.3249-1-anand.jain@oracle.com>
References: <20161206043938.3249-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 41623f3183a8..ecac37edf936 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1136,21 +1136,13 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 			close_file_or_dir(fd, dirstream);
 			continue;
 		}
-		if (recursive) {
-			if (S_ISDIR(st.st_mode)) {
-				ret = nftw(argv[i], defrag_callback, 10,
+		if (recursive && S_ISDIR(st.st_mode)) {
+			ret = nftw(argv[i], defrag_callback, 10,
 						FTW_MOUNT | FTW_PHYS);
-				if (ret == ENOTTY)
-					exit(1);
-				/* errors are handled in the callback */
-				ret = 0;
-			} else {
-				if (defrag_global_verbose)
-					printf("%s\n", argv[i]);
-				ret = do_defrag(fd, defrag_global_fancy_ioctl,
-						&defrag_global_range);
-				e = errno;
-			}
+			if (ret == ENOTTY)
+				exit(1);
+			/* errors are handled in the callback */
+			ret = 0;
 		} else {
 			if (defrag_global_verbose)
 				printf("%s\n", argv[i]);
-- 
2.10.0


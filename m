Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:14542 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751239AbdK2CIo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 21:08:44 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH v3 2/3] btrfs-progs: fi defrag: do not exit if defrag range ioctl is unsupported
Date: Wed, 29 Nov 2017 10:12:25 +0800
Message-ID: <20171129021225.15509-1-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If ioctl of defrag range is unsupported, defrag will exit immediately.

Since caller can handle the error, let cmd_filesystem_defrag()
close file, break the loop and return error instead of calling exit(1).

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:	Separate the patch from commit 6e991b9161fa ("btrfs-progs: fi
	defrag: clean up duplicate code if find errors").
v3:	Call close_file_or_dir() before breaking the loop.
---
 cmds-filesystem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 17d399d58adf..232d4e88e0c0 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1049,8 +1049,10 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		if (recursive && S_ISDIR(st.st_mode)) {
 			ret = nftw(argv[i], defrag_callback, 10,
 						FTW_MOUNT | FTW_PHYS);
-			if (ret == ENOTTY)
-				exit(1);
+			if (ret == ENOTTY) {
+				close_file_or_dir(fd, dirstream);
+				break;
+			}
 			/* errors are handled in the callback */
 			ret = 0;
 		} else {
-- 
2.15.0




Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38027 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab3LKJac (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 04:30:32 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBB9T6hp003266
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 17:30:29 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix improper error prompt for defragment
Date: Wed, 11 Dec 2013 17:27:46 +0800
Message-Id: <1386754066-5113-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error msg:
	"ERROR: defrag range ioctl not supported in this kernel,
	 please try without any options."
should only show up when failing to do a range defraging,
not upon non-range defraging.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 83fe819..0cb35c6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -765,7 +765,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 		ret = do_defrag(fd, defrag_global_fancy_ioctl, &defrag_global_range);
 		e = errno;
 		close(fd);
-		if (ret && e == ENOTTY) {
+		if (ret && e == ENOTTY && defrag_global_fancy_ioctl) {
 			fprintf(stderr, "ERROR: defrag range ioctl not "
 				"supported in this kernel, please try "
 				"without any options.\n");
@@ -898,7 +898,7 @@ static int cmd_defrag(int argc, char **argv)
 			e = errno;
 		}
 		close_file_or_dir(fd, dirstream);
-		if (ret && e == ENOTTY) {
+		if (ret && e == ENOTTY && defrag_global_fancy_ioctl) {
 			fprintf(stderr, "ERROR: defrag range ioctl not "
 				"supported in this kernel, please try "
 				"without any options.\n");
-- 
1.8.0.1


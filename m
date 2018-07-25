Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:51273 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbeGYJ1i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 05:27:38 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id EBCF5AC00AF
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:17:00 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id 2450246E839
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:17:00 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: ins: logical-resolve: Set correct error value
Date: Wed, 25 Jul 2018 17:20:16 +0900
Message-ID: <1447450b84429a439316493340c0c82a605f6539.1532501096.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reset ret value to zero after snprintf(), which returns the number
of written chars. Otherwise non-zero value returns after command
success with -P option. Also set return value from __ino_to_path_fd() to
reflect the final status for default behavior.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 cmds-inspect.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index 2fc50c1a..ac77a5ee 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -211,6 +211,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 		error("path buffer too small: %d bytes", bytes_left);
 		goto out;
 	}
+	ret = 0;
 
 	for (i = 0; i < inodes->elem_cnt; i += 3) {
 		u64 inum = inodes->val[i];
@@ -245,7 +246,8 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 					goto out;
 				}
 			}
-			__ino_to_path_fd(inum, path_fd, verbose, full_path);
+			ret = __ino_to_path_fd(inum, path_fd, verbose,
+						full_path);
 			if (path_fd != fd)
 				close_file_or_dir(path_fd, dirs);
 		} else {
-- 
2.14.4



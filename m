Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:57728 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751389AbdK1JLK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 04:11:10 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 2/3] btrfs-progs: fi defrag: do not exit if defrag range ioctl is unsupported
Date: Tue, 28 Nov 2017 17:14:49 +0800
Message-ID: <20171128091450.21789-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If ioctl of defrag range is unsupported, defrag will exit
immediately.

Since caller can handle the error, let cmd_filesystem_defrag()
break the loop and return error instead of calling exit(1).

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:	Separate the patch from commit 6e991b9161fa ("btrfs-progs: fi
	defrag: clean up duplicate code if find errors").
---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 17d399d58adf..3931333f76c6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1050,7 +1050,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 			ret = nftw(argv[i], defrag_callback, 10,
 						FTW_MOUNT | FTW_PHYS);
 			if (ret == ENOTTY)
-				exit(1);
+				break;
 			/* errors are handled in the callback */
 			ret = 0;
 		} else {
-- 
2.15.0




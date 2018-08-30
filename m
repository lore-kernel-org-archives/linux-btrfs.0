Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56865 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727170AbeH3NC2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 09:02:28 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 934EC4B6ED50
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 17:01:19 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: dump-tree: print invalid argument and strerror
Date: Thu, 30 Aug 2018 17:08:04 +0800
Message-ID: <20180830090804.13264-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch:
$ ls nothingness
ls: cannot access 'nothingness': No such file or directory
$ btrfs inspect-internal dump-tree nothingness
ERROR: not a block device or regular file: nothingness

The confusing error message makes users thinks that nonexistent
file is existed but in wrong type.

This patch let check_arg_type return -errno if realpath failed.
And print strerror if check_arg_type failed and the returned code
is negative. Like:

$ btrfs inspect-internal dump-tree nothingness
ERROR: invalid argument: nothingness: No such file or directory

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-inspect-dump-tree.c | 7 ++++++-
 utils.c                  | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index c8acd55a0c3a..f70a1c47d145 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -313,7 +313,12 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 
 	ret = check_arg_type(argv[optind]);
 	if (ret != BTRFS_ARG_BLKDEV && ret != BTRFS_ARG_REG) {
-		error("not a block device or regular file: %s", argv[optind]);
+		if (ret < 0)
+			error("invalid argument: %s: %s", argv[optind],
+			      strerror(-ret));
+		else
+			error("not a block device or regular file: %s",
+			      argv[optind]);
 		goto out;
 	}
 
diff --git a/utils.c b/utils.c
index 1e275c668cd5..80eca77b1b20 100644
--- a/utils.c
+++ b/utils.c
@@ -502,6 +502,8 @@ int check_arg_type(const char *input)
 			return BTRFS_ARG_REG;
 
 		return BTRFS_ARG_UNKNOWN;
+	} else {
+		return -errno;
 	}
 
 	if (strlen(input) == (BTRFS_UUID_UNPARSED_SIZE - 1) &&
-- 
2.17.1

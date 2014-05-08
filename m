Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63462 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaEHE4x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 00:56:53 -0400
Received: by mail-pd0-f179.google.com with SMTP id g10so1950539pdj.24
        for <linux-btrfs@vger.kernel.org>; Wed, 07 May 2014 21:56:52 -0700 (PDT)
From: Guangliang Zhao <lucienchao@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: lucienchao@gmail.com
Subject: [PATCH] Btrfs: remove OPT_acl parse when acl disabled
Date: Thu,  8 May 2014 12:56:32 +0800
Message-Id: <1399524992-10810-1-git-send-email-lucienchao@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even CONFIG_BTRFS_FS_POSIX_ACL is not defined, the acl still could
been enabled using a mount option, and now fs/btrfs/acl.o is not
built, so the mount options will appear to be supported but will
be silently ignored.

Signed-off-by: Guangliang Zhao <lucienchao@gmail.com>
---
 fs/btrfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 363404b..68ae27c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -579,9 +579,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			}
 			break;
+#ifdef CONFIG_BTRFS_FS_POSIX_ACL
 		case Opt_acl:
 			root->fs_info->sb->s_flags |= MS_POSIXACL;
 			break;
+#endif
 		case Opt_noacl:
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
-- 
1.7.9.5


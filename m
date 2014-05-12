Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55671 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaELDEv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 23:04:51 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so7365358pad.37
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 20:04:51 -0700 (PDT)
From: Guangliang Zhao <lucienchao@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: lucienchao@gmail.com
Subject: [PATCH v2] Btrfs: remove OPT_acl parse when acl disabled
Date: Mon, 12 May 2014 11:04:33 +0800
Message-Id: <1399863873-475-1-git-send-email-lucienchao@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even CONFIG_BTRFS_FS_POSIX_ACL is not defined, the acl still could
been enabled using a mount option, and now fs/btrfs/acl.o is not
built, so the mount options will appear to be supported but will
be silently ignored.

Signed-off-by: Guangliang Zhao <lucienchao@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---

V2: return -EINVAL when ACL didn't complied in 

 fs/btrfs/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 363404b..1046e66 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -580,8 +580,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 			break;
 		case Opt_acl:
+#ifdef CONFIG_BTRFS_FS_POSIX_ACL
 			root->fs_info->sb->s_flags |= MS_POSIXACL;
 			break;
+#else
+			btrfs_err(root->fs_info,
+				"support for ACL not compiled in!");
+			ret = -EINVAL;
+			goto out;
+#endif
 		case Opt_noacl:
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
-- 
1.7.9.5


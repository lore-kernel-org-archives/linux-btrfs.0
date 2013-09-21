Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52392 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3IUCdX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 22:33:23 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4E8BC7C068F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 20:33:23 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id OrRmN1MiWBclWPMr (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 20:33:22 -0600 (MDT)
Date: Fri, 20 Sep 2013 22:33:20 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: create the uuid tree on remount rw
Message-ID: <20130921023320.GD5672@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Users have been complaining of the uuid tree stuff warning that there is no uuid
root when trying to do snapshot operations.  This is because if you mount -o ro
we will not create the uuid tree.  But then if you mount -o rw,remount we will
still not create it and then any subsequent snapshot/subvol operations you try
to do will fail gloriously.  Fix this by creating the uuid_root on remount rw if
it was not already there.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 6ab0df5..05cfd79 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1383,6 +1383,16 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			pr_warn("btrfs: failed to resume dev_replace\n");
 			goto restore;
 		}
+
+		if (!fs_info->uuid_root) {
+			pr_info("btrfs: creating UUID tree\n");
+			ret = btrfs_create_uuid_tree(fs_info);
+			if (ret) {
+				pr_warn("btrfs: failed to create the uuid "
+					"%d\n", ret);
+				goto restore;
+			}
+		}
 		sb->s_flags &= ~MS_RDONLY;
 	}
 out:
-- 
1.8.3.1


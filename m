Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:37743 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964894AbcJ1Blj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 21:41:39 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 4/6] Btrfs: incremental send, skip check overwritten if parents' generation are different
Date: Fri, 28 Oct 2016 09:40:48 +0800
Message-Id: <1477618850-12922-5-git-send-email-robbieko@synology.com>
In-Reply-To: <1477618850-12922-1-git-send-email-robbieko@synology.com>
References: <1477618850-12922-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Example scenario:
Parent snapshot:
|---- d259_old/         (ino 259, gen 96)
    |---- d1/           (ino 258, gen 96)
|---- f                 (ino 257, gen 96)

Send snapshot:
|---- d258/             (ino 258, gen 98)
|---- d259/             (ino 259, gen 98)
    |---- d1/           (ino 257, gen 98)

unlink f
mkdir o257-98-0
mkdir o259-98-0
chown o257-98-0 - uid=0, gid=0
chmod o257-98-0 - mode=0755
rmdir o258-96-0
ERROR: rmdir o258-96-0 failed: No such file or directory

While computing the send stream the following steps happen:

1) While processing inode 257 we create o257-98-0 and o259-98-0,
   then delay o257-98-0 rename operation because its new parent
   in the send snapshot, inode 259, was not yet processed and therefore
   not yet renamed;

2) Later we want to delete d1 (ino 258, gen 96) while processing inode
   258. In order to get its path for delete, we need to check if it is
   overwritten in the send snapshot. And we find it is overwritten so
   we delete it via unique name , which leads to error. The reason is
   we will find out d1 is under parent directory (inode 259) in the send
   snapshot, and for this case, because d1(inode 257, gen 98) is not same
   as d1 (inode 258, gen 96), we conclude d1 has been overwritten.

Fix this by adding generation check for the parent directory. Because
both parent directory are not identical, we can just skip the overwrite
check. In addition, inode 256 should not check for this since it is a
subvolume.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index eaf1c92..139f492 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1938,6 +1938,19 @@ static int did_overwrite_ref(struct send_ctx *sctx,
 	if (ret <= 0)
 		goto out;
 
+	if (dir != BTRFS_FIRST_FREE_OBJECTID) {
+		ret = get_inode_info(sctx->send_root, dir, NULL, &gen, NULL,
+				     NULL, NULL, NULL);
+		if (ret < 0 && ret != -ENOENT)
+			goto out;
+		if (ret) {
+			ret = 0;
+			goto out;
+		}
+		if (gen != dir_gen)
+			goto out;
+	}
+
 	/* check if the ref was overwritten by another ref */
 	ret = lookup_dir_item_inode(sctx->send_root, dir, name, name_len,
 			&ow_inode, &other_type);
-- 
1.9.1


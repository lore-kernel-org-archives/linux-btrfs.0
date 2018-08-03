Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:15665 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbeHCGDG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2018 02:03:06 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 79CB1AC01F4
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 13:08:41 +0900 (JST)
Received: from G01JPEXCHKW15.g01.fujitsu.local (G01JPEXCHKW15.g01.fujitsu.local [10.0.194.54])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id B156C69275E
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Aug 2018 13:08:40 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: qgroup: Remove qgroup item along with subvolume
 deletion
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
Message-ID: <eeaa9ab1-f6a5-9043-9b5e-cc9acf82ca47@jp.fujitsu.com>
Date: Fri, 3 Aug 2018 13:08:21 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1533263845.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When qgroup is on, subvolume deletion does not remove qgroup items
of the subvolume (qgroup info, limits, relation) from quota tree and
they need to get removed manually by "btrfs qgroup destroy".

Since level 0 qgroup cannot be used/inherited by any other subvolume,
let's remove them automatically when subvolume is deleted.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---

I don't see any reason to keep these items after subvolume deletion,
but is there something I'm missing?

 fs/btrfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3f51ddc18f98..4ec60a1b53a3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4372,6 +4372,10 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		}
 	}
 
+	ret = btrfs_remove_qgroup(trans, dest->root_key.objectid);
+	if (ret == -EINVAL || ret == -ENOENT)
+		ret = 0;
+
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
-- 
2.14.4



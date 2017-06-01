Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20770 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751093AbdFAIzZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 04:55:25 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 8/9] btrfs: Check namelen before in 'btrfs_del_root_ref'
Date: Thu, 1 Jun 2017 16:57:15 +0800
Message-ID: <20170601085716.25898-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Call btrfs_is_namelen_valid before memcmp.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/root-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 7d6bc308bf43..7a5450600723 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -390,6 +390,13 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		WARN_ON(btrfs_root_ref_dirid(leaf, ref) != dirid);
 		WARN_ON(btrfs_root_ref_name_len(leaf, ref) != name_len);
 		ptr = (unsigned long)(ref + 1);
+		ret = btrfs_is_namelen_valid(leaf, path->slots[0], ptr,
+					     name_len);
+		if (!ret) {
+			err = -EIO;
+			goto out;
+		}
+
 		WARN_ON(memcmp_extent_buffer(leaf, name, ptr, name_len));
 		*sequence = btrfs_root_ref_sequence(leaf, ref);
 
-- 
2.13.0




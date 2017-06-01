Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20770 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751090AbdFAIzc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Jun 2017 04:55:32 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2 7/9] btrfs: Check namelen before read in 'btrfs_get_name'
Date: Thu, 1 Jun 2017 16:57:14 +0800
Message-ID: <20170601085716.25898-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Call 'btrfs_is_namelen_valid' in 'btrfs_get_name'.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/export.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 87144c9f9593..213e971e8dcf 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -282,6 +282,11 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 		name_len = btrfs_inode_ref_name_len(leaf, iref);
 	}
 
+	ret = btrfs_is_namelen_valid(leaf, path->slots[0], name_ptr, name_len);
+	if (!ret) {
+		btrfs_free_path(path);
+		return -EIO;
+	}
 	read_extent_buffer(leaf, name, name_ptr, name_len);
 	btrfs_free_path(path);
 
-- 
2.13.0




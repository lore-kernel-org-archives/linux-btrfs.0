Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36725 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751681AbdEKVRf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 17:17:35 -0400
Received: by mail-it0-f48.google.com with SMTP id o5so597309ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 14:17:35 -0700 (PDT)
Date: Thu, 11 May 2017 21:17:33 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH v2 1/2] btrfs: add quota override flag to enable quota
 override for sys_resource
Message-ID: <20170511211731.GA8413@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170511211658.GA8401@ircssh-2.c.rugged-nimbus-611.internal>

This patch introduces the quota override flag to btrfs_fs_info, and
a change to quota limit checking code to temporarily allow for quota
to be overridden for processes with cap_sys_resource.

It's useful for administrative programs, such as log rotation,
that may need to temporarily use more disk space in order to free up
a greater amount of overall disk space without yielding more disk
space to the rest of userland.

Eventually, we may want to add the idea of an operator-specific
quota, operator reserved space, or something else to allow for
administrative override, but this is perhaps the simplest
solution.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ctree.h  | 2 ++
 fs/btrfs/qgroup.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 643c70d..e86cb7c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -716,6 +716,8 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_BTREE_ERR			11
 #define BTRFS_FS_LOG1_ERR			12
 #define BTRFS_FS_LOG2_ERR			13
+#define BTRFS_FS_QUOTA_OVERRIDE			14
+
 /*
  * Indicate that a whole-filesystem exclusive operation is running
  * (device replace, resize, device add/delete, balance)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index deffbeb..458fec0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2338,6 +2338,11 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 
 	if (num_bytes == 0)
 		return 0;
+
+	if (test_bit(BTRFS_FS_QUOTA_OVERRIDE, &fs_info->flags) &&
+	    capable(CAP_SYS_RESOURCE))
+		enforce = false;
+
 retry:
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
-- 
2.9.3


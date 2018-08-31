Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55758 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeHaGfB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 02:35:01 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0A57B05B
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 02:29:51 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: Set qgroup inherit size limit to SZ_4K instead of page size
Date: Fri, 31 Aug 2018 10:29:28 +0800
Message-Id: <20180831022930.3465-2-wqu@suse.com>
In-Reply-To: <20180831022930.3465-1-wqu@suse.com>
References: <20180831022930.3465-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Change btrfs_qgroup_inherit maximum size from PAGE_SIZE to SZ_4K to make
it consistent across different architectures.

Although in theory this could lead to incompatibility, but considering
how rare btrfs_qgroup_inherit is used, it's still not too late to change
it without impacting a large user base.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c           | 2 +-
 include/uapi/linux/btrfs.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63600dc2ac4c..5db8680b40a9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1811,7 +1811,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 	if (vol_args->flags & BTRFS_SUBVOL_RDONLY)
 		readonly = true;
 	if (vol_args->flags & BTRFS_SUBVOL_QGROUP_INHERIT) {
-		if (vol_args->size > PAGE_SIZE) {
+		if (vol_args->size > BTRFS_QGROUP_INHERIT_MAX_SIZE) {
 			ret = -EINVAL;
 			goto free_args;
 		}
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..311edb65567c 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -82,6 +82,7 @@ struct btrfs_qgroup_limit {
  */
 #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
 
+#define BTRFS_QGROUP_INHERIT_MAX_SIZE	(SZ_4K)
 struct btrfs_qgroup_inherit {
 	__u64	flags;
 	__u64	num_qgroups;
-- 
2.18.0

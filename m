Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:32784 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdFFXpr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 19:45:47 -0400
Received: by mail-pf0-f177.google.com with SMTP id 83so45354848pfr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 16:45:47 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        kernel-team@fb.com
Subject: [PATCH 7/7] Btrfs: warn if total_bytes_pinned is non-zero on unmount
Date: Tue,  6 Jun 2017 16:45:32 -0700
Message-Id: <0a015ca3c5d799b501b9c23475ed9e96d16de671.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
References: <cover.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Catch any future/remaining leaks or underflows of total_bytes_pinned.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75ad24f8d253..5fb2fb27eda6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9860,6 +9860,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 			    space_info->bytes_reserved > 0 ||
 			    space_info->bytes_may_use > 0))
 			dump_space_info(info, space_info, 0, 0);
+		WARN_ON(percpu_counter_sum(&space_info->total_bytes_pinned) != 0);
 		list_del(&space_info->list);
 		for (i = 0; i < BTRFS_NR_RAID_TYPES; i++) {
 			struct kobject *kobj;
-- 
2.13.0


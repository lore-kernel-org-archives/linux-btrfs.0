Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60047 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423514AbcKANV3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 09:21:29 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, stable@vger.kernel.org, #@suse.cz,
        4.4+@suse.cz
Subject: [PATCH] btrfs: store and load values of stripes_min/stripes_max in balance status item
Date: Tue,  1 Nov 2016 14:21:23 +0100
Message-Id: <20161101132123.11673-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The balance status item contains currently known filter values, but the
stripes filter was unintentionally not among them. This would mean, that
interrupted and automatically restarted balance does not apply the
stripe filters.

Fixes: dee32d0ac3719ef8d640efaf0884111df444730f
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9d8edcb0813c..223c706aea1f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2210,6 +2210,8 @@ btrfs_disk_balance_args_to_cpu(struct btrfs_balance_args *cpu,
 	cpu->target = le64_to_cpu(disk->target);
 	cpu->flags = le64_to_cpu(disk->flags);
 	cpu->limit = le64_to_cpu(disk->limit);
+	cpu->stripes_min = le32_to_cpu(disk->stripes_min);
+	cpu->stripes_max = le32_to_cpu(disk->stripes_max);
 }
 
 static inline void
@@ -2228,6 +2230,8 @@ btrfs_cpu_balance_args_to_disk(struct btrfs_disk_balance_args *disk,
 	disk->target = cpu_to_le64(cpu->target);
 	disk->flags = cpu_to_le64(cpu->flags);
 	disk->limit = cpu_to_le64(cpu->limit);
+	disk->stripes_min = cpu_to_le32(cpu->stripes_min);
+	disk->stripes_max = cpu_to_le32(cpu->stripes_max);
 }
 
 /* struct btrfs_super_block */
-- 
2.10.1


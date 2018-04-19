Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:38003 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbeDSJi1 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Apr 2018 05:38:27 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: Add incompat flags check for btrfs_check_super_valid()
Date: Thu, 19 Apr 2018 17:38:14 +0800
Message-Id: <20180419093816.888-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we have already checked incompat flags manually before really
mounting it, we could still enhance btrfs_check_super_valid() to check
incompat flags for later write time super block validation check.

This patch adds such incompat flags check for btrfs_check_super_valid(),
currently it won't be triggered, but provides the basis for later write
time check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 60caa68c3618..ec123158f051 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4104,6 +4104,19 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		ret = -EINVAL;
 	}
 
+	/*
+	 * Before calling btrfs_check_super_valid() we have already checked
+	 * incompat flags. So if we developr new incompat flags, it's must be
+	 * some corruption.
+	 */
+	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
+		btrfs_err(fs_info,
+		"corrupted incompat flags detected 0x%llx, supported 0x%llx",
+			  btrfs_super_incompat_flags(sb),
+			  BTRFS_FEATURE_INCOMPAT_SUPP);
+		ret = -EINVAL;
+	}
+
 	/*
 	 * The generation is a global counter, we'll trust it more than the others
 	 * but it's still possible that it's the one that's wrong.
-- 
2.17.0


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58926 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755809AbeDXEsU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Apr 2018 00:48:20 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs: Add incompat flags check for btrfs_check_super_valid()
Date: Tue, 24 Apr 2018 12:48:07 +0800
Message-Id: <20180424044809.29838-3-wqu@suse.com>
In-Reply-To: <20180424044809.29838-1-wqu@suse.com>
References: <20180424044809.29838-1-wqu@suse.com>
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
index 23b5c90cdbb2..3968f7ff8de2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4104,6 +4104,19 @@ static int btrfs_validate_super(struct btrfs_fs_info *fs_info)
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


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33586 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755812AbeDXEsU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Apr 2018 00:48:20 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] btrfs: Add csum type check for btrfs_check_super_valid()
Date: Tue, 24 Apr 2018 12:48:08 +0800
Message-Id: <20180424044809.29838-4-wqu@suse.com>
In-Reply-To: <20180424044809.29838-1-wqu@suse.com>
References: <20180424044809.29838-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like incompat flags check, although we have already done super csum
type check before calling btrfs_check_super_valid(), we can still add
such check for later write time check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3968f7ff8de2..9282a6ac91db 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3985,6 +3985,15 @@ static int btrfs_validate_super(struct btrfs_fs_info *fs_info)
 		btrfs_err(fs_info, "no valid FS found");
 		ret = -EINVAL;
 	}
+	/*
+	 * For write time check, as for mount time we have checked csum before
+	 * calling btrfs_check_super_valid(), so it must be a corruption
+	 */
+	if (btrfs_super_csum_type(sb) >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		btrfs_err(fs_info, "corrupted csum type %u",
+			  btrfs_super_csum_type(sb));
+		ret = -EINVAL;
+	}
 	if (btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP) {
 		btrfs_err(fs_info, "unrecognized or unsupported super flag: %llu",
 				btrfs_super_flags(sb) & ~BTRFS_SUPER_FLAG_SUPP);
-- 
2.17.0


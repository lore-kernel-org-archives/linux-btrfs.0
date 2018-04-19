Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50918 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbeDSLC2 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Apr 2018 07:02:28 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: Add csum type check for btrfs_check_super_valid()
Date: Thu, 19 Apr 2018 19:02:11 +0800
Message-Id: <20180419110212.11196-2-wqu@suse.com>
In-Reply-To: <20180419110212.11196-1-wqu@suse.com>
References: <20180419110212.11196-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like incompat flags check, although we have already done super csum
type check before calling btrfs_check_super_valid(), we can still add
such check for later write time check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  Move csum_type check after magic check.
---
 fs/btrfs/disk-io.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ec123158f051..23d70c3fdc22 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3985,6 +3985,15 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
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


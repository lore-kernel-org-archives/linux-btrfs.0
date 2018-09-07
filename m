Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34258 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbeIGPIP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:08:15 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05BE4AE2D
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 10:27:57 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: qgroup: Prepare to deprecate some btrfs_qgroup_inherit features
Date: Fri,  7 Sep 2018 18:27:45 +0800
Message-Id: <20180907102745.10387-4-wqu@suse.com>
In-Reply-To: <20180907102745.10387-1-wqu@suse.com>
References: <20180907102745.10387-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Prepare to deprecate the following btrfs_qgroup_inherit features:

1) Flags
   There is only one flag supported, BTRFS_QGROUP_INHERIT_SET_LIMITS,
   however it's never used by btrfs-progs.

2) num_excl|ref_copies
   These two features are going to copy excl/rfer numbers from one
   qgroup to another.
   There is no easier way to screw up qgroup numbers like this.

3) btrfs_qgroup_inherit::lim
   It's used along with BTRFS_QGROUP_INHERIT_SET_LIMITS, never supported
   by btrfs-progs either.

Just output warnings for such features for now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 75e1dccf8ed3..aecd3cfc7c78 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2248,6 +2248,9 @@ int btrfs_validate_inherit(struct btrfs_fs_info *fs_info,
 
 	if (inherit->flags & ~BTRFS_QGROUP_INHERIT_FLAGS_SUPP)
 		return -ENOTTY;
+	if (inherit->flags & BTRFS_QGROUP_INHERIT_SET_LIMITS)
+		btrfs_warn(fs_info,
+"btrfs_qgroup_inherit::flags BTRFS_QGROUP_INHERIT_SET_LIMITS will be deprecated");
 
 	/* Size check */
 	if (sizeof(u64) * inherit->num_qgroups +
@@ -2256,12 +2259,20 @@ int btrfs_validate_inherit(struct btrfs_fs_info *fs_info,
 	    sizeof(*inherit) >
 	    min_t(u64, BTRFS_QGROUP_INHERIT_MAX_SIZE, inherit_size))
 		return -EINVAL;
+	if (inherit->num_excl_copies || inherit->num_ref_copies)
+		btrfs_warn(fs_info,
+	"btrfs_qgroup_inherit::num_excl/ref_copies will be deprecated");
 
 	/* Qgroup 0/0 is not allowed */
 	for (i = 0; i < inherit->num_qgroups; i++) {
 		if (inherit->qgroups[i] == 0)
 			return -EINVAL;
 	}
+	if (inherit->lim.max_rfer || inherit->lim.max_excl ||
+	    inherit->lim.rsv_rfer || inherit->lim.rsv_excl ||
+	    inherit->lim.flags)
+		btrfs_warn(fs_info,
+			"btrfs_qgroup_inherit::lim will be deprecated");
 	return 0;
 }
 
-- 
2.18.0

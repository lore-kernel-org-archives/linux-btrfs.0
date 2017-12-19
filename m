Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43956 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761989AbdLSKp3 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 19 Dec 2017 05:45:29 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually inherit rfer/excl numbers
Date: Tue, 19 Dec 2017 18:45:11 +0800
Message-Id: <20171219104511.3563-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_qgroup_inherit structure has two members, num_ref_copies and
num_excl_copies, to info btrfs kernel modules to inherit (copy)
rfer/excl numbers at snapshot/subvolume creation time.

Since qgroup number is already hard to maintain for multi-level qgroup
scenario, allowing user to manually manipulate qgroup inherit is quite
easy to screw up qgroup numbers.

Although btrfs-progs supports such inheritance specification, the
options are hidden from user and not documented.
So there is no need to allow user to manually specify inheritance in
kernel.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
The only concern is, currently we don't have good tool to handle
inheritance of multi-level qgroups.
The only method to get qgroup numbers correct is to run a quota rescan.

So there may be some case where experienced (well, mostly a developer)
user can use the hidden btrfs-progs options or manually craft an ioctl
to handle multi-level qgroups without costly rescan.
---
 fs/btrfs/qgroup.c          | 56 ++++++++++++++--------------------------------
 include/uapi/linux/btrfs.h |  4 ++--
 2 files changed, 19 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 168fd03ca3ac..d8a2413272f9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2158,9 +2158,24 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	}
 
 	if (inherit) {
+		/*
+		 * num_excl/rfer_copies indicate how many qgroup pairs needs
+		 * to be manually inherited (copy rfer or excl from src
+		 * qgroup to dst)
+		 *
+		 * Allowing user to manipulate inheritance can easily cause
+		 * problem in multi-level qgroup scenario.
+		 * And the ioctl interface is hidden in btrfs-progs for a long
+		 * time, deprecate them should not be a big problem.
+		 */
+		if (inherit->__num_excl_copies || inherit->__num_ref_copies) {
+			ret = -ENOTTY;
+			btrfs_warn(fs_info,
+			"manually inherit excl/rfer is no longer supported");
+			goto out;
+		}
 		i_qgroups = (u64 *)(inherit + 1);
-		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
-		       2 * inherit->num_excl_copies;
+		nums = inherit->num_qgroups;
 		for (i = 0; i < nums; ++i) {
 			srcgroup = find_qgroup_rb(fs_info, *i_qgroups);
 
@@ -2286,43 +2301,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		++i_qgroups;
 	}
 
-	for (i = 0; i <  inherit->num_ref_copies; ++i, i_qgroups += 2) {
-		struct btrfs_qgroup *src;
-		struct btrfs_qgroup *dst;
-
-		if (!i_qgroups[0] || !i_qgroups[1])
-			continue;
-
-		src = find_qgroup_rb(fs_info, i_qgroups[0]);
-		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
-
-		if (!src || !dst) {
-			ret = -EINVAL;
-			goto unlock;
-		}
-
-		dst->rfer = src->rfer - level_size;
-		dst->rfer_cmpr = src->rfer_cmpr - level_size;
-	}
-	for (i = 0; i <  inherit->num_excl_copies; ++i, i_qgroups += 2) {
-		struct btrfs_qgroup *src;
-		struct btrfs_qgroup *dst;
-
-		if (!i_qgroups[0] || !i_qgroups[1])
-			continue;
-
-		src = find_qgroup_rb(fs_info, i_qgroups[0]);
-		dst = find_qgroup_rb(fs_info, i_qgroups[1]);
-
-		if (!src || !dst) {
-			ret = -EINVAL;
-			goto unlock;
-		}
-
-		dst->excl = src->excl + level_size;
-		dst->excl_cmpr = src->excl_cmpr + level_size;
-	}
-
 unlock:
 	spin_unlock(&fs_info->qgroup_lock);
 out:
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index ce615b75e855..099e088414d6 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -80,8 +80,8 @@ struct btrfs_qgroup_limit {
 struct btrfs_qgroup_inherit {
 	__u64	flags;
 	__u64	num_qgroups;
-	__u64	num_ref_copies;
-	__u64	num_excl_copies;
+	__u64	__num_ref_copies;	/* DEPRECATED */
+	__u64	__num_excl_copies;	/* DEPRECATED */
 	struct btrfs_qgroup_limit lim;
 	__u64	qgroups[0];
 };
-- 
2.15.1


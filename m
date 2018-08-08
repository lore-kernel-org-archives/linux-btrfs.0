Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39370 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbeHHIWT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Aug 2018 04:22:19 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 918CFAF5B
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Aug 2018 06:04:12 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: qgroup: Don't populating excl numbers for snapshot src if it belongs to other qgroups
Date: Wed,  8 Aug 2018 14:04:09 +0800
Message-Id: <20180808060409.20048-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When quota is enabled and we do a snapshot, we just update the 'excl'
number of both snapshot src and dst to src's 'rfer' - nodesize.

It's a quick hack to avoid quota rescan every time we create a snapshot
and it works if src doesn't belong to other qgroups.

But if we have higher level qgroups, such behavior only works for level
0 qgroups, and higher level qgroups don't get update, thus making qgroup
number inconsistent.

The problem of updating higher level qgroup numbers is, it's way to
complex.

Under the following case, it's pretty simple: (src is 257, dst is 258)
0/257 - 1/0, 0/258.

In this case, we only need to modify 1/0 to reduce its 'excl'

But under the following case, it will go out of control:

0/257 - 1/0, 0/258 - 1/1 (using -i option), 1/0 - 2/0, 1/1 - 2/0.

So to make it simple, if snapshot src has higher level qgroups, just
mark qgroup inconsistent and let later rescan to do its job.

Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ec4351fd7537..2b3d2dd1b735 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2298,6 +2298,22 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		if (!srcgroup)
 			goto unlock;
 
+		/*
+		 * If snapshot source is belonging to high level qgroups, it
+		 * will be a more complex to hack the numbers.
+		 * E.g. source is 257, snapshot is 258:
+		 * 0/257 - 1/0, creating snapshot 258 will need to update 1/0
+		 * It's too complex when higher level qgroup is involved.
+		 * Mark qgroup inconsistent for later rescan
+		 */
+		if (!list_empty(&srcgroup->groups)) {
+			btrfs_info_rl(fs_info,
+"src qgroup 0/%llu belongs to higher level qgroup, creating snapshot for it need qgroup rescan",
+				      srcid);
+			fs_info->qgroup_flags |=
+				BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+			goto unlock;
+		}
 		/*
 		 * We call inherit after we clone the root in order to make sure
 		 * our counts don't go crazy, so at this point the only
-- 
2.18.0


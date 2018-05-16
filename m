Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751227AbeEPVjF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 17:39:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB457ADA7
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 21:39:03 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 18/18] btrfs-progs: qgroups: don't print dead qgroups
Date: Wed, 16 May 2018 17:38:51 -0400
Message-Id: <20180516213851.10196-19-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20180516213851.10196-1-jeffm@suse.com>

From: Jeff Mahoney <jeffm@suse.com>

When qgroup items get left behind, we still print them in
'btrfs qgroup show' even though there is nothing to show.  Since we
now look up the pathname and that means we look up the subvolume,
we can filter out first-level qgroups that correspond to roots
that have been removed.  Specifying -v will still show them.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 qgroup.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/qgroup.c b/qgroup.c
index 647bc2f3..08e78887 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -313,6 +313,13 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 	}
 }
 
+static bool qgroup_target_exists(const struct btrfs_qgroup *qgroup)
+{
+	if (btrfs_qgroup_level(qgroup->qgroupid) > 0)
+		return true;
+	return qgroup->pathname != NULL;
+}
+
 static void print_single_qgroup_table(struct btrfs_qgroup *qgroup, bool verbose)
 {
 	int i;
@@ -1369,7 +1376,8 @@ static void print_all_qgroups(struct qgroup_lookup *qgroup_lookup, bool verbose)
 	n = rb_first(&qgroup_lookup->root);
 	while (n) {
 		entry = rb_entry(n, struct btrfs_qgroup, sort_node);
-		print_single_qgroup_table(entry, verbose);
+		if (qgroup_target_exists(entry) || verbose)
+			print_single_qgroup_table(entry, verbose);
 		n = rb_next(n);
 	}
 }
-- 
2.15.1


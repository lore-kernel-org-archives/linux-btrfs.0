Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48589 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756639AbdKGInJ (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 03:43:09 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 02/12] btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we should repair qgroups
Date: Tue,  7 Nov 2017 16:42:47 +0800
Message-Id: <20171107084259.22367-4-wqu@suse.com>
In-Reply-To: <20171107084259.22367-1-wqu@suse.com>
References: <20171107084259.22367-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In fact qgroup-verify is just kind of offline qgroup rescan, and later
mkfs qgroup support will reuse it.

So qgroup-verify doesn't really need to rely the global variable @repair
to check if it should repair qgroups.

Instead check fs_info->readonly to do the repair.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 qgroup-verify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qgroup-verify.c b/qgroup-verify.c
index 58c735788977..f509cdb9317a 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1582,7 +1582,7 @@ int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
 
 	*repaired = 0;
 
-	if (!repair)
+	if (info->readonly)
 		return 0;
 
 	list_for_each_entry_safe(count, tmpcount, &bad_qgroups, bad_list) {
-- 
2.15.0


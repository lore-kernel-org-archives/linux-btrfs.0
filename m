Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeEHGcE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:32:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 40C12AF4B
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 06:32:03 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 02/12] btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we should repair qgroups
Date: Tue,  8 May 2018 14:31:46 +0800
Message-Id: <20180508063156.24665-3-wqu@suse.com>
In-Reply-To: <20180508063156.24665-1-wqu@suse.com>
References: <20180508063156.24665-1-wqu@suse.com>
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
2.17.0


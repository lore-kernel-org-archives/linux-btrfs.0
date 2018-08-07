Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53648 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbeHGKc7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 06:32:59 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CB57DADB9
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Aug 2018 08:19:46 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/11] btrfs-progs: qgroup-verify: Use fs_info->readonly to check if we should repair qgroups
Date: Tue,  7 Aug 2018 16:19:30 +0800
Message-Id: <20180807081938.21348-4-wqu@suse.com>
In-Reply-To: <20180807081938.21348-1-wqu@suse.com>
References: <20180807081938.21348-1-wqu@suse.com>
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
index 4b8bfa69914d..eb42e199bcf9 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -1617,7 +1617,7 @@ int repair_qgroups(struct btrfs_fs_info *info, int *repaired)
 
 	*repaired = 0;
 
-	if (!repair)
+	if (info->readonly)
 		return 0;
 
 	list_for_each_entry_safe(count, tmpcount, &bad_qgroups, bad_list) {
-- 
2.18.0


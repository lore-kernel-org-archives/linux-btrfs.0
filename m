Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32924 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbbIAOgj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 10:36:39 -0400
Received: by paczk9 with SMTP id zk9so31260842pac.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Sep 2015 07:36:39 -0700 (PDT)
Received: from arch-nb.localdomain ([175.118.89.137])
        by smtp.gmail.com with ESMTPSA id hb1sm18387507pbd.36.2015.09.01.07.36.36
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 01 Sep 2015 07:36:38 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove unnecessary list_del
Date: Tue,  1 Sep 2015 23:36:28 +0900
Message-Id: <1441118188-63111-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can safely iterate whole list items, without using list_del macro.
So remove the list_del call.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 fs/btrfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bda3c41dc9d5..fe42e339efec 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2595,7 +2595,6 @@ static void free_sa_defrag_extent(struct new_sa_defrag_extent *new)
 		return;
 
 	list_for_each_entry_safe(old, tmp, &new->head, list) {
-		list_del(&old->list);
 		kfree(old);
 	}
 	kfree(new);
-- 
2.5.1


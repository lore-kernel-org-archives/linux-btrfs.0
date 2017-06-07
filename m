Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33974 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdFGBAH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:07 -0400
Received: by mail-wr0-f195.google.com with SMTP id u101so9096111wrc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:06 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 4/7] Btrfs: ref_tree_add remove useless compare
Date: Wed,  7 Jun 2017 03:58:41 +0300
Message-Id: <20170607005844.2078-5-nefelim4ag@gmail.com>
In-Reply-To: <20170607005844.2078-1-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As code already know that (node->ref_mod > 0)
else if (node->ref_mod <= 0) - useless
So just leave 'else'

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 2e4709e0c..897d664a9 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -294,7 +294,7 @@ static int ref_tree_add(struct ref_root *ref_tree, u64 root_id, u64 object_id,
 
 	if (node->ref_mod > 0)
 		ref_tree->unique_refs += origin_count > 0 ? 0 : 1;
-	else if (node->ref_mod <= 0)
+	else
 		ref_tree->unique_refs += origin_count > 0 ? -1 : 0;
 
 	if (!node->ref_mod)
-- 
2.13.0


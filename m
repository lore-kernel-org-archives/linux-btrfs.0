Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36421 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdFMU4X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 16:56:23 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so3397856wrb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Jun 2017 13:56:22 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 1/2] Btrfs: ref_tree_add remove useless compare
Date: Tue, 13 Jun 2017 23:56:07 +0300
Message-Id: <20170613205608.28483-2-nefelim4ag@gmail.com>
In-Reply-To: <20170613205608.28483-1-nefelim4ag@gmail.com>
References: <20170613205608.28483-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove useless compare to make it more readable

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 24865da63..0005b8851 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -290,7 +290,7 @@ static int ref_tree_add(struct ref_root *ref_tree, u64 root_id, u64 object_id,

 	if (node->ref_mod > 0)
 		ref_tree->unique_refs += origin_count > 0 ? 0 : 1;
-	else if (node->ref_mod <= 0)
+	else
 		ref_tree->unique_refs += origin_count > 0 ? -1 : 0;

 	if (!node->ref_mod)
--
2.13.1

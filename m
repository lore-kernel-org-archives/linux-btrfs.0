Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33310 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbdFGBAH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 21:00:07 -0400
Received: by mail-wr0-f193.google.com with SMTP id v104so11594188wrb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 18:00:07 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 5/7] Btrfs: add_all_parents skip compare
Date: Wed,  7 Jun 2017 03:58:42 +0300
Message-Id: <20170607005844.2078-6-nefelim4ag@gmail.com>
In-Reply-To: <20170607005844.2078-1-nefelim4ag@gmail.com>
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

By comparison logic if ret => 0 -> ret=0;
So lets cleanup compare logic

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/backref.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 897d664a9..f53045891 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -592,10 +592,10 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			ret = btrfs_next_old_item(root, path, time_seq);
 	}
 
-	if (ret > 0)
-		ret = 0;
-	else if (ret < 0)
+	if (ret < 0)
 		free_inode_elem_list(eie);
+	else
+		ret = 0;
 	return ret;
 }
 
-- 
2.13.0


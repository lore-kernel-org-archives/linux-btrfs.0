Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36442 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdFMU4Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 16:56:24 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so3398046wrb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Jun 2017 13:56:23 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v2 2/2] Btrfs: add_all_parents skip compare
Date: Tue, 13 Jun 2017 23:56:08 +0300
Message-Id: <20170613205608.28483-3-nefelim4ag@gmail.com>
In-Reply-To: <20170613205608.28483-1-nefelim4ag@gmail.com>
References: <20170613205608.28483-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simplify code to make it more readable

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/backref.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0005b8851..2081a8de7 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -588,10 +588,10 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
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
2.13.1

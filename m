Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:34958 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755670AbdETIjj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 04:39:39 -0400
Received: by mail-it0-f47.google.com with SMTP id c15so130146297ith.0
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 01:39:39 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id u200sm5187522itb.29.2017.05.20.01.39.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 May 2017 01:39:38 -0700 (PDT)
Date: Sat, 20 May 2017 08:39:37 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/8] btrfs: qgroup.h whitespace change
Message-ID: <20170520083935.GA4235@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170520083826.GA4176@ircssh-2.c.rugged-nimbus-611.internal>

This patch is just changing whitespace alignment in qgroup.h

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/qgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index fe04d3f..fb6c7da 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -127,7 +127,7 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info, u64 qgroupid);
+			struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 qgroupid,
 		       struct btrfs_qgroup_limit *limit);
-- 
2.9.3


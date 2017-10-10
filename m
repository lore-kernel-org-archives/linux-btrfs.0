Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:37818 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756376AbdJJPyw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 11:54:52 -0400
From: Tejun Heo <tj@kernel.org>
To: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] blkcg: export blkcg_root_css
Date: Tue, 10 Oct 2017 08:54:37 -0700
Message-Id: <20171010155441.753966-2-tj@kernel.org>
In-Reply-To: <20171010155441.753966-1-tj@kernel.org>
References: <20171010155441.753966-1-tj@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Export blkcg_root_css so that filesystem modules can use it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d3f56ba..597a457 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -45,6 +45,7 @@ struct blkcg blkcg_root;
 EXPORT_SYMBOL_GPL(blkcg_root);
 
 struct cgroup_subsys_state * const blkcg_root_css = &blkcg_root.css;
+EXPORT_SYMBOL_GPL(blkcg_root_css);
 
 static struct blkcg_policy *blkcg_policy[BLKCG_MAX_POLS];
 
-- 
2.9.5


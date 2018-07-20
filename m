Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731251AbeGTPTD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 11:19:03 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03402AD96
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 14:30:30 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: constify strings passed to assertion helper
Date: Fri, 20 Jul 2018 16:30:23 +0200
Message-Id: <ff07cf8ec77e23447ee61a4203f05aedcb3c8057.1532096607.git.dsterba@suse.com>
In-Reply-To: <cover.1532096607.git.dsterba@suse.com>
References: <cover.1532096607.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5f6ec80d374f..2e32584c635f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3425,7 +3425,7 @@ do {								\
 #ifdef CONFIG_BTRFS_ASSERT
 
 __cold
-static inline void assfail(char *expr, char *file, int line)
+static inline void assfail(const char *expr, const char *file, int line)
 {
 	pr_err("assertion failed: %s, file: %s, line: %d\n",
 	       expr, file, line);
-- 
2.18.0


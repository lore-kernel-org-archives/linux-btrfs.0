Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965616AbeFOLGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:06:12 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/6] btrfs-progs: Add freespace tree as compat_ro supported feature
Date: Fri, 15 Jun 2018 14:06:00 +0300
Message-Id: <1529060762-4372-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1529060762-4372-1-git-send-email-nborisov@suse.com>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The RO_FREE_SPACE_TREE(_VALID) flags are required in order to be able
to open an FST filesystem in repair mode. Add them to
BTRFS_FEATURE_COMPAT_RO_SUPP.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 ctree.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index ade883fecbd6..ef05e8122982 100644
--- a/ctree.h
+++ b/ctree.h
@@ -497,7 +497,9 @@ struct btrfs_super_block {
  * added here until read-write support for the free space tree is implemented in
  * btrfs-progs.
  */
-#define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
+	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
+	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID)
 
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF |		\
-- 
2.7.4


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbcDAUOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 16:14:39 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 81035AC31
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 20:14:37 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/8] btrfs: uapi/linux/btrfs.h migration, move BTRFS_LABEL_SIZE
Date: Fri,  1 Apr 2016 16:14:23 -0400
Message-Id: <1459541670-4097-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_LABEL_SIZE is required to define the BTRFS_IOC_GET_FSLABEL and
BTRFS_IOC_SET_FSLABEL ioctls.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h           | 1 -
 include/uapi/linux/btrfs.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84a6a5b..3beaa24 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -410,7 +410,6 @@ struct btrfs_header {
  * room to translate 14 chunks with 3 stripes each.
  */
 #define BTRFS_SYSTEM_CHUNK_ARRAY_SIZE 2048
-#define BTRFS_LABEL_SIZE 256
 
 /*
  * just in case we somehow lose the roots and are not able to mount,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index dea8931..11eee34 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -23,6 +23,7 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
+#define BTRFS_LABEL_SIZE 256
 
 /* this should be 4k */
 #define BTRFS_PATH_NAME_MAX 4087
-- 
2.7.1


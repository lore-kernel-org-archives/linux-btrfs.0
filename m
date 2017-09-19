Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37187 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbdISPB1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:01:27 -0400
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: make array types static const, reduces object code size
Date: Tue, 19 Sep 2017 16:01:23 +0100
Message-Id: <20170919150123.23913-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the read-only array types on the stack, instead make
it static const.  Makes the object code smaller by nearly 60 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  90536	   6552	     64	  97152	  17b80	fs/btrfs/ioctl.o

After:
   text	   data	    bss	    dec	    hex	filename
  90414	   6616	     64	  97094	  17b46	fs/btrfs/ioctl.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/ioctl.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a74ed6c12d6a..feab6f61cb97 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4114,10 +4114,12 @@ static long btrfs_ioctl_space_info(struct btrfs_fs_info *fs_info,
 	struct btrfs_ioctl_space_info *dest_orig;
 	struct btrfs_ioctl_space_info __user *user_dest;
 	struct btrfs_space_info *info;
-	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
-		       BTRFS_BLOCK_GROUP_SYSTEM,
-		       BTRFS_BLOCK_GROUP_METADATA,
-		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA};
+	static const u64 types[] = {
+		BTRFS_BLOCK_GROUP_DATA,
+		BTRFS_BLOCK_GROUP_SYSTEM,
+		BTRFS_BLOCK_GROUP_METADATA,
+		BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA
+	};
 	int num_types = 4;
 	int alloc_size;
 	int ret = 0;
-- 
2.14.1


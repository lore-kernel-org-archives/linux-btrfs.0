Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723AbcBKQze (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:55:34 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BB10AAB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:55:32 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: change max_inline default to 2048
Date: Thu, 11 Feb 2016 17:55:30 +0100
Message-Id: <1455209730-22811-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The current practical default is ~4k on x86_64 (the logic is more complex,
simplified for brevity), the inlined files land in the metadata group and
thus consume space that could be needed for the real metadata.

The inlining brings some usability surprises:

1) total space consumption measured on various filesystems and btrfs
   with DUP metadata was quite visible because of the duplicated data
   within metadata

2) inlined data may exhaust the metadata, which are more precious in case
   the entire device space is allocated to chunks (ie. balance cannot
   make the space more compact)

3) performance suffers a bit as the inlined blocks are duplicate and
   stored far away on the device.

Proposed fix: set the default to 2048

This fixes namely 1), the total filesysystem space consumption will be on
par with other filesystems.

Partially fixes 2), more data are pushed to the data block groups.

The characteristics of 3) are based on actual small file size
distribution.

The change is independent of the metadata blockgroup type (though it's
most visible with DUP) or system page size as these parameters are not
trival to find out, compared to file size.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bfe4a337fb4d..6661ad8b4088 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2252,7 +2252,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_FREE_SPACE_TREE	(1 << 26)
 
 #define BTRFS_DEFAULT_COMMIT_INTERVAL	(30)
-#define BTRFS_DEFAULT_MAX_INLINE	(8192)
+#define BTRFS_DEFAULT_MAX_INLINE	(2048)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
-- 
2.7.1


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35656 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdHAK2V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 06:28:21 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: copy fsid to super_block s_uuid
Date: Tue,  1 Aug 2017 18:35:08 +0800
Message-Id: <20170801103508.19746-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We didn't copy fsid to struct super_block.s_uuid so Overlay disables
index feature with btrfs as the lower FS.

kernel: overlayfs: fs on '/lower' does not support file handles, falling back to index=off.

Fix this by publishing the fsid through struct super_block.s_uuid.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
I tried to know if in case did we deliberately missed this for some reason,
however there is no information on that. If we mount a non-default subvol in
the next mount/remount, its still the same FS, so publishing the FSID
instead of subvol uuid is correct, OR I can't think any other reason for
not using s_uuid for btrfs.


 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 080e2ebb8aa0..b7e72d040442 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2899,6 +2899,7 @@ int open_ctree(struct super_block *sb,
 
 	sb->s_blocksize = sectorsize;
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
+	memcpy(&sb->s_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
 
 	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_sys_array(fs_info);
-- 
2.13.1


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934743AbdBQQ2O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:28:14 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B60C7AB9A
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 16:28:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: constify input buffer of btrfs_csum_data
Date: Fri, 17 Feb 2017 17:27:43 +0100
Message-Id: <0a86e5d281acdc36fbf1955806597a3dd59af074.1487348702.git.dsterba@suse.com>
In-Reply-To: <cover.1487348702.git.dsterba@suse.com>
References: <cover.1487348702.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function does not modify the input buffer, also update a typecast in
one caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 fs/btrfs/disk-io.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2b06f557c176..1b4d737bb908 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -265,7 +265,7 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 	return em;
 }
 
-u32 btrfs_csum_data(char *data, u32 seed, size_t len)
+u32 btrfs_csum_data(const char *data, u32 seed, size_t len)
 {
 	return btrfs_crc32c(seed, data, len);
 }
@@ -3448,7 +3448,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			btrfs_set_super_bytenr(sb, bytenr);
 
 			crc = ~(u32)0;
-			crc = btrfs_csum_data((char *)sb +
+			crc = btrfs_csum_data((const char *)sb +
 					      BTRFS_CSUM_SIZE, crc,
 					      BTRFS_SUPER_INFO_SIZE -
 					      BTRFS_CSUM_SIZE);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 0be2d4fe705b..2e0ec29bfd69 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -116,7 +116,7 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
-u32 btrfs_csum_data(char *data, u32 seed, size_t len);
+u32 btrfs_csum_data(const char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, u8 *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			enum btrfs_wq_endio_type metadata);
-- 
2.10.1


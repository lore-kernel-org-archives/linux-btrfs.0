Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36724 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754833AbcJULrN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 07:47:13 -0400
Received: by mail-lf0-f65.google.com with SMTP id b75so5480553lfg.3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 04:47:12 -0700 (PDT)
From: =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
Subject: [PATCH v2] btrfs: change btrfs_csum_final result param type to u8
Date: Fri, 21 Oct 2016 12:47:02 +0100
Message-Id: <20161021114702.29425-1-domagoj.trsan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

csum member of struct btrfs_super_block has array type of u8. It makes sense
that function btrfs_csum_final should be also declared to accept u8 *. I
changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
to void btrfs_csum_final(u32 crc, u8 *result);

---
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/disk-io.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 50bed6c..95bd34f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -273,7 +273,7 @@ u32 btrfs_csum_data(char *data, u32 seed, size_t len)
 	return btrfs_crc32c(seed, data, len);
 }
 
-void btrfs_csum_final(u32 crc, char *result)
+void btrfs_csum_final(u32 crc, u8 *result)
 {
 	put_unaligned_le32(~crc, result);
 }
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 8e79d00..e849845 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -118,7 +118,7 @@ int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 u32 btrfs_csum_data(char *data, u32 seed, size_t len);
-void btrfs_csum_final(u32 crc, char *result);
+void btrfs_csum_final(u32 crc, u8 *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			enum btrfs_wq_endio_type metadata);
 int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
-- 
2.7.4


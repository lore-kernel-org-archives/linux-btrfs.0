Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33543 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936161AbcJ0OpJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 10:45:09 -0400
Received: by mail-wm0-f65.google.com with SMTP id m83so3064496wmc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 07:44:56 -0700 (PDT)
From: =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
Subject: [PATCH v3] btrfs: change btrfs_csum_final result param type to u8
Date: Thu, 27 Oct 2016 08:52:33 +0100
Message-Id: <20161027075233.4050-1-domagoj.trsan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

csum member of struct btrfs_super_block has array type of u8. It makes sense
that function btrfs_csum_final should be also declared to accept u8 *. I
changed the declaration of method void btrfs_csum_final(u32 crc, char *result);
to void btrfs_csum_final(u32 crc, u8 *result);

Signed-off-by: Domagoj Tršan <domagoj.trsan@gmail.com>
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
2.9.3


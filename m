Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36006 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932209AbcIQXKl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 19:10:41 -0400
Received: by mail-wm0-f65.google.com with SMTP id b184so9127113wma.3
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Sep 2016 16:10:40 -0700 (PDT)
From: =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        =?UTF-8?q?Domagoj=20Tr=C5=A1an?= <domagoj.trsan@gmail.com>
Subject: [PATCH] btrfs: change btrfs_csum_final result param type to u8
Date: Sun, 18 Sep 2016 00:10:35 +0100
Message-Id: <1474153835-6728-2-git-send-email-domagoj.trsan@gmail.com>
In-Reply-To: <1474153835-6728-1-git-send-email-domagoj.trsan@gmail.com>
References: <1474153835-6728-1-git-send-email-domagoj.trsan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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


From: "JieJing.Zhang" <kzjeef@gmail.com>
Subject: [PATCH] Btrfs: handle kmalloc() failure in btrfs_file_aio_write()
Date: Sun, 20 Jun 2010 02:13:14 +0800
Message-ID: <1276971194-24572-1-git-send-email-kzjeef@gmail.com>
Cc: "JieJing.Zhang" <kzjeef@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

set errno to -ENOMEM and goto out

Signed-off-by: JieJing.Zhang <kzjeef@gmail.com>
---
 fs/btrfs/file.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e354c33..e0fcb6c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -926,6 +926,10 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
 		     (sizeof(struct page *)));
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (!pages) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
-- 
1.7.0.4


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34917 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161104AbdKQRpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:21 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6886ADF7
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:19 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 8/8] fs: Introduce iomap->dirty_page()
Date: Fri, 17 Nov 2017 11:44:55 -0600
Message-Id: <20171117174456.13393-10-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

In dirty_page(), we are clearing PageChecked, though I don't see it set.
Is this used for compression only?
Can we call __set_page_dirty_nobuffers instead?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c       | 8 ++++++++
 fs/iomap.c            | 2 ++
 include/linux/iomap.h | 1 +
 3 files changed, 11 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b5cc5c0a0cf5..049ed1d8ce1f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1648,10 +1648,18 @@ static void btrfs_file_process_page(struct inode *inode, struct page *page)
 	get_page(page);
 }
 
+static void btrfs_file_dirty_page(struct page *page)
+{
+	SetPageUptodate(page);
+	ClearPageChecked(page);
+	set_page_dirty(page);
+}
+
 const struct iomap_ops btrfs_iomap_ops = {
         .iomap_begin            = btrfs_file_iomap_begin,
         .iomap_end              = btrfs_file_iomap_end,
 	.iomap_process_page	= btrfs_file_process_page,
+	.iomap_dirty_page	= btrfs_file_dirty_page,
 };
 
 static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
diff --git a/fs/iomap.c b/fs/iomap.c
index a32660b1b6c5..0907790c76c0 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -208,6 +208,8 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		status = iomap_write_end(inode, pos, bytes, copied, page, iomap);
 		if (unlikely(status < 0))
 			break;
+		if (ops->iomap_dirty_page)
+			ops->iomap_dirty_page(page);
 		copied = status;
 
 		cond_resched();
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index fbb0194d56d6..7fbf6889dc54 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -76,6 +76,7 @@ struct iomap_ops {
 			ssize_t written, unsigned flags, struct iomap *iomap);
 
 	void (*iomap_process_page)(struct inode *inode, struct page *page);
+	void (*iomap_dirty_page)(struct page *page);
 };
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
-- 
2.14.2


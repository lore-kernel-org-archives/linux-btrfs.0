From: Zhang JieJing <kzjeef@gmail.com>
Subject: Re: [PATCH] Btrfs: handle kmalloc() failure in btrfs_file_aio_write()
Date: Sun, 4 Jul 2010 01:35:14 +0800
Message-ID: <AANLkTikZK2TBWoKS6zGTGnk830EK7fwhcjhJqfCgey55@mail.gmail.com>
References: <1276971194-24572-1-git-send-email-kzjeef@gmail.com>
	<AANLkTinv_7JGRhI8PtnmPUY3yqcPJBV7-ENPsCfYJPkb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinv_7JGRhI8PtnmPUY3yqcPJBV7-ENPsCfYJPkb@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is the improved of the former patch.

>From d9c4cf7dd0e4489a31610e2fb2565ee29f0e4179 Mon Sep 17 00:00:00 2001
From: JieJing.Zhang <kzjeef@gmail.com>
Date: Sun, 4 Jul 2010 01:17:54 +0800
Subject: [PATCH] Btrfs: handle memory alloc failure in btrfs_file_aio_write()

1. kmalloc() should add a check of return valule.

2. In later code it memset zero to the allocated memory,
   so use kzalloc() instead of kmalloc() when allocation is better.

Signed-off-by: JieJing.Zhang <kzjeef@gmail.com>
---
 fs/btrfs/file.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e354c33..961612c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -925,7 +925,11 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	nrptrs = min((iov_iter_count(&i) + PAGE_CACHE_SIZE - 1) /
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
 		     (sizeof(struct page *)));
-	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	pages = kzalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (!pages) {
+		ret = -ENOMEM;
+		goto out;
+	}

 	/* generic_write_checks can change our pos */
 	start_pos = pos;
@@ -968,7 +972,6 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 					PAGE_CACHE_SHIFT;

 		WARN_ON(num_pages > nrptrs);
-		memset(pages, 0, sizeof(struct page *) * nrptrs);

 		ret = btrfs_delalloc_reserve_space(inode, write_bytes);
 		if (ret)
-- 
1.7.0.4

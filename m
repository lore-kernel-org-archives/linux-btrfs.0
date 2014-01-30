Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:52399 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaA3PYU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 10:24:20 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so1721380eaj.15
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 07:24:19 -0800 (PST)
Received: from localhost (host-115-115.kawo1.rwth-aachen.de. [134.130.115.115])
        by mx.google.com with ESMTPSA id u7sm23679987eep.11.2014.01.30.07.24.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 30 Jan 2014 07:24:19 -0800 (PST)
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFCv4 5/7] btrfs: new function read_extent_buffer_to_user
Date: Thu, 30 Jan 2014 16:24:01 +0100
Message-Id: <1391095443-20287-6-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
References: <1391095443-20287-1-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This new function reads the content of an extent directly to user memory.

Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
---
 fs/btrfs/extent_io.c | 37 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |  3 +++
 2 files changed, 40 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fbe501d..d1e9dd8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4956,6 +4956,43 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	}
 }
 
+int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dstv,
+			unsigned long start,
+			unsigned long len)
+{
+	size_t cur;
+	size_t offset;
+	struct page *page;
+	char *kaddr;
+	char __user *dst = (char __user *)dstv;
+	size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
+	unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
+	int ret = 0;
+
+	WARN_ON(start > eb->len);
+	WARN_ON(start + len > eb->start + eb->len);
+
+	offset = (start_offset + start) & (PAGE_CACHE_SIZE - 1);
+
+	while (len > 0) {
+		page = extent_buffer_page(eb, i);
+
+		cur = min(len, (PAGE_CACHE_SIZE - offset));
+		kaddr = page_address(page);
+		if (copy_to_user(dst, kaddr + offset, cur)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		dst += cur;
+		len -= cur;
+		offset = 0;
+		i++;
+	}
+
+	return ret;
+}
+
 int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 			       unsigned long min_len, char **map,
 			       unsigned long *map_start,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 58b27e5..d0b1541 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -304,6 +304,9 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 void read_extent_buffer(struct extent_buffer *eb, void *dst,
 			unsigned long start,
 			unsigned long len);
+int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dst,
+			       unsigned long start,
+			       unsigned long len);
 void write_extent_buffer(struct extent_buffer *eb, const void *src,
 			 unsigned long start, unsigned long len);
 void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
-- 
1.8.5.3


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51280 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754520AbcKIREh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 12:04:37 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3F542AC34
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 17:04:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/12] btrfs: introduce helpers for updating eb uuids
Date: Wed,  9 Nov 2016 18:04:34 +0100
Message-Id: <77d3ede388ba26b93ead0afb8c7f5e6af3a10c35.1478710770.git.dsterba@suse.com>
In-Reply-To: <cover.1478710770.git.dsterba@suse.com>
References: <cover.1478710770.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fsid and chunk tree uuid are always located in the first page,
we don't need the to use write_extent_buffer.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 21 +++++++++++++++++++++
 fs/btrfs/extent_io.h |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8ed05d95584a..45a986791fe0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5465,6 +5465,27 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 	return ret;
 }
 
+void write_extent_buffer_chunk_tree_uuid(struct extent_buffer *eb,
+		const void *srcv)
+{
+	char *kaddr;
+
+	WARN_ON(!PageUptodate(eb->pages[0]));
+	kaddr = page_address(eb->pages[0]);
+	memcpy(kaddr + offsetof(struct btrfs_header, chunk_tree_uuid), srcv,
+			BTRFS_FSID_SIZE);
+}
+
+void write_extent_buffer_fsid(struct extent_buffer *eb, const void *srcv)
+{
+	char *kaddr;
+
+	WARN_ON(!PageUptodate(eb->pages[0]));
+	kaddr = page_address(eb->pages[0]);
+	memcpy(kaddr + offsetof(struct btrfs_header, fsid), srcv,
+			BTRFS_FSID_SIZE);
+}
+
 void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 			 unsigned long start, unsigned long len)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ab31d145227e..065c77d43921 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -405,6 +405,9 @@ void read_extent_buffer(struct extent_buffer *eb, void *dst,
 int read_extent_buffer_to_user(struct extent_buffer *eb, void __user *dst,
 			       unsigned long start,
 			       unsigned long len);
+void write_extent_buffer_fsid(struct extent_buffer *eb, const void *src);
+void write_extent_buffer_chunk_tree_uuid(struct extent_buffer *eb,
+		const void *src);
 void write_extent_buffer(struct extent_buffer *eb, const void *src,
 			 unsigned long start, unsigned long len);
 void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
-- 
2.10.1


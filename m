Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933433AbcECQM5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 12:12:57 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 67407AB9D
	for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2016 16:12:56 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs-progs: add getters for ioctl search_header
Date: Tue,  3 May 2016 18:12:40 +0200
Message-Id: <99993863d5906bb4987502ea08411fab56b64f35.1462291729.git.dsterba@suse.com>
In-Reply-To: <cover.1462291729.git.dsterba@suse.com>
References: <cover.1462291729.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The search header is usually accessed in an unaligned way, we could
trigger errors (SIGBUS) on architectures that do not support that.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 ctree.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/ctree.h b/ctree.h
index 2da6f7786a78..13ed05052301 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2196,6 +2196,32 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
        return btrfs_item_size(eb, e) - offset;
 }
 
+/* struct btrfs_ioctl_search_header */
+static inline u64 btrfs_search_header_transid(struct btrfs_ioctl_search_header *sh)
+{
+	return get_unaligned_64(&sh->transid);
+}
+
+static inline u64 btrfs_search_header_objectid(struct btrfs_ioctl_search_header *sh)
+{
+	return get_unaligned_64(&sh->objectid);
+}
+
+static inline u64 btrfs_search_header_offset(struct btrfs_ioctl_search_header *sh)
+{
+	return get_unaligned_64(&sh->offset);
+}
+
+static inline u32 btrfs_search_header_type(struct btrfs_ioctl_search_header *sh)
+{
+	return get_unaligned_32(&sh->type);
+}
+
+static inline u32 btrfs_search_header_len(struct btrfs_ioctl_search_header *sh)
+{
+	return get_unaligned_32(&sh->len);
+}
+
 /* this returns the number of file bytes represented by the inline item.
  * If an item is compressed, this is the uncompressed size
  */
-- 
2.7.1


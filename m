Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38815 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbcBUR3H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 12:29:07 -0500
Received: by mail-wm0-f52.google.com with SMTP id a4so133460089wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 09:29:06 -0800 (PST)
Message-ID: <286C424321A6496789A866288933406A@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
To: <linux-btrfs@vger.kernel.org>, <fdmanana@kernel.org>, <jbacik@fb.com>
Subject: [RFC - PATCH] btrfs: do not write corrupted metadata blocks to disk
Date: Sun, 21 Feb 2016 17:36:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

csum_dirty_buffer was issuing a warning in case the extent buffer
did not look alright, but was still returning success.
Let's return error in this case, and also add two additional sanity
checks on the extent buffer header.

We had btrfs metadata corruption, and after looking at the logs we saw
that WARN_ON(found_start != start) has been triggered. We are still 
investigating
which component trashed the cache page which belonged to btrfs. But btrfs
only issued a warning, and as a result, the corrupted metadata block went to 
disk.

I think we should return an error in such case that the extent buffer 
doesn't look alright.
The caller up the chain may BUG_ON on this, for example flush_epd_write_bio 
will,
but it is better than to have a silent metadata corruption on disk.

Note: this patch has been properly tested on 3.18 kernel only.

Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
---
fs/btrfs/disk-io.c | 14 ++++++++++++--
1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4545e2e..701e706 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -508,22 +508,32 @@ static int csum_dirty_buffer(struct btrfs_fs_info 
*fs_info, struct page *page)
{
     u64 start = page_offset(page);
     u64 found_start;
     struct extent_buffer *eb;

     eb = (struct extent_buffer *)page->private;
     if (page != eb->pages[0])
         return 0;
     found_start = btrfs_header_bytenr(eb);
     if (WARN_ON(found_start != start || !PageUptodate(page)))
-        return 0;
-    csum_tree_block(fs_info, eb, 0);
+        return -EUCLEAN;
+#ifdef CONFIG_BTRFS_ASSERT
+    if (WARN_ON(memcmp_extent_buffer(eb, fs_info->fsid,
+                    (unsigned long)btrfs_header_fsid(), BTRFS_FSID_SIZE)))
+        return -EUCLEAN;
+    if (WARN_ON(memcmp_extent_buffer(eb, fs_info->fsid,
+                    (unsigned long)btrfs_header_chunk_tree_uuid(eb),
+                    BTRFS_FSID_SIZE)))
+        return -EUCLEAN;
+#endif
+    if (csum_tree_block(fs_info, eb, 0))
+        return -EUCLEAN;
     return 0;
}

static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
                  struct extent_buffer *eb)
{
     struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
     u8 fsid[BTRFS_UUID_SIZE];
     int ret = 1;

-- 
1.9.1


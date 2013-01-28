Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64047 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3A1RIt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 12:08:49 -0500
Received: by mail-wi0-f181.google.com with SMTP id c10so1650180wiw.8
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 09:08:48 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Jan 2013 19:08:47 +0200
Message-ID: <CAOcd+r3S7E8E7q_BEWBJk-ZfD3XuuCqS80iNP2Wdo-1RZ_X04g@mail.gmail.com>
Subject: [PATCH 2/2] V2 On a diff-send, avoid sending PREALLOC extents
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>,
        Alexander Block <ablock84@googlemail.com>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On a diff-send, avoid sending PREALLOC extents, if the parent root has
only PREALLOC extents on an appropriate file range.

This does not fully avoid sending PREALLOC extents, because on
full-send or on new inode we need a new send command to do that.
But this patch improves the situation by handling diff-sends.

Signed-off-by: Alex Lyakas <alex.btrfs@zadarastorage.com>
---
 fs/btrfs/send.c |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 150 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e23f5cf..2dce125 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3765,6 +3765,148 @@ out:
        return ret;
 }

+static int is_prealloc_extent_unchanged(struct send_ctx *sctx,
+                              struct btrfs_path *left_path,
+                              struct btrfs_key *ekey)
+{
+       int ret = 0;
+       struct btrfs_key key;
+       struct btrfs_path *path = NULL;
+       struct extent_buffer *eb;
+       int slot;
+       struct btrfs_key found_key;
+       struct btrfs_file_extent_item *ei;
+       u64 left_len;
+       u64 right_len;
+       u8 right_type;
+
+       eb = left_path->nodes[0];
+       slot = left_path->slots[0];
+       ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+       left_len = btrfs_file_extent_num_bytes(eb, ei);
+
+       /*
+        * The logic is similar, but much simpler than in is_extent_unchanged().
+        * We need to check extents on the parent root, and make sure that only
+        * PREALLOC extents are on the same file range as our current extent.
+        *
+        * Following comments will refer to these graphics. L is the left
+        * extents which we are checking at the moment. 1-8 are the right
+        * extents that we iterate.
+        *
+        *    |-----L-----|
+        * |-1-|-2a-|-3-|-4-|-5-|-6-|
+        *
+        *        |-----L-----|
+        * |--1--|-2b-|...(same as above)
+        *
+        * Alternative situation. Happens on files where extents got split.
+        *        |-----L-----|
+        * |-----------7-----------|-6-|
+        *
+        * Alternative situation. Happens on files which got larger.
+        *        |-----L-----|
+        * |-8-|
+        * Nothing follows after 8.
+        */
+
+       path = alloc_path_for_send();
+       if (!path)
+               return -ENOMEM;
+
+       key.objectid = ekey->objectid;
+       key.type = BTRFS_EXTENT_DATA_KEY;
+       key.offset = ekey->offset;
+       ret = btrfs_search_slot_for_read(sctx->parent_root, &key, path, 0, 0);
+       if (ret < 0)
+               goto out;
+       if (ret) {
+               ret = 0;
+               goto out;
+       }
+
+       /*
+        * Handle special case where the right side has no extents at all.
+        */
+       eb = path->nodes[0];
+       slot = path->slots[0];
+       btrfs_item_key_to_cpu(eb, &found_key, slot);
+       if (found_key.objectid != key.objectid ||
+               found_key.type != key.type) {
+               /*
+                * We need to send a "prealloc" command,
+                * which we don't have yet, just send
+                * this extent fully.
+                */
+               ret = 0;
+               goto out;
+       }
+
+       key = found_key;
+       while (key.offset < ekey->offset + left_len) {
+               ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+               right_type = btrfs_file_extent_type(eb, ei);
+               right_len = btrfs_file_extent_num_bytes(eb, ei);
+
+               if (right_type != BTRFS_FILE_EXTENT_PREALLOC) {
+                       ret = 0;
+                       goto out;
+               }
+
+               /*
+                * Are we at extent 8? If yes, we know the extent is changed.
+                * This may only happen on the first iteration.
+                */
+               if (found_key.offset + right_len <= ekey->offset) {
+                       /*
+                        * We need to send a "prealloc" command,
+                        * which we don't have yet,
+                        * just send this extent fully.
+                        */
+                       ret = 0;
+                       goto out;
+               }
+
+               /*
+                * The right extent is also PREALLOC, so up to
+                * here we are ok, continue checking
+                */
+               ret = btrfs_next_item(sctx->parent_root, path);
+               if (ret < 0)
+                       goto out;
+               if (!ret) {
+                       eb = path->nodes[0];
+                       slot = path->slots[0];
+                       btrfs_item_key_to_cpu(eb, &found_key, slot);
+               }
+               if (ret || found_key.objectid != key.objectid ||
+                   found_key.type != key.type) {
+                       key.offset += right_len;
+                       break;
+               } else {
+                       if (found_key.offset != key.offset + right_len) {
+                               /* Should really not happen */
+                               ret = -EIO;
+                               goto out;
+                       }
+               }
+               key = found_key;
+       }
+
+       /*
+        * We're now behind the left extent (treat as unchanged) or at the end
+        * of the right side (treat as changed).
+        */
+       if (key.offset >= ekey->offset + left_len)
+               ret = 1;
+       else
+               ret = 0;
+
+out:
+       btrfs_free_path(path);
+       return ret;
+}
+
 static int is_extent_unchanged(struct send_ctx *sctx,
                               struct btrfs_path *left_path,
                               struct btrfs_key *ekey)
@@ -3788,15 +3930,15 @@ static int is_extent_unchanged(struct send_ctx *sctx,
        u8 left_type;
        u8 right_type;

-       path = alloc_path_for_send();
-       if (!path)
-               return -ENOMEM;
-
        eb = left_path->nodes[0];
        slot = left_path->slots[0];
        ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
        left_type = btrfs_file_extent_type(eb, ei);

+       if (left_type == BTRFS_FILE_EXTENT_PREALLOC) {
+               ret = is_prealloc_extent_unchanged(sctx, left_path, ekey);
+               goto out;
+       }
        if (left_type != BTRFS_FILE_EXTENT_REG) {
                ret = 0;
                goto out;
@@ -3827,6 +3969,10 @@ static int is_extent_unchanged(struct send_ctx *sctx,
         * Nothing follows after 8.
         */

+       path = alloc_path_for_send();
+       if (!path)
+               return -ENOMEM;
+
        key.objectid = ekey->objectid;
        key.type = BTRFS_EXTENT_DATA_KEY;
        key.offset = ekey->offset;
--
1.7.9.5

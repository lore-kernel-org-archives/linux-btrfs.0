Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:52068 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3AUK1Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 05:27:24 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so248520wer.22
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 02:27:22 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Jan 2013 12:27:22 +0200
Message-ID: <CAOcd+r1_hiz7A98r0o1e_=60+3tN16n+HTgQs0SgMhHjGG-E7Q@mail.gmail.com>
Subject: [PATCH 1/2] V2 Avoid sending disknr==0 extents when possible.
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>,
        Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <CAOcd+r35boyF4QzFUoJ3wU2fQDWGNu-izjk9X3u8hx+8_GPR+g@mail.gmail.com>

In the following cases we do not send disknr==0 extents:
1) full send 2) new inode in a diff-send 3) when disknr==0 extents are
added to the end of an inode

Original-version-by: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
---
 fs/btrfs/send.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5445454..bdef966 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3844,7 +3844,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
        btrfs_item_key_to_cpu(eb, &found_key, slot);
        if (found_key.objectid != key.objectid ||
            found_key.type != key.type) {
-               ret = 0;
+               /* No need to send a no-data extent it in this case */
+               ret = (left_disknr == 0) ? 1 : 0;
                goto out;
        }

@@ -3870,7 +3871,8 @@ static int is_extent_unchanged(struct send_ctx *sctx,
                 * This may only happen on the first iteration.
                 */
                if (found_key.offset + right_len <= ekey->offset) {
-                       ret = 0;
+                       /* No need to send a no-data extent it in this case */
+                       ret = (left_disknr == 0) ? 1 : 0;
                        goto out;
                }

@@ -3951,6 +3953,30 @@ static int process_extent(struct send_ctx *sctx,
                        ret = 0;
                        goto out;
                }
+       } else {
+               struct extent_buffer *eb;
+               struct btrfs_file_extent_item *ei;
+               u8 extent_type;
+               u64 extent_disknr;
+
+               eb = path->nodes[0];
+               ei = btrfs_item_ptr(eb, path->slots[0],
+                               struct btrfs_file_extent_item);
+
+               extent_type = btrfs_file_extent_type(eb, ei);
+               extent_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
+               if (extent_type == BTRFS_FILE_EXTENT_REG &&
+                       extent_disknr == 0) {
+                       /*
+                        * This is disknr=0 extent in a full-send or a
+                        * new inode in a diff-send. Since we will
+                        * send truncate command in finish_inode_if_needed
+                        * anyways, the inode size will be correct,
+                        * and we don't have to send all-zero data.
+                        */
+                       ret = 0;
+                       goto out;
+               }
        }

        ret = find_extent_clone(sctx, path, key->objectid, key->offset,
--
1.7.9.5

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:42481 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbeFGDdH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2018 23:33:07 -0400
Received: by mail-oi0-f67.google.com with SMTP id k190-v6so7280057oib.9
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jun 2018 20:33:07 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Wed, 6 Jun 2018 23:33:06 -0400
Message-ID: <CA+X5Wn5iV-q3jfDBPjGgvjtO4j+DCs0nifjFsya6GfLG9eNYWA@mail.gmail.com>
Subject: [PATCH RFC] btrfs-progs: map-logical: look at next leaf if slot > items
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

=====[ NOTE ]=====

I think I found a buffer over-read error that will come up other places, unless
EACH caller checks bounds themselves.  See "Bonus bug, LEFT FOR READER" below.

=====[ PROBLEM ]=====

Using btrfs-progs v4.16:

No extent found at range [10955980800,10955984896)

But, this extent exists.  btrfs-debug-tree shows:
...
extent tree key (EXTENT_TREE ROOT_ITEM 0)
...
leaf 316456960 items 203 free space 3697 generation 84225 owner EXTENT_TREE
...
        item 197 key (10955931648 EXTENT_ITEM 28672) itemoff 8957 itemsize 37
                refs 1 gen 62656 flags DATA
                shared data backref parent 142622720 count 1
        item 198 key (10955960320 EXTENT_ITEM 4096) itemoff 8920 itemsize 37
                refs 1 gen 62656 flags DATA
                shared data backref parent 142622720 count 1
        item 199 key (10955964416 EXTENT_ITEM 4096) itemoff 8883 itemsize 37
                refs 1 gen 62656 flags DATA
                shared data backref parent 142622720 count 1
        item 200 key (10955968512 EXTENT_ITEM 4096) itemoff 8846 itemsize 37
                refs 1 gen 62656 flags DATA
                shared data backref parent 142622720 count 1
        item 201 key (10955972608 EXTENT_ITEM 4096) itemoff 8809 itemsize 37
                refs 1 gen 62656 flags DATA
                shared data backref parent 142655488 count 1
        item 202 key (10955976704 EXTENT_ITEM 4096) itemoff 8772 itemsize 37
                refs 1 gen 62656 flags DATA
                shared data backref parent 142655488 count 1
...
leaf 316489728 items 208 free space 3387 generation 84225 owner EXTENT_TREE
...
        item 0 key (10955980800 EXTENT_ITEM 4096) itemoff 16246 itemsize 37
                refs 1 gen 62656 flags DATA
                shared data backref parent 128958464 count 1
...
checksum tree key (CSUM_TREE ROOT_ITEM 0)
...
        item 412 key (EXTENT_CSUM EXTENT_CSUM 10955980800) itemoff 10647
                   itemsize 4
                range start 10955980800 end 10955984896 length 4096
....
file tree key (3038 ROOT_ITEM 80009)
...
leaf 128958464 items 37 free space 6032 generation 62656 owner FS_TREE
...
        item 1 key (997645 INODE_ITEM 0) itemoff 15220 itemsize 160
                generation 62656 transid 62656 size 4943 nbytes 8192
                block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
                sequence 5 flags 0x0(none)
                atime 1478246492.0 (2016-11-04 08:01:32)
                ctime 1478246493.129060242 (2016-11-04 08:01:33)
                mtime 1477487995.0 (2016-10-26 13:19:55)
                otime 1478246493.129060242 (2016-11-04 08:01:33)
        item 2 key (997645 INODE_REF 299949) itemoff 15200 itemsize 20
                index 13 namelen 10 name: as_map.hpp
        item 3 key (997645 EXTENT_DATA 0) itemoff 15147 itemsize 53
                generation 62656 type 1 (regular)
                extent data disk byte 10955980800 nr 4096
                extent data offset 0 nr 8192 ram 8192
                extent compression 2 (lzo)
...

=====[ CAUSE ]=====

In main's first call to map_one_extent(10955980800, 4096, 0):

* btrfs_search_slot() looks for (10955980800, 0, 0), and:
** returns 1 because it doesn't exist
** sets path->slots[0] to 203 (for leaf 316456960), where it should go if
   inserted (pointing after the last existing item)
* ret is reset to 0
* btrfs_item_key_to_cpu sets key to (10955960320, BTRFS_EXTENT_ITEM_KEY, 4096)
!!! Bonus bug, LEFT FOR READER.  Why is this item #197, 5 items before the 203
    given?  I think no bounds checking causes a buffer over-read here.
    btrfs_item_key_to_cpu() calls btrfs_item_key(), which uses the macro
    read_eb_member() to call read_extent_buffer() which memcpy's using an out
    of range index, at least for this leaf.
* With (!search_forward && key.objectid > logical) being false, the code calling
  btrfs_next_item() is not run.
* logical is set to this too-low key.objectid
* !ret, so set *logical_ret and *len_ret with the new values

Back in main:

* ret is 0, so don't print the first error
* ret is still 0, so don't run map_one_extent() with search_forward=1
* At the while loop, (10955960320 + 4096 >= 10955980800 && 10955960320 <
  10955980800 + 4096) (10955964416 >= 10955980800 && 10955960320 < 10955984896)
  (false && true) (false), so don't call map_one_extent() with search_forward=1
  here, either.
* In the while loop, now call map_one_extent() with search_forward=1
* !found, so print (somewhat deceptive) error only mentioning the user-given
  logical without mentioning it looked elsewhere, and give up.

=====[ FIX ]=====

btrfs-map-logical and I are not friends.  The "least code" fix for this
situation is this patch.

Qu's "btrfs-progs: check: Also compare data between mirrors to detect corruption
for NODATASUM extents" uses a simpler way, which makes me wonder if that should
just be modified to replace how btrfs-map-logical works.  But, I'll admit I do
not have my head around the entire way everything is done in btrfs-map-logical,
and there could be reasons for it needing to be different here.

This doesn't touch what I think is the buffer over-read error described above.

With this fix, btrfs_item_key_to_cpu() is not asked to read out of bounds, so
map_one_extent() leaves cur_logical and cur_len unmodified because they don't
need to be.  (Both the first time it's ran with search_forward=0, and in the
while loop when it's ran with search_forward=1.)

Also updated call from btrfs_next_item() to btrfs_next_extent_item().  I can't
see any reason not to, while this area's being modified.  It looks for both
BTRFS_EXTENT_ITEM_KEY and BTRFS_METADATA_ITEM_KEY, which is what we need.
(Granted, inside, it's just calling btrfs_next_item().)

Also fixed misspelling of "foward" to "forward".

Signed-off-by: James Harvey <jamespharvey20@gmail.com>
---
 btrfs-map-logical.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 7a8bcff9..1c30b22b 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -39,7 +39,7 @@
 static FILE *info_file;

 static int map_one_extent(struct btrfs_fs_info *fs_info,
-                         u64 *logical_ret, u64 *len_ret, int search_foward)
+                         u64 *logical_ret, u64 *len_ret, int search_forward)
 {
        struct btrfs_path *path;
        struct btrfs_key key;
@@ -65,17 +65,25 @@ static int map_one_extent(struct btrfs_fs_info *fs_info,
        BUG_ON(ret == 0);
        ret = 0;

+       if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+               ret = btrfs_next_leaf(fs_info->extent_root, path);
+               if (ret != 0) {
+                       ret = -1;
+                       goto out;
+               }
+       }
+
 again:
        btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-       if ((search_foward && key.objectid < logical) ||
-           (!search_foward && key.objectid > logical) ||
+       if ((search_forward && key.objectid < logical) ||
+           (!search_forward && key.objectid > logical) ||
            (key.type != BTRFS_EXTENT_ITEM_KEY &&
             key.type != BTRFS_METADATA_ITEM_KEY)) {
-               if (!search_foward)
+               if (!search_forward)
                        ret = btrfs_previous_extent_item(fs_info->extent_root,
                                                         path, 0);
                else
-                       ret = btrfs_next_item(fs_info->extent_root, path);
+                       ret =
btrfs_next_extent_item(fs_info->extent_root, path);
                if (ret)
                        goto out;
                goto again;
--
2.17.0

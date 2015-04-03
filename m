Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34296 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbDCXgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 19:36:13 -0400
Received: by wgbdm7 with SMTP id dm7so121179348wgb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 16:36:12 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Apr 2015 16:36:11 -0700
Message-ID: <CAKgsxVRfn8v3ubrwonm-UXgBRg7Mz=90_DSOwzpeyVTTP-JQ8g@mail.gmail.com>
Subject: Btrfs ENOSPC issue
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

We're hitting a consistently reproducible ENOSPC condition with a
simple test case:

# truncate -s 1T btrfs.fs
# mkfs.btrfs btrfs.fs
# mount btrfs.fs /mnt/
# fallocate -l 1021G /mnt/fallocate
# btrfs fi sync /mnt/
# dd if=/dev/zero of=/mnt/dd bs=1G
# btrfs fi sync /mnt/
# rm /mnt/fallocate
# btrfs fi sync /mnt/
# fallocate -l 20G /mnt/fallocate
fallocate: /mnt/fallocate: fallocate failed: No space left on device

I continue to get ENOSPC even after unmount / mount.

Here we have 1022GB free as reported by df, yet we can't allocate
20GB.  I tried the integration-4.1 tree, which had the same results.
I also added Zhao Lei's ENOSPC most recent patchset from today, but it
didn't seem to help.

So it appears that when allocating the first chunk,
find_free_dev_extent() finds a huge hole, and allocates a portion of
that free 1022GB.  Real chunk allocation is delayed until transaction
submit and does not insert the DEV_EXTENT item into the device tree
immediately, so transaction->pending_chunks is used to record pending
chunks.

When it comes to the next chunk allocation, find_free_dev_extent()
detects the same huge hole, but contains_pending_extent() returns true
and sets hole_size to 0.  This means we skip our one and only huge
free space hole and try to search for some other free space holes.

The problem occurs when there is not enough space for chunk allocation
if we skip that huge hole, and find_free_dev_extent() eventually
returns –ENOSPC.

The following patch makes it work for me, but I certainly may have
missed some subtleties in how btrfs allocation works; so if something
is incorrect here, I'd appreciate feedback.  If this is the proper way
to go about fixing it, I can whip up a proper patch and post it to the
list.

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a73acf4..d056448 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1053,7 +1053,7 @@ out:

 static int contains_pending_extent(struct btrfs_trans_handle *trans,
                                   struct btrfs_device *device,
-                                  u64 *start, u64 len)
+                                  u64 *start, u64 *len)
 {
        struct extent_map *em;
        struct list_head *search_list = &trans->transaction->pending_chunks;
@@ -1068,12 +1068,16 @@ again:
                for (i = 0; i < map->num_stripes; i++) {
                        if (map->stripes[i].dev != device)
                                continue;
-                       if (map->stripes[i].physical >= *start + len ||
+                       if (map->stripes[i].physical >= *start + *len ||
                            map->stripes[i].physical + em->orig_block_len <=
                            *start)
                                continue;
                        *start = map->stripes[i].physical +
                                em->orig_block_len;
+                       if (*len > em->orig_block_len)
+                               *len -= em->orig_block_len;
+                       else
+                               *len = 0;
                        ret = 1;
                }
        }
@@ -1191,10 +1195,9 @@ again:
                         * Have to check before we set max_hole_start, otherwise
                         * we could end up sending back this offset anyway.
                         */
-                       if (contains_pending_extent(trans, device,
-                                                   &search_start,
-                                                   hole_size))
-                               hole_size = 0;
+                       contains_pending_extent(trans, device,
+                                               &search_start,
+                                               &hole_size);

                        if (hole_size > max_hole_size) {
                                max_hole_start = search_start;
@@ -1239,7 +1242,7 @@ next:
                max_hole_size = hole_size;
        }

-       if (contains_pending_extent(trans, device, &search_start, hole_size)) {
+       if (contains_pending_extent(trans, device, &search_start, &hole_size)) {
                btrfs_release_path(path);
                goto again;
        }

Thanks,
-Justin

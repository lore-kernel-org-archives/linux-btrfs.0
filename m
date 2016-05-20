Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42770 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbcETPJF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 11:09:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8EC7C20364
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:09:03 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 27BEC2012D
	for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 15:09:00 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] Btrfs: fix race between device replace and chunk allocation
Date: Fri, 20 May 2016 05:45:21 +0100
Message-Id: <1463719521-3680-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

While iterating and copying extents from the source device, the device
replace code keeps adjusting a left cursor that is used to make sure that
once we finish processing a device extent, any future writes to extents
from the corresponding block group will get into both the source and
target devices. This left cursor is also used for resuming the device
replace operation at mount time.

However using this left cursor to decide whether writes go into both
devices or only the source device is not enough to guarantee we don't
miss copying extents into the target device. There are two cases where
the current approach fails. The first one is related to when there are
holes in the device and they get allocated for new block groups while
the device replace operation is iterating the device extents (more on
this explained below). The second one is that when that loop over the
device extents finishes, we start dellaloc, wait for all ordered extents
and then commit the current transaction, we might have got new block
groups allocated that are now using a device extent that has an offset
greater then or equals to the value of the left cursor, in which case
writes to extents belonging to these new block groups will get issued
only to the source device.

For the first case where the current approach of using a left cursor
fails, consider the source device currently has the following layout:

  [ extent bg A ] [ hole, unallocated space ] [extent bg B ]
  3Gb             4Gb                         5Gb

While we are iterating the device extents from the source device using
the commit root of the device tree, the following happens:

        CPU 1                                            CPU 2

                      <we are at transaction N>

  scrub_enumerate_chunks()
    --> searches the device tree for
        extents belonging to the source
        device using the device tree's
        commit root
    --> 1st iteration finds extent belonging to
        block group A

        --> sets block group A to RO mode
            (btrfs_inc_block_group_ro)

        --> sets cursor left to found_key.offset
            which is 3Gb

        --> scrub_chunk() starts
            copies all allocated extents from
            block group's A stripe at source
            device into target device

                                                           btrfs_alloc_chunk()
                                                             --> allocates device extent
                                                                 in the range [4Gb, 5Gb[
                                                                 from the source device for
                                                                 a new block group C

                                                           extent allocated from block
                                                           group C for a direct IO,
                                                           buffered write or btree node/leaf

                                                           extent is written to, perhaps
                                                           in response to a writepages()
                                                           call from the VM or directly
                                                           through direct IO

                                                           the write is made only against
                                                           the source device and not against
                                                           the target device because the
                                                           extent's offset is in the interval
                                                           [4Gb, 5Gb[ which is larger then
                                                           the value of cursor_left (3Gb)

        --> scrub_chunks() finishes

        --> updates left cursor from 3Gb to
            4Gb

        --> btrfs_dec_block_group_ro() sets
            block group A back to RW mode

                             <we are still at transaction N>

    --> 2nd iteration finds extent belonging to
        block group B - it did not find the new
        extent in the range [4Gb, 5Gb[ for block
        group C because we are using the device
        tree's commit root or even because the
        block group's items are not all yet
        inserted in the respective btrees, that is,
        the block group is still attached to some
        transaction handle's new_bgs list and
        btrfs_create_pending_block_groups() was
        not called yet against that transaction
        handle, so the device extent items were
        not yet inserted into the devices tree

                             <we are still at transaction N>

        --> so we end not copying anything from the newly
            allocated device extent from the source device
            to the target device

So fix this by making __btrfs_map_block() always redirect writes to the
target device as well, independently of the left cursor's value. With
this change the left cursor is now used only for the purpose of tracking
progress and allow a mount operation to resume a device replace.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 683e2bd..1724c418 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5729,20 +5729,17 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			}
 		}
 		if (found) {
-			if (physical_of_found + map->stripe_len <=
-			    dev_replace->cursor_left) {
-				struct btrfs_bio_stripe *tgtdev_stripe =
-					bbio->stripes + num_stripes;
+			struct btrfs_bio_stripe *tgtdev_stripe =
+				bbio->stripes + num_stripes;
 
-				tgtdev_stripe->physical = physical_of_found;
-				tgtdev_stripe->length =
-					bbio->stripes[index_srcdev].length;
-				tgtdev_stripe->dev = dev_replace->tgtdev;
-				bbio->tgtdev_map[index_srcdev] = num_stripes;
+			tgtdev_stripe->physical = physical_of_found;
+			tgtdev_stripe->length =
+				bbio->stripes[index_srcdev].length;
+			tgtdev_stripe->dev = dev_replace->tgtdev;
+			bbio->tgtdev_map[index_srcdev] = num_stripes;
 
-				tgtdev_indexes++;
-				num_stripes++;
-			}
+			tgtdev_indexes++;
+			num_stripes++;
 		}
 	}
 
-- 
2.7.0.rc3


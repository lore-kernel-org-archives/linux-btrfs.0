Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45561 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdFEPhx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 11:37:53 -0400
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: [PATCH] Btrfs: Improve btrfs_ioctl_search_key documentation
Date: Mon,  5 Jun 2017 17:27:33 +0200
Message-Id: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A programmer who is trying to implement calling the btrfs SEARCH
or SEARCH_V2 ioctl will probably soon end up reading this struct
definition.

Properly document the input fields to prevent common misconceptions:
 1. The search space is linear, not 3 dimensional.
 2. The transaction id (a.k.a. generation) filter applies only on
 transaction id of the last COW operation on a whole metadata page, not
 on individual items.

Ad 1. The first misunderstanding was helped by the previous misleading
comments on min/max type and offset: "keys returned will be
>= min and <= max".

Ad 2. For example, running btrfs balance will happily cause rewriting of
metadata pages that contain a filesystem tree of a read only subvolume,
causing transids to be increased.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 include/uapi/linux/btrfs.h | 63 +++++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index a456e5309238..864ad86c5d80 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -427,30 +427,53 @@ struct btrfs_ioctl_ino_lookup_args {
 };
 
 struct btrfs_ioctl_search_key {
-	/* which root are we searching.  0 is the tree of tree roots */
-	__u64 tree_id;
-
-	/* keys returned will be >= min and <= max */
-	__u64 min_objectid;
-	__u64 max_objectid;
-
-	/* keys returned will be >= min and <= max */
-	__u64 min_offset;
-	__u64 max_offset;
-
-	/* max and min transids to search for */
-	__u64 min_transid;
-	__u64 max_transid;
+	/*
+	 * The tree we're searching in. 1 is the tree of tree roots, 2 is the
+	 * extent tree, etc...
+	 */
+	__u64 tree_id;	/* in */
 
-	/* keys returned will be >= min and <= max */
-	__u32 min_type;
-	__u32 max_type;
+	/*
+	 * This struct is used to provide the search key range for the SEARCH and
+	 * SEARCH_V2 ioctls.
+	 *
+	 * When doing a tree search, we're actually taking a slice from a linear
+	 * search space of 136-bit keys:
+	 *
+	 * Key of the first possible item to be returned:
+	 *   (min_objectid << 72) + (min_type << 64) + min_offset
+	 * Key of the last possible item to be returned:
+	 *   (max_objectid << 72) + (max_type << 64) + max_offset
+	 *
+	 * All of the min/max input numbers only define the ultimate lower and
+	 * upper boundary of the keys of items that will be returned. In other
+	 * words, they are not used to filter the type or offset of intermediate
+	 * keys encountered.
+	 *
+	 * Additionally, we can filter the items returned on transaction id of the
+	 * metadata block they're stored in by specifying a transid range.  Be
+	 * aware that this transaction id only denotes when the metadata page that
+	 * currently contains the item got written the last time as result of a COW
+	 * operation.  The number does not have any meaning related to the
+	 * transaction in which an individual item that is being returned was
+	 * created or changed.
+	 */
+	__u64 min_objectid;	/* in */
+	__u64 max_objectid;	/* in */
+	__u64 min_offset;	/* in */
+	__u64 max_offset;	/* in */
+	__u64 min_transid;	/* in */
+	__u64 max_transid;	/* in */
+	__u32 min_type;	/* in */
+	__u32 max_type;	/* in */
 
 	/*
-	 * how many items did userland ask for, and how many are we
-	 * returning
+	 * input: The maximum amount of results desired.
+	 * output: The actual amount of items returned, restricted by either
+	 *   stopping the search when reaching the input nr_items amount of items,
+	 *   or restricted by the size of the supplied memory buffer.
 	 */
-	__u32 nr_items;
+	__u32 nr_items;	/* in/out */
 
 	/* align to 64 bits */
 	__u32 unused;
-- 
2.11.0


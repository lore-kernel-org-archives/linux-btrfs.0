Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45565 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdFEWUi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 18:20:38 -0400
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs@vger.kernel.org
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: [PATCH v2] Btrfs: btrfs_ioctl_search_key documentation
Date: Tue,  6 Jun 2017 00:20:32 +0200
Message-Id: <20170605222032.9207-1-hans.van.kranenburg@mendix.com>
In-Reply-To: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
References: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A programmer who is trying to implement calling the btrfs SEARCH
or SEARCH_V2 ioctl will probably soon end up reading this struct
definition.

Properly document the input fields to prevent common misconceptions:
 1. The search space is linear, not 3 dimensional. The invidual min/max
 values for objectid, type and offset cannot be used to filter the
 result, they only define the endpoints of an interval.
 2. The transaction id (a.k.a. generation) filter applies only on
 transaction id of the last COW operation on a whole metadata page, not
 on individual items.

Ad 1. The first misunderstanding was helped by the previous misleading
comments on min/max type and offset:
  "keys returned will be >= min and <= max".

Ad 2. For example, running btrfs balance will happily cause rewriting of
metadata pages that contain a filesystem tree of a read only subvolume,
causing transids to be increased.

Also, improve descriptions of tree_id and nr_items and add in/out
annotations.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---

Most interesting changes since v1:
 - mention the special tree_id input value 0
 - rewrite the part about min_key and max_key, trying to be more concise

Less interesting changes since v1:
 - the first line of the commit message was 51 characters long
 - a > ended up at the beginning of the line in the commit message, messing up
   the >= notation in some mail programs

 include/uapi/linux/btrfs.h | 62 +++++++++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index a456e5309238..88ae3d096a21 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -426,31 +426,53 @@ struct btrfs_ioctl_ino_lookup_args {
 	char name[BTRFS_INO_LOOKUP_PATH_MAX];
 };
 
+/* Search criteria for the btrfs SEARCH ioctl family. */
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
+	 *
+	 * A special tree_id value of 0 will cause a search in the subvolume tree
+	 * that the inode which is passed to the ioctl is part of.
+	 */
+	__u64 tree_id;	/* in */
 
-	/* keys returned will be >= min and <= max */
-	__u32 min_type;
-	__u32 max_type;
+	/*
+	 * When doing a tree search, we're actually taking a slice from a linear
+	 * search space of 136-bit keys.
+	 *
+	 * A full 136-bit tree key is composed as:
+	 *   (objectid << 72) + (type << 64) + offset
+	 *
+	 * The individual min and max values for objectid, type and offset define
+	 * the min_key and max_key values for the search range. All metadata items
+	 * with a key in the interval [min_key, max_key] will be returned.
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
+	 * output: The actual amount of items returned, restricted by any of:
+	 *  - reaching the upper bound of the search range
+	 *  - reaching the input nr_items amount of items
+	 *  - completely filling the supplied memory buffer
 	 */
-	__u32 nr_items;
+	__u32 nr_items;	/* in/out */
 
 	/* align to 64 bits */
 	__u32 unused;
-- 
2.11.0


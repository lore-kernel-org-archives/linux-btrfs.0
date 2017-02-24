Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13082 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750937AbdBXF4G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 00:56:06 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH v2 3/9] btrfs-progs: convert: Add comment for the overall convert workflow
Date: Fri, 24 Feb 2017 13:52:26 +0800
Message-ID: <20170224055232.4140-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
References: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert is now a little complex due to that fact we need to separate
meta and data chunks for different profiles.

Add a comment with ascii art explaining the whole workflow and points
out the really complex part, so any newcomers interested in convert can
get a quick overview of it before digging into the hard to read code.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/convert/main.c b/convert/main.c
index 8d9f29fa..26356e8a 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -16,6 +16,63 @@
  * Boston, MA 021110-1307, USA.
  */
 
+/*
+ * btrfs convert design:
+ * The overall design of btrfs convert is like the following:
+ * |<------------------Old fs----------------------------->|
+ * |<- used ->| |<- used ->|                    |<- used ->|
+ *                           ||
+ *                           \/
+ * |<---------------Btrfs fs------------------------------>|
+ * |<-   Old data chunk  ->|< new chunk (D/M/S)>|<- ODC  ->|
+ * |<-Old-FE->| |<-Old-FE->|<- Btrfs extents  ->|<-Old-FE->|
+ *
+ * ODC    = Old data chunk, btrfs chunks containing old fs data
+ *          Mapped 1:1 (logical address == device offset)
+ * Old-FE = file extents points to old fs.
+ *
+ * So old fs used space is (mostly) kept as is, while btrfs will insert
+ * its chunk(Data/Meta/Sys) into large enough free space.
+ * In this way, we can create different profiles for meta/data for converted fs.
+ *
+ * The DIRTY work is, we must reserve and relocate 3 ranges for btrfs:
+ * [0, 1M), [btrfs_sb_offset(1), +64K), [btrfs_sb_offset(2), +64K)
+ *
+ * Most work are spent handling corner cases around these reserved ranges.
+ *
+ * Detailed workflow is:
+ * 1)   Scan old fs used space and calculate data chunk layout
+ * 1.1) Scan old fs
+ *      We can a map of used space of old fs
+ *
+ * 1.2) Calculate data chunk layout <<< Complex work
+ *      New data chunks must meet 3 conditions using result fomr 1.1)
+ *      a. Large enough to be a chunk
+ *      b. Doesn't cover reserved ranges
+ *      c. Covers all the remaining old fs used space
+ *
+ *      XXX: This can be simplified if we don't need to handle backup supers 
+ *
+ * 1.3) Calculate usable space for btrfs new chunks
+ *      Btrfs chunk usable space must meet 3 conditions using result from 1.2)
+ *      a. Large enough to be a chunk
+ *      b. Doesn't cover reserved ranges
+ *      c. Doesn't cover any data chunks in 1.1)
+ *
+ * 2)   Create basic btrfs
+ *      Initial metadata and sys chunks are inserted in the first availabe
+ *      space of result of 1.3)
+ *      Then insert all data chunks into the basic btrfs
+ *
+ * 3)   Create convert image
+ *      We need to relocate reserved ranges here.
+ *      After this step, the convert image is done, and we can use the image
+ *      as reflink source to create old files
+ *
+ * 4)   Iterate old fs to create files
+ *      We just reflink any offset in old fs to new file extents
+ */
+
 #include "kerncompat.h"
 
 #include <sys/ioctl.h>
@@ -276,6 +333,9 @@ static void init_blk_iterate_data(struct blk_iterate_data *data,
  * The special point is, old disk_block can point to a reserved range.
  * So here, we don't use disk_block directly but search convert_root
  * to get the real disk_bytenr.
+ *
+ * XXX: Better extract this function as btrfs_reflink(), as in fact we are
+ * just reflinking from convert_image.
  */
 static int record_file_blocks(struct blk_iterate_data *data,
 			      u64 file_block, u64 disk_block, u64 num_blocks)
-- 
2.11.1




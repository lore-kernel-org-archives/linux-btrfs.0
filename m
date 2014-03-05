Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:33790 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754034AbaCEAM1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Mar 2014 19:12:27 -0500
Date: Wed, 5 Mar 2014 02:12:23 +0200
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: remove unused variable and update btrfs-image
 man page
Message-ID: <20140305001222.GA4418@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove unused variable in btrfs-image.c (update_super) and update man
page documentation about -r option. Running btrfsck on a restored
image produces missing chunk information. This is because by default,
btrfs-image fixes up chunk tree to use 1 stripe pointing to the
primary device. This in turns results in btrfsck making some noise.

$  ./mkfs.btrfs /dev/sdb2 -f
$  ./btrfs-image /dev/sdb2 btrfs_image_output
$  ./btrfs-image -r btrfs_image_output disk-image
$  ./btrfsck disk-image

Device extent[1, 29360128, 8388608] didn't find the relative chunk.
Device extent[1, 1111490560, 1073741824] didn't find the relative chunk.

Ideally btfsck should be updated to reflect this default behavior and
not through these messages, but it isn't harmful and can be done
later.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 btrfs-image.c        | 3 ---
 man/btrfs-image.8.in | 5 ++++-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index c3a7fe5..cc8627c 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1373,7 +1373,6 @@ static int update_super(u8 *buffer)
 	u32 new_array_size = 0;
 	u32 array_size;
 	u32 cur = 0;
-	u32 new_cur = 0;
 	u8 *ptr, *write_ptr;
 	int old_num_stripes;
 
@@ -1390,7 +1389,6 @@ static int update_super(u8 *buffer)
 		write_ptr += sizeof(*disk_key);
 		ptr += sizeof(*disk_key);
 		cur += sizeof(*disk_key);
-		new_cur += sizeof(*disk_key);
 
 		if (key.type == BTRFS_CHUNK_ITEM_KEY) {
 			chunk = (struct btrfs_chunk *)ptr;
@@ -1406,7 +1404,6 @@ static int update_super(u8 *buffer)
 			memcpy(chunk->stripe.dev_uuid, super->dev_item.uuid,
 			       BTRFS_UUID_SIZE);
 			new_array_size += sizeof(*chunk);
-			new_cur += sizeof(*chunk);
 		} else {
 			fprintf(stderr, "Bogus key in the sys chunk array "
 				"%d\n", key.type);
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
index d5ba594..3f51f3f 100644
--- a/man/btrfs-image.8.in
+++ b/man/btrfs-image.8.in
@@ -17,7 +17,10 @@ is the image file that btrfs-image creates. When used with \fB-r\fP option,
 .SH OPTIONS
 .TP
 \fB\-r\fP
-restore metadump image.
+Restore metadump image. By default, this fixes super's chunk tree, by
+using 1 stripe pointing to primary device, so that file system can be
+restored by running tree log reply if possible. To restore without
+changing number of stripes in chunk tree check \fB-o\fP option.
 .TP
 \fB\-c\fR \fIvalue\fP
 compression level (0 ~ 9).
-- 
1.8.5.3


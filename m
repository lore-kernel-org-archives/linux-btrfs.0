Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15597 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756385AbbHZOFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 10:05:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7QE59x6026804
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 22:05:09 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: Simplify memory allocation for enumerate_dead_subvols
Date: Wed, 26 Aug 2015 22:03:37 +0800
Message-ID: <a35e7055905a4407f144f7515b058be66125f7ac.1440597812.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
References: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need prepare memory for enumerate_dead_subvols() in caller, and pass
additional argument for allocated length.

Just do every thing inside enumerate_dead_subvols(), it will not
increase malloc count, but make code simple.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-subvolume.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8e8d019..0d83bd5 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -1169,12 +1169,13 @@ again:
  * Enumerate all dead subvolumes that exist in the filesystem.
  * Fill @ids and reallocate to bigger size if needed.
  */
-static int enumerate_dead_subvols(int fd, int count, u64 **ids)
+static int enumerate_dead_subvols(int fd, u64 **ids)
 {
 	int ret;
 	struct btrfs_ioctl_search_args args;
 	struct btrfs_ioctl_search_key *sk = &args.key;
 	int idx = 0;
+	int count = 0;
 
 	memset(&args, 0, sizeof(args));
 
@@ -1189,6 +1190,7 @@ static int enumerate_dead_subvols(int fd, int count, u64 **ids)
 	sk->max_transid = (u64)-1;
 	sk->nr_items = 4096;
 
+	*ids = NULL;
 	while (1) {
 		struct btrfs_ioctl_search_header *sh;
 		unsigned long off;
@@ -1207,8 +1209,6 @@ static int enumerate_dead_subvols(int fd, int count, u64 **ids)
 			off += sizeof(*sh);
 
 			if (sh->type == BTRFS_ORPHAN_ITEM_KEY) {
-				(*ids)[idx] = sh->offset;
-				idx++;
 				if (idx >= count) {
 					u64 *newids;
 
@@ -1218,6 +1218,8 @@ static int enumerate_dead_subvols(int fd, int count, u64 **ids)
 						return -ENOMEM;
 					*ids = newids;
 				}
+				(*ids)[idx] = sh->offset;
+				idx++;
 			}
 			off += sh->len;
 
@@ -1284,14 +1286,7 @@ static int cmd_subvol_sync(int argc, char **argv)
 
 	id_count = argc - optind;
 	if (!id_count) {
-		id_count = SUBVOL_ID_BATCH;
-		ids = (u64*)malloc(id_count * sizeof(u64));
-		if (!ids) {
-			fprintf(stderr, "ERROR: not enough memory\n");
-			ret = 1;
-			goto out;
-		}
-		id_count = enumerate_dead_subvols(fd, id_count, &ids);
+		id_count = enumerate_dead_subvols(fd, &ids);
 		if (id_count < 0) {
 			fprintf(stderr, "ERROR: can't enumerate dead subvolumes: %s\n",
 					strerror(-id_count));
-- 
1.8.5.1


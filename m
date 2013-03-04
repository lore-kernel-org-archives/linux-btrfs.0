Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:57007 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3CDBgu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 20:36:50 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Sun, 3 Mar 2013 18:36:49 -0700
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id BFA6B1FF0039
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2013 18:31:54 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r241alfO109138
	for <linux-btrfs@vger.kernel.org>; Sun, 3 Mar 2013 18:36:47 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r241akaa003802
	for <linux-btrfs@vger.kernel.org>; Sun, 3 Mar 2013 18:36:46 -0700
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] btrfs-progs: update mkfs.btrfs help info for raid5/6
Date: Mon,  4 Mar 2013 09:37:28 +0800
Message-Id: <1362361048-30744-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Since raid5/6 support was introduced, we should update mkfs.btrfs help info.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index 5ece186..f9f26a5 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -326,7 +326,7 @@ static void print_usage(void)
 	fprintf(stderr, "options:\n");
 	fprintf(stderr, "\t -A --alloc-start the offset to start the FS\n");
 	fprintf(stderr, "\t -b --byte-count total number of bytes in the FS\n");
-	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid10, dup or single\n");
+	fprintf(stderr, "\t -d --data data profile, raid0, raid1, raid5, raid6, raid10, dup or single\n");
 	fprintf(stderr, "\t -l --leafsize size of btree leaves\n");
 	fprintf(stderr, "\t -L --label set a label\n");
 	fprintf(stderr, "\t -m --metadata metadata profile, values like data profile\n");
-- 
1.7.11.7


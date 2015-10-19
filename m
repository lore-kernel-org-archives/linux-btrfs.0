Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34431 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbJSLng (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:43:36 -0400
Received: by padhk11 with SMTP id hk11so28173252pad.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:43:36 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 04/10] btrfs-progs: return -EIO properly in restore_metadump()
Date: Mon, 19 Oct 2015 19:37:54 +0800
Message-Id: <1445254680-11102-5-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Error number -EIO is assigned to ret but later ret is overwritten by
wait_for_worker().

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 btrfs-image.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 82eed05..7d3a2f8 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2465,6 +2465,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	u64 bytenr = 0;
 	FILE *in = NULL;
 	int ret = 0;
+	int err = 0;
 
 	if (!strcmp(input, "-")) {
 		in = stdin;
@@ -2526,7 +2527,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 		if (le64_to_cpu(header->magic) != HEADER_MAGIC ||
 		    le64_to_cpu(header->bytenr) != bytenr) {
 			fprintf(stderr, "bad header in metadump image\n");
-			ret = -EIO;
+			err = -EIO;
 			break;
 		}
 		ret = add_cluster(cluster, &mdrestore, &bytenr);
@@ -2536,6 +2537,8 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 		}
 	}
 	ret = wait_for_worker(&mdrestore);
+	if (!ret)
+		ret = err;
 
 	if (!ret && !multi_devices && !old_restore) {
 		struct btrfs_root *root;
-- 
2.4.3


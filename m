Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19874 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752928AbaB0P1C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 10:27:02 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s1RFR08D017390
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:27:01 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1j9pwuuef0-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:27:00 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make sure to save mirror_num only if it is set
Date: Thu, 27 Feb 2014 10:25:49 -0500
Message-ID: <1393514749-28795-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we are cycling through all of the mirrors trying to find the best one we need
to make sure we set best_mirror to an actual mirror number and not 0.  Otherwise
we could end up reading a mirror that wasn't the best and make everybody sad.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index e840177..0bd1bb0 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -297,7 +297,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 			ignore = 1;
 			continue;
 		}
-		if (btrfs_header_generation(eb) > best_transid) {
+		if (btrfs_header_generation(eb) > best_transid && mirror_num) {
 			best_transid = btrfs_header_generation(eb);
 			good_mirror = mirror_num;
 		}
-- 
1.8.3.1


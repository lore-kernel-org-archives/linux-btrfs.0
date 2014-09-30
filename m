Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11283 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750939AbaI3U4J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 16:56:09 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8UKrlxd005862
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 13:56:08 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pr10cru5j-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 13:56:08 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: check all slots in leaves
Date: Tue, 30 Sep 2014 16:56:05 -0400
Message-ID: <1412110565-7889-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's an off by one error in btrfs_check_leaf, we should be going to nritems -
1, not nritems - 2, we were missing problems with items in the very last slot.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.c b/ctree.c
index 9e5b30f..c085941 100644
--- a/ctree.c
+++ b/ctree.c
@@ -494,7 +494,7 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 		       (unsigned long long)btrfs_header_bytenr(buf));
 		goto fail;
 	}
-	for (i = 0; nritems > 1 && i < nritems - 2; i++) {
+	for (i = 0; nritems > 1 && i < nritems - 1; i++) {
 		btrfs_item_key(buf, &key, i);
 		btrfs_item_key_to_cpu(buf, &cpukey, i + 1);
 		if (btrfs_comp_keys(&key, &cpukey) >= 0) {
-- 
1.8.3.1


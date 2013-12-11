Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54259 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809Ab3LKQSN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 11:18:13 -0500
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBBGICuD000763
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 08:18:12 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0b-00082601.pphosted.com with ESMTP id 1gptvn03uv-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 08:18:12 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: reset balance before reiniting extent root
Date: Wed, 11 Dec 2013 11:17:52 -0500
Message-ID: <1386778672-15357-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we re-init the extent root we make it completely empty, so when we reset a
pending balance we will fail to find refs for any blocks we may cow, which will
result in errors and we will exit out.  We need to reset the balance first so
the normal cow stuff doesn't freak out and then we can re-init the extent tree.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b27154f..7f07d3b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5931,6 +5931,12 @@ static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
 		return ret;
 	}
 
+	ret = reset_balance(trans, fs_info);
+	if (ret) {
+		fprintf(stderr, "error reseting the pending balance\n");
+		return ret;
+	}
+
 	/* Ok we can allocate now, reinit the extent root */
 	ret = btrfs_fsck_reinit_root(trans, fs_info->extent_root, 0);
 	if (ret) {
@@ -5943,12 +5949,6 @@ static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
 		return ret;
 	}
 
-	ret = reset_balance(trans, fs_info);
-	if (ret) {
-		fprintf(stderr, "error reseting the pending balance\n");
-		return ret;
-	}
-
 	/*
 	 * Now we have all the in-memory block groups setup so we can make
 	 * allocations properly, and the metadata we care about is safe since we
-- 
1.8.3.1


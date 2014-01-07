Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22195 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbaAGUel (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 15:34:41 -0500
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s07KVqGa021145
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Jan 2014 12:34:40 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0a-00082601.pphosted.com with ESMTP id 1h80sf5k4w-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Jan 2014 12:34:40 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: bail if we find errors in the extent tree
Date: Tue, 7 Jan 2014 15:34:21 -0500
Message-ID: <1389126861-31257-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For some reason we weren't exiting if there were errors in the extent tree,
which means we could have errors in just the extent tree and things like
xfstests would keep going because we completely throw away the return value.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 689fe6c..cbabfdc 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6409,8 +6409,10 @@ int cmd_check(int argc, char **argv)
 		goto out;
 	}
 	ret = check_chunks_and_extents(root);
-	if (ret)
+	if (ret) {
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
+		goto out;
+	}
 
 	fprintf(stderr, "checking free space cache\n");
 	ret = check_space_cache(root);
-- 
1.8.3.1


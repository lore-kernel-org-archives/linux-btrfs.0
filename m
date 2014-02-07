Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14955 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751301AbaBGRWh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 12:22:37 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s17HJA8V014818
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Feb 2014 09:22:36 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0b-00082601.pphosted.com with ESMTP id 1hvyc4gu2n-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 09:22:36 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: unlock extent and pages on error in cow_file_range
Date: Fri, 7 Feb 2014 12:22:33 -0500
Message-ID: <1391793753-2194-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When I converted the BUG_ON() for the free_space_cache_inode in cow_file_range I
made it so we just return an error instead of unlocking all of our various
stuff.  This is a mistake and causes us to hang when we run into this.  This
patch fixes this problem.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d44ff9f..dbd996a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -864,7 +864,8 @@ static noinline int cow_file_range(struct inode *inode,
 
 	if (btrfs_is_free_space_inode(inode)) {
 		WARN_ON_ONCE(1);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
 	num_bytes = ALIGN(end - start + 1, blocksize);
-- 
1.8.3.1


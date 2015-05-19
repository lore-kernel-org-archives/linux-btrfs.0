Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41353 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbbESOoJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 10:44:09 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t4JEhEjg029930
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 07:44:07 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1ug6ug82wy-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 07:44:07 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: set UNWRITTEN for prealloc'ed extents in fiemap
Date: Tue, 19 May 2015 10:44:04 -0400
Message-ID: <1432046644-6981-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should be doing this, it's weird we hadn't been doing this.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c32d226..428930b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4492,6 +4492,8 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		}
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			flags |= FIEMAP_EXTENT_ENCODED;
+		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+			flags |= FIEMAP_EXTENT_UNWRITTEN;
 
 		free_extent_map(em);
 		em = NULL;
-- 
1.8.3.1


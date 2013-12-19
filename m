Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46587 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3LSDMf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 22:12:35 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBJ3CYmv019172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 03:12:35 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBJ3CXBP024909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 03:12:34 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBJ3CXCI024897
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 03:12:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix the warning in prepare_pages
Date: Thu, 19 Dec 2013 11:20:52 +0800
Message-Id: <1387423252-14637-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

would fix the below compile warning

fs/btrfs/file.c: In function ‘prepare_pages’:
fs/btrfs/file.c:1247: warning: ‘err’ may be used uninitialized in this function

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 740ae8c..35bf838 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1244,7 +1244,7 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 	int i;
 	unsigned long index = pos >> PAGE_CACHE_SHIFT;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
-	int err;
+	int err = 0;
 	int faili;
 
 	for (i = 0; i < num_pages; i++) {
-- 
1.7.1


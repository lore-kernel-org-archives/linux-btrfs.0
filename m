Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19434 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbbFQJAT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 05:00:19 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5H90IwQ027010
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:00:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t5H90I0K008635
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:00:18 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t5H90Hh9023442
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:00:18 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix warning of bytes_may_use
Date: Wed, 17 Jun 2015 16:59:58 +0800
Message-Id: <1434531598-8607-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1434531598-8607-1-git-send-email-bo.li.liu@oracle.com>
References: <1434531598-8607-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While running generic/019, dmesg got several warnings from
btrfs_free_reserved_data_space().

Test generic/019 produces some disk failures so sumbit dio will get errors,
in which case, btrfs_direct_IO() goes to the error handling and free
bytes_may_use, but the problem is that bytes_may_use has been free'd
during get_block().

This adds a runtime flag to show if we've gone through get_block(), if so,
don't do the cleanup work.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/btrfs_inode.h |  2 ++
 fs/btrfs/inode.c       | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0ef5cc1..81220b2 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -44,6 +44,8 @@
 #define BTRFS_INODE_IN_DELALLOC_LIST		9
 #define BTRFS_INODE_READDIO_NEED_LOCK		10
 #define BTRFS_INODE_HAS_PROPS		        11
+/* DIO is ready to submit */
+#define BTRFS_INODE_DIO_READY		        12
 /*
  * The following 3 bits are meant only for the btree inode.
  * When any of them is set, it means an error happened while writing an
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7bf150a..438b56f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7530,6 +7530,7 @@ unlock:
 
 		current->journal_info = outstanding_extents;
 		btrfs_free_reserved_data_space(inode, len);
+		set_bit(BTRFS_INODE_DIO_READY, &BTRFS_I(inode)->runtime_flags);
 	}
 
 	/*
@@ -8311,9 +8312,18 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 				   btrfs_submit_direct, flags);
 	if (iov_iter_rw(iter) == WRITE) {
 		current->journal_info = NULL;
-		if (ret < 0 && ret != -EIOCBQUEUED)
-			btrfs_delalloc_release_space(inode, count);
-		else if (ret >= 0 && (size_t)ret < count)
+		if (ret < 0 && ret != -EIOCBQUEUED) {
+			/*
+			 * If the error comes from submitting stage,
+			 * btrfs_get_blocsk_direct() has free'd data space,
+			 * and metadata space will be handled by
+			 * finish_ordered_fn, don't do that again to make
+			 * sure bytes_may_use is correct.
+			 */
+			if (!test_and_clear_bit(BTRFS_INODE_DIO_READY,
+				     &BTRFS_I(inode)->runtime_flags))
+				btrfs_delalloc_release_space(inode, count);
+		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode,
 						     count - (size_t)ret);
 	}
-- 
2.1.0


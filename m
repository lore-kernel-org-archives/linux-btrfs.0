Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31660 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbbCEIsq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 03:48:46 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t258mjlo023239
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 08:48:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t258miWU013152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 08:48:44 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t258mihT023572
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 08:48:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix data loss of fsync
Date: Thu,  5 Mar 2015 16:48:27 +0800
Message-Id: <1425545307-3721-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This problem is uncovered by a test case: http://patchwork.ozlabs.org/patch/244297.

Fsync() can report success when it actually doesn't.  When we
have several threads running fsync() at the same tiem and in one fsync() we
get a transaction abortion due to some problems(in the test case it's disk
failures), and other fsync()s may return successfully which makes userspace
programs think that data is now safely flushed into disk.

It's because that after fsyncs() fail btrfs_sync_log() due to disk failures,
they get to try btrfs_commit_transaction() where it finds that there is
already a transaction being committed, and they'll just call wait_for_commit()
and return.  Note that we actually check "trans->aborted" in btrfs_end_transaction,
but it's likely that the error message is still not yet throwed out and only after
wait_for_commit() we're sure whether the transaction is committed successfully.

This add the necessary check and it now passes the test.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/transaction.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7e80f32..bd7ea86 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1814,6 +1814,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 		wait_for_commit(root, cur_trans);
 
+		if (unlikely(ACCESS_ONCE(cur_trans->aborted)))
+			ret = cur_trans->aborted;
+
 		btrfs_put_transaction(cur_trans);
 
 		return ret;
-- 
1.8.1.4


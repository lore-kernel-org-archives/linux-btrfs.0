Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbbCEKg6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Mar 2015 05:36:58 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t25Aavus026342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 10:36:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t25AavQR020156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 10:36:57 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t25AavYj007050
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 10:36:57 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2] Btrfs: catch transaction abortion after waiting for it
Date: Thu,  5 Mar 2015 18:36:45 +0800
Message-Id: <1425551805-7314-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1425545307-3721-1-git-send-email-bo.li.liu@oracle.com>
References: <1425545307-3721-1-git-send-email-bo.li.liu@oracle.com>
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
v2: Use a more generic title since it's not only for fsync, but for others.

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


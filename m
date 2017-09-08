Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34339 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757154AbdIHWhV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 18:37:21 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v88MbKtk029381
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Sep 2017 22:37:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v88MbJJ6000781
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Sep 2017 22:37:19 GMT
Received: from ubhmp0006.oracle.com (ubhmp0006.oracle.com [156.151.24.59])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v88MbJAC029410
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Sep 2017 22:37:19 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] Btrfs: fix confusing worker helper info
Date: Fri,  8 Sep 2017 15:34:45 -0600
Message-Id: <20170908213445.1601-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've seen the following backtrace stack in ftrace or dmesg log,

  kworker/u16:10-4244  [000] 241942.480955: function:             btrfs_put_ordered_extent
  kworker/u16:10-4244  [000] 241942.480956: kernel_stack:         <stack trace>
=> finish_ordered_fn (ffffffffa0384475)
=> btrfs_scrubparity_helper (ffffffffa03ca577)
=> btrfs_freespace_write_helper (ffffffffa03ca98e)
=> process_one_work (ffffffff81117b2f)
=> worker_thread (ffffffff81118c2a)
=> kthread (ffffffff81121de0)
=> ret_from_fork (ffffffff81d7087a)

btrfs_scrubparity_helper really shouldn't be shown up.

It's caused by compiler doing inline for our helper function, adding a
noinline tag can fix that.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/async-thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index ff0b0be..593709a 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -67,7 +67,7 @@ struct btrfs_workqueue {
 static void normal_work_helper(struct btrfs_work *work);
 
 #define BTRFS_WORK_HELPER(name)					\
-void btrfs_##name(struct work_struct *arg)				\
+noinline void btrfs_##name(struct work_struct *arg)			\
 {									\
 	struct btrfs_work *work = container_of(arg, struct btrfs_work,	\
 					       normal_work);		\
-- 
2.9.4


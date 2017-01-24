Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750831AbdAXJBz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 04:01:55 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0O8wcIj068595
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 04:01:54 -0500
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28612we5bw-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 04:01:54 -0500
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 24 Jan 2017 09:01:53 -0000
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Chris Mason <clm@fb.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 2/2] btrfs: add lockdep annotation for btrfs_log_inode
Date: Tue, 24 Jan 2017 10:01:47 +0100
In-Reply-To: <1485248507-6079-1-git-send-email-borntraeger@de.ibm.com>
References: <20161126134638.GA79987@clm-mbp.masoncoding.com>
 <1485248507-6079-1-git-send-email-borntraeger@de.ibm.com>
Message-Id: <1485248507-6079-2-git-send-email-borntraeger@de.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a proper subclass to get rid of the following lockdep
error.

 [ INFO: possible recursive locking detected ]
 4.9.0+ #279 Not tainted
 ---------------------------------------------
 vim/4801 is trying to acquire lock:
  (&ei->log_mutex){+.+...}, at: [<000003ff82057592>]
btrfs_log_inode+0x182/0xfa8 [btrfs]

  (&ei->log_mutex){+.+...}, at: [<000003ff82057592>]
btrfs_log_inode+0x182/0xfa8 [btrfs]

  Possible unsafe locking scenario:
        CPU0
        ----
   lock(&ei->log_mutex);
   lock(&ei->log_mutex);

                                 *** DEADLOCK ***
  May be due to missing lock nesting notation
 3 locks held by vim/4801:
  #0:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at: [<000003ff81fc274c>]
btrfs_sync_file+0x204/0x728 [btrfs]
  #1:  (sb_internal#2){.+.+..}, at: [<000003ff81fa38e0>]
start_transaction+0x318/0x770 [btrfs]
  #2:  (&ei->log_mutex){+.+...}, at: [<000003ff82057592>]

[...]
 Call Trace:
 ([<0000000000115ffc>] show_trace+0xe4/0x108)
  [<00000000001160f8>] show_stack+0x68/0xe0
  [<0000000000652d52>] dump_stack+0x9a/0xd8
  [<0000000000209bb0>] __lock_acquire+0xac8/0x1bd0
  [<000000000020b3c6>] lock_acquire+0x106/0x4a0
  [<0000000000a1fb36>] mutex_lock_nested+0xa6/0x428
  [<000003ff82057592>] btrfs_log_inode+0x182/0xfa8 [btrfs]
  [<000003ff82057c76>] btrfs_log_inode+0x866/0xfa8 [btrfs]
  [<000003ff81ffe278>] btrfs_log_inode_parent+0x218/0x988 [btrfs]
  [<000003ff81ffffaa>] btrfs_log_dentry_safe+0x7a/0xa0 [btrfs]
  [<000003ff81fc29b6>] btrfs_sync_file+0x46e/0x728 [btrfs]
  [<000000000044aeee>] do_fsync+0x5e/0x90
  [<000000000044b2ba>] SyS_fsync+0x32/0x40
  [<0000000000a26786>] system_call+0xd6/0x288

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 3d33c4e..a3ec717 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4648,7 +4648,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	mutex_lock(&BTRFS_I(inode)->log_mutex);
+	mutex_lock_nested(&BTRFS_I(inode)->log_mutex, inode_only);
 
 	/*
 	 * a brute force approach to making sure we get the most uptodate
-- 
2.7.4


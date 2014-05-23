Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20991 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaEWCrP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 22:47:15 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, sandeen@redhat.com, rm@romanrm.net,
        koen@dominion.thruhere.net
Subject: [PATCH 2/2 v4] btrfs: usage error should not be logged into system log
Date: Fri, 23 May 2014 10:50:02 +0800
Message-Id: <1400813402-27474-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1400813402-27474-1-git-send-email-anand.jain@oracle.com>
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
 <1400813402-27474-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

I have an opinion that system logs under /var/log/ are
valuable info to investigate the real system issues at
the data center. People handling data center issues
do spend a lot time and efforts analyzing messages
files. Having usage error logged into system log is
something we should avoid.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 v4: commit reword. Thanks Koen
 v3: rebase again
 v2: rebase

 fs/btrfs/sysfs.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index e12e2be..522d023 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -381,11 +381,8 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	 */
 	p_len = strcspn(buf, "\n");
 
-	if (p_len >= BTRFS_LABEL_SIZE) {
-		pr_err("BTRFS: unable to set label with more than %d bytes\n",
-		       BTRFS_LABEL_SIZE - 1);
+	if (p_len >= BTRFS_LABEL_SIZE)
 		return -EINVAL;
-	}
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans))
-- 
1.7.1


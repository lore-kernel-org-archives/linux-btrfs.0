Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36833 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaANLH4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 06:07:56 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s0EB7tF4021084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 11:07:56 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0EB7sXX020696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 11:07:55 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s0EB7sre022378
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 11:07:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: mid flight return leaks memory during filesystem show mnt
Date: Tue, 14 Jan 2014 19:17:08 +0800
Message-Id: <1389698228-9580-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1389698228-9580-1-git-send-email-anand.jain@oracle.com>
References: <1389698228-9580-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

since now handle_print()->print_one_fs() calls add_seen_fsid()
the thread has to go through free_seen_fsid()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index ee6cc84..d38fae6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -681,10 +681,11 @@ static int cmd_show(int argc, char **argv)
 			}
 		} else if (type == BTRFS_ARG_MNTPOINT) {
 			char label[BTRFS_LABEL_SIZE];
-			if (get_label_mounted(search, label))
+			ret = get_label_mounted(search, label);
+			if (ret)
 				return 1;
 			handle_print(search, label);
-			return 0;
+			goto out;
 		}
 	}
 
-- 
1.7.1


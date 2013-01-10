Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24894 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3AJLfG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:35:06 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r0ABZ5kf030847
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:05 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r0ABZ4n3005559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:35:04 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r0ABZ4Df032311
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 05:35:04 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/11] Btrfs-progs: put find_mount_root() in commands.h
Date: Thu, 10 Jan 2013 19:41:20 +0800
Message-Id: <1357818083-15531-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1357818083-15531-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 commands.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/commands.h b/commands.h
index 8114a73..9b77f3e 100644
--- a/commands.h
+++ b/commands.h
@@ -103,3 +103,6 @@ int cmd_qgroup(int argc, char **argv);
 
 /* subvolume exported functions */
 int test_issubvolume(char *path);
+
+/* send.c */
+int find_mount_root(const char *path, char **mount_root);
-- 
1.7.1


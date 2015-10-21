Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41501 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbbJUIrg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 04:47:36 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9L8laFw013507
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t9L8lZa1005060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:36 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t9L8lZGo018317
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 2/3] btrfs-progs: kernel based default features for mkfs
Date: Wed, 21 Oct 2015 16:45:48 +0800
Message-Id: <1445417149-804-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs from latest btrfs-progs will enable latest default features,
and if the kernel is down-rev and does not support a latest default
feature then mount fails, as expected.

This patch disables default features based on the running kernel.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mkfs.c b/mkfs.c
index a5802f7..2b9d734 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1357,10 +1357,13 @@ int main(int ac, char **av)
 	int dev_cnt = 0;
 	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
-	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 features;
 	struct mkfs_allocation allocation = { 0 };
 	struct btrfs_mkfs_config mkfs_cfg;
 
+	features = btrfs_features_allowed_by_kernel();
+	features &= BTRFS_MKFS_DEFAULT_FEATURES;
+
 	while(1) {
 		int c;
 		static const struct option long_options[] = {
-- 
2.4.1


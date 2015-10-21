Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41514 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbbJUIrj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 04:47:39 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t9L8lcYu013534
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t9L8laeK012208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:38 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t9L8laVX011964
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 08:47:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 3/3] btrfs-progs: kernel based default features for btrfs-convert
Date: Wed, 21 Oct 2015 16:45:49 +0800
Message-Id: <1445417149-804-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
References: <1445417149-804-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-convert convert FS with latest default features enabled, and
if the kernel is down-rev and does not support a latest feature then
mount fails, as expected.

This patch disables default features based on the running kernel.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-convert.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index cb92020..edec09e 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2890,7 +2890,10 @@ int main(int argc, char *argv[])
 	int progress = 1;
 	char *file;
 	char fslabel[BTRFS_LABEL_SIZE];
-	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
+	u64 features;
+
+	features = btrfs_features_allowed_by_kernel();
+	features &= BTRFS_MKFS_DEFAULT_FEATURES;
 
 	while(1) {
 		enum { GETOPT_VAL_NO_PROGRESS = 256 };
-- 
2.4.1


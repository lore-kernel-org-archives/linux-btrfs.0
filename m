Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25871 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161346Ab3DEFx4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:56 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355rtAM032471
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:55 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355rsvL012151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:54 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355rs8w017144
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:53:54 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs-progs: btrfs-select-super output is confusing when it fails
Date: Fri,  5 Apr 2013 13:55:02 +0800
Message-Id: <1365141303-10571-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Trivial patch:
./btrfs-progs/btrfs-select-super -s 0 /dev/sdc
using SB copy 0, bytenr 65536
No valid Btrfs found on /dev/sdc
Open ctree failed

The line 'using..' is confusing which gives an
indication that command is successful

This patch will avoid that when command fails

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 btrfs-select-super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfs-select-super.c b/btrfs-select-super.c
index 0c4f5c0..6a458b8 100644
--- a/btrfs-select-super.c
+++ b/btrfs-select-super.c
@@ -43,7 +43,7 @@ int main(int ac, char **av)
 {
 	struct btrfs_root *root;
 	int ret;
-	int num;
+	int num = 0;
 	u64 bytenr = 0;
 
 	while(1) {
@@ -55,8 +55,6 @@ int main(int ac, char **av)
 			case 's':
 				num = atol(optarg);
 				bytenr = btrfs_sb_offset(num);
-				printf("using SB copy %d, bytenr %llu\n", num,
-				       (unsigned long long)bytenr);
 				break;
 			default:
 				print_usage();
@@ -97,5 +95,7 @@ int main(int ac, char **av)
 	 * transaction commit.  We just want the super copy we pulled off the
 	 * disk to overwrite all the other copies
 	 */ 
+	printf("using SB copy %d, bytenr %llu\n", num,
+	       (unsigned long long)bytenr);
 	return ret;
 }
-- 
1.8.1.227.g44fe835


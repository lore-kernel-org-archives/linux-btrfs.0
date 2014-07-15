Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31677 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaGOHlQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 03:41:16 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6F7fFIg005583
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:41:15 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s6F7fDKH010947
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:41:15 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6F7fDP7024826
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Jul 2014 07:41:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: define BTRFS_MKFS_SMALL_VOLUME_SIZE for small volume
Date: Tue, 15 Jul 2014 16:02:10 +0800
Message-Id: <1405411330-8557-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1405411330-8557-1-git-send-email-anand.jain@oracle.com>
References: <1405411330-8557-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

mkfs cut of size '1024 * 1024 * 1024' to mark dev as small volume so to
force mixed group. Use a define for that.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 mkfs.c  | 2 +-
 utils.c | 4 ++--
 utils.h | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index cba4f02..d980d4a 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1335,7 +1335,7 @@ int main(int ac, char **av)
 				break;
 			case 'b':
 				block_count = parse_size(optarg);
-				if (block_count <= 1024*1024*1024) {
+				if (block_count <= BTRFS_MKFS_SMALL_VOLUME_SIZE) {
 					fprintf(stdout,
 				"SMALL VOLUME: forcing mixed metadata/data groups\n");
 					mixed = 1;
diff --git a/utils.c b/utils.c
index 159f2a2..673134e 100644
--- a/utils.c
+++ b/utils.c
@@ -705,7 +705,7 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	if (max_block_count)
 		block_count = min(block_count, max_block_count);
 
-	if (block_count < 1024 * 1024 * 1024 && !(*mixed)) {
+	if (block_count < BTRFS_MKFS_SMALL_VOLUME_SIZE && !(*mixed)) {
 		printf("SMALL VOLUME: forcing mixed metadata/data groups\n");
 		*mixed = 1;
 	}
@@ -2351,7 +2351,7 @@ int is_vol_small(char *file)
 		close(fd);
 		return -1;
 	}
-	if (size < 1024 * 1024 * 1024) {
+	if (size < BTRFS_MKFS_SMALL_VOLUME_SIZE) {
 		close(fd);
 		return 1;
 	} else {
diff --git a/utils.h b/utils.h
index 5bc22ec..ddf31cf 100644
--- a/utils.h
+++ b/utils.h
@@ -24,6 +24,7 @@
 #include <dirent.h>
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
+#define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
 
 #define BTRFS_SCAN_PROC		(1ULL << 0)
 #define BTRFS_SCAN_DEV		(1ULL << 1)
-- 
2.0.0.153.g79dcccc


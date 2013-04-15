Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44400 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3DOGhh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:37 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 08/11, RESEND] btrfs-progs: btrfs-select-super output is confusing when it fails
Date: Mon, 15 Apr 2013 14:38:14 +0800
Message-Id: <1366007897-26567-9-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
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


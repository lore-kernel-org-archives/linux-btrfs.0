Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64834 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752199AbbEKIJB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:01 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87aLR028746
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 02/13] btrfs-progs: Use unified function to implement print_readable_*_flag() function.
Date: Mon, 11 May 2015 16:08:43 +0800
Message-ID: <1431331734-11714-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now add a new unified __print_readable_flag() function to implement
print_readable_incompat_flag().

This makes later extension for human readable flags easier.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced.
---
 btrfs-show-super.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 1c7a086..430ddfe 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -305,7 +305,8 @@ struct readable_flag_entry incompat_flags_array[] = {
 static const int incompat_flags_num = sizeof(incompat_flags_array) /
 				      sizeof(struct readable_flag_entry);
 
-static void print_readable_incompat_flag(u64 flag)
+static void __print_readable_flag(u64 flag, struct readable_flag_entry *array,
+				  int array_size, u64 supported_flags)
 {
 	int i;
 	int first = 1;
@@ -313,9 +314,10 @@ static void print_readable_incompat_flag(u64 flag)
 
 	if (!flag)
 		return;
+
 	printf("\t\t\t( ");
-	for (i = 0; i < incompat_flags_num; i++) {
-		entry = incompat_flags_array + i;
+	for (i = 0; i < array_size; i++) {
+		entry = array + i;
 		if (flag & entry->bit) {
 			if (first)
 				printf("%s ", entry->output);
@@ -324,7 +326,7 @@ static void print_readable_incompat_flag(u64 flag)
 			first = 0;
 		}
 	}
-	flag &= ~BTRFS_FEATURE_INCOMPAT_SUPP;
+	flag &= ~supported_flags;
 	if (flag) {
 		if (first)
 			printf("unknown flag: 0x%llx ", flag);
@@ -334,6 +336,13 @@ static void print_readable_incompat_flag(u64 flag)
 	printf(")\n");
 }
 
+static void print_readable_incompat_flag(u64 flag)
+{
+	return __print_readable_flag(flag, incompat_flags_array,
+				     incompat_flags_num,
+				     BTRFS_FEATURE_INCOMPAT_SUPP);
+}
+
 static void dump_superblock(struct btrfs_super_block *sb, int full)
 {
 	int i;
-- 
2.4.0


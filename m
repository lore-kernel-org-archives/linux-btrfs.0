Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11526 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751153AbbEKIJB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:01 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87bEc028750
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 03/13] btrfs-progs: Make btrfs-show-super print human readable flag for super flags.
Date: Mon, 11 May 2015 16:08:44 +0800
Message-ID: <1431331734-11714-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the new __print_readable_flag() to implement
print_readable_super_flag().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced.
---
 btrfs-show-super.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 430ddfe..6da80d8 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -305,6 +305,30 @@ struct readable_flag_entry incompat_flags_array[] = {
 static const int incompat_flags_num = sizeof(incompat_flags_array) /
 				      sizeof(struct readable_flag_entry);
 
+#define DEF_HEADER_FLAG_ENTRY(bit_name)			\
+	{BTRFS_HEADER_FLAG_##bit_name, #bit_name}
+#define DEF_SUPER_FLAG_ENTRY(bit_name)			\
+	{BTRFS_SUPER_FLAG_##bit_name, #bit_name}
+
+struct readable_flag_entry super_flags_array[] = {
+	DEF_HEADER_FLAG_ENTRY(WRITTEN),
+	DEF_HEADER_FLAG_ENTRY(RELOC),
+	DEF_SUPER_FLAG_ENTRY(CHANGING_FSID),
+	DEF_SUPER_FLAG_ENTRY(CHANGING_CHUNK_TREE_ID),
+	DEF_SUPER_FLAG_ENTRY(SEEDING),
+	DEF_SUPER_FLAG_ENTRY(METADUMP),
+	DEF_SUPER_FLAG_ENTRY(METADUMP_V2)
+};
+static const int super_flags_num = ARRAY_SIZE(super_flags_array);
+
+#define BTRFS_SUPER_FLAG_SUPP	(BTRFS_HEADER_FLAG_WRITTEN |\
+				 BTRFS_HEADER_FLAG_RELOC |\
+				 BTRFS_SUPER_FLAG_CHANGING_FSID |\
+				 BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID |\
+				 BTRFS_SUPER_FLAG_SEEDING |\
+				 BTRFS_SUPER_FLAG_METADUMP |\
+				 BTRFS_SUPER_FLAG_METADUMP_V2)
+
 static void __print_readable_flag(u64 flag, struct readable_flag_entry *array,
 				  int array_size, u64 supported_flags)
 {
@@ -343,6 +367,12 @@ static void print_readable_incompat_flag(u64 flag)
 				     BTRFS_FEATURE_INCOMPAT_SUPP);
 }
 
+static void print_readable_super_flag(u64 flag)
+{
+	return __print_readable_flag(flag, super_flags_array,
+				     super_flags_num, BTRFS_SUPER_FLAG_SUPP);
+}
+
 static void dump_superblock(struct btrfs_super_block *sb, int full)
 {
 	int i;
@@ -362,6 +392,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 		(unsigned long long)btrfs_super_bytenr(sb));
 	printf("flags\t\t\t0x%llx\n",
 		(unsigned long long)btrfs_super_flags(sb));
+	print_readable_super_flag(btrfs_super_flags(sb));
 
 	printf("magic\t\t\t");
 	s = (char *) &sb->magic;
-- 
2.4.0


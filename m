Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbcBBDBe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:01:34 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id D427D405640A
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 11:01:26 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 6/8] btrfs-progs: Add show-super support for new DEDUP flag
Date: Tue,  2 Feb 2016 10:59:11 +0800
Message-Id: <1454381953-29676-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454381953-29676-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now btrfs-show-super can handle DEDUP ro compat flag.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-show-super.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 051bd11..0bc0b1f 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -328,6 +328,15 @@ struct readable_flag_entry {
 	u64 bit;
 	char *output;
 };
+#define DEF_RO_COMPAT_FLAG_ENTRY(bit_name)		\
+	{BTRFS_FEATURE_COMPAT_RO_##bit_name, #bit_name}
+
+struct readable_flag_entry ro_compat_flags_array[] = {
+	DEF_RO_COMPAT_FLAG_ENTRY(DEDUP)
+};
+
+static const int ro_compat_flags_num = sizeof(ro_compat_flags_array) /
+				       sizeof(struct readable_flag_entry);
 
 #define DEF_INCOMPAT_FLAG_ENTRY(bit_name)		\
 	{BTRFS_FEATURE_INCOMPAT_##bit_name, #bit_name}
@@ -400,6 +409,13 @@ static void __print_readable_flag(u64 flag, struct readable_flag_entry *array,
 	printf(")\n");
 }
 
+static void print_readable_ro_compat_flag(u64 ro_flag)
+{
+	return __print_readable_flag(ro_flag, ro_compat_flags_array,
+				     ro_compat_flags_num,
+				     BTRFS_FEATURE_COMPAT_RO_SUPP);
+}
+
 static void print_readable_incompat_flag(u64 flag)
 {
 	return __print_readable_flag(flag, incompat_flags_array,
@@ -491,6 +507,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
+	print_readable_ro_compat_flag(btrfs_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_incompat_flags(sb));
 	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
-- 
2.7.0




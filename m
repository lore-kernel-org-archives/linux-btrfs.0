Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbcCVHVu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 03:21:50 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id DDF3D4056406
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 15:21:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 6/8] btrfs-progs: Add show-super support for new DEDUPE flag
Date: Tue, 22 Mar 2016 15:19:19 +0800
Message-Id: <1458631161-19036-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458631161-19036-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458631161-19036-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now btrfs-show-super can handle DEDUPE ro compat flag.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-inspect-dump-super.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 3e09ee8..6a939c9 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -198,6 +198,16 @@ struct readable_flag_entry {
 	char *output;
 };
 
+#define DEF_RO_COMPAT_FLAG_ENTRY(bit_name)	\
+	{BTRFS_FEATURE_COMPAT_RO_##bit_name, #bit_name}
+
+struct readable_flag_entry ro_compat_flags_array[] = {
+	DEF_RO_COMPAT_FLAG_ENTRY(DEDUPE)
+};
+
+static const int ro_compat_flags_num = sizeof(ro_compat_flags_array) /
+				      sizeof(struct readable_flag_entry);
+
 #define DEF_INCOMPAT_FLAG_ENTRY(bit_name)		\
 	{BTRFS_FEATURE_INCOMPAT_##bit_name, #bit_name}
 
@@ -269,6 +279,13 @@ static void __print_readable_flag(u64 flag, struct readable_flag_entry *array,
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
@@ -360,6 +377,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
+	print_readable_ro_compat_flag(btrfs_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_incompat_flags(sb));
 	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
-- 
2.7.4




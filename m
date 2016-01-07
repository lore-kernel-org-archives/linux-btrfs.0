Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18653 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752254AbcAGBWq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:22:46 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 35FAD406CF6E
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:22:28 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 6/7] btrfs: dedup: Add show-super support for new DEDUP flag
Date: Thu, 7 Jan 2016 09:22:13 +0800
Message-ID: <1452129734-7261-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452129734-7261-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452129734-7261-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now btrfs-show-super can handle DEDUP ro compat flag.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-show-super.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index d8ad69e..7c0dfa9 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -291,6 +291,15 @@ struct readable_flag_entry {
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
@@ -363,6 +372,13 @@ static void __print_readable_flag(u64 flag, struct readable_flag_entry *array,
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
@@ -454,6 +470,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
+	print_readable_ro_compat_flag(btrfs_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_incompat_flags(sb));
 	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
-- 
2.6.4




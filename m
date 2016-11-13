Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:34465 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932504AbcKMTlV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 14:41:21 -0500
Received: by mail-pg0-f43.google.com with SMTP id x23so41502605pgx.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Nov 2016 11:41:21 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 2/6] btrfs-progs: format FREE_SPACE_TREE{,_VALID} nicely in dump-super
Date: Sun, 13 Nov 2016 11:35:20 -0800
Message-Id: <86cfb5c7a06eb6fb488e4c615cd8dfbf2fa4180e.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
In-Reply-To: <cover.1479064970.git.osandov@fb.com>
References: <cover.1479064970.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-inspect-dump-super.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index d9f7bfb..ba0d708 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -197,6 +197,16 @@ struct readable_flag_entry {
 	char *output;
 };
 
+#define DEF_COMPAT_RO_FLAG_ENTRY(bit_name)		\
+	{BTRFS_FEATURE_COMPAT_RO_##bit_name, #bit_name}
+
+static struct readable_flag_entry compat_ro_flags_array[] = {
+	DEF_COMPAT_RO_FLAG_ENTRY(FREE_SPACE_TREE),
+	DEF_COMPAT_RO_FLAG_ENTRY(FREE_SPACE_TREE_VALID),
+};
+static const int compat_ro_flags_num = sizeof(compat_ro_flags_array) /
+				       sizeof(struct readable_flag_entry);
+
 #define DEF_INCOMPAT_FLAG_ENTRY(bit_name)		\
 	{BTRFS_FEATURE_INCOMPAT_##bit_name, #bit_name}
 
@@ -268,6 +278,19 @@ static void __print_readable_flag(u64 flag, struct readable_flag_entry *array,
 	printf(")\n");
 }
 
+static void print_readable_compat_ro_flag(u64 flag)
+{
+	/*
+	 * We know about the FREE_SPACE_TREE{,_VALID} bits, but we don't
+	 * actually support them yet.
+	 */
+	return __print_readable_flag(flag, compat_ro_flags_array,
+				     compat_ro_flags_num,
+				     BTRFS_FEATURE_COMPAT_RO_SUPP |
+				     BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |
+				     BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID);
+}
+
 static void print_readable_incompat_flag(u64 flag)
 {
 	return __print_readable_flag(flag, incompat_flags_array,
@@ -377,6 +400,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_compat_flags(sb));
 	printf("compat_ro_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
+	print_readable_compat_ro_flag(btrfs_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_incompat_flags(sb));
 	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
-- 
2.10.2


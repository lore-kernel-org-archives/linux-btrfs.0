Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53743 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754027AbaIXDQx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 23:16:53 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8O3Guum028609
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 11:16:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Add human readable incompat flags output for btrfs-show-super
Date: Wed, 24 Sep 2014 11:16:50 +0800
Message-ID: <1411528610-28401-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add human readable incompat flags output for btrfs-show-super,
now no longer needs to calculate the hex flags by hand.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-show-super.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 38c5d26..c591865 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -285,6 +285,58 @@ static void print_backup_roots(struct btrfs_super_block *sb)
 	}
 }
 
+struct readable_flag_entry {
+	u64 bit;
+	char *output;
+};
+
+#define DEF_INCOMPAT_FLAG_ENTRY(bit_name)		\
+	{BTRFS_FEATURE_INCOMPAT_##bit_name, #bit_name}
+
+struct readable_flag_entry incompat_flags_array[] = {
+	DEF_INCOMPAT_FLAG_ENTRY(MIXED_BACKREF),
+	DEF_INCOMPAT_FLAG_ENTRY(DEFAULT_SUBVOL),
+	DEF_INCOMPAT_FLAG_ENTRY(MIXED_GROUPS),
+	DEF_INCOMPAT_FLAG_ENTRY(COMPRESS_LZO),
+	DEF_INCOMPAT_FLAG_ENTRY(COMPRESS_LZOv2),
+	DEF_INCOMPAT_FLAG_ENTRY(BIG_METADATA),
+	DEF_INCOMPAT_FLAG_ENTRY(EXTENDED_IREF),
+	DEF_INCOMPAT_FLAG_ENTRY(RAID56),
+	DEF_INCOMPAT_FLAG_ENTRY(SKINNY_METADATA),
+	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES)
+};
+static const int incompat_flags_num = sizeof(incompat_flags_array) /
+				      sizeof(struct readable_flag_entry);
+
+static void print_readable_incompat_flag(u64 flag)
+{
+	int i;
+	int first = 1;
+	struct readable_flag_entry *entry;
+
+	if (!flag)
+		return;
+	printf("\t\t\t( ");
+	for (i = 0; i < incompat_flags_num; i++) {
+		entry = incompat_flags_array + i;
+		if (flag & entry->bit) {
+			if (first)
+				printf("%s ", entry->output);
+			else
+				printf("|\n\t\t\t  %s ", entry->output);
+		}
+		first = 0;
+	}
+	flag &= ~BTRFS_FEATURE_INCOMPAT_SUPP;
+	if (flag) {
+		if (first)
+			printf("unknown flag:%llx ", flag);
+		else
+			printf("|\n\t\t\t  unknown flag:%llx ", flag);
+	}
+	printf(")\n");
+}
+
 static void dump_superblock(struct btrfs_super_block *sb, int full)
 {
 	int i;
@@ -364,6 +416,7 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
 	printf("incompat_flags\t\t0x%llx\n",
 	       (unsigned long long)btrfs_super_incompat_flags(sb));
+	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
 	printf("csum_type\t\t%llu\n",
 	       (unsigned long long)btrfs_super_csum_type(sb));
 	printf("csum_size\t\t%llu\n",
-- 
2.1.0


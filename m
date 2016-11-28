Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47314 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752196AbcK1SwJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 13:52:09 -0500
From: Adam Borowski <kilobyte@angband.pl>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon, 28 Nov 2016 19:51:53 +0100
Message-Id: <20161128185153.14908-1-kilobyte@angband.pl>
Subject: [PATCH] btrfs-progs: mkfs, balance convert: warn about RAID5/6 in fiery letters
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

People who don't frequent IRC nor the mailing list tend to believe RAID 5/6
are stable; this leads to data loss.  Thus, let's do warn them.

At this point, I think fiery letters that won't be missed are warranted.

Kernel 4.9 and its -progs will be a part of LTS of multiple distributions,
so leaving experimental features without a warning is inappropriate.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 cmds-balance.c |  2 ++
 mkfs.c         |  2 ++
 utils.c        | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 utils.h        |  2 ++
 4 files changed, 52 insertions(+)

diff --git a/cmds-balance.c b/cmds-balance.c
index f17345e..0967162 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -48,8 +48,10 @@ static int parse_one_profile(const char *profile, u64 *flags)
 	} else if (!strcmp(profile, "raid10")) {
 		*flags |= BTRFS_BLOCK_GROUP_RAID10;
 	} else if (!strcmp(profile, "raid5")) {
+		print_raid56_warning();
 		*flags |= BTRFS_BLOCK_GROUP_RAID5;
 	} else if (!strcmp(profile, "raid6")) {
+		print_raid56_warning();
 		*flags |= BTRFS_BLOCK_GROUP_RAID6;
 	} else if (!strcmp(profile, "dup")) {
 		*flags |= BTRFS_BLOCK_GROUP_DUP;
diff --git a/mkfs.c b/mkfs.c
index e501a93..8d460b7 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -378,8 +378,10 @@ static u64 parse_profile(const char *s)
 	} else if (strcasecmp(s, "raid1") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID1;
 	} else if (strcasecmp(s, "raid5") == 0) {
+		print_raid56_warning();
 		return BTRFS_BLOCK_GROUP_RAID5;
 	} else if (strcasecmp(s, "raid6") == 0) {
+		print_raid56_warning();
 		return BTRFS_BLOCK_GROUP_RAID6;
 	} else if (strcasecmp(s, "raid10") == 0) {
 		return BTRFS_BLOCK_GROUP_RAID10;
diff --git a/utils.c b/utils.c
index 69b580a..b9e44c2 100644
--- a/utils.c
+++ b/utils.c
@@ -4204,6 +4204,52 @@ out:
 	return ret;
 }
 
+#define NFL 5
+#define CYCLE (NFL * 2 - 2)
+/* force text-on-black even if reversed */
+#define BG "\e[0;40;"
+static const char *fire_levels[NFL] =
+{ BG"1;30m", BG"31m", BG"1;31m", BG"1;33m", BG"1;37m", };
+#undef BG
+
+/* If this ever gets localized, we'll need to split by characters not bytes. */
+static void text_on_fire(const char *str)
+{
+	int s = 0, sl, chunks, len = strlen(str);
+
+	/* no colors if our output is redirected */
+	if (!isatty(fileno(stderr)))
+		return (void)fputs(str, stderr);
+
+	/* repeat the scheme if too long, try 2-3 letters per level */
+	chunks = (len / CYCLE / 3 + 1) * CYCLE + 1;
+	for (int ch = 0; ch < chunks; ++ch) {
+		int lev = ch % CYCLE;
+		fputs(fire_levels[(lev < NFL) ? lev : CYCLE - lev],
+		      stderr);
+		sl = len * (ch + 1) / chunks;
+		for (; s < sl; ++s)
+			fputc(*str++, stderr);
+	}
+	fputs("\e[0m", stderr); /* reset color */
+}
+#undef NFL
+#undef CYCLE
+
+void print_raid56_warning(void)
+{
+	static int given = 0;
+	if (given)
+		return;
+	given = 1;
+
+	fprintf(stderr,
+"WARNING: btrfs RAID5 and 6 are still experimental, suffering from serious\n"
+"problems.  Thus, you are advised not to continue unless you know what you're\n"
+"doing.  In all cases, do keep up-to-date backups!\n");
+	text_on_fire("Don't use RAID5/6 for anything important!\n");
+}
+
 void init_rand_seed(u64 seed)
 {
 	int i;
diff --git a/utils.h b/utils.h
index 366ca29..00a253a 100644
--- a/utils.h
+++ b/utils.h
@@ -423,6 +423,8 @@ static inline int __error_on(int condition, const char *fmt, ...)
 	return 1;
 }
 
+void print_raid56_warning(void);
+
 /* Pseudo random number generator wrappers */
 u32 rand_u32(void);
 
-- 
2.10.2


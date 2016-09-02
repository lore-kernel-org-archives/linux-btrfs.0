Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbcIBPG0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 11:06:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 23102ABE8
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2016 15:06:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: dump-super: changes in options to specify superblocks
Date: Fri,  2 Sep 2016 17:04:58 +0200
Message-Id: <1472828698-7618-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some tools (check, select-super, dump-super) can use the alternate
superblocks, but the options are not consistent. To make it less
confusing, change the meaning of option -s in 'dump-super' to specify
the superblock copy, instead of taking the offset.

Though this is a change in UI, the old usage is detected and the result
would be the same, no breakage in existing scripts.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 Documentation/btrfs-inspect-internal.asciidoc | 29 ++++++++++++++++--------
 cmds-inspect-dump-super.c                     | 32 +++++++++++++++++++++------
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 74f6dea821a2..44615e767942 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -30,25 +30,36 @@ Besides verifictaion of the filesystem signature, there are no other sanity
 checks. The superblock checksum status is reported, the device item and
 filesystem UUIDs are checked and reported.
 +
+NOTE: the meaning of option '-s' has changed in version 4.8 to be consistent
+with other tools to specify superblock copy rather the offset. The old way still
+works, but prints a warning. Please update your scripts to use '--bytenr'
+instead. The option '-i' has been deprecated.
++
 `Options`
 +
 -f|--full::::
 print full superblock information, including the system chunk array and backup roots
 -a|--all::::
-print information about all present superblock copies (cannot be used together with '-i' option)
--i <super_mirror>::::
-specify which mirror to print, valid values are 0, 1 and 2 and the superblock must be present on the device
+print information about all present superblock copies (cannot be used together
+with '-s' option)
+-i <super>::::
+(deprecated since 4.8, same behaviour as '--super')
+--bytenr <bytenr>::::
+specify offset to a superblock in a non-standard location at 'bytenr', useful
+for debugging (disables the '-f' option)
 +
-If there are multiple options specified, only the last one is applies.
+If there are multiple options specified, only the last one applies.
 +
 -F|--force::::
-attempt to print the superblock even if thre's no valid BTRFS signature found
+attempt to print the superblock even if thre's no valid BTRFS signature found,
+the result may be completely wrong if the data do not resemble a superblock
 +
-The result may be completely wrong if the data do not resemble a superblock.
+-s|--super <bytenr>::::
+(see compatibility note above)
 +
--s <bytenr>::::
-specify offset to a superblock in a non-standard location at 'bytenr', useful
-for debugging (disables the '-f' option)
+specify which mirror to print, valid values are 0, 1 and 2 and the superblock
+must be present on the device with a valid signature, can be used together with
+'--force'
 
 *dump-tree* [options] <device>::
 (replaces the standalone tool *btrfs-debug-tree*)
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index aab507523698..b9409d31ceae 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -458,11 +458,18 @@ static int load_and_dump_sb(char *filename, int fd, u64 sb_bytenr, int full,
 const char * const cmd_inspect_dump_super_usage[] = {
 	"btrfs inspect-internal dump-super [options] device [device...]",
 	"Dump superblock from a device in a textual form",
-	"-f|--full           print full superblock information",
-	"-a|--all            print information about all superblocks",
-	"-i <super_mirror>   specify which mirror to print out",
-	"-F|--force          attempt to dump superblocks with bad magic",
-	"-s <bytenr>         specify alternate superblock offset",
+	"-f|--full             print full superblock information, backup roots etc.",
+	"-a|--all              print information about all superblocks",
+	"-s|--super <super>    specify which copy to print out (values: 0, 1, 2)",
+	"-F|--force            attempt to dump superblocks with bad magic",
+	"--bytenr <offset>     specify alternate superblock offset",
+	"",
+	"Deprecated syntax:",
+	"-s <bytenr>           specify alternate superblock offset, values other than 0, 1, 2",
+	"                      will be interpreted as --bytenr for backward compatibility,",
+	"                      option renamed for consistency with other tools (eg. check)",
+	"-i <super>            specify which copy to print out (values: 0, 1, 2), now moved",
+	"                      to -s|--super",
 	NULL
 };
 
@@ -484,6 +491,7 @@ int cmd_inspect_dump_super(int argc, char **argv)
 			{"all", no_argument, NULL, 'a'},
 			{"full", no_argument, NULL, 'f'},
 			{"force", no_argument, NULL, 'F'},
+			{"super", required_argument, NULL, 's' },
 			{NULL, 0, NULL, 0}
 		};
 
@@ -493,11 +501,13 @@ int cmd_inspect_dump_super(int argc, char **argv)
 
 		switch (c) {
 		case 'i':
+			warning(
+			    "option -i is deprecated, please use -s or --super");
 			arg = arg_strtou64(optarg);
 			if (arg >= BTRFS_SUPER_MIRROR_MAX) {
 				error("super mirror too big: %llu >= %d",
 					arg, BTRFS_SUPER_MIRROR_MAX);
-				usage(cmd_inspect_dump_super_usage);
+				return 1;
 			}
 			sb_bytenr = btrfs_sb_offset(arg);
 			break;
@@ -512,7 +522,15 @@ int cmd_inspect_dump_super(int argc, char **argv)
 			force = 1;
 			break;
 		case 's':
-			sb_bytenr = arg_strtou64(optarg);
+			arg = arg_strtou64(optarg);
+			if (0 <= arg && BTRFS_SUPER_MIRROR_MAX < arg) {
+				warning(
+		"deprecated use of -s <bytenr> with %llu, assuming --bytenr",
+						(unsigned long long)arg);
+				sb_bytenr = arg;
+			} else {
+				sb_bytenr = btrfs_sb_offset(arg);
+			}
 			all = 0;
 			break;
 		default:
-- 
2.7.1


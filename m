Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35836 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030341AbcIYB1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 21:27:04 -0400
Received: by mail-qt0-f193.google.com with SMTP id 38so4692491qte.2
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Sep 2016 18:27:03 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH] Fix user-facing typos
Date: Sat, 24 Sep 2016 21:26:41 -0400
Message-Id: <20160925012641.24339-2-nsteeves@gmail.com>
In-Reply-To: <20160925012641.24339-1-nsteeves@gmail.com>
References: <20160925012641.24339-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 Documentation/btrfs-check.asciidoc  | 2 +-
 Documentation/btrfs-device.asciidoc | 2 +-
 Documentation/btrfs-man5.asciidoc   | 2 +-
 Documentation/btrfs-scrub.asciidoc  | 2 +-
 Documentation/btrfstune.asciidoc    | 2 +-
 btrfs-convert.c                     | 2 +-
 cmds-check.c                        | 6 +++---
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index abc9f0d..a32e1c7 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -20,7 +20,7 @@ by the option '--readonly'.
 
 *btrfsck* is an alias of *btrfs check* command and is now deprecated.
 
-WARNING: Do not use '--repair' unless you are adviced to by a developer, an
+WARNING: Do not use '--repair' unless you are advised to by a developer, an
 experienced user or accept the fact that 'fsck' cannot possibly fix all sorts
 of damage that could happen to a filesystem because of software and hardware
 bugs.
diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index d05fc45..239c99b 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -27,7 +27,7 @@ The device management works on a mounted filesystem. Devices can be added,
 removed or replaced, by commands profided by *btrfs device* and *btrfs replace*.
 
 The profiles can be also changed, provided there's enough workspace to do the
-conversion, using the *btrfs balance* comand and namely the filter 'convert'.
+conversion, using the *btrfs balance* command and namely the filter 'convert'.
 
 Profile::
 A profile describes an allocation policy based on the redundancy/replication
diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index caa9390..d12b059 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -562,7 +562,7 @@ crw------- 1 root root 10, 234 Jan  1 12:00 /dev/btrfs-control
 The device accepts some ioctl calls that can perform following actions on the
 filesyste module:
 
-* scan devices for btrfs filesytem (ie. to let multi-device filesystems mount
+* scan devices for btrfs filesystem (ie. to let multi-device filesystems mount
   automatically) and register them with the kernel module
 * similar to scan, but also wait until the device scanning process is finished
   for a given filesystem
diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
index 40e793c..fcc6d68 100644
--- a/Documentation/btrfs-scrub.asciidoc
+++ b/Documentation/btrfs-scrub.asciidoc
@@ -20,7 +20,7 @@ structural damage in the filesystem.
 
 The user is supposed to run it manually or via a periodic system service. The
 recommended period is a month but could be less. The estimated device bandwidth
-utilization is about 80% on an idle filesytem. The IO priority class is by
+utilization is about 80% on an idle filesystem. The IO priority class is by
 default 'idle' so background scrub should not interfere with normal filesystem
 operation significantly.
 
diff --git a/Documentation/btrfstune.asciidoc b/Documentation/btrfstune.asciidoc
index 1e9aa70..04295ee 100644
--- a/Documentation/btrfstune.asciidoc
+++ b/Documentation/btrfstune.asciidoc
@@ -20,7 +20,7 @@ complete list of features and kernel version of their introduction at
 https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature .  Also, the
 manual page `mkfs.btrfs`(8) contains more details about the features.
 
-Some of the features could be enabled on a mounted filesytem. Please refer to
+Some of the features could be enabled on a mounted filesystem. Please refer to
 the respective section in `btrfs`(5).
 
 OPTIONS
diff --git a/btrfs-convert.c b/btrfs-convert.c
index e39cda8..ecf1d2a 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -3016,7 +3016,7 @@ static void print_usage(void)
 	printf("\t-O|--features LIST     comma separated list of filesystem features\n");
 	printf("\t--no-progress          show only overview, not the detailed progress\n");
 	printf("\n");
-	printf("Suported filesystems:\n");
+	printf("Supported filesystems:\n");
 	printf("\text2/3/4: %s\n", BTRFSCONVERT_EXT2 ? "yes" : "no");
 }
 
diff --git a/cmds-check.c b/cmds-check.c
index e9e7a4c..c2c9a95 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -12550,14 +12550,14 @@ const char * const cmd_check_usage[] = {
 	"--readonly                  run in read-only mode (default)",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
-	"--mode <MODE>               select mode, allows to make some memory/IO",
-	"                            trade-offs, where MODE is one of:",
+	"--mode <MODE>               allows choice of memory/IO trade-offs",
+	"                            where MODE is one of:",
 	"                            original - read inodes and extents to memory (requires",
 	"                                       more memory, does less IO)",
 	"                            lowmem   - try to use less memory but read blocks again",
 	"                                       when needed",
 	"--check-data-csum           verify checksums of data blocks",
-	"-Q|--qgroup-report           print a report on qgroup consistency",
+	"-Q|--qgroup-report          print a report on qgroup consistency",
 	"-E|--subvol-extents <subvolid>",
 	"                            print subvolume extents and sharing state",
 	"-r|--tree-root <bytenr>     use the given bytenr for the tree root",
-- 
2.9.3


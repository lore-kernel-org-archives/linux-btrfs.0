Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaKDR10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 12:27:26 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B4EFFAC0F
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Nov 2014 17:27:24 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: use the correct SI prefixes
Date: Tue,  4 Nov 2014 18:27:23 +0100
Message-Id: <1415122043-8385-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The SI standard defines lowercase 'k' and uppercase for the rest.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-filesystem.txt | 6 +++---
 cmds-filesystem.c                  | 8 ++++----
 utils.c                            | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index 6e63d2c9c2ae..a8f2972a0e1a 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -35,11 +35,11 @@ select the 1000 base for the following options, according to the SI standard
 -k|--kbytes::::
 show sizes in KiB, or kB with --si
 -m|--mbytes::::
-show sizes in MiB, or mB with --si
+show sizes in MiB, or MB with --si
 -g|--gbytes::::
-show sizes in GiB, or gB with --si
+show sizes in GiB, or GB with --si
 -t|--tbytes::::
-show sizes in TiB, or tB with --si
+show sizes in TiB, or TB with --si
 
 If conflicting options are passed, the last one takes precedence.
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index af56fbeb48ed..e4b278590ca6 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -128,11 +128,11 @@ static const char * const cmd_df_usage[] = {
 	"-h                 human friendly numbers, base 1024 (default)",
 	"-H                 human friendly numbers, base 1000",
 	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)",
-	"--si               use 1000 as a base (kB, mB, gB, tB)",
+	"--si               use 1000 as a base (kB, MB, GB, TB)",
 	"-k|--kbytes        show sizes in KiB, or kB with --si",
-	"-m|--mbytes        show sizes in MiB, or mB with --si",
-	"-g|--gbytes        show sizes in GiB, or gB with --si",
-	"-t|--tbytes        show sizes in TiB, or tB with --si",
+	"-m|--mbytes        show sizes in MiB, or MB with --si",
+	"-g|--gbytes        show sizes in GiB, or GB with --si",
+	"-t|--tbytes        show sizes in TiB, or TB with --si",
        NULL
 };
 
diff --git a/utils.c b/utils.c
index f51bc564d8f1..4b3bace4433a 100644
--- a/utils.c
+++ b/utils.c
@@ -1328,7 +1328,7 @@ out:
 static const char* unit_suffix_binary[] =
 	{ "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
 static const char* unit_suffix_decimal[] =
-	{ "B", "kB", "mB", "gB", "tB", "pB", "eB"};
+	{ "B", "kB", "MB", "GB", "TB", "PB", "EB"};
 
 int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mode)
 {
-- 
2.1.1


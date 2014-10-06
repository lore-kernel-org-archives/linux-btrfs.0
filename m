Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJFQtG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 12:49:06 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 6CDAAAD55
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Oct 2014 16:49:05 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: check, add verbosity level option
Date: Mon,  6 Oct 2014 18:48:58 +0200
Message-Id: <1412614138-32008-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1412172669-1975-1-git-send-email-jbacik@fb.com>
References: <1412172669-1975-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-check.txt | 2 ++
 cmds-check.c                  | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index 8a8073f52fad..589466e0a3f3 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -32,6 +32,8 @@ create a new CRC tree.
 create a new extent tree.
 --check-data-csum::
 verify checkums of data blocks.
+--verbose::
+increase verbosity level.
 
 EXIT STATUS
 -----------
diff --git a/cmds-check.c b/cmds-check.c
index af1940a3fe38..6f3dc77171c4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -55,6 +55,7 @@ static int repair = 0;
 static int no_holes = 0;
 static int init_extent_tree = 0;
 static int check_data_csum = 0;
+static int verbose = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -6801,6 +6802,7 @@ const char * const cmd_check_usage[] = {
 	"--check-data-csum           verify checkums of data blocks",
 	"--qgroup-report             print a report on qgroup consistency",
 	"--subvol-extents            print subvolume extents and sharing state",
+	"--verbose                   increase verbosity level",
 	NULL
 };
 
@@ -6822,7 +6824,7 @@ int cmd_check(int argc, char **argv)
 
 	while(1) {
 		int c;
-		c = getopt_long(argc, argv, "as:b", long_options,
+		c = getopt_long(argc, argv, "as:bv", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -6849,6 +6851,9 @@ int cmd_check(int argc, char **argv)
 			case 'E':
 				subvolid = arg_strtou64(optarg);
 				break;
+			case 'v':
+				verbose++;
+				break;
 			case '?':
 			case 'h':
 				usage(cmd_check_usage);
-- 
2.1.1


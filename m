Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaLRO1p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:27:45 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3BE91AD08
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 14:27:44 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/6] btrfs-progs: fi usage, change option for tabular output to T
Date: Thu, 18 Dec 2014 15:27:44 +0100
Message-Id: <8e27f8ee91efdffcee80ad81db4d19e4d560a57e.1418912740.git.dsterba@suse.cz>
In-Reply-To: <cover.1418912740.git.dsterba@suse.cz>
References: <cover.1418912740.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're going to use -t for tera- units prefix, same as 'fi df' does.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 6a33b5d1da51..77ab8b4c1604 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -848,7 +848,7 @@ const char * const cmd_filesystem_usage_usage[] = {
 	"Show in which disk the chunks are allocated.",
 	"",
 	"-b\tSet byte as unit",
-	"-t\tShow data in tabular format",
+	"-T\tShow data in tabular format",
 	NULL
 };
 
@@ -861,7 +861,7 @@ int cmd_filesystem_usage(int argc, char **argv)
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "bt");
+		int c = getopt(argc, argv, "bT");
 
 		if (c < 0)
 			break;
@@ -870,7 +870,7 @@ int cmd_filesystem_usage(int argc, char **argv)
 		case 'b':
 			mode = UNITS_RAW;
 			break;
-		case 't':
+		case 'T':
 			tabular = 1;
 			break;
 		default:
-- 
2.1.3


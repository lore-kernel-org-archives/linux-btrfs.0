Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:55836 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbbJBQuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 12:50:04 -0400
From: axel@tty0.ch
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [PATCH 1/4] btrfs-progs: add -A option for subvolume list (print all available information)
Date: Fri,  2 Oct 2015 18:41:20 +0200
Message-Id: <1443804083-876-2-git-send-email-axel@tty0.ch>
In-Reply-To: <1443804083-876-1-git-send-email-axel@tty0.ch>
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 Documentation/btrfs-subvolume.asciidoc | 2 ++
 cmds-subvolume.c                       | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index c187fd8..afbec83 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -114,6 +114,8 @@ print the UUID of the subvolume.
 print the parent uuid of subvolumes (and snapshots).
 -R::::
 print the UUID of the sent subvolume, where the subvolume is the result of a receive operation
+-A::::
+print all available subvolume information.
 -t::::
 print the result as a table.
 -s::::
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 82173c0..26a08f1 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -428,6 +428,7 @@ static const char * const cmd_subvol_list_usage[] = {
 	"-u           print the uuid of subvolumes (and snapshots)",
 	"-q           print the parent uuid of the snapshots",
 	"-R           print the uuid of the received snapshots",
+	"-A           print all available subvolume information",
 	"-t           print the result as a table",
 	"-s           list snapshots only in the filesystem",
 	"-r           list readonly subvolumes (including snapshots)",
@@ -471,7 +472,7 @@ static int cmd_subvol_list(int argc, char **argv)
 		};
 
 		c = getopt_long(argc, argv,
-				    "acdgopqsurRG:C:t", long_options, NULL);
+				    "acdgopqsurRAG:C:t", long_options, NULL);
 		if (c < 0)
 			break;
 
@@ -515,6 +516,9 @@ static int cmd_subvol_list(int argc, char **argv)
 		case 'R':
 			btrfs_list_setup_print_column(BTRFS_LIST_RUUID);
 			break;
+		case 'A':
+			btrfs_list_setup_print_column(BTRFS_LIST_ALL);
+			break;
 		case 'r':
 			flags |= BTRFS_ROOT_SUBVOL_RDONLY;
 			break;
-- 
2.4.9


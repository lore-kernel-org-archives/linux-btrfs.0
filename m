Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:32497 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab3DWJZE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 05:25:04 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp1) (RZmta 31.27 OK)
	with ESMTP id X00d35p3N824Ad for <linux-btrfs@vger.kernel.org>;
	Tue, 23 Apr 2013 11:25:01 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: btrfs-send: free used memory and close fds
Date: Tue, 23 Apr 2013 11:25:00 +0200
Message-Id: <1366709101-17887-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not important at all since exit() is called afterwards and this is
not part of the library. It just makes valgrind happy and thus
allows to search for real flaws.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-send.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index adfb67d..72804a9 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -479,6 +479,13 @@ int cmd_send_start(int argc, char **argv)
 			add_clone_source(&send, root_id);
 			subvol_uuid_search_finit(&send.sus);
 			free(subvol);
+			subvol = NULL;
+			if (send.mnt_fd >= 0) {
+				close(send.mnt_fd);
+				send.mnt_fd = -1;
+			}
+			free(send.root_path);
+			send.root_path = NULL;
 			full_send = 0;
 			break;
 		case 'f':
@@ -487,7 +494,8 @@ int cmd_send_start(int argc, char **argv)
 		case 'p':
 			if (snapshot_parent) {
 				fprintf(stderr, "ERROR: you cannot have more than one parent (-p)\n");
-				return 1;
+				ret = 1;
+				goto out;
 			}
 			snapshot_parent = realpath(optarg, NULL);
 			if (!snapshot_parent) {
@@ -501,17 +509,20 @@ int cmd_send_start(int argc, char **argv)
 		case 'i':
 			fprintf(stderr,
 				"ERROR: -i was removed, use -c instead\n");
-			return 1;
+			ret = 1;
+			goto out;
 		case '?':
 		default:
 			fprintf(stderr, "ERROR: send args invalid.\n");
-			return 1;
+			ret = 1;
+			goto out;
 		}
 	}
 
 	if (optind == argc) {
 		fprintf(stderr, "ERROR: send needs path to snapshot\n");
-		return 1;
+		ret = 1;
+		goto out;
 	}
 
 	if (outname != NULL) {
@@ -528,7 +539,8 @@ int cmd_send_start(int argc, char **argv)
 		fprintf(stderr, 
 			"ERROR: not dumping send stream into a terminal, "
 			"redirect it into a file\n");
-		return 1;
+		ret = 1;
+		goto out;
 	}
 
 	/* use first send subvol to determine mount_root */
@@ -559,6 +571,7 @@ int cmd_send_start(int argc, char **argv)
 	}
 
 	for (i = optind; i < argc; i++) {
+		free(subvol);
 		subvol = realpath(argv[i], NULL);
 		if (!subvol) {
 			ret = -errno;
@@ -590,13 +603,13 @@ int cmd_send_start(int argc, char **argv)
 					subvol);
 			goto out;
 		}
-		free(subvol);
 	}
 
 	for (i = optind; i < argc; i++) {
 		int is_first_subvol;
 		int is_last_subvol;
 
+		free(subvol);
 		subvol = argv[i];
 
 		fprintf(stderr, "At subvol %s\n", subvol);
@@ -655,14 +668,17 @@ int cmd_send_start(int argc, char **argv)
 
 		parent_root_id = 0;
 		full_send = 0;
-		free(subvol);
 	}
 
 	ret = 0;
 
 out:
+	free(subvol);
+	free(snapshot_parent);
+	free(send.clone_sources);
 	if (send.mnt_fd >= 0)
 		close(send.mnt_fd);
+	free(send.root_path);
 	subvol_uuid_search_finit(&send.sus);
 	return ret;
 }
-- 
1.8.2.1


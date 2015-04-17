Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032AbbDQQ2j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 12:28:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id CA763ABBC
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 16:28:37 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fi resize: accept only directories as paths
Date: Fri, 17 Apr 2015 18:28:35 +0200
Message-Id: <1429288115-16127-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resize of a filesystem image does not work as expected. This has been
confusing and can have bad consequences as people have reported,
resizing the wrong filesystem.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-filesystem.asciidoc |  9 +++++++--
 cmds-filesystem.c                       | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index cefdc8ea93dd..630483d8c114 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -89,8 +89,13 @@ NOTE: the maximum allowable length shall be less than 256 chars
 
 // Some wording are extracted by the resize2fs man page
 *resize* [<devid>:][+/-]<size>[kKmMgGtTpPeE]|[<devid>:]max <path>::
-Resize a filesystem identified by <path> for the underlying device
-devid *online*. +
+Resize a mounted filesystem identified by directory <path>. A particular device
+can be resized by specifying a <devid>.
++
+If <path> is a file containing a btrfs image then resize does not work as
+expected and does not resize the image. This would resize the underlying
+filesytem instead.
++
 The devid can be found with *btrfs filesystem show* and
 defaults to 1 if not specified.
 The <size> parameter specifies the new size of the filesystem.
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 188dbf0c48d2..d62aef6833ce 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -1234,6 +1234,7 @@ static int cmd_resize(int argc, char **argv)
 	int	fd, res, len, e;
 	char	*amount, *path;
 	DIR	*dirstream = NULL;
+	struct stat st;
 
 	if (check_argc_exact(argc, 3))
 		usage(cmd_resize_usage);
@@ -1248,6 +1249,20 @@ static int cmd_resize(int argc, char **argv)
 		return 1;
 	}
 
+	res = stat(path, &st);
+	if (res < 0) {
+		fprintf(stderr, "ERROR: resize: cannot stat %s: %s\n",
+				path, strerror(errno));
+		return 1;
+	}
+	if (!S_ISDIR(st.st_mode)) {
+		fprintf(stderr,
+			"ERROR: resize works on mounted filesystems and accepts only\n"
+			"directories as argument. Passing file containing a btrfs image\n"
+			"would resize the underlying filesytem instead of the image.\n");
+		return 1;
+	}
+
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
-- 
2.1.3


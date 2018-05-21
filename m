Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42828 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbeEUO6x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 10:58:53 -0400
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Mon, 21 May 2018 16:58:43 +0200
Message-Id: <20180521145843.16622-1-kilobyte@angband.pl>
In-Reply-To: <20180521144515.16501-1-kilobyte@angband.pl>
References: <20180521144515.16501-1-kilobyte@angband.pl>
Subject: [PATCH] defrag: open files RO
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NOT FOR MERGING -- requires kernel versioning

Fixes EXTXBSY races.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 cmds-filesystem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 30a50bf5..7eb6b7bb 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -876,7 +876,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
 		if (defrag_global_verbose)
 			printf("%s\n", fpath);
-		fd = open(fpath, O_RDWR);
+		fd = open(fpath, O_RDONLY);
 		if (fd < 0) {
 			goto error;
 		}
@@ -1012,7 +1012,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		int defrag_err = 0;
 
 		dirstream = NULL;
-		fd = open_file_or_dir(argv[i], &dirstream);
+		fd = open_file_or_dir3(argv[i], &dirstream, O_RDONLY);
 		if (fd < 0) {
 			error("cannot open %s: %m", argv[i]);
 			ret = -errno;
-- 
2.17.0


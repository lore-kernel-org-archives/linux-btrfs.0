Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:54590 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752969AbeE1CSb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:31 -0400
Received: by mail-it0-f48.google.com with SMTP id z6-v6so13182534iti.4
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:31 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 4/6] Btrfs-progs: add write and clone commands debug info to receive
Date: Sun, 27 May 2018 22:14:39 -0400
Message-Id: <20180528021443.13923-11-linux@hmclauchlan.com>
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
References: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@gmail.com>

When specifying -vv print information about received write and clone commands too,
as we do this for other commands already and it's very useful for debugging and
troubleshooting.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-receive.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index 510b6bc8..20e593f7 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -790,6 +790,10 @@ static int process_write(const char *path, const void *data, u64 offset,
 	u64 pos = 0;
 	int w;
 
+	if (g_verbose >= 2)
+		fprintf(stderr, "write %s, offset %llu, len %llu\n",
+			path, offset, len);
+
 	ret = path_cat_out(full_path, rctx->full_subvol_path, path);
 	if (ret < 0) {
 		error("write: path invalid: %s", path);
@@ -831,6 +835,11 @@ static int process_clone(const char *path, u64 offset, u64 len,
 	char full_clone_path[PATH_MAX];
 	int clone_fd = -1;
 
+	if (g_verbose >= 2)
+		fprintf(stderr,
+			"clone %s, offset %llu, len %llu, clone path %s, clone offset %llu\n",
+			path, offset, len, clone_path, clone_offset);
+
 	ret = path_cat_out(full_path, rctx->full_subvol_path, path);
 	if (ret < 0) {
 		error("clone: source path invalid: %s", path);
-- 
2.17.0


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49678 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaDOPlO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 11:41:14 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so5922614wiv.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 08:41:13 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 4/4] Btrfs-progs: add write and clone commands debug info to receive
Date: Tue, 15 Apr 2014 17:40:51 +0100
Message-Id: <1397580051-26643-4-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
References: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When specifying -vv print information about received write and clone commands too,
as we do this for other commands already and it's very useful for debugging and
troubleshooting.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-receive.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index 3f30066..7a23823 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -636,6 +636,10 @@ static int process_write(const char *path, const void *data, u64 offset,
 	u64 pos = 0;
 	int w;
 
+	if (g_verbose >= 2)
+		fprintf(stderr, "write %s, offset %llu, len %llu\n",
+			path, offset, len);
+
 	ret = open_inode_for_write(r, full_path);
 	if (ret < 0)
 		goto out;
@@ -672,6 +676,11 @@ static int process_clone(const char *path, u64 offset, u64 len,
 	char *full_clone_path = NULL;
 	int clone_fd = -1;
 
+	if (g_verbose >= 2)
+		fprintf(stderr,
+			"clone %s, offset %llu, len %llu, clone path %s, clone offset %llu\n",
+			path, offset, len, clone_path, clone_offset);
+
 	ret = open_inode_for_write(r, full_path);
 	if (ret < 0)
 		goto out;
-- 
1.9.1


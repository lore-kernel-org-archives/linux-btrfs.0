Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45634 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077AbaDPN6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 09:58:35 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so10858040wgg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 06:58:33 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 4/4 v2] Btrfs-progs: add write and clone commands debug info to receive
Date: Wed, 16 Apr 2014 15:58:50 +0100
Message-Id: <1397660330-8155-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580051-26643-4-git-send-email-fdmanana@gmail.com>
References: <1397580051-26643-4-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When specifying -vv print information about received write and clone commands too,
as we do this for other commands already and it's very useful for debugging and
troubleshooting.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added new send ioctl flag BTRFS_SEND_FLAG_SUPPORT_FALLOCATE. A version 2
    stream is now only produced is the ioctl caller specifies at least one of
    the new send flags (BTRFS_SEND_FLAG_SUPPORT_FALLOCATE or
    BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE).

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


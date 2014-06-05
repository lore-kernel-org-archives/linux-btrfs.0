Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.mylinuxtime.de ([148.251.109.235]:59918 "EHLO
	mx.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFEIOC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 04:14:02 -0400
From: Christian Hesse <mail@eworm.de>
To: linux-btrfs@vger.kernel.org
Cc: Christian Hesse <mail@eworm.de>
Subject: [PATCH 1/1] btrfs-progs: fix compiler warning
Date: Thu,  5 Jun 2014 10:13:39 +0200
Message-Id: <1401956019-2175-1-git-send-email-mail@eworm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gcc 4.9.0 gives warnings about possibly uninitialized values when
compiling with function inlining and optimization level two enabled
(CFLAGS="-finline-functions -O2").

Initializing the values fixes the warning. Hope this is correct.

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 cmds-send.c   | 2 +-
 send-stream.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 1cd457d..0c3e96b 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -416,7 +416,7 @@ int cmd_send(int argc, char **argv)
 	u32 i;
 	char *mount_root = NULL;
 	char *snapshot_parent = NULL;
-	u64 root_id;
+	u64 root_id = 0;
 	u64 parent_root_id = 0;
 	int full_send = 1;
 	int new_end_cmd_semantic = 0;
diff --git a/send-stream.c b/send-stream.c
index 88e18e2..54edafe 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -216,7 +216,7 @@ static int tlv_get_string(struct btrfs_send_stream *s, int attr, char **str)
 {
 	int ret;
 	void *data;
-	int len;
+	int len = 0;
 
 	TLV_GET(s, attr, &data, &len);
 
-- 
2.0.0


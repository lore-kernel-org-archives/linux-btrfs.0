Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53223 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaCaMw1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 08:52:27 -0400
Received: by mail-wi0-f179.google.com with SMTP id z2so1477218wiv.6
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 05:52:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: send, build path string only once in send_hole
Date: Mon, 31 Mar 2014 14:52:14 +0100
Message-Id: <1396273934-15888-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's no point building the path string in each iteration of the
send_hole loop, as it produces always the same string.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 281ab2c..c81e0d9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4410,6 +4410,9 @@ static int send_hole(struct send_ctx *sctx, u64 end)
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto tlv_put_failure;
 	memset(sctx->read_buf, 0, BTRFS_SEND_READ_SIZE);
 	while (offset < end) {
 		len = min_t(u64, end - offset, BTRFS_SEND_READ_SIZE);
@@ -4417,9 +4420,6 @@ static int send_hole(struct send_ctx *sctx, u64 end)
 		ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
 		if (ret < 0)
 			break;
-		ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
-		if (ret < 0)
-			break;
 		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
 		TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
 		TLV_PUT(sctx, BTRFS_SEND_A_DATA, sctx->read_buf, len);
-- 
1.7.10.4


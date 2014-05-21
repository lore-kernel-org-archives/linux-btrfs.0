Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:59854 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUPYS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 11:24:18 -0400
Received: by mail-wi0-f182.google.com with SMTP id r20so2925386wiv.15
        for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 08:24:16 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe David Borba Manana <fdmanana@gmail.com>,
        Marc Merlin <marc@merlins.org>
Subject: [PATCH] Btrfs: send, fix corrupted paths strings for long paths
Date: Wed, 21 May 2014 17:23:39 +0100
Message-Id: <1400689419-13446-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a path has more than 230 characters, we allocate a new buffer to
use for the path, but we were forgotting to copy the contents of the
previous buffer into the new one, which has random content from the
kmalloc call.

Test:

    mkfs.btrfs -f /dev/sdd
    mount /dev/sdd /mnt

    TEST_PATH="/mnt/fdmanana/.config/google-chrome-mysetup/Default/Pepper_Data/Shockwave_Flash/WritableRoot/#SharedObjects/JSHJ4ZKN/s.wsj.net/[[IMPORT]]/players.edgesuite.net/flash/plugins/osmf/advanced-streaming-plugin/v2.7/osmf1.6/Ak#"
    mkdir -p $TEST_PATH
    echo "hello world" > $TEST_PATH/amaiAdvancedStreamingPlugin.txt

    btrfs subvolume snapshot -r /mnt /mnt/mysnap1
    btrfs send /mnt/mysnap1 -f /tmp/1.snap

A test for xfstests follows.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: Marc Merlin <marc@merlins.org>
---
 fs/btrfs/send.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f6bbc1e..70c5e8c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -368,10 +368,13 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	/*
 	 * First time the inline_buf does not suffice
 	 */
-	if (p->buf == p->inline_buf)
+	if (p->buf == p->inline_buf) {
 		tmp_buf = kmalloc(len, GFP_NOFS);
-	else
+		if (tmp_buf)
+			memcpy(tmp_buf, p->buf, old_buf_len);
+	} else {
 		tmp_buf = krealloc(p->buf, len, GFP_NOFS);
+	}
 	if (!tmp_buf)
 		return -ENOMEM;
 	p->buf = tmp_buf;
-- 
1.9.1


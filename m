Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33160 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759693AbdLSKDB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 05:03:01 -0500
Received: by mail-wr0-f193.google.com with SMTP id v21so7738011wrc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 02:03:01 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 4/4] Btrfs: reduce size of struct btrfs_inode
Date: Tue, 19 Dec 2017 13:02:47 +0300
Message-Id: <20171219100247.13880-5-nefelim4ag@gmail.com>
In-Reply-To: <20171219100247.13880-1-nefelim4ag@gmail.com>
References: <20171219100247.13880-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs_inode have size equal 1136 bytes. (On x86_64).

struct btrfs_inode store several vars releated to compression code,
all states use 1 or 2 bits.

Lets declare bitfields for compression releated vars, to reduce
sizeof btrfs_inode to 1128 bytes.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/btrfs_inode.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 9eb0c92ee4b4..9d29d7e68757 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -181,13 +181,13 @@ struct btrfs_inode {
 	/*
 	 * Cached values of inode properties
 	 */
-	unsigned prop_compress;		/* per-file compression algorithm */
+	unsigned prop_compress : 2;	/* per-file compression algorithm */
 	/*
 	 * Force compression on the file using the defrag ioctl, could be
 	 * different from prop_compress and takes precedence if set
 	 */
-	unsigned defrag_compress;
-	unsigned change_compress;
+	unsigned defrag_compress : 2;
+	unsigned change_compress : 1;
 
 	struct btrfs_delayed_node *delayed_node;
 
-- 
2.15.1

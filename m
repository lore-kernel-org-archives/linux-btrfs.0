Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752041AbeCOMgh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 08:36:37 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F104AD8E
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 12:36:36 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/8] btrfs: Remove unused tot_len var from lzo_decompress
Date: Thu, 15 Mar 2018 14:36:24 +0200
Message-Id: <1521117389-13712-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1521117389-13712-1-git-send-email-nborisov@suse.com>
References: <1521117389-13712-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added already unused in a6fa6fae40ec ("btrfs: Add lzo compression
support")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/lzo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 6c7f18cd3b61..1c7f7f70caf4 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -382,14 +382,12 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 	size_t in_len;
 	size_t out_len;
-	size_t tot_len;
 	int ret = 0;
 	char *kaddr;
 	unsigned long bytes;
 
 	BUG_ON(srclen < LZO_LEN);
 
-	tot_len = read_compress_length(data_in);
 	data_in += LZO_LEN;
 
 	in_len = read_compress_length(data_in);
-- 
2.7.4


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60359 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932265AbeFFH1W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 03:27:22 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83DC9ADF4
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Jun 2018 07:27:20 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs-progs: restore: Fix wrong compressed item size for decompress()
Date: Wed,  6 Jun 2018 15:27:12 +0800
Message-Id: <20180606072717.28854-2-wqu@suse.com>
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
References: <20180606072717.28854-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using decompress() in copy_one_inline(), we're passing the
decompressed extent size (ram_bytes) into decompress().
However we only has @inline_item_len read out, the pending data will be
uninitialized data.

Thankfully, all compression methods supported have some extra data in
its header, thus it won't cause real problem.

Whatever fixing it is never a bad idea.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-restore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 342f5cc7eabb..29a329a397c2 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -324,7 +324,8 @@ static int copy_one_inline(struct btrfs_root *root, int fd,
 		return -ENOMEM;
 	}
 
-	ret = decompress(root, buf, outbuf, len, &ram_size, compress);
+	ret = decompress(root, buf, outbuf, inline_item_len, &ram_size,
+			 compress);
 	if (ret) {
 		free(outbuf);
 		return ret;
-- 
2.17.1


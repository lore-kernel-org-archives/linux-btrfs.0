Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751075AbdEaRu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 13:50:26 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB38CAAB6
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 17:50:24 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/5] btrfs: send: use kvmalloc in iterate_dir_item
Date: Wed, 31 May 2017 19:49:24 +0200
Message-Id: <b4c7abc3e53eda95ca717d793863639711625d63.1496252765.git.dsterba@suse.com>
In-Reply-To: <cover.1496252765.git.dsterba@suse.com>
References: <cover.1496252765.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use a growing buffer for xattrs larger than a page size, at some
point vmalloc is unconditionally used for larger buffers. We can still
try to avoid it using the kvmalloc helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 924b1d941b53..7416b17c0eac 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1083,7 +1083,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 				buf = tmp;
 			}
 			if (!buf) {
-				buf = vmalloc(buf_len);
+				buf = kvmalloc(buf_len, GFP_KERNEL);
 				if (!buf) {
 					ret = -ENOMEM;
 					goto out;
-- 
2.12.0


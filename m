Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39514 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab3EFVjm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 17:39:42 -0400
Received: by mail-wg0-f54.google.com with SMTP id x12so4145408wgg.9
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 14:39:41 -0700 (PDT)
Message-ID: <51882319.1040307@gmail.com>
Date: Mon, 06 May 2013 23:39:37 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] btrfs: don't stop searching after encountering the wrong
 item
References: <5187EB02.8030207@gmail.com>
In-Reply-To: <5187EB02.8030207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The search ioctl skips items that are too large for a result buffer, but
inline items of a certain size occuring before any search result is
found would trigger an overflow and stop the search entirely.

Cc: stable@vger.kernel.org
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=57641

Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
---
(resent, with the correct header to have stable copied)

 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2c02310..f49b62f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1794,23 +1794,23 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 
 	for (i = slot; i < nritems; i++) {
 		item_off = btrfs_item_ptr_offset(leaf, i);
 		item_len = btrfs_item_size_nr(leaf, i);
 
-		if (item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
+		btrfs_item_key_to_cpu(leaf, key, i);
+		if (!key_in_sk(key, sk))
+			continue;
+
+		if (sizeof(sh) + item_len > BTRFS_SEARCH_ARGS_BUFSIZE)
 			item_len = 0;
 
 		if (sizeof(sh) + item_len + *sk_offset >
 		    BTRFS_SEARCH_ARGS_BUFSIZE) {
 			ret = 1;
 			goto overflow;
 		}
 
-		btrfs_item_key_to_cpu(leaf, key, i);
-		if (!key_in_sk(key, sk))
-			continue;
-
 		sh.objectid = key->objectid;
 		sh.offset = key->offset;
 		sh.type = key->type;
 		sh.len = item_len;
 		sh.transid = found_transid;
-- 
1.8.2.1.419.ga0b97c6


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:64995 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3EFRkX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 13:40:23 -0400
Message-ID: <5187EB02.8030207@gmail.com>
Date: Mon, 06 May 2013 19:40:18 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>
CC: linux-stable@vger.kernel.org, Tristan Seligmann <mithrandi@mithrandi.net>
Subject: [PATCH] btrfs: don't stop searching after encountering the wrong
 item
Content-Type: multipart/mixed;
 boundary="------------030409060009020105010200"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030409060009020105010200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The search ioctl skips items that are too large for a result buffer, but
inline items of a certain size occuring before any search result is
found would trigger an overflow and stop the search entirely.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=57641

Signed-off-by: Gabriel de Perthuis <g2p.code+btrfs@gmail.com>
---
 fs/btrfs/ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 95d46cc..b3f0276 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1797,23 +1797,23 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 
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


--------------030409060009020105010200
Content-Type: text/plain; charset=UTF-8;
 name="Portion de message joint"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Portion de message joint"


--------------030409060009020105010200--

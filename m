Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 20.mo1.mail-out.ovh.net ([188.165.45.168]:41922 "EHLO
	20.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbcBVJ6P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 04:58:15 -0500
Received: from mail690.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 2E061102C051
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 10:51:18 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH] Btrfs: dir-item: added line after variable declaration
Date: Mon, 22 Feb 2016 10:51:11 +0100
Message-Id: <1456134671-20827-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added line after variable declaration, fixing checkpatch warning.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/dir-item.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 1752625..70c39a3 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -46,6 +46,7 @@ static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans_handle
 	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
 	if (ret == -EEXIST) {
 		struct btrfs_dir_item *di;
+
 		di = btrfs_match_dir_item_name(root, path, name, name_len);
 		if (di)
 			return ERR_PTR(-EEXIST);
-- 
2.7.1


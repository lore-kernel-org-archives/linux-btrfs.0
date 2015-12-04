Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33953 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbbLDIK6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 03:10:58 -0500
Received: by pacwq6 with SMTP id wq6so6101920pac.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 00:10:57 -0800 (PST)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, Naohiro Aota <naota@elisp.net>
Subject: [PATCH 2/3] btrfs-progs: properly reset nlink of multi-linked file
Date: Fri,  4 Dec 2015 14:37:26 +0900
Message-Id: <1449207447-1203-3-git-send-email-naota@elisp.net>
In-Reply-To: <1449207447-1203-1-git-send-email-naota@elisp.net>
References: <1449207447-1203-1-git-send-email-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a file is linked from more than one directory and only one
of the links is corrupted, btrfs check dose not reset the nlink
properly. Actually it can go into infinite loop to link the broken file
into lost+found.

This patch fix two part of the code. The first one delay the freeing
valid (no error, found inode ref, directory index, and directory
item) backrefs. Freeing valid backrefs earier prevent reset_nlink() to
add back all valid links.

The second fix is obvious: passing `ref_type' to btrfs_add_link() is just
wrong. It should be `filetype' instead. The current code can break all valid
file links.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 6a0b50a..11ff3fe 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -810,7 +810,8 @@ static void maybe_free_inode_rec(struct cache_tree *inode_cache,
 		if (backref->found_dir_item && backref->found_dir_index) {
 			if (backref->filetype != filetype)
 				backref->errors |= REF_ERR_FILETYPE_UNMATCH;
-			if (!backref->errors && backref->found_inode_ref) {
+			if (!backref->errors && backref->found_inode_ref &&
+			    rec->nlink == rec->found_link) {
 				list_del(&backref->list);
 				free(backref);
 			}
@@ -2392,7 +2393,7 @@ static int reset_nlink(struct btrfs_trans_handle *trans,
 	list_for_each_entry(backref, &rec->backrefs, list) {
 		ret = btrfs_add_link(trans, root, rec->ino, backref->dir,
 				     backref->name, backref->namelen,
-				     backref->ref_type, &backref->index, 1);
+				     backref->filetype, &backref->index, 1);
 		if (ret < 0)
 			goto out;
 	}
-- 
2.6.3


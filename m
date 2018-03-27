Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750917AbeC0HTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:41 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A57CB045
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/10] btrfs-progs: Drop ext_ref parameter from find_inode_ref
Date: Tue, 27 Mar 2018 10:19:23 +0300
Message-Id: <1522135172-8276-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a boolean parameter which signals whether the fs has the
EXTENDED_IREF feature flag toggled or not. Since a reference to fs_info
can be obtained there is no need to pollute the interface.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index dac3201b7d99..a8a2f76549a2 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -921,14 +921,13 @@ static int check_inode_extref(struct btrfs_root *root,
  * @namelen:	the length of name in the INODE_REF/INODE_EXTREF
  * @index_ret:	the index in the INODE_REF/INODE_EXTREF,
  *              value (64)-1 means do not check index
- * @ext_ref:	the EXTENDED_IREF feature
  *
  * Return 0 if no error occurred.
  * Return >0 for error bitmap
  */
 static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
-			  char *name, int namelen, u64 *index_ret,
-			  unsigned int ext_ref)
+			  char *name, int namelen, u64 *index_ret)
+
 {
 	struct btrfs_path path;
 	struct btrfs_inode_ref *ref;
@@ -1001,8 +1000,9 @@ static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
 	}
 
 extref:
+
 	/* Skip if not support EXTENDED_IREF feature */
-	if (!ext_ref)
+	if (!btrfs_fs_incompat(root->fs_info, EXTENDED_IREF))
 		goto out;
 
 	btrfs_release_path(&path);
@@ -1311,8 +1311,7 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *di_key,
 		key.objectid = location.objectid;
 		key.type = BTRFS_INODE_REF_KEY;
 		key.offset = di_key->objectid;
-		tmp_err |= find_inode_ref(root, &key, namebuf, len,
-					  &index, ext_ref);
+		tmp_err |= find_inode_ref(root, &key, namebuf, len, &index);
 
 		/* check relative INDEX/ITEM */
 		key.objectid = di_key->objectid;
@@ -4241,7 +4240,7 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 	/* special index value */
 	index = 0;
 
-	ret = find_inode_ref(root, &key, "..", strlen(".."), &index, ext_ref);
+	ret = find_inode_ref(root, &key, "..", strlen(".."), &index);
 	if (ret < 0)
 		goto out;
 	err |= ret;
-- 
2.7.4


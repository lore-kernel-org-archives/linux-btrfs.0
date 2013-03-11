Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab3CKRHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 13:07:48 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B47EFA4386
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 18:07:47 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs: merge save_error_info helpers into one
Date: Mon, 11 Mar 2013 18:07:45 +0100
Message-Id: <1363021665-15359-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/super.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 68a29a1..eed1464 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -91,7 +91,7 @@ static const char *btrfs_decode_error(int errno, char nbuf[16])
 	return errstr;
 }
 
-static void __save_error_info(struct btrfs_fs_info *fs_info)
+static void save_error_info(struct btrfs_fs_info *fs_info)
 {
 	/*
 	 * today we only save the error info into ram.  Long term we'll
@@ -100,11 +100,6 @@ static void __save_error_info(struct btrfs_fs_info *fs_info)
 	set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
 }
 
-static void save_error_info(struct btrfs_fs_info *fs_info)
-{
-	__save_error_info(fs_info);
-}
-
 /* btrfs handle error by forcing the filesystem readonly */
 static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 {
-- 
1.7.9


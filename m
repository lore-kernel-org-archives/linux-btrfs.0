Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752428AbdBMJfN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:35:13 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CCA75ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:35:06 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 25/29] btrfs: remove unused parameter from clone_copy_inline_extent
Date: Mon, 13 Feb 2017 10:34:38 +0100
Message-Id: <3f8bfd048583e3c93e834305b46152b05c76b70a.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1f13f8416d29..b9e6f8a4f760 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3383,8 +3383,7 @@ static void clone_update_extent_map(struct inode *inode,
  * data into the destination inode's inline extent if the later is greater then
  * the former.
  */
-static int clone_copy_inline_extent(struct inode *src,
-				    struct inode *dst,
+static int clone_copy_inline_extent(struct inode *dst,
 				    struct btrfs_trans_handle *trans,
 				    struct btrfs_path *path,
 				    struct btrfs_key *new_key,
@@ -3763,7 +3762,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 				size -= skip + trim;
 				datal -= skip + trim;
 
-				ret = clone_copy_inline_extent(src, inode,
+				ret = clone_copy_inline_extent(inode,
 							       trans, path,
 							       &new_key,
 							       drop_start,
-- 
2.10.1


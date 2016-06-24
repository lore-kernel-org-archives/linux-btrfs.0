Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbcFXWP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:29 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 08888AD93
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:27 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/31] btrfs: copy_to_sk drop unused root parameter
Date: Fri, 24 Jun 2016 18:15:01 -0400
Message-Id: <1466806524-27508-9-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

The root parameter for copy_to_sk is not used at all.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ioctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ffb1628..81413e6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1948,8 +1948,7 @@ static noinline int key_in_sk(struct btrfs_key *key,
 	return 1;
 }
 
-static noinline int copy_to_sk(struct btrfs_root *root,
-			       struct btrfs_path *path,
+static noinline int copy_to_sk(struct btrfs_path *path,
 			       struct btrfs_key *key,
 			       struct btrfs_ioctl_search_key *sk,
 			       size_t *buf_size,
@@ -2120,7 +2119,7 @@ static noinline int search_ioctl(struct inode *inode,
 				ret = 0;
 			goto err;
 		}
-		ret = copy_to_sk(root, path, &key, sk, buf_size, ubuf,
+		ret = copy_to_sk(path, &key, sk, buf_size, ubuf,
 				 &sk_offset, &num_found);
 		btrfs_release_path(path);
 		if (ret)
-- 
2.7.1


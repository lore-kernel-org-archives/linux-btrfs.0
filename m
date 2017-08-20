Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57678 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753191AbdHTUVP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 16:21:15 -0400
Subject: [PATCH 4/4] btrfs: Delete an unnecessary variable initialisation in
 tree_mod_log_eb_copy()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
Message-ID: <31e6e888-586c-3480-7d57-dbf96989a26c@users.sourceforge.net>
Date: Sun, 20 Aug 2017 22:20:59 +0200
MIME-Version: 1.0
In-Reply-To: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 22:02:54 +0200

The variable "tm_list" will eventually be set to an appropriate pointer
a bit later. Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/btrfs/ctree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3b49f39eaaf6..78387f5be0ce 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -801,7 +801,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 		     unsigned long src_offset, int nr_items)
 {
 	int ret = 0;
-	struct tree_mod_elem **tm_list = NULL;
+	struct tree_mod_elem **tm_list;
 	struct tree_mod_elem **tm_list_add, **tm_list_rem;
 	int i;
 	int locked = 0;
-- 
2.14.0


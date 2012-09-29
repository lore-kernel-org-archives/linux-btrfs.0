Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36190 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2I2NUL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 09:20:11 -0400
Received: by lagh6 with SMTP id h6so1390858lag.19
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Sep 2012 06:20:09 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 29 Sep 2012 22:20:09 +0900
Message-ID: <CANW9uyu_-DFmggZUyAc1OOd0knMxEp-O3GPcs_8ZsoXAxm0DZg@mail.gmail.com>
Subject: [PATCH] Btrfs: shrink_delalloc check bdi write congested
From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In srhink_delalloc(), writeback starts if idle, also check the bdi is
not write congested.
The patch is against the head of the btrfs-next.

Signed-off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

 fs/btrfs/extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index efb044e..caa74d3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3712,7 +3712,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 t
        while (delalloc_bytes && loops < 3) {
                max_reclaim = min(delalloc_bytes, to_reclaim);
                nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
-               writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
+               if (!bdi_write_congested(root->fs_info->sb->s_bdi)) writeback_in
                                               WB_REASON_FS_FREE_SPACE);

                /*

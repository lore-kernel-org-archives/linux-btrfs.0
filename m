Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbbFWV2w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 17:28:52 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/5] btrfs: pass unaligned length to btrfs_cmp_data()
Date: Tue, 23 Jun 2015 14:28:36 -0700
Message-Id: <1435094920-22442-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1435094920-22442-1-git-send-email-mfasheh@suse.de>
References: <1435094920-22442-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the case that we dedupe the tail of a file, we might expand the dedupe
len out to the end of our last block. We don't want to compare data past
i_size however, so pass the original length to btrfs_cmp_data().

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2d24ff4..2deea1f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2933,7 +2933,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 		goto out_unlock;
 	}
 
-	ret = btrfs_cmp_data(src, loff, dst, dst_loff, len);
+	/* pass original length for comparison so we stay within i_size */
+	ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen);
 	if (ret == 0)
 		ret = btrfs_clone(src, dst, loff, olen, len, dst_loff);
 
-- 
2.1.2


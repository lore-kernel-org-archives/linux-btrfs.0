Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:42713 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbdKVVQZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 16:16:25 -0500
Received: by mail-qt0-f194.google.com with SMTP id j12so3862979qtc.9
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 13:16:25 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v2 11/11] btrfs: add NR_METADATA_BYTES accounting
Date: Wed, 22 Nov 2017 16:16:06 -0500
Message-Id: <1511385366-20329-12-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1511385366-20329-1-git-send-email-josef@toxicpanda.com>
References: <1511385366-20329-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Now that we have these counters, account for the private pages we
allocate in NR_METADATA_BYTES.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e11372455fb0..7536352f424d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4802,6 +4802,8 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 
+		mod_node_page_state(page_pgdat(page), NR_METADATA_BYTES,
+				    -(long)PAGE_SIZE);
 		/* Once for the page private. */
 		put_page(page);
 
@@ -5081,6 +5083,8 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			goto free_eb;
 		}
 		attach_extent_buffer_page(eb, p);
+		mod_node_page_state(page_pgdat(p), NR_METADATA_BYTES,
+				    PAGE_SIZE);
 		eb->pages[i] = p;
 	}
 again:
-- 
2.7.5


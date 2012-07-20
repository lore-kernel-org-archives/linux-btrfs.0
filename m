Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:58060 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab2GTUWf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 16:22:35 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id JYS4EOf2F8sWpaq6 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 14:22:34 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: lock the transition from dirty to writeback for an eb
Date: Fri, 20 Jul 2012 16:27:31 -0400
Message-ID: <1342816051-10003-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a small window where an eb can have no IO bits set on it, which
could potentially result in extent_buffer_under_io() returning false when we
want it to return true, which could result in not fun things happening.  So
in order to protect this case we need to hold the refs_lock when we make
this transition to make sure we get reliable results out of
extent_buffer_udner_io().  Thanks,
Btrfs: lock the transition from dirty to writeback for an eb

There is a small window where an eb can have no IO bits set on it, which
could potentially result in extent_buffer_under_io() returning false when we
want it to return true, which could result in not fun things happening.  So
in order to protect this case we need to hold the refs_lock when we make
this transition to make sure we get reliable results out of
extent_buffer_udner_io().  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20440ea..669219b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3077,8 +3077,15 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 		}
 	}
 
+	/*
+	 * We need to do this to prevent races in people who check if the eb is
+	 * under IO since we can end up having no IO bits set for a short period
+	 * of time.
+	 */
+	spin_lock(&eb->refs_lock);
 	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->bflags)) {
 		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
+		spin_unlock(&eb->refs_lock);
 		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
 		spin_lock(&fs_info->delalloc_lock);
 		if (fs_info->dirty_metadata_bytes >= eb->len)
@@ -3087,6 +3094,8 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 			WARN_ON(1);
 		spin_unlock(&fs_info->delalloc_lock);
 		ret = 1;
+	} else {
+		spin_unlock(&eb->refs_lock);
 	}
 
 	btrfs_tree_unlock(eb);
-- 
1.7.7.6


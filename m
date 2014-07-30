Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbaG3QiY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 12:38:24 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] Btrfs: Kill u64_to_ptr() and ptr_to_u64() macros
Date: Wed, 30 Jul 2014 18:38:23 +0200
Message-Id: <1406738303-24341-2-git-send-email-tiwai@suse.de>
In-Reply-To: <1406738303-24341-1-git-send-email-tiwai@suse.de>
References: <1406738303-24341-1-git-send-email-tiwai@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These macros are no longer used after replacements of aux data type.
Let's kill them.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 fs/btrfs/qgroup.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b499f580d005..dc2665cb3f1b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -99,9 +99,6 @@ struct btrfs_qgroup_list {
 	struct btrfs_qgroup *member;
 };
 
-#define ptr_to_u64(x) ((u64)(uintptr_t)x)
-#define u64_to_ptr(x) ((struct btrfs_qgroup *)(uintptr_t)x)
-
 static int
 qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 		   int init_flags);
-- 
2.0.1


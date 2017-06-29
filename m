Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52062 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751898AbdF2D41 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 23:56:27 -0400
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: [PATCH v2 11/13] btrfs: add cond_resched() calls when resolving backrefs
Date: Wed, 28 Jun 2017 21:57:03 -0600
Message-Id: <20170629035705.1589-12-enadolski@suse.com>
In-Reply-To: <20170629035705.1589-1-enadolski@suse.com>
References: <20170629035705.1589-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since backref resolution is CPU-intensive, the cond_resched calls
should help alleviate soft lockup occurences.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 54180f4..3cd4f05 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -656,6 +656,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		prelim_ref_insert(fs_info, &preftrees->direct, ref);
 
 		ulist_reinit(parents);
+		cond_resched();
 	}
 out:
 	ulist_free(parents);
@@ -698,6 +699,7 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 		btrfs_tree_read_unlock(eb);
 		free_extent_buffer(eb);
 		prelim_ref_insert(fs_info, &preftrees->indirect, ref);
+		cond_resched();
 	}
 	return 0;
 }
@@ -1239,6 +1241,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			}
 			eie = NULL;
 		}
+		cond_resched();
 	}
 
 out:
-- 
2.10.2


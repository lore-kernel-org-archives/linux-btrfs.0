Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60455 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751901AbdFTQGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 12:06:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E2FFAAC5
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 16:06:08 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 11/13] btrfs: add cond_resched() calls when resolving backrefs
Date: Tue, 20 Jun 2017 10:06:51 -0600
Message-Id: <20170620160653.19907-12-enadolski@suse.com>
In-Reply-To: <20170620160653.19907-1-enadolski@suse.com>
References: <20170620160653.19907-1-enadolski@suse.com>
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
index 0dffd7e..e95049a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -658,6 +658,7 @@ static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 		prelim_ref_insert(fs_info, &preftrees->direct, ref);
 
 		ulist_reinit(parents);
+		cond_resched();
 	}
 out:
 	ulist_free(parents);
@@ -697,6 +698,7 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 			btrfs_node_key_to_cpu(eb, &ref->key_for_search, 0);
 		btrfs_tree_read_unlock(eb);
 		free_extent_buffer(eb);
+		cond_resched();
 	}
 	return 0;
 }
@@ -1236,6 +1238,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			}
 			eie = NULL;
 		}
+		cond_resched();
 	}
 
 out:
-- 
2.10.2


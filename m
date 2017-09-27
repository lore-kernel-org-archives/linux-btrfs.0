Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19661 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751821AbdI0Gby (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 02:31:54 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 600EE47CAAD0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 14:31:40 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] btrfs-progs: check: return value of check_extent_refs()
Date: Wed, 27 Sep 2017 14:34:36 +0800
Message-ID: <20170927063440.25961-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In original check mode(without option "--repair"), check_extent_refs()
always returns 0.

Add a variable @error to record status while checking extents.
At the end of check_extent_refs(), let it return -EIO if @error is
nonzero.

Example:
$ btrfs check bad-extent-inline-ref-type.raw
Checking filesystem on bad-extent-inline-ref-type.raw
UUID: 1942d6fe-617b-4499-9982-cc8ffae5447f
checking extents
corrupt extent record: key 29360128 169 16384
ref mismatch on [29360128 16384] extent item 0, found 1
Backref 29360128 parent 5 root 5 not found in extent tree
backpointer mismatch on [29360128 16384]
bad extent [29360128, 29376512), type mismatch with chunk
checking free space cache
checking fs roots
checking csums
checking root refs
found 114688 bytes used, no error found
total csum bytes: 0
total tree bytes: 114688
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 109471
file data blocks allocated: 0
 referenced 0

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 8aa136df..93b47194 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10664,6 +10664,7 @@ static int check_extent_refs(struct btrfs_root *root,
 	struct cache_extent *cache;
 	int ret = 0;
 	int had_dups = 0;
+	int error = 0;
 
 	if (repair) {
 		/*
@@ -10807,6 +10808,7 @@ static int check_extent_refs(struct btrfs_root *root,
 			cur_err = 1;
 		}
 
+		error = cur_err;
 		remove_cache_extent(extent_cache, cache);
 		free_all_extent_backrefs(rec);
 		if (!init_extent_tree && repair && (!cur_err || fix))
@@ -10839,7 +10841,10 @@ repair_abort:
 		}
 		return ret;
 	}
-	return 0;
+
+	if (error)
+		error = -EIO;
+	return error;
 }
 
 u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
-- 
2.14.1




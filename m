Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:32469 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728219AbeIJTza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 15:55:30 -0400
Date: Mon, 10 Sep 2018 23:00:29 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: kbuild-all@01.org, David Sterba <dsterba@suse.com>,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH linux-next] btrfs: btrfs_run_delayed_refs_for_head() can
 be static
Message-ID: <20180910150029.GA11874@lkp-wsm-ep1.lkp.intel.com>
References: <201809102215.95hxOLVe%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201809102215.95hxOLVe%fengguang.wu@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Fixes: ac75a14eb672 ("btrfs: Factor out loop processing all refs of a head")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 extent-tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b0882b6..719f1bb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2537,9 +2537,9 @@ struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
 }
 
 STATIC
-int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
-				    struct btrfs_delayed_ref_head *locked_ref,
-				    unsigned long *run_refs)
+static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
+					   struct btrfs_delayed_ref_head *locked_ref,
+					   unsigned long *run_refs)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_delayed_ref_root *delayed_refs;

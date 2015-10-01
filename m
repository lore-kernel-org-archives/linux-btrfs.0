Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14081 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbbJAW2N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 18:28:13 -0400
Date: Fri, 2 Oct 2015 06:26:24 +0800
From: kbuild test robot <lkp@intel.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com,
        david@fromorbit.com
Subject: [RFC PATCH] btrfs: drop_status_lock can be static
Message-ID: <20151001222624.GA2456@lkp-nex05>
References: <201510020624.ABe5GlB7%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151001213047.GB1044@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 extent-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75f499e..0e9a9f1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8465,7 +8465,7 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
 	return 1;
 }
 
-DEFINE_SPINLOCK(drop_status_lock);
+static DEFINE_SPINLOCK(drop_status_lock);
 void btrfs_add_drop_status(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;

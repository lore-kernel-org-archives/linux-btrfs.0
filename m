Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25775 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751019AbdEJCg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 22:36:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [RFC PATCH v3 3/6] btrfs: qgroup: Return actually freed bytes for qgroup release or free data
Date: Wed, 10 May 2017 10:36:46 +0800
Message-ID: <20170510023649.31331-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170510023649.31331-1-quwenruo@cn.fujitsu.com>
References: <20170510023649.31331-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_qgroup_release/free_data() only returns 0 or minus error
number(ENOMEM is the only possible error).

This is normally good enough, but sometimes we need the accurate byte
number it freed/released.

Change it to return actually released/freed bytenr number instead of 0
for success.
And slightly modify related extent_changeset structure, since in btrfs
one none-hole data extent won't be larger than 128M, so "unsigned int"
is large enough for the use case.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/extent_io.h   | 2 +-
 fs/btrfs/qgroup.c      | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e390451c72e6..4f62696131a6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4298,7 +4298,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 start, u64 len)
 
 	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
 	ret = btrfs_qgroup_reserve_data(inode, start, len);
-	if (ret)
+	if (ret < 0)
 		btrfs_free_reserved_data_space_noquota(inode, start, len);
 	return ret;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 1eafa2f0ede3..cc1b08fa9fe7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -205,7 +205,7 @@ struct extent_buffer {
  */
 struct extent_changeset {
 	/* How many bytes are set/cleared in this operation */
-	u64 bytes_changed;
+	unsigned int bytes_changed;
 
 	/* Changed ranges */
 	struct ulist range_changed;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9f01c25469f7..ad2e99491395 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2886,6 +2886,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
 				BTRFS_I(inode)->root->objectid,
 				changeset.bytes_changed);
+	ret = changeset.bytes_changed;
 out:
 	ulist_release(&changeset.range_changed);
 	return ret;
-- 
2.12.2




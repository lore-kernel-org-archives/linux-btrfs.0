Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6243 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752664AbbEKIJG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 04:09:06 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t4B87i16028779
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 16:07:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 10/13] btrfs-progs: Introduce change_id_prepare() and change_id_done() functions.
Date: Mon, 11 May 2015 16:08:51 +0800
Message-ID: <1431331734-11714-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two functions will write flags to all supers before and after
fsid/chunk tree id change, informing kernel not to mount a inconsistent
fs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced to inform kernel and progs not to open fs with
  unfinished uuid change.
---
 props.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/props.c b/props.c
index 59e09b3..0a1bc1e 100644
--- a/props.c
+++ b/props.c
@@ -351,6 +351,38 @@ out:
 	return ret;
 }
 
+static int change_id_prepare(struct btrfs_fs_info *fs_info)
+{
+	u64 flags = btrfs_super_flags(fs_info->super_copy);
+
+	if (!fs_info->new_fsid && !fs_info->new_chunk_tree_uuid)
+		return 0;
+
+	if (fs_info->new_fsid)
+		flags |= BTRFS_SUPER_FLAG_CHANGING_FSID;
+	if (fs_info->new_chunk_tree_uuid)
+		flags |= BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID;
+	btrfs_set_super_flags(fs_info->super_copy, flags);
+
+	return write_all_supers(fs_info->tree_root);
+}
+
+static int change_id_done(struct btrfs_fs_info *fs_info)
+{
+	u64 flags = btrfs_super_flags(fs_info->super_copy);
+
+	if (!fs_info->new_fsid && !fs_info->new_chunk_tree_uuid)
+		return 0;
+
+	if (fs_info->new_fsid)
+		flags &= ~BTRFS_SUPER_FLAG_CHANGING_FSID;
+	if (fs_info->new_chunk_tree_uuid)
+		flags &= ~BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID;
+	btrfs_set_super_flags(fs_info->super_copy, flags);
+
+	return write_all_supers(fs_info->tree_root);
+}
+
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
-- 
2.4.0


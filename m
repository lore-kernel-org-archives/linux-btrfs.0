Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20078 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaCKSYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 14:24:49 -0400
From: Guangyu Sun <guangyu.sun@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, koen.de.wit@oracle.com
Subject: [PATCH v2] Btrfs: return EPERM when deleting a default subvolume
Date: Tue, 11 Mar 2014 11:24:18 -0700
Message-Id: <1394562258-17024-1-git-send-email-guangyu.sun@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error message is confusing:

 # btrfs sub delete /mnt/mysub/
 Delete subvolume '/mnt/mysub'
 ERROR: cannot delete '/mnt/mysub' - Directory not empty

The error message does not make sense to me: It's not about deleting a
directory but it's a subvolume, and it doesn't matter if the subvolume is
empty or not.

Maybe EPERM or is more appropriate in this case, combined with an explanatory
kernel log message. (e.g. "subvolume with ID 123 cannot be deleted because
it is configured as default subvolume.")

Reported-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
---
 fs/btrfs/ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a6d8efa..0751c0f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1797,7 +1797,9 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	if (di && !IS_ERR(di)) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
 		if (key.objectid == root->root_key.objectid) {
-			ret = -ENOTEMPTY;
+			ret = -EPERM;
+			btrfs_err(root->fs_info, "deleting default subvolume "
+				  "%llu is not allowed", key.objectid);
 			goto out;
 		}
 		btrfs_release_path(path);
-- 
1.7.9.5


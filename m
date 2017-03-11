Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752022AbdCKXDM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Mar 2017 18:03:12 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH v2] qgroup: Retry after commit on getting EDQUOT
Date: Sat, 11 Mar 2017 17:02:57 -0600
Message-Id: <20170311230257.12260-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We are facing the same problem with EDQUOT which was experienced with
ENOSPC. Not sure if we require a full ticketing system such as ENOSPC, but
here is a fix. Let me know if it is too big a hammer.

Quotas are reserved during the start of an operation, incrementing
qg->reserved. However, it is written to disk in a commit_transaction
which could take as long as commit_interval. In the meantime there
could be deletions which are not accounted for because deletions are
accounted for only while committed (free_refroot). So, when we get
a EDQUOT flush the data to disk and try again.

I combined the conditions of rfer and excl to reduce code lines, though
the condition looks uglier.

Here is a sample script which shows this issue.

DEVICE=/dev/vdb
MOUNTPOINT=/mnt
TESTVOL=$MOUNTPOINT/tmp
QUOTA=5
PROG=btrfs
DD_BS="4k"
DD_COUNT="256"
RUN_TIMES=5000

mkfs.btrfs -f $DEVICE
mount -o commit=240 $DEVICE $MOUNTPOINT
$PROG subvolume create $TESTVOL
$PROG quota enable $TESTVOL
$PROG qgroup limit ${QUOTA}G $TESTVOL

typeset -i DD_RUN_GOOD
typeset -i QUOTA

function _check_cmd() {
        if [[ ${?} > 0 ]]; then
                echo -n "$(date) E: Running previous command"
                echo ${*}
		echo "Without sync"
		$PROG qgroup show -pcreFf ${TESTVOL}
		echo "With sync"
		$PROG qgroup show -pcreFf --sync ${TESTVOL}
                exit 1
        fi
}

while true; do
DD_RUN_GOOD=$RUN_TIMES

while (( ${DD_RUN_GOOD} != 0 )); do
	dd if=/dev/zero of=${TESTVOL}/quotatest${DD_RUN_GOOD} bs=${DD_BS} count=${DD_COUNT}
	_check_cmd "dd if=/dev/zero of=${TESTVOL}/quotatest${DD_RUN_GOOD} bs=${DD_BS} count=${DD_COUNT}"
	DD_RUN_GOOD=(${DD_RUN_GOOD}-1)
done

$PROG qgroup show -pcref $TESTVOL
echo "----------- Cleanup ---------- "
rm $TESTVOL/quotatest*

done

Changes since v1:
 - Changed start_delalloc_roots() to start_delalloc_inode() to target
   the root in question only to reduce the amount of flush to be done.
 - Added wait_ordered_extents().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a5da750..6215264 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2367,6 +2367,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
+	int retried = 0;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 
@@ -2376,6 +2377,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 	if (num_bytes == 0)
 		return 0;
 
+retry:
 	spin_lock(&fs_info->qgroup_lock);
 	quota_root = fs_info->quota_root;
 	if (!quota_root)
@@ -2402,6 +2404,19 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 		qg = unode_aux_to_qgroup(unode);
 
 		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
+			if (!retried && qg->reserved > 0) {
+				struct btrfs_trans_handle *trans;
+				spin_unlock(&fs_info->qgroup_lock);
+				btrfs_start_delalloc_inodes(root, 0);
+				btrfs_wait_ordered_extents(root, -1, 0,
+						(u64)-1);
+				trans = btrfs_join_transaction(root);
+				if (IS_ERR(trans))
+					return PTR_ERR(trans);
+				btrfs_commit_transaction(trans);
+				retried++;
+				goto retry;
+			}
 			ret = -EDQUOT;
 			goto out;
 		}
-- 
2.10.2


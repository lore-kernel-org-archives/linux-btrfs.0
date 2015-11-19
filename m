Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44583 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757419AbbKSJ2N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 04:28:13 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAJ9RRJe016697
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 17:27:27 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: Support convert to -d dup for btrfs-convert
Date: Thu, 19 Nov 2015 17:26:22 +0800
Message-ID: <a00388267bcd7b1f90f45259338901ba1cfffb0b.1447925171.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we will add support for -d dup for non-mixed filesystem,
kernel need to support converting to this raid-type.

This patch remove limitation of above case.

Tested by following script:
(combination of dup conversion with fsck):

export TEST_DEV='/dev/vdc'
export TEST_DIR='/var/ltf/tester/mnt'

do_dup_test()
{
    local m_from="$1"
    local d_from="$2"
    local m_to="$3"
    local d_to="$4"

    echo "Convert from -m $m_from -d $d_from to -m $m_to -d $d_to"

    umount "$TEST_DIR" &>/dev/null
    ./mkfs.btrfs -f -m "$m_from" -d "$d_from" "$TEST_DEV" >/dev/null || return 1
    mount "$TEST_DEV" "$TEST_DIR" || return 1

    cp -a /sbin/* "$TEST_DIR"

    [[ "$m_from" != "$m_to" ]] && {
        ./btrfs balance start -f -mconvert="$m_to" "$TEST_DIR" || return 1
    }

    [[ "$d_from" != "$d_to" ]] && {
	local opt=()
	[[ "$d_to" == single ]] && opt+=("-f")
        ./btrfs balance start "${opt[@]}" -dconvert="$d_to" "$TEST_DIR" || return 1
    }

    umount "$TEST_DIR" || return 1
    ./btrfsck "$TEST_DEV" || return 1
    echo

    return 0
}

test_all()
{
    for m_from in single dup; do
    for d_from in single dup; do
    for m_to in single dup; do
    for d_to in single dup; do
    do_dup_test "$m_from" "$d_from" "$m_to" "$d_to" || return 1
    done
    done
    done
    done
}

test_all

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6fc73586..9f3f4a0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3551,14 +3551,6 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		goto out;
 	}
 
-	/* allow dup'ed data chunks only in mixed mode */
-	if (!mixed && (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-	    (bctl->data.target & BTRFS_BLOCK_GROUP_DUP)) {
-		btrfs_err(fs_info, "dup for data is not allowed");
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/* allow to reduce meta or sys integrity only if force set */
 	allowed = BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
 			BTRFS_BLOCK_GROUP_RAID10 |
-- 
1.8.5.1


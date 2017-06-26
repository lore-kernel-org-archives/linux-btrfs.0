Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60520 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751441AbdFZKhf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 06:37:35 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marc@merlins.org>
Subject: [PATCH v3 1/4] btrfs-progs: lowmem check: Fix false alert about file extent interrupt
Date: Mon, 26 Jun 2017 18:37:24 +0800
Message-ID: <20170626103727.8945-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As Qu mentioned in this thread
(https://www.spinics.net/lists/linux-btrfs/msg64469.html), compression
can cause regular extent to co-exist with inlined extent. This coexistence
makes things confusing. Since it was permitted currently, so fix
btrfsck to prevent a bunch of error logs that will make user feel
panic.

When check file extent, record the extent_end of regular extent to check
if there is a gap between the regular extents. Normally there is only one
inlined extent, so the extent_end of inlined extent is useless. However,
if regular extent can co-exist with inlined extent, the extent_end of
inlined extent also need to record.

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---

Changlog:
v2: Just fix reported-by
v3: Output verbose information when file extent interrupt

 cmds-check.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c052f66e..70d2b7f2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4782,6 +4782,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 				extent_num_bytes, item_inline_len);
 			err |= FILE_EXTENT_ERROR;
 		}
+		*end += extent_num_bytes;
 		*size += extent_num_bytes;
 		return err;
 	}
@@ -4847,8 +4848,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 		      root->objectid, fkey->objectid, fkey->offset);
 	} else if (!no_holes && *end != fkey->offset) {
 		err |= FILE_EXTENT_ERROR;
-		error("root %llu EXTENT_DATA[%llu %llu] interrupt",
-		      root->objectid, fkey->objectid, fkey->offset);
+		error("root %llu EXTENT_DATA[%llu %llu] interrupt, should start at %llu",
+		      root->objectid, fkey->objectid, fkey->offset, *end);
 	}
 
 	*end += extent_num_bytes;
-- 
2.13.1




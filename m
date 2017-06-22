Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25504 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752667AbdFVINB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 04:13:01 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <marc@merlins.org>
Subject: [PATCH v2] btrfs-progs: lowmem check: Fix false alert about file extent interrupt
Date: Thu, 22 Jun 2017 16:12:56 +0800
Message-ID: <20170622081256.4981-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170622075237.1852-1-lufq.fnst@cn.fujitsu.com>
References: <20170622075237.1852-1-lufq.fnst@cn.fujitsu.com>
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

Sorry, I mistook the reporter in v1.
Changes since v1:
- Fix the reported-by.

 cmds-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-check.c b/cmds-check.c
index c052f66e..c173d285 100644
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
-- 
2.13.1




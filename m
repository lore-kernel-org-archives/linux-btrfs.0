Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49015 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932383AbcLLJit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 04:38:49 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 2/3] btrfs: scrub: Fix RAID56 recovery race condition
Date: Mon, 12 Dec 2016 17:38:42 +0800
Message-Id: <20161212093843.8878-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161212093843.8878-1-quwenruo@cn.fujitsu.com>
References: <20161212093843.8878-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When scrubbing a RAID5 which has recoverable data corruption (only one
data stripe is corrupted), sometimes scrub will report more csum errors
than expected. Sometimes even unrecoverable error will be reported.

The problem can be easily reproduced by the following steps:
1) Create a btrfs with RAID5 data profile with 3 devs
2) Mount it with nospace_cache or space_cache=v2
   To avoid extra data space usage.
3) Create a 128K file and sync the fs, unmount it
   Now the 128K file lies at the beginning of the data chunk
4) Locate the physical bytenr of data chunk on dev3
   Dev3 is the 1st data stripe.
5) Corrupt the first 64K of the data chunk stripe on dev3
6) Mount the fs and scrub it

The correct csum error number should be 16(assuming using x86_64).
Larger csum error number can be reported in a 1/3 chance.
And unrecoverable error can also be reported in a 1/10 chance.

The root cause of the problem is RAID5/6 recover code has race
condition, due to the fact that full scrub is initiated per device.

While for other mirror based profiles, each mirror is independent with
each other, so race won't cause any big problem.

For example:
        Corrupted       |       Correct          |      Correct        |
|   Scrub dev3 (D1)     |    Scrub dev2 (D2)     |    Scrub dev1(P)    |
------------------------------------------------------------------------
Read out D1             |Read out D2             |Read full stripe     |
Check csum              |Check csum              |Check parity         |
Csum mismatch           |Csum match, continue    |Parity mismatch      |
handle_errored_block    |                        |handle_errored_block |
 Read out full stripe   |                        | Read out full stripe|
 D1 csum error(err++)   |                        | D1 csum error(err++)|
 Recover D1             |                        | Recover D1          |

So D1's csum error is accounted twice, just because
handle_errored_block() doesn't have enough protect, and race can happen.

On even worse case, for example D1's recovery code is re-writing
D1/D2/P, and P's recovery code is just reading out full stripe, then we
can cause unrecoverable error.

This patch will use previously introduced lock_full_stripe() and
unlock_full_stripe() to protect the whole scrub_handle_errored_block()
function for RAID56 recovery.
So no extra csum error nor unrecoverable error.

Reported-by: Goffredo Baroncelli <kreijack@libero.it>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2b9555c..5b2f94a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1067,6 +1067,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	unsigned int have_csum;
 	struct scrub_block *sblocks_for_recheck; /* holds one for each mirror */
 	struct scrub_block *sblock_bad;
+	int lock_ret;
 	int ret;
 	int mirror_index;
 	int page_num;
@@ -1096,6 +1097,17 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 	have_csum = sblock_to_check->pagev[0]->have_csum;
 	dev = sblock_to_check->pagev[0]->dev;
 
+	/*
+	 * For RAID5/6 race can happen for different dev scrub thread.
+	 * For data corruption, Parity and Data thread will both try
+	 * to recovery the data.
+	 * Race can lead to double added csum error, or even unrecoverable
+	 * error.
+	 */
+	ret = lock_full_stripe(fs_info, logical, GFP_NOFS);
+	if (ret < 0)
+		return ret;
+
 	if (sctx->is_dev_replace && !is_metadata && !have_csum) {
 		sblocks_for_recheck = NULL;
 		goto nodatasum_case;
@@ -1430,6 +1442,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
 		kfree(sblocks_for_recheck);
 	}
 
+	lock_ret = unlock_full_stripe(fs_info, logical);
+	if (lock_ret < 0)
+		return lock_ret;
 	return 0;
 }
 
-- 
2.10.2




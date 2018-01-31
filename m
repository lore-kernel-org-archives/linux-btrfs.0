Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59477 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbeAaF41 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 31 Jan 2018 00:56:27 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs: volumes: Remove the meaningless condition of minimal nr_devs when allocating a chunk
Date: Wed, 31 Jan 2018 13:56:15 +0800
Message-Id: <20180131055615.14454-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When checking the minimal nr_devs, there is one dead and meaningless
condition:

if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This condition is meaningless, @devs_increment has nothing to do with
@sub_stripes.

In fact, in btrfs_raid_array[], profile with sub_stripes larger than 1
(RAID10) already has the @devs_increment set to 2.
So no need to multiple it by @sub_stripes.

And above condition is also dead.
For RAID10, @devs_increment * @sub_stripes equals 4, which is also the
@devs_min of RAID10.
For other profiles, @sub_stripes is always 1, and since @ndevs is
rounded down to @devs_increment, the condition will always be true.

Remove the meaningless condition to make later reader wander less.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 215e85e22c8e..cb0a8d27661b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4729,7 +4729,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	/* round down to number of usable stripes */
 	ndevs = round_down(ndevs, devs_increment);
 
-	if (ndevs < devs_increment * sub_stripes || ndevs < devs_min) {
+	if (ndevs < devs_min) {
 		ret = -ENOSPC;
 		goto error;
 	}
-- 
2.16.1


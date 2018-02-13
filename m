Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47127 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964978AbeBMOQy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 09:16:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7BBD0ADD2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 14:16:52 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: Remove extra run_delayed_items call
Date: Tue, 13 Feb 2018 16:16:48 +0200
Message-Id: <1518531409-31625-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before commit 581227d0d2b8 ("Btrfs: remove the time check in
btrfs_commit_transaction()") there would be a loop in the transaction
commit path that will go on until all existing writers ended their
transaction handles. This loop would try and flush as much pending stuff
as possible before going into the transaction critical section. However,
the aforementioned commit removed it, yet continued calling this
"extra" code for the sake of optimisation.

As it stands the rules for running the delayed items are a bit of
a mess. First we have the one call which this patch removes, then we
have another one, acting as a "safety net" by catching any delayed
items introduced after the previous call is finished and extwriters
becoming 0 (meaning no more TRANS_START/TRANS_ATTACHS are possible, only
joins). Then we have the delayed items running as part of creating a
snapshot (once per pedning snapshot). Finally, delayed items are run
once more _after_ snapshots have been created. All in all this amounts
to 3 + N (N = number of snapshots slated for creation). I think this
could really be reduced to 2 calls - 1 before create_pending_snapshots
is called and 1 after it's finished. This suffices to ensure consistent
fs state during snapshot creation and after they are created.

I did a full xfstest run to ensure no consistency issues came up. Then
I picked the tests which exhibitted rather long runtimes and looked
closer to see if it was as a result of this commit - which it wasn't.
Finally I did an artifical test with fsstres with only those operations
that put stress on the delayed items code:

fsstress -z -f mkdir=25% -f rmdir=25% -f creat=25 -f unlink=25%
-f attr_set=25% -p5 -n 25000 and also didn't observe any performance
regressions

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/transaction.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2cdf7be02f41..02bc1e6212e6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2066,10 +2066,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (ret)
 		goto cleanup_transaction;
 
-	ret = btrfs_run_delayed_items(trans);
-	if (ret)
-		goto cleanup_transaction;
-
 	wait_event(cur_trans->writer_wait,
 		   extwriter_counter_read(cur_trans) == 0);
 
-- 
2.7.4


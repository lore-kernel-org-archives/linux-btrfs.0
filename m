Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:36696 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3JVR0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 13:26:39 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid5
References: <0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com>
	<pan$59a02$8231ca78$f5d54bfb$30812437@cox.net>
Date: Tue, 22 Oct 2013 15:18:24 -0200
In-Reply-To: <pan$59a02$8231ca78$f5d54bfb$30812437@cox.net> (Duncan's message
	of "Tue, 22 Oct 2013 13:27:44 +0000 (UTC)")
Message-ID: <or7gd59qcf.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Oct 22, 2013, Duncan <1i5t5.duncan@cox.net> wrote:

> This is because there's a hole in the recovery process in case of a
> lost device, making it dangerous to use except for the pure test-case.

It's not just that; any I/O error in raid56 chunks will trigger a BUG
and make the filesystem unusable until the next reboot, because the
mirror number is zero.  I wrote this patch last week, just before
leaving on a trip, and I was happy to find out it enabled a
frequently-failing disk to hold a filesystem that turned out to be
surprisingly reliable!


btrfs: some progress in raid56 recovery

From: Alexandre Oliva <oliva@gnu.org>

This patch is WIP, but it has enabled a raid6 filesystem on a bad disk
(frequent read failures at random blocks) to work flawlessly for a
couple of weeks, instead of hanging the entire filesystem upon the
first read error.

One of the problems is that we have the mirror number set to zero on
most raid56 reads.  That's unexpected, for mirror numbers start at
one.  I couldn't quite figure out where to fix the mirror number in
the bio construction, but by simply refraining from failing when the
mirror number is zero, I found out we end up retrying the read with
the next mirror, which becomes a read retry that, on my bad disk,
often succeeds.  So, that was the first win.

After that, I had to make a few further tweaks so that other BUG_ONs
wouldn't hit, and we'd instead fail the read altogether, i.e., in the
extent_io layer, we still don't repair/rewrite the raid56 blocks, nor
do we attempt to rebuild bad blocks out of the other blocks in the
stride.  In a few cases in which the read retry didn't succeed, I'd
get an extent cksum verify failure, which I regarded as ok.

What did surprise me was that, for some of these failures, but not
all, the raid56 recovery code would kick in and rebuild the bad block,
so that we'd get the correct data back in spite of the cksum failure
and the bad block.  I'm still puzzled by that; I can't explain what
I'm observing, but surely the correct data is coming out of somewhere
;-)

Another oddity I noticed is that sometimes the mirror numbers appear
to be totally out of range; I suspect there might be some type
mismatch or out-of-range memory access that causes some other
information to be read as a mirror number from bios or somesuch.  I
couldn't track that down yet.

As it stands, although I know this still doesn't kick in the recovery
or repair code at the right place, the patch is usable on its own, and
it is surely an improvement over the current state of raid56 in btrfs,
so it might be a good idea to put it in.  So far, I've put more than
1TB of data on that failing disk with 16 partitions on raid6, and
somehow I got all the data back successfully: every file passed an
md5sum check, in spite of tons of I/O errors in the process.

Signed-off-by: Alexandre Oliva <oliva@gnu.org>
---
 fs/btrfs/extent_io.c |   17 ++++++++++++-----
 fs/btrfs/raid56.c    |   18 ++++++++++++++----
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe443fe..4a592a3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2061,11 +2061,11 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	int ret;
 
-	BUG_ON(!mirror_num);
-
 	/* we can't repair anything in raid56 yet */
 	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num))
-		return 0;
+		return -EIO;
+
+	BUG_ON(!mirror_num);
 
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
 	if (!bio)
@@ -2157,7 +2157,6 @@ static int clean_io_failure(u64 start, struct page *page)
 		return 0;
 
 	failrec = (struct io_failure_record *)(unsigned long) private_failure;
-	BUG_ON(!failrec->this_mirror);
 
 	if (failrec->in_validation) {
 		/* there was no real error, just free the record */
@@ -2167,6 +2166,12 @@ static int clean_io_failure(u64 start, struct page *page)
 		goto out;
 	}
 
+	if (!failrec->this_mirror) {
+		pr_debug("clean_io_failure: failrec->this_mirror not set, assuming %llu not repaired\n",
+			   failrec->start);
+		goto out;
+	}
+
 	spin_lock(&BTRFS_I(inode)->io_tree.lock);
 	state = find_first_extent_bit_state(&BTRFS_I(inode)->io_tree,
 					    failrec->start,
@@ -2338,7 +2343,9 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		 * everything for repair_io_failure to do the rest for us.
 		 */
 		if (failrec->in_validation) {
-			BUG_ON(failrec->this_mirror != failed_mirror);
+			if (failrec->this_mirror != failed_mirror)
+				pr_debug("bio_readpage_error: this_mirror equals failed_mirror: %i\n",
+					 failed_mirror);
 			failrec->in_validation = 0;
 			failrec->this_mirror = 0;
 		}
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0525e13..2d1a960 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1732,6 +1732,8 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	int err;
 	int i;
 
+	pr_debug("__raid_recover_end_io: attempting error recovery\n");
+
 	pointers = kzalloc(rbio->bbio->num_stripes * sizeof(void *),
 			   GFP_NOFS);
 	if (!pointers) {
@@ -1886,17 +1888,22 @@ cleanup:
 cleanup_io:
 
 	if (rbio->read_rebuild) {
-		if (err == 0)
+		if (err == 0) {
+			pr_debug("__raid_recover_end_io: successful read_rebuild\n");
 			cache_rbio_pages(rbio);
-		else
+		} else {
+			pr_debug("__raid_recover_end_io: failed read_rebuild\n");
 			clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
+		}
 
 		rbio_orig_end_io(rbio, err, err == 0);
 	} else if (err == 0) {
+		pr_debug("__raid_recover_end_io: successful recovery, on to fnish_rmw\n");
 		rbio->faila = -1;
 		rbio->failb = -1;
 		finish_rmw(rbio);
 	} else {
+		pr_debug("__raid_recover_end_io: failed recovery\n");
 		rbio_orig_end_io(rbio, err, 0);
 	}
 }
@@ -1922,10 +1929,13 @@ static void raid_recover_end_io(struct bio *bio, int err)
 	if (!atomic_dec_and_test(&rbio->bbio->stripes_pending))
 		return;
 
-	if (atomic_read(&rbio->bbio->error) > rbio->bbio->max_errors)
+	if (atomic_read(&rbio->bbio->error) > rbio->bbio->max_errors) {
+		pr_debug("raid_recover_end_io: unrecoverable error\n");
 		rbio_orig_end_io(rbio, -EIO, 0);
-	else
+	} else {
+		pr_debug("raid_recover_end_io: attempting error recovery\n");
 		__raid_recover_end_io(rbio);
+	}
 }
 
 /*


-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:52075 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab3CYM71 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 08:59:27 -0400
From: Emil Goode <emilgoode@gmail.com>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] Btrfs: fix gcc warnings by adding third argument
Date: Mon, 25 Mar 2013 14:02:11 +0100
Message-Id: <1364216531-16467-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function pointer bi_end_io expects three arguments of the
function it points to. This patch adds a struct batch_complete
pointer as a third argument to the raid_write_end_io,
raid_rmw_end_io and raid_recover_end_io functions.

GCC is warning about this:
fs/btrfs/raid56.c: In function ‘finish_rmw’:
fs/btrfs/raid56.c:1258:18: warning:
	assignment from incompatible pointer type [enabled by default]
fs/btrfs/raid56.c: In function ‘raid56_rmw_stripe’:
fs/btrfs/raid56.c:1514:18: warning:
	assignment from incompatible pointer type [enabled by default]
fs/btrfs/raid56.c: In function ‘__raid56_parity_recover’:
fs/btrfs/raid56.c:2013:18: warning:
	assignment from incompatible pointer type [enabled by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 fs/btrfs/raid56.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 9a79fb7..6df1ac8 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -850,7 +850,8 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, int err, int uptodate)
  * end io function used by finish_rmw.  When we finally
  * get here, we've written a full stripe
  */
-static void raid_write_end_io(struct bio *bio, int err)
+static void raid_write_end_io(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1384,7 +1385,8 @@ static void set_bio_pages_uptodate(struct bio *bio)
  * This will usually kick off finish_rmw once all the bios are read in, but it
  * may trigger parity reconstruction if we had any errors along the way
  */
-static void raid_rmw_end_io(struct bio *bio, int err)
+static void raid_rmw_end_io(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1905,7 +1907,8 @@ cleanup_io:
  * This is called only for stripes we've read from disk to
  * reconstruct the parity.
  */
-static void raid_recover_end_io(struct bio *bio, int err)
+static void raid_recover_end_io(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
-- 
1.7.10.4


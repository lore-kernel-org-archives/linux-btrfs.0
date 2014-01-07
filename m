Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46285 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaAGUPk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 15:15:40 -0500
MIME-Version: 1.0
In-Reply-To: <20140107055318.GA19016@localhost>
References: <20140102053101.GA29352@localhost>
	<CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	<20140106221036.GE9037@kmo>
	<CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	<20140107055318.GA19016@localhost>
Date: Tue, 7 Jan 2014 12:15:39 -0800
Message-ID: <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Fengguang. Final patch with added comment. BTW, fengguang
mentioned that git-am has trouble with the inline patch and "quilt
import" worked fine for him...

------------
In btrfs_end_bio(), we increment bi_remaining if is_orig_bio. If not,
we restore the orig_bio but failed to increment bi_remaining for
orig_bio, which triggers a BUG_ON later when bio_endio is called. Fix
is to increment bi_remaining when we restore the orig bio as well.

Reported-and-Tested-by: Fengguang wu <fengguang.wu@intel.com>
CC: Kent Overstreet <kmo@daterainc.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Chris Mason <clm@fb.com>
Signed-off-by: Muthukumar Ratty <muthur@gmail.com>

-----------
 fs/btrfs/volumes.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 37972d5..34aba2b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5297,9 +5297,13 @@ static void btrfs_end_bio(struct bio *bio, int err)
                if (!is_orig_bio) {
                        bio_put(bio);
                        bio = bbio->orig_bio;
-               } else {
-                       atomic_inc(&bio->bi_remaining);
                }
+                /*
+                 * We have original bio now. So increment bi_remaining to
+                 * account for it in endio
+                 */
+               atomic_inc(&bio->bi_remaining);
+
                bio->bi_private = bbio->private;
                bio->bi_end_io = bbio->end_io;
                btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;

-------------------------------------

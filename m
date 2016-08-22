Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755284AbcHVPHB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 11:07:01 -0400
Date: Mon, 22 Aug 2016 11:07:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Lukas Herbolt <lherbolt@redhat.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        device-mapper development <dm-devel@redhat.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [Regression/Behavior change]dm-flakey corrupt read bio, even the
 feature is drop_writes
Message-ID: <20160822150720.GA29950@redhat.com>
References: <cc2b06b5-7598-67ab-d528-9087cbf75f45@cn.fujitsu.com>
 <CAM4Jq_4t0uGMA2KtGJWgM36wyu7czWjZQD0Lchh6n=gGZ9F+WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM4Jq_4t0uGMA2KtGJWgM36wyu7czWjZQD0Lchh6n=gGZ9F+WQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 22 2016 at  4:05am -0400,
Lukas Herbolt <lherbolt@redhat.com> wrote:

> Hello,
> 
> There is patch from Mike. It's part of current pull request to 4.8-rc1
> For more details check:
>  - https://www.redhat.com/archives/dm-devel/2016-July/msg00561.html
>  - https://www.redhat.com/archives/dm-devel/2016-August/msg00109.html
> 
> Lukas
> 
> On Mon, Aug 22, 2016 at 9:31 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> > Hi, Mike and btrfs and dm guys
> >
> > When doing regression test on v4.8-rc1, we found that fstests/btrfs/056
> > always fails. With the following dmesg:
> > ---
> > Buffer I/O error on dev dm-0, logical block 1310704, async page read
> > Buffer I/O error on dev dm-0, logical block 16, async page read
> > Buffer I/O error on dev dm-0, logical block 16, async page read
> > ---
> >
> > And bisect leads to the following commits:
> > ---
> > commit 99f3c90d0d85708e7401a81ce3314e50bf7f2819
> > Author: Mike Snitzer <snitzer@redhat.com>
> > Date:   Fri Jul 29 13:19:55 2016 -0400
> >
> >     dm flakey: error READ bios during the down_interval
> > ---
> >
> > While according to the document of dm-flakey, it says that when using
> > drop_writes feature, read bios are not affected:
> > ---
> >   drop_writes:
> >         All write I/O is silently ignored.
> >         Read I/O is handled correctly.

I went back to the dm-flakey.c code at the time that the 'drop_writes'
feature was added via commit b26f5e3d.  It does confirm your
understanding of how reads should be handled if drop_writes is enabled.

Not sure why I thought differently.  Please try the following patch.

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 97e446d..6a2e8dd 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -289,15 +289,13 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 		pb->bio_submitted = true;
 
 		/*
-		 * Map reads as normal only if corrupt_bio_byte set.
+		 * Error reads if neither corrupt_bio_byte or drop_writes are set.
+		 * Otherwise, flakey_end_io() will decide if the reads should be modified.
 		 */
 		if (bio_data_dir(bio) == READ) {
-			/* If flags were specified, only corrupt those that match. */
-			if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
-			    all_corrupt_bio_flags_match(bio, fc))
-				goto map_bio;
-			else
+			if (!fc->corrupt_bio_byte && !test_bit(DROP_WRITES, &fc->flags))
 				return -EIO;
+			goto map_bio;
 		}
 
 		/*
@@ -334,14 +332,21 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio, int error)
 	struct flakey_c *fc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	/*
-	 * Corrupt successful READs while in down state.
-	 */
 	if (!error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
-		if (fc->corrupt_bio_byte)
+		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
+		    all_corrupt_bio_flags_match(bio, fc)) {
+			/*
+			 * Corrupt successful matching READs while in down state.
+			 */
 			corrupt_bio_data(bio, fc);
-		else
+
+		} else if (!test_bit(DROP_WRITES, &fc->flags)) {
+			/*
+			 * Error read during the down_interval if drop_writes
+			 * wasn't configured.
+			 */
 			return -EIO;
+		}
 	}
 
 	return error;

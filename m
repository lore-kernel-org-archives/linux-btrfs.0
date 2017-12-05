Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59564 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752042AbdLENJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 08:09:19 -0500
Date: Tue, 5 Dec 2017 14:07:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] define BTRFS_DEV_STATE
Message-ID: <20171205130719.GH3553@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171204045456.8602-1-anand.jain@oracle.com>
 <20171204202842.GB3553@twin.jikos.cz>
 <c152b897-2309-18ac-cf78-e4215973dcbd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c152b897-2309-18ac-cf78-e4215973dcbd@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 09:20:38AM +0800, Anand Jain wrote:
> 
> 
> On 12/05/2017 04:28 AM, David Sterba wrote:
> > On Mon, Dec 04, 2017 at 12:54:51PM +0800, Anand Jain wrote:
> >> As of now device properties and states are being represented as int
> >> variable. So clean that up using bitwise operations. Also patches in
> >> the ML such as device failed state needs this cleanup as well.
> >>
> >> V2:
> >>   Accepts all comments from Nikolay.
> >>   Drops can_discard.
> >>   Adds BTRFS_DEV_STATE_REPLACE_TGT and BTRFS_DEV_STATE_FLUSH_SENT
> >>      patches.
> >>
> >> Anand Jain (5):
> >>    btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
> >>    btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
> >>    btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
> >>    btrfs: cleanup device states define BTRFS_DEV_STATE_REPLACE_TGT
> >>    btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT
> > 
> > 1-5 added to next. I had to tweak the whitespace in the conditions.
> 
>   Oops I did run, checkpatch, not too sure how did I still missed it.

Checkpatch will not help, this is a matter of style used in btrfs code.
We should tweak the coding style so it looks consistent and familiar to
us. I read a lot of code so it's quite obvious to me and need to fix it
if it's feasible or ask the submitter.

An example:

@@ -3403,7 +3403,8 @@  static int barrier_all_devices(struct btrfs_fs_info *info)
 			continue;
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;
 
 		write_dev_flush(dev);

The condition on the next line should start under the first one like

-		if (!dev->in_fs_metadata || !dev->writeable)
+		if (!dev->in_fs_metadata ||
+		    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
 			continue;

As it makes a bit clear what's the condition and what's the statement.
This can become tricky with condition terms that do not fit on one line
or are tested in ( ) :

@@ -3403,8 +3403,10 @@  static int barrier_all_devices(struct btrfs_fs_info *info)
 			continue;
 		if (!dev->bdev)
 			continue;
-		if (!dev->in_fs_metadata ||
-			!test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
+		if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
+						&dev->dev_state) ||
+			!test_bit(BTRFS_DEV_STATE_WRITEABLE,
+						&dev->dev_state))
 			continue;

Became

@@ -3395,7 +3395,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
                        continue;
                if (!dev->bdev)
                        continue;
-               if (!dev->in_fs_metadata ||
+               if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &dev->dev_state) ||
                    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state))
                        continue;

You can notice in other patches, that the || operator ends up on column 81,
which is exactly where checkpatch would complain but I will not, as the
operator is completely hidden. The end result is IMHO better.

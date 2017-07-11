Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60248 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753701AbdGKXEU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Jul 2017 19:04:20 -0400
Date: Tue, 11 Jul 2017 16:04:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
Message-ID: <20170711230419.GR30689@merlins.org>
References: <20170711062155.hvlx5ud4zphpzjnp@merlins.org> <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com> <20170711164812.sj64s3nc2oe3ai3n@merlins.org> <CAJCQCtSYJqa=nJA0w+yiHvwzdiWF51PmrfUPGVUjm1MwbiNZaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSYJqa=nJA0w+yiHvwzdiWF51PmrfUPGVUjm1MwbiNZaQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 04:43:06PM -0600, Chris Murphy wrote:
> Assuming it works, settle on 4.9 until 4.14 shakes out a bit. Given
> your setup and the penalty for even small problems, it's probably
> better to go low risk and that means longterm kernels. Maybe one of
> the three systems can use a newer kernel just to make sure you're
> regressions, if any, are contained, but otherwise avoid all eggs in
> one basket approach.
 
That's indeed what I was considering doing.
I guess I got complacent/too trusting after btrfs had worked for me without
real problems for over a year (maybe close to 2?)

My laptop had to be upgraded to 4.11 due to a kernel issue with nvme drives
that made any kernel before that hang on S3 sleep.
But my server can be on anything, and it seems that I'm going to leave it in
4.9 for a while indeed, even if it had been happily on 4.8 for a long time
(but given this snapshot rotation bug that caused it to remount a perfectly
good filesystem, as read only, I indeed just moved it to 4.9.36)

> Another option is cutting down the size of the array and going with a
> gluster or ceph approach so the rebuilds aren't so hideously invasive.

Right, it's just personal stuff, I don't want the management to be
ridiculously high for something that ought to be simple.
I only have 2 raid5 arrays of 5 drives each (when back in the day, I
remember building a 26 drive array with SCSI SCA drives in 3 disk shelves
for a total of 2TB, woot!)
I don't really want to artificially cut that raid5 in smaller filesystem by
adding yet another layer like LVM and then concatenate several smaller btrfs
filesystems.
I know I might be a bit stubborn here, but only 4 data drives, it should be
considered small enough, even if the drives are not super small.

> You could also optionally use a different storage layout and file
> system for a small subset of the bricks, either XFS on LVM RAID or

Yes, basically instead of having one media array and one backup array, I can
make multiple ones, and then take the penalty of moving data across them.
Been there in the past, don't really want to go back :-/
But as you said, there is no magic answer outside not having filesystems
that get corrupted so easily. I did have one flaky SAS card that did
probably slightly damage one of my arrays, but the other 2 (and the
filesystem on my laptop) don't have that hardware excuse.

Anyway, while it's not very helpful to the btrfs project, 4.9.36 seems like
indeed what's best for me for now.

Thanks for the replies.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35960 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbcAXU6g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jan 2016 15:58:36 -0500
Received: by mail-oi0-f43.google.com with SMTP id o124so76716273oia.3
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jan 2016 12:58:35 -0800 (PST)
Date: Sun, 24 Jan 2016 13:58:32 -0700
From: Tom Hunt <tomdicksonhunt@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Chicken-egg: uncorrectable checksum error prevents RAID1
 rebalancing
Message-ID: <20160124205832.GE908@breitenfeld.lan>
References: <20160124175258.GD908@breitenfeld.lan>
 <CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtTFwz3YxaYJSnq3M7fQQ152=1ka_Y1ecXT=9LurPSaRrw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> You delete the file and yet the scrub still says inode 515 exists and
> has an error? Or there are no errors, but then after copying the same
> file back to the volume, the problem reoccurs? Are there any snapshots
> or subvolumes? Because if there are any subvolumes/snapshots, each is
> its own fs tree with its own set of inodes. So an inode can be used
> more than once for different files so I wonder off hand if you haven't
> found the actual problematic file.
> 
> Or possibly it's a directory, and not a file.

There are no snapshots, but there are subvolumes. I did the same procedure on
the file at inode 515 in each subvolume, which was:

# cp $file ~
# rm $file
# mv ~/$file {old_file_path}

This concluded without any errors. After doing this, the inode number is
different, and 'find / -inum 515' no longer finds anything on either subvolume.
However, initiating a scrub after this still shows the error at ino 515.

On Sun, Jan 24, 2016 at 01:34:20PM -0700, Chris Murphy wrote:
> On Sun, Jan 24, 2016 at 10:52 AM, Tom Hunt <tomdicksonhunt@gmail.com> wrote:
> > I've been running for a week or two using a single-drive 6TB btrfs
> > volume. For some of this time, the machine running had bad memory,
> > which led to various checksum errors. For most of these, I just
> > deleted the relevant file and reacquired it (the errors fortuitously
> > never occurring in files which were not easily replaceable). However,
> > there currently remains a single error which does not appear to be in
> > any file:
> >
> > # btrfs scrub status /
> > scrub status for 85f5b744-f68c-4194-aa90-d6fe238115a3
> >       scrub started at Fri Jan 22 09:49:02 2016 and finished after 11:55:08
> >       total bytes scrubbed: 4.27TiB with 1 errors
> >       error details: csum=1
> >       corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
> >
> > # dmesg
> > (...)
> > [52841.310422] BTRFS warning (device dm-0): csum failed ino 515 off 15118336 csum 2629660496 expected csum 54021641
> > [52841.335656] BTRFS warning (device dm-0): csum failed ino 515 off 15118336 csum 2629660496 expected csum 54021641
> > [95071.256448] BTRFS: bdev /dev/mapper/rootvol_1 errs: wr 0, rd 0, flush 0, corrupt 11, gen 0
> > [95071.256532] BTRFS: unable to fixup (regular) error at logical 4450167468032 on dev /dev/mapper/rootvol_1
> >
> > I've searched for ino 515, and the file there does not have any
> > apparent error (can read the whole thing without problem; deleting and
> > recreating it does not make the error go away). The error is, of
> > course, uncorrectable, because it's a single-drive volume. However,
> > having put in a second drive, the balance filter to convert to raid1
> > fails because of the I/O error.
> 
> # find /brick2 -inum 60724
> 
> On my system, it returns six results, four are files, two of which are
> in common to the others due to snapshotting, and two are directories
> one of which is also a snapshot of the other. So a single inode can
> not only appear multiple times on a Btrfs volume, but can be pointing
> to a file or a directory. The scrub not saying what the file path is
> suggests it could be a directory.
> 
> 
> -- 
> Chris Murphy

-- 
Tom Hunt

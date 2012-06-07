Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58197 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2FGKVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jun 2012 06:21:41 -0400
Date: Thu, 7 Jun 2012 12:21:37 +0200
From: David Sterba <dave@jikos.cz>
To: Randall Mason <randall@mason.ch>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Uncorrectable errors on newly extended volume
Message-ID: <20120607102137.GF32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CADP2XCmhPX9HyLn6XWs4jgDHhHj8S1-G8PrZo50m4pRRXVft7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CADP2XCmhPX9HyLn6XWs4jgDHhHj8S1-G8PrZo50m4pRRXVft7A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 01, 2012 at 11:53:18AM +0300, Randall Mason wrote:
> sudo /sbin/btrfs scrub status .
> > scrub status for 3a29a904-ad28-4e2a-8e80-df29d8d5fafc
> >         scrub started at Thu May 31 10:15:39 2012 and finished after 27581 seconds
> >         total bytes scrubbed: 1.00TB with 23929636 errors
> >         error details: csum=23929636
> >         corrected errors: 0, uncorrectable errors: 23929636, unverified errors: 0
[...]
> 
> These are the most frequent lines in the kern.log:
> >   1189 <datetime> <hostname> kernel: scrub_fixup: <number> callbacks suppressed
> >   1442 <datetime> <hostname> kernel: btrfs_readpage_end_io_hook: <number> callbacks suppressed
> >  11900 <datetime> <hostname> kernel: btrfs: unable to fixup at <number>
> >  14538 <datetime> <hostname> kernel: btrfs csum failed ino <number> off <number> csum <number> private <number>

> > 237549 <datetime> <hostname> kernel: bio too big device sdb1 (<number> > <number>)

As was reported via IRC in the past, this message could appear when a
disk is connected via USB and makes a device group with other disks in
the filesystem connected normally. The bio size is not same for the
disks and the write requests may get dropped. This explains the high
number of csum failures, and I'm afraid the data are lost.

I think that the issue could be more general, once I put an old IDE
disk with a new 4k sector 2TB disk into the same filesystem. I don't
remember what happened next (power failure or forced reboot), but when I
mounted the filesystem I was not able to remove the 2TB disk from the
set and saw csum problems plus the 'bio too big' message. It was quite
some time ago and I think it was a 3.1 based kernel with the known bug
when flushing data to multiple devices. I wasn't able to reproduce the
bug though.

> So, the question:  What went wrong?  Is there any hope of getting my
> Dad's data back?  How should I proceed from here?  Delete the volume
> and start from scratch?  Is btrfs not compatible with the size of
> disk/volume on this architecture?  Is the external disk broken?
> Should I use a different filesystem?  Why were there no indications of
> error when copying?  If worse comes to worse, how can I tell which
> files are bad?  Can scrub go through and unlink the bad files?

> > UUID=3a29a904-ad28-4e2a-8e80-df29d8d5fafc /var/lib/btrfs  btrfs   defaults                0 0
> > UUID=3a29a904-ad28-4e2a-8e80-df29d8d5fafc /home           btrfs   defaults,subvol=current 0 0
> 
> sudo /sbin/btrfs filesystem show /dev/sdb1
> > Label: none  uuid: 3a29a904-ad28-4e2a-8e80-df29d8d5fafc
> >         Total devices 2 FS bytes used 1.04TB
> >         devid    2 size 2.73TB used 185.50GB path /dev/sdb1
> >         devid    1 size 922.19GB used 922.19GB path /dev/sda2

so it's 3TB and 1TB disks, isn't there some issue with >2TB disks? I
think this could be a bug, so either adapt to different disk
characteristics of the disk or forbid to add the device.


david

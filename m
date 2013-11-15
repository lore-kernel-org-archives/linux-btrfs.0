Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43619 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3KOPA3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 10:00:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhKsl-0008KT-A3
	for linux-btrfs@vger.kernel.org; Fri, 15 Nov 2013 16:00:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 16:00:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 16:00:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "btrfs: 1 enospc errors during balance" when balancing after
 formerly failed raid1 device re-appeared
Date: Fri, 15 Nov 2013 15:00:07 +0000 (UTC)
Message-ID: <pan$60165$d2183833$89d72951$862c11b1@cox.net>
References: <l650m2$njg$1@ger.gmane.org>
	<20131115123841.GP4315@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 15 Nov 2013 12:38:41 +0000 as excerpted:

>> I also wonder: Would btrfs try to write _two_ copies of everything to
>> _one_ remaining device of a degraded two-disk raid1?
> 
> No. It would have to degrade from RAID-1 to DUP to do that (and I
> think we prevent DUP data for some reason).

You may be correct about DUP data, but that is unlikely to be the issue 
here, because he's likely using the mixed-mode default due to the <1GB 
filesystem size, and on a multi-device filesystem that should default to 
RAID1 just as metadata by itself does.

However, I noticed that his outlined duplicator SKIPPED the mkfs.btrfs 
command part, and there's no btrfs filesystem show and btrfs filesystem df 
to verify how the kernel's actually treating the filesystem, so...

@ LV:

For further tests, please include these commands and their output:

1) your mkfs.btrfs command

[Then mount, and after mount...]

2) btrfs filesystem show <path>

3) btrfs filesystem df <path>

Thanks.  These should make what btrfs is doing far clearer.


Meanwhile, I've been following your efforts with quite some interest as 
they correspond to some of the pre-deployment btrfs raid1 mode testing I 
did.  This was several kernels ago, however, so I had been wondering if 
the behavior had changed, hopefully for the better, and your testing 
looks to be headed toward the same test I did at some point.

Back then, I found a rather counterintuitive result of my own.

Basically, take a two-device raid1 mode (both data and metadata; in my 
case the devices were over a gig so mixed data+metadata wasn't invoked 
and I specified -m raid1 -d raid1 when doing the mkfs.btrfs) btrfs, mount 
it, copy some files to it, unmount it.

Then disconnect one device (I was using actual devices not the loop 
devices you're using) and mount degraded.  Make a change to the degraded 
filesystem.  Unmount.

Then disconnect that device and reconnect the other.  Mount degraded.  
Make a *DIFFERENT* change to the same file.  Unmount.  The two copies 
have now forked in an incompatible manner.

Now reconnect both devices and remount, this time without degraded.

As you, here I expected btrfs to protest, particularly so since the two 
copies were incompatible.  *NO* *PROTEST*!!

OK, so check that file to see which version I got.  I've now forgotten 
which one it was, but it was definitely one of the two forks, not the 
original version.

Now unmount and disconnect the device with the copy it said it had.  
Mount the filesystem degraded with the other device.  Check the file 
again.

!!  I got the other fork! !!

Not only did btrfs not protest when I mounted a raid1 device undegraded 
after making incompatible changes to the file with each of the two 
devices mounted degraded separately, but accessing the file on the 
undegraded filesystem neither protested nor corrected the other copy, 
which remained the incompatibly forked copy as confirmed by remounting 
the filesystem degraded with just that device in ordered to access it.

To my way of thinking, that's downright dangerous, as well as being 
entirely unintuitive.

Unfortunately, I didn't actually do a balance to see what btrfs would do 
with the incompatible versions, I simply blew away that testing 
filesystem with a new mkfs.btrfs (I'm on SSD so mkfs.btrfs automatically 
issues a trim/discard to clear the new filesystem space before mking it), 
and I've been kicking myself for not doing so ever since, because I 
really would like to know balance actually /does/ in such a case!  But I 
was still new enough to btrfs at that time that I didn't really know what 
I was doing, so I didn't realize I'd omitted a critical part of the test 
until it was too late, and I've not been interested /enough/ in the 
outcome to redo the test again, with a newer kernel and tools and a 
balance this time.

What scrub would have done with it would be an interesting testcase as 
well, but I don't know that either, because I never tried it.

At least I hadn't redone the test yet.  But I keep thinking about it, and 
I guess I would have one of these days.  But now it seems like you're 
heading toward doing it for me. =:^)

Meanwhile, the conclusion I took from the test was that if I ever had to 
mount degraded in read/write mode, I should make *VERY* sure I 
CONSISTENTLY used the same device when I did so.  And when I undegraded, 
/hopefully/ a balance would choose the newer version.  Unfortunately I 
never did actually test that, so I figured should I actually need to use 
degraded, even if the degrade was only temporary, the best way to recover 
was probably to trim that entire partition on the lost device and then 
proceed to add it back into the filesystem as if it were a new device and 
do a balance to finally recover raid1 mode.

Meanwhile (2), what btrfs raid1 mode /has/ been providing me with is data 
integrity via the checksumming and scrub features.  And with raid1 
providing a second copy of the data to work with, scrub really does 
appear to do what it says on the tin, copy the good copy over the bad, if 
there's a checksum mismatch on the bad one.  What I do NOT know is what 
happens in /either/ a scrub or balance case, when the metadata of both 
copies is valid, but they differ from each other!

FWIW, here's my original list post on the subject, tho it doesn't seem to 
have generated any followup (beyond my own).  IIRC I did get a reply from 
another sysadmin on another thread, but I can't find it now, and all it 
did was echo my concern, no reply from a dev or the like.

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/26096

So anyway, yes, I'm definitely following your results with interest! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


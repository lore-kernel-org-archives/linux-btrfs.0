Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48940 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbaILLMQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 07:12:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XSOlu-0007cf-2s
	for linux-btrfs@vger.kernel.org; Fri, 12 Sep 2014 13:12:10 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:12:10 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 13:12:10 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 failure and recovery
Date: Fri, 12 Sep 2014 11:11:58 +0000 (UTC)
Message-ID: <pan$aa994$73a842cd$40b308e3$74fd442f@cox.net>
References: <000f01cfce67$9e9015f0$dbb041d0$@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

shane-kernel posted on Fri, 12 Sep 2014 01:57:37 -0700 as excerpted:

[Last question first as it's easy to answer...]

> Finally for those using this sort of setup in production, is running
> btrfs on top of mdraid the way to go at this point?

While the latest kernel and btrfs-tools have removed the warnings, btrfs 
is still not yet fully stable and isn't really recommended for 
production.  Yes, certain distributions support it, but that's their 
support choice that you're buying from them, and if it all goes belly up, 
I guess you'll see what that money actually buys.  However, /here/ it's 
not really recommended yet.

That said, there are people doing it, and if you make sure you have 
suitable backups for the extent to which you're depending on the data on 
that btrfs and are willing to deal with the downtime or failover hassles 
if it happens...

Also, keeping current with particularly kernels but not letting btrfs-
progs userspace get too outdated either, is important, as is following 
this list to keep up with current status.  If you're running older than 
the latest kernel series without a specific reason, you're likely to be 
running without patches for the most recently discovered btrfs bugs.

There was a recent exception to the general latest kernel rule in the 
form of a bug that only affected the kworker threads that btrfs 
transferred to in 3.15, so 3.14 was unaffected, while it took thru 3.15 
and 3.16 to find and trace the bug.  3.17-rc3 got the fix, and I believe 
it's in the latest 3.16 stable as well.  But that's where staying current 
with the list and actually having a reason to run an older than current 
kernel comes in, so while an exception to the general latest kernel rule, 
it wasn't an exception to the way I put it above, because once it became 
known on the list there was a reason to run the older kernel.

If you're unwilling to do that, then choose something other than btrfs.

But anyway, here's a direct answer to the question...

While btrfs on top of mdraid (or dmraid or...) in general works, it 
doesn't match up well with btrfs checksummed data integrity features.

Consider:  mdraid-1 writes to all devices, but reads from only one, 
without any checksumming or other data integrity measures.  If the copy 
mdraid-1 decides to read from is bad, unless the hardware actually 
reports it as bad, mdraid is entirely oblivious and will carry on as if 
nothing happened.  There's no checking the other copies to see that they 
match, no checksums or other verification, nothing.

Btrfs OTOH has checksumming and data verification.  With btrfs raid1, 
that verification means that if whatever copy btrfs happens to pull fails 
the verify, it can verify and pull from the second copy, overwriting the 
bad-checksum copy with a good-checksum copy.  BUT THAT ONLY HAPPENS IF IT 
HAS THAT SECOND COPY, AND IT ONLY HAS THAT SECOND COPY IN BTRFS RAID1 (or 
raid10 or for metadata, dup) MODE.

Now, consider what happens when btrfs data verification interacts with 
mdraid's lack of data verification.  If whatever copy mdraid pulls up is 
bad, it's going to fail the btrfs checksum and btrfs will reject it.  But 
because btrfs is on top of mdraid and mdraid is oblivious, there's no 
mechanism for btrfs to know that mdraid has other copies that may be just 
fine -- to btrfs, that copy is bad, period.  And if btrfs doesn't have a 
second btrfs copy, either due to btrfs raid1 or raid10 mode on top of 
mdraid, or for metadata, due to dup mode, then btrfs will simply return 
an error for that data, no second chance, because it knows nothing about 
the other copies mdraid has.

So while in general it works about as well as any other filesystem on top 
of mdraid, the interaction between mdraid's lack of data verification and 
btrfs' automated data verification is... unfortunate.

With that said, let's look at the rest of the post...

> I am testing BTRFS in a simple RAID1 environment. Default mount options
> and data and metadata are mirrored between sda2 and sdb2. I have a few
> questions and a potential bug report. I don't normally have console
> access to the server so when the server boots with 1 of 2 disks, the
> mount will fail without -o degraded. Can I use -o degraded by default to
> force mounting with any number of disks? This is the default behaviour
> for linux-raid so I was rather surprised when the server didn't boot
> after a simulated disk failure.

The idea here is that if a device is malfunctioning, the admin should 
have to take deliberate action to demonstrate knowledge of that fact 
before the filesystem will mount.  Btrfs isn't yet as robust in degraded 
mode as say mdraid, and important btrfs features like data validation and 
scrub are seriously degraded when that second copy is no longer there.  
In addition, btrfs raid1 mode requires that each of the two copies of a 
chunk be written to different devices, and once there's only a single 
device available, that can no longer happen, so unless behavior has 
changed recently, as soon as the currently allocated chunks get full, you 
get ENOSPC, even if there's lots of unallocated space left on the 
remaining device, because there's no second device available to allocate 
the second copy of a new data or metadata chunk on.

That said, some admins *DO* choose to add degraded to their default mount 
options, since it simply /lets/ btrfs mount in degraded mode, it doesn't 
FORCE it degraded if all devices show up.

If you want to be one of those admins you are of course free to do so.  
However, if btrfs breaks unexpectedly as a result, you get to keep the 
pieces. =:^)  It's something that some admins choose to do, but it's not 
recommended.

> So I pulled sdb to simulate a disk failure. The kernel oops'd but did
> continue running. I then rebooted encountering the above mount problem.
> I re-inserted the disk and rebooted again and BTRFS mounted
> successfully. However, I am now getting warnings like:
> BTRFS: read error corrected: ino 1615 off 86016 (dev /dev/sda2 sector
> 4580382824)
> I take it there were writes to SDA and sdb is out of sync. Btrfs is
> correcting sdb as it goes but I won't have redundancy until sdb resyncs
> completely. Is there a way to tell btrfs that I just re-added a failed
> disk and to go through and resync the array as mdraid would do? I know I
> can do a btrfs fi resync manually but can that be automated if the array
> goes out of sync for whatever reason (power failure)...

btrfs fi resync?  Do you mean btrfs scrub?  Because a scrub is the method 
normally used to check and fix such things.  A btrfs balance would also 
do it, but that rewrites the entire filesystem one chunk at a time, which 
isn't necessarily what you want to do.

To directly answer your question, however, no, btrfs does not have 
anything like mdraid's device re-add, with automatic resync.  Scrub comes 
the closest, verifying checksums and comparing transaction-id 
generations, but it's not run automatically.

In fact, until very recently, so recently I'm not sure it has been fixed 
yet altho I know there has been discussion on the list, btrfs in the 
kernel wasn't really aware when a device dropped out, either.  It would 
still queue up the transactions and they'd simply backup.  And a device 
plugged back in after a degraded mount with devices missing wouldn't 
necessarily be detected either.  They're working on it; as I said there 
have been recent discussions, but I'm not sure the code is actually in 
mainline for that, yet.

As I said above, btrfs isn't really entirely stable yet.  This simply 
demonstrates the point.  It's also why it's so important that an admin 
know about a degraded mount and actually choose to do it, thus the reason 
adding degraded to the default mount options isn't recommended, since it 
bypasses that deliberate choice.

If a filesystem is deliberately mounted degraded, an admin will know it 
and be able to take equally deliberate action to fix it.  Once they 
actually have the physical replacement device in place, the next equally 
deliberate step is to initiate a btrfs scrub (if the device was re-added) 
or a btrfs replace.

Meanwhile, in the event of a stale device, the transaction-id generation 
is used to determine which version is current.  Be careful not to 
separately mount-degraded one device and then the other, so they've both 
had updates and diverged from the common origin and from each other.  In 
most cases that should work and the one with the highest transaction-id 
will be chosen, but based on my testing now several kernel versions ago 
when I first got into btrfs raid (so hopefully my experience is outdated 
and the result is a /bit/ better now), it's not something you want to 
tempt fate with in any case.  At a minimum, the result is likely to be 
confusing to /you/ even if the filesystem does the right thing.  So if 
that happens, be sure to always mount and update the same device, not 
alternating devices, until you again unify the copies with a scrub.  At 
least for my own usage, I decided that if for some reason I DID happen to 
accidentally use both copies separately, I was best off wiping the one 
and adding it back in as a new device, thus ensuring absolute 
predictability in which divergent copy actually got USED.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


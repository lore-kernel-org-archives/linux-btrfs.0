Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33666 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaKXEYG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 23:24:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XslC0-0004Re-EM
	for linux-btrfs@vger.kernel.org; Mon, 24 Nov 2014 05:24:04 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:24:04 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 05:24:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
Date: Mon, 24 Nov 2014 04:23:53 +0000 (UTC)
Message-ID: <pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Sun, 23 Nov 2014 16:12:54 +0100 as excerpted:

> The balance run now finishes without errors with usage=99 and I think
> I'll leave it at that. No RAID yet but will convert to RAID1.

Converting between raid modes is done with a balance, so if you can't get 
that last bit to balance, you can't do a full conversion to raid1.

> Is it correct that there is no reason to ever do a 100% balance as
> routine maintenance? I mean if you really need that last 1% space you
> actually need a disk upgrade instead.

I'm too cautious to make an unequivocal statement like that, but at least 
of the top of my head, I can't think of any reason why /routine/ 
maintenance needs a full balance.  Like I said above, the mode 
conversions need it as that's what rewrites them to the new mode, but 
that's not /routine/.  Similarly, adding/deleting devices, where balance 
is used to rebalance the usage between remaining devices, isn't routine.

Certainly, I've had no reason to do that full balance, as opposed to 99% 
or whatever not-quite-full value, here, in routine usage.  That doesn't 
mean I won't someday find such a reason, but I've not seen one so far.

> How about running a monthly maintenance job that uses bytes_used and
> dev_item.bytes_used from btrfs-show-super to approximate the balance
> need?

I'm not familiar enough with the individual btrfs-show-super line items 
to address that specific question in an intelligent manner.

What I'd recommend using instead is the output from btrfs filesystem df 
<mountpoint> and/or btrfs fi show <mountpoint>.  These commands spit out 
information that's more "human readable", that should be usable in a 
script that conditionally triggers a balance as needed, as well.

In btrfs fi show, you're primarily interested in the devid line(s).  That 
tells you how much of the total available space is chunk-allocated for 
that device, with the difference between total and used being the 
unallocated space, available to allocate to either data or metadata 
chunks as needed.

What you're watching for there is of course nearly all space used.  How 
much you want to keep free will depend to some extent on the size of the 
devices and how close to full they actually are, but with data chunks 
being 1 GiB in size and metadata chunks being a quarter GiB in size, 
until the filesystem gets really too full to do so, keeping enough room 
to allocate several chunks of each shouldn't hurt.  With the usual multi-
hundred-gig filesystems[1], I'd suggest doing a rebalance whenever 
unallocated space is under 20 GiB.  If in fact you have /lots/ of unused 
space, say a TB filesystem with only a couple hundred GiB used, I'd 
probably set the safety margin higher, say 100 GiB or even 200 GiB, while 
at the same time using a lower usage=N balance filter.  No sense getting 
anywhere /close/ to the wire in that case.  As the filesystem fills that 
can be reduced as necessary, but you'll want to keep at *LEAST* 3 GiB or 
so unallocated, so the filesystem always has room to do at least a couple 
more chunk-allocations each of data and metadata.  That should also 
guarantee that there's at least enough room for balance to create a new 
chunk in ordered to be able to do its rewriting thing, thus allowing you 
to free /more/ space.

In btrfs fi df, watch the data and metadata lines.  Specifically, you're 
interested in the spread between total, which is what is chunk-allocated 
for the filesystem, and used, actual usage within those allocated 
chunks.  High spread indicates a bunch of empty chunks that a balance can 
free back to unallocated space, our goal in this case.

Again, data chunks are 1 GiB in size, so for the data line, a spread of 
under a GiB indicates that even a full balance isn't likely to free 
anything back to unallocated.  Generally if it's within a single-digit 
number of GiB difference, don't worry about balancing it.  Similarly, on 
a TB-class filesystem, if btrfs fi show says you still have hundreds of 
GiB  of room, there's little reason to worry about a balance even if the 
spread in fi df is a similar hundreds of GiB, because you still have 
plenty of unallocated room left.

Metadata chunks are a quarter-GiB in size, but on a single-device-
filesystem, they normally default to DUP mode, so two will be allocated 
at a time.  So if you're under a half-gig difference between total (aka 
allocated) and used metadata, doing even a full metadata balance is 
unlikely to get anything back, and it's normally not worth worrying about 
a metadata balance unless the spread is over a couple GiB.  Basically the 
same general rules apply as for data, only at half the metadata size.  So 
under 5-10 GiB spread is unlikely to be worth the hassle.  On a TB-class 
filesystem, still don't worry about it if there's hundreds of GiB 
unallocated, but if the fi df metadata spread between total/allocated and 
used is 50 GiB or more, you may wish to do a metadata balance just to get 
some of that back, even if unallocated (from fi show, as above) /is/ 
still hundreds of GiB.

So bottom line, on a TB-class filesystem with plenty of room (a couple 
hundred GiB free still, or more), I'd rebalance if unallocated (fi show, 
difference between total and used on a device line) drops under 100 GiB, 
rebalancing data if fi df shows over 100 GiB spread between data total 
(aka allocated) and used, and rebalancing metadata if there's over a 50 
GiB spread.

As the filesystem fills up, say with only 100 GiB free, that'd drop to 
triggering a balance if there's under perhaps 20 GiB unallocated on fi 
show, with a data balance at a similar 20 GiB data spread, and a metadata 
balance with a 10 GiB metadata spread.

On a TB-class filesystem or even a half-TB-class filesystem, once you're 
having trouble maintaining at least 10 GiB free, you should really be 
adding more devices or upgrading to bigger hardware, because you really 
don't want the unallocated to drop below 3 GiB or balance itself can have 
trouble running.


On my sub-100 GiB filesystems, I tend to have the filesystem sized much 
closer to what I actually need.  For instance, my rootfs is btrfs raid1 
mode, 8 GiB per device, two devices, so 8 GiB filesystem capacity.

/bin/df reports 2.1 G used, 5.8 GiB available.

btrfs fi show reports (per device) 8 GiB size, 2.78 GiB used.  So call it 
3 GiB used and 5 GiB unallocated.

btrfs fi df reports data of 2 GiB (obviously two 1 GiB chunks) total, 
1.75 GiB of which is used, for a spread of a quarter GiB.  That's under 
the 1 GiB data chunk size so even a full balance likely won't return 
anything.

Btrfs fi df reports metadata of 768 MiB total (obviously three quarter-
GiB chunks, remember this is raid1 so it's not duping the metadata chunks 
to the same device, the other copy is on the other device), 298.12 MiB 
used.

So in theory I could get 1 chunk of that metadata back, reducing it to 2 
metadata chunks.  However, there's typically a couple-hundred MiB 
metadata overhead that btrfs won't actually let you use as it uses it 
internally, and even a full balance doesn't recover it.  So it's unlikely 
I could recover that /apparently/ spare metadata block.

So I appear to be at optimum.  Obviously on an 8 GiB filesystem, I'm 
going to have to watch unallocated space very closely.  However, because 
this /is/ a specific-purpose filesystem (system root, with all installed 
programs and config) and I've already using it for that specific purpose, 
usage shouldn't and doesn't change /that/ much, even tho I'm on gentoo 
and thus have rolling updates.  It's thus /easier/ to keep an eye on data/
metadata spread as well as on total allocated usage and do a balance  
(which on an 8 GiB only filesystem on SSD, tends to take only perhaps a 
couple minutes for a full balance anyway) when I need to, because while 
it's small, even with updates the general data/metadata ratio doesn't 
tend to change much and normally the data and metadata usage stays about 
the same even as the files are updated, because it's simply reusing the 
chunks it has.

---
[1] Multi-hundred-gig filesystems:  These are usual for me as I like to 
keep my physical devices partitioned up and my filesystems small and 
manageable, but most people just create a big filesystem or two out of 
the multi-hundred-gig physical device, so their filesystems are commonly 
multi-hundred-gig as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


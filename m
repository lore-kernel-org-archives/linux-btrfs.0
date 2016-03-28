Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36765 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbcC1K0p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 06:26:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1akUNY-0002xK-7d
	for linux-btrfs@vger.kernel.org; Mon, 28 Mar 2016 12:26:36 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 12:26:36 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 12:26:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Compression causes kernel crashes if there are I/O or checksum
 errors (was: RE: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing
 device in RAID-1)
Date: Mon, 28 Mar 2016 10:26:29 +0000 (UTC)
Message-ID: <pan$284e3$6ee9615a$919b0339$15e3af27@cox.net>
References: <001b01d188ac$16740630$435c1290$@codenest.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Johnston posted on Mon, 28 Mar 2016 04:41:24 +0000 as excerpted:

> After puzzling over the btrfs failure I reported here a week ago, I
> think there is a bad incompatibility between compression and RAID-1
> (maybe other RAID levels too?).  I think it is unsafe for users to use
> compression, at least with multiple devices until this is
> fixed/investigated further.  That seems like a drastic claim, but I know
> I will not be using it for now.  Otherwise, checksum errors scattered
> across multiple devices that *should* be recoverable will render the
> file system unusable, even to read data from.  (One alternative
> hypothesis might be that defragmentation causes the issue, since I used
> defragment to compress existing files.)
> 
> I finally was able to simplify this to a hopefully easy to reproduce
> test case, described in lengthier detail below.  In summary, suppose we
> start with an uncompressed btrfs file system on only one disk containing
> the root file system,
> such as created by a clean install of a Linux distribution.  I then:
> (1) enable compress=lzo in fstab, reboot, and then defragment the disk
> to compress all the existing files, (2) add a second drive to the array
> and balance for RAID-1, (3) reboot for good measure, (4) cause a high
> level of I/O errors, such as hot-removal of the second drive, OR simply
> a high level of bit rot (i.e. use dd to corrupt most of the disk, while
> either mounted or unmounted). This is guaranteed to cause the kernel to
> crash.

Described that way, my own experience confirms your tests, except that 
(1) I hadn't tested the no-compression case to know it was any different, 
and (2) in my case I was actually using btrfs raid1 mode and scrub to be 
able to continue to deal with a failing ssd out of a pair, for quite some 
while after I would have ordinarily had to replace it were I not using 
something like btrfs raid1 with checksummed file integrity and scrubbing 
errors with replacements from the good device.

Here's how it worked for me and why I ultimately agree with your 
conclusions, at least regarding compressed raid1 mode crashes due to too 
many failed checksum failures (since I have no reference to agree or 
disagree with the uncompressed case).

As I said above, I had one ssd failing, but was taking the opportunity 
while I had it to watch its behavior deeper into the failure than I 
normally would, and while I was at it, get familiar enough with btrfs 
scrub to repair errors that it became just another routine command for me 
(to the point that I even scripted up a custom scrub command complete 
with my normally used options, etc).  On the relatively small (largest 
was 24 GiB per device, paired device btrfs raid1) multiple btrfs on 
partitions on the two devices scrub was normally under a minute to run 
even when doing quite a few repairs, so it wasn't as if it was taking me 
the hours to days it can take at TB scale on spinning rust.

The failure mode of this particular ssd was premature failure of more and 
more sectors, about 3 MiB worth over several months based on the raw 
count of reallocated sectors in smartctl -A, but using scrub to rewrite 
them from the good device would normally work, forcing the firmware to 
remap that sector to one of the spares as scrub corrected the problem.

One not immediately intuitive thing I found with scrub, BTW, was that if 
it finished with unverified errors, I needed to rerun scrub again to do 
further repairs.  I've since confirmed with someone who can read code (I 
sort of do but more at the admin playing with patches level than the dev 
level) that my guess at the reason behind this behavior was correct.  
When a metadata node fails checksum verification and is repaired, the 
checksums that it in turn contained cannot be verified in that pass and 
show up as unverified errors.  A repeated scrub once those errors are 
fixed can verify and fix if necessary those additional nodes, and 
occasionally up to three or four runs were necessary to fully verify and 
repair all blocks, eliminating all unverified errors, at which point 
further scrubs found no further errors.

It occurred to me as I write this, that the problem I saw and you have 
confirmed with testing and now reported, may actually be related to some 
interaction between these unverified errors and compressed blocks.

Anyway, as it happens, my / filesystem is normally mounted ro except 
during updates and by the end I was scrubbing after updates, and even 
after extended power-downs, so it generally had only a few errors.

But /home (on an entirely separate filesystem, but a filesystem still on 
a pair of partitions, one on each of the same two ssds) would often have 
more, and because I have a particular program that I start with my X and 
KDE session that reads a bunch of files into cache as it starts up, I had 
a systemd service configured to start at boot and cat all the files in 
that particular directory to /dev/null, thus caching them so when I later 
started X and KDE (I don't run a *DM and thus login at the text CLI and 
startx, with a kde session, from the CLI) and thus this program, all the 
files it reads would already be in cache.

And that's where the problem actually was and how I can actually confirm 
your report.  If that service didn't run, that directory, including some 
new files with a relatively large chance of being written to bad parts of 
the ssd as they hadn't been repositioned via scrub to relatively sound 
areas yet, wouldn't have all its files read, and the relative number of 
checksum errors would normally remain below whatever point triggered the 
kernel crash.  If that service was allowed to run, it would read in all 
those files and the resulting errors would often crash the kernel.

So I quickly learned that if I powered up and the kernel crashed at that 
point, I could reboot with the emergency kernel parameter, which would 
tell systemd to give me a maintenance-mode root login prompt after doing 
its normal mounts but before starting the normal post-mount services, and 
I could run scrub from there.  That would normally repair things without 
triggering the crash, and when I had run scrub repeatedly if necessary to 
correct any unverified errors in the first runs, I could then exit 
emergency mode and let systemd start the normal services, including the 
service that read all these files off the now freshly scrubbed 
filesystem, without further issues.

Needless to say, after dealing with that a few times and figuring out 
what was actually triggering the crashes, I disabled that cache-ahead 
service and started doing scrubs before I loaded X and KDE, and thus the 
app that would read all those files I had been trying to pre-cache.

And it wasn't /too/ long after that, that I decided I had observed the 
slow failure and remapped sectors thing for long enough, and I was tired 
of doing scrubs more and more often to try to keep up with things, and I 
did a final scrub and then a btrfs replace of that failing ssd.  The new 
one (as well as the other one that never had a problem) were the same 
brand and model number, but have remained fine, both then and since.


But the point of all that is to confirm your experience.  At least with 
compression, once the number of checksum failures goes too high, even if 
it's supposedly reading from the good copy and fixing things as it goes, 
eventually a kernel crash is triggered.  A reboot and scrub before 
triggering so many checksum failures fixed things for me, so it was 
indeed simple checksum failures with good second copies, but something 
about the process would still crash the kernel if it saw too many of them 
in too short a period.

So it's definitely behavior I've confirmed with compression on.  I can't 
confirm that it doesn't happen with compression off as I've never tried 
that, but that would explain why it hasn't been more commonly reported 
and thus likely fixed by now.  And apparently the devs don't test the 
someone less common combination of both compression and high numbers of 
raid1 correctable checksum errors, or they would have probably detected 
and fixed the problem from that.

So thanks for the additional tests and narrowing it down to the 
compression on raid1 with many checksum errors case.  Now that you've 
found out how the problem can be replicated, I'd guess we'll have a fix 
patch in relatively short order. =:^)


That said, based on my own experience, I don't consider the problem dire 
enough to switch off compression on my btrfs raid1s here.  After all, I 
both figured out how to live with the problem on my failing ssd before I 
knew all this detail, and have eliminated the symptoms for the time being 
at least, as the devices I'm using now are currently reliable enough that 
I don't have to deal with this issue.

And in the even that I do encounter the problem again, in severe enough 
form that I can't even get a successful scrub in to fix it, possibly due 
to catastrophic failure of a device, I should still be able to simply 
remove that device and use degraded,ro mounts of the remaining device to 
get access to the data in ordered to copy it to a replacement filesystem.

Which is already how I intended to deal with a catastrophic device 
failure, should it happen, so no real change of plans at all.  In my case 
I don't have to have live failover, so shutdown and cold replacement, if 
necessary with degraded,ro mounting and using the old filesystem as a 
backup to restore to a new filesystem on the new device, then device-
adding the old device partitions to the new filesystem and reconverting 
to raid1, will be a bit of a hassle, but should otherwise be a reasonably 
straightforward recovery.  And that's perfectly sufficient for my 
purposes if necessary, even if I'd prefer to avoid that degraded-readonly 
situation in the first place, when it's possible.

But the fix for this one should go quite some way toward increasing btrfs 
raid1 robustness and will definitely be a noticeable step on the journey 
toward production-ready, for sure, and now that you've nailed it down so 
nicely, a fix should be quickly forthcoming. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58020 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbaJ1AH3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 20:07:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XiuJs-0008CK-3b
	for linux-btrfs@vger.kernel.org; Tue, 28 Oct 2014 01:07:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 01:07:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 01:07:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS balance segfault, where to go from here
Date: Tue, 28 Oct 2014 00:07:11 +0000 (UTC)
Message-ID: <pan$98595$5149a38a$2d53014$f3ac0c62@cox.net>
References: <trinity-814e9704-84ce-4a27-a187-439cc5a13f06-1414401999856@3capp-mailcom-bs01>
	<5DD6D691-A067-4937-A5B4-545A0DFB9B1E@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 27 Oct 2014 10:51:16 -0600 as excerpted:

> On Oct 27, 2014, at 3:26 AM, Stephan Alz <stephan008@gmx.com> wrote:
>> 
>> My question is where to go from here? What I going to do right now is
>> to copy the most important data to another separated XFS drive.
>> What I planning to do is:
>> 
>> 1, Upgrade the kernel 2, Upgrade BTRFS 3, Continue the balancing.
> 
> Definitely upgrade the kernel and see how that goes, there's been many
> many changes since 3.13. I would upgrade the user space tools also but
> that's not as important.

Just emphasizing...

Because btrfs is still under heavy development and not yet fully stable, 
keeping particularly the kernel updated is vital, because running an old 
kernel often means running a kernel with known btrfs bugs, fixed in newer 
kernels.

The userspace isn't quite as important since under normal operation it 
mostly simply tells the kernel what operations to perform, and an older 
userspace simply means you might be missing newer features.  However, 
commands such as btrfs check (the old btrfsck) and btrfs restore work 
from userspace, so having a current btrfs-progs is important when you run 
into trouble and you're trying to fix things.

That said, a couple of recent kernels has known issues.  Don't use the 
3.15 series at all, and be sure you're on 3.16.3 or newer for the 3.16 
series.  3.17 introduced another bug, with the fix hopefully in 3.17.2 
(it didn't make 3.17.1) and in 3.18-rcs.

So 3.16.3 or later for stable kernel, or the latest 3.18-rc or live-git 
kernel, is what I'd recommend.  The other alternative if you're really 
conservative is the latest long-term stable series kernel, 3.14.x, as it 
gets critical bugfixes as well, tho it won't be quite as current as 
3.16.x or 3.18-rc.  But anything older than the latest 3.14.x stable 
series is old and outdated in btrfs terms, and is thus not recommended.  
And 3.15, 3.16 before 3.16.3, and 3.17 before 3.17.2 (hopefully), are 
blackout versions due to known btrfs bugs.  Avoid them.

Of course with btrfs still not fully stable, the usual sysadmin rule of 
thumb that if you don't have a tested backup you don't have a backup, and 
if you don't have a backup, by definition you don't care if you lose the 
data, applies more than ever.  If you're on not-yet-fully-stable btrfs 
and you don't have backups, by definition you don't care if you lose that 
data.  There's people having to learn that the hard way, tho btrfs 
restore can often recover at least some of what would otherwise be lost.

> FYI you can mount with skip_balance mount option to inhibit resuming
> balance, sometimes pausing the balance isn't fast enough when there are
> balance problems.

=:^)

>> Could someone please also explain that how is exactly the raid10 setup
>> works with ODD number of drives with btrfs?
>> Raid10 should be a stripe of mirrors. Now then this sdf drive is
>> mirrored or striped or what?
> 
> I have no idea honestly. Btrfs is very tolerant of adding odd number and
> sizes of devices, but things get a bit nutty in actual operation
> sometimes.

In btrfs, raid1, including the raid1 side of raid10, is defined as 
exactly two copies of the data, one on each of two different devices.  
These copies are allocated by chunk size, 1 GiB size for data, quarter 
GiB size for metadata, and chunks are normally allocated on the device 
with the most unallocated space available, provided the other constraints 
(such as don't but both copies on the same device) are met.

Btrfs raid0 stripes will be as wide as possible, but again are allocated 
a chunk at a time, in sub-chunk-size strips.

While I've not run btrfs raid10 personally and thus (as a sysadmin not a 
dev) can't say for sure, what this implies to me is that, assuming equal 
sized devices, an odd number of devices in raid10 will alternate skipping 
one device at each chunk allocation.

So with a five same-size device btrfs raid10, if I'm not mistaken, btrfs 
will allocate chunks from four at once, two mirrors, two stripes, with 
the fifth one unused for that chunk allocation.  However, at the next 
chunk allocation, the device skipped in the previous allocation will now 
have the most free space and will thus get the first allocation, with the 
one of the other four devices skipped in that allocation round.  After 
five allocation rounds (assuming all allocation rounds were 1 GiB data 
chunks, not quarter-GiB metadata), usage should thus be balanced across 
all five devices.

Of course with six same-size devices, because btrfs raid1 does exactly 
two copies, no more, each stripe will be three devices wide.


As for the dataloss question, unlike say raid56 mode which is known to be 
effectively little more than expensive raid0 at this point, raid10 should 
be as reliable as raid1, etc.  But I'd refer again to that sysadmin's 
rule of thumb above.  If you don't have tested backups, you don't have 
backups, and if you don't have backups, the data is by definition not 
valuable enough to be worth the hassle of backing it up; the calculated 
risk cost of data loss is lower than the given time required to make, 
test and keep current the backups.  After that, it's your decision 
whether you value that data more than the time required to make and 
maintain those backups, or not, given the risk factor including the fact 
that btrfs is still under heavy development and is not yet fully stable.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


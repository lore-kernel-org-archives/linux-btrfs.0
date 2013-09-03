Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55913 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759773Ab3ICIyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 04:54:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VGmNQ-0008CL-N4
	for linux-btrfs@vger.kernel.org; Tue, 03 Sep 2013 10:54:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 10:54:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Sep 2013 10:54:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recovering from csum errors
Date: Tue, 3 Sep 2013 08:54:01 +0000 (UTC)
Message-ID: <pan$97a5$71cfb7f0$286a61f9$62ed2e15@cox.net>
References: <CAD+_0YrG2ju47suCSRKta+bONwUPcjTpv1y=11rkVNqVtHHwiQ@mail.gmail.
	com> <20130902220006.GA6389@carfax.org.uk> <
	CAD+_0YqsQRO90Lx1R64h8EE-L=4zrE6CEQGDKy-h=92hLLptWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rain Maker posted on Tue, 03 Sep 2013 00:28:30 +0200 as excerpted:

> 2013/9/3 Hugo Mills <hugo@carfax.org.uk>:
>> On Mon, Sep 02, 2013 at 11:41:12PM +0200, Rain Maker wrote:
>>> Now, I removed the offending file. But is there something else I
>>> should have done to recover the data in this file? Can it be
>>> recovered?
>>
>>    No, and no. The data's failing a checksum, so it's basically
>> broken. If you had a btrfs RAID-1 configuration, the FS would be able
>> to recover from one broken copy using the other (good) copy.
>>
> Ofcourse, this makes sense.
> 
> I know filesystem recovery in BTRFS is incomplete. I'm opting for a
> override for these usecases. I mean; the filesystem still knows the
> checksum. There are 2 possibilities:
> - The checksum is wrong - The data is wrong
> 
> In case the checksum is wrong, why is there no possibility to
> recalculate the checksum and continue with the file (taking small
> corruptions for granted)? In this case (and, I believe, in more cases),
> it's a VM. I could have run Windows chkdsk from the VM to see what I
> could have salvaged.

AFAIK chkdsk wouldn't have returned an error, because from its point of 
view, the data is probably correct.  The issue, as stated, is (AFAIK 
proprietary, blackbox-unpatchable from a freedomware perspective) vmware 
changing data under direct-IO "in-flight", which breaks the intent and 
rules of direct-IO, at least as defined for Linux.  The previous 
discussion I've seen of the problem indicates that MS allows such 
changes, apparently choosing to take the speed hit for doing so, so it's 
an impedance miss-match between VM/physical-machine layers, one of which 
is proprietary and thus unfixable from a FLOSS perspective, with the 
other unwilling to take the general case slowdown for the proprietary 
special case that's breaking the intent of direct-IO and thus the rules 
for it in the first place.

It's worth noting that in the normal non-direct-IO case, there's no 
problem; the data is allowed to change and the checksum is simply 
recalculated.  But the entire purpose of direct-IO is to short-cut a lot 
of the care taken in the normal path in the interest of performance, when 
the user knows it can guarantee certain conditions are met.  The problem 
here is that direct-IO is being used, but the user is breaking the 
guarantee it chose to make by choosing to use direct-IO in the first 
place, then changing data in-flight that is guaranteed to be stable once 
committed to the direct-IO path.

(Just because it happened to work with ext3/4, etc, because they didn't 
do checksums and thus didn't actually rely on the level of guarantee 
being made, doesn't obligate other filesystems to do the same, 
particularly when one of their major features is checksummed data 
integrity, as is the case with btrfs.)

So because the data under direct-IO was changed in-flight, after the 
btrfs checksum had already been calculated, the MS side should indeed 
show it to be correct -- only the btrfs side will show as wrong, since 
the data changed after it calculated its checksum, thus breaking the 
rules for direct-IO under Linux.

The "proper" fix would thus be in vmware or possibly in the MS software 
running on top of it.  It should either not change the data in-flight if 
it's going to use direct-IO and by doing so make the guarantee that the 
data won't change in-flight, or should not use direct-IO if it's going to 
be changing the data in-flight and thus can't make that guarantee.  But 
of course that's not within the Linux/FLOSS world's control.

> In case the data is wrong, there may be a reverse CRC32 algorithm
> implemented. Most likely it's only several bytes which got "flipped".
> On modern hardware, it shouldn't take that much time to brute-force the
> checksum, especially considering we have a good guess (the raw,
> corrupted data).

But... that flips the entire reason for choosing direct-IO in the first 
place -- performance -- on its head, incurring a **HUGE** slowdown just 
to fix up a broken program that can't keep the guarantees it chose to 
make, to try to gain just a bit of performance.

By analogy, normal-IO might be considered surface shipping China to US, 
with direct-IO shipping by air.  But once the packages/data arrive by 
air, they're found to be broken because the packer didn't pack the data 
with the padding specified by the air-carrier so things broke in 
shipping, but instead of proposing the problem be fixed by actually 
padding as specified by the carrier or choosing the slower but more 
careful surface carrier, you're now proposing we send them to Mars (!!) 
and back to be fixed!

> Now, the VM I removed did not have any special data in it (+ I make
> backups), but it could've been much worse.
> 
>>> I have several subvolumes defined, one of which for VMWare
>>> Workstation (on which the corruption took place).
>>
>> Aaah, the VM workload could explain this. There's some (known,
>> won't-fix) issues with (I think) direct-IO in VM guests that can cause
>> bad checksums to be written under some circumstances.
>>
>> I'm not 100% certain, but I _think_ that making your VM images
>> nocow (create an empty file with touch; use chattr +C; extend the file
>> to the right size) may help prevent these problems.
>>
> Hmm, could try that. Thanks for the tip.

I'm similarly not 100% certain, but from (I believe accurate) memory, it 
was indeed nocow (nodatacow in terms of mount options).  The actual 
desired feature would be nodatasum, but AFAIK that's only available as a 
mount option, not as a per-file attribute.  And since those mount options 
currently apply to the entire filesystem, not just a subvolume, and 
checksumming is one of the big reasons you'd use btrfs in the first 
place, turning it off for the entire filesystem probably isn't what you 
want.  But since nodatacow/nocow implies nodatasum, turning off COW on 
the file also turns off checksumming, so it should do what you need, even 
if it does a bit more as well.

But nocow for a file containing a VM is almost certainly a good idea 
anyway, since the file-internal write pattern of VMs is such that the 
file would very likely otherwise end up hugely fragmented over time.  So 
it's probably what you want in the first place. =:^)

Of course you could look up the previous discussion in the list archives 
if you want the original discussion.

Meanwhile, as an alternative to the touch/chattr/extend routine 
(ordinarily necessary since nocow won't fix data that's already written), 
you can set nodatacow on the subdir the file will be created in, and 
(based on what I've read, I'm an admin not a developer myself and thus 
haven't actually read the code) all new files in that subdir should 
automatically inherit the nocow attribute.  That's what I'd probably do.

> I could also disable writeback cache on the VM. But, VMWare uses it's
> own "vmblock" kernel module for I/O, so I'm not sure if this would do
> any good. Then ofcourse, there's the performance hit.

Well, considering that by analogy you've proposed after-the-fact shipping 
to Mars and back to fix the breakage, choosing surface shipping vs. air 
shipment should be entirely insignificant, performance-wise. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


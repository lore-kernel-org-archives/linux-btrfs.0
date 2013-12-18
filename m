Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41048 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab3LRI3H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 03:29:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VtCV7-0003GZ-9p
	for linux-btrfs@vger.kernel.org; Wed, 18 Dec 2013 09:29:05 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 09:29:05 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 09:29:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs RAID1 File System Grew Something Extra
Date: Wed, 18 Dec 2013 08:28:41 +0000 (UTC)
Message-ID: <pan$2df35$e3cf512f$a0410338$348e2cbb@cox.net>
References: <1617587.38j2eTuIdt@vfr> <52B10C85.90405@oracle.com>
	<17576852.FmZ5tQlVm8@vfr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Garry T. Williams posted on Tue, 17 Dec 2013 23:12:25 -0500 as excerpted:

> On 12-18-13 10:46:29 Anand Jain wrote:
>> On 12/18/2013 10:03 AM, Garry T. Williams wrote:
>> > I have been using btrfs for my /home partition on my home machine for
>> > a few years now.  I created the file system RAID1 using two disk
>> > partitions.  Recently I noticed btrfs fi df shows extra Data, System,
>> > and Metadata allocations.
>>
>>   this is a known bug in mkfs.btrfs, the workaround for now is to run
>>   balance on FS having some data. so that unused group-
>>   profile will go away.
> 
> Thanks.
> 
>     garry@vfr$ sudo btrfs balance start /home
>     Done, had to relocate 50 out of 50 chunks
>     garry@vfr$ sudo btrfs filesystem df /home
>     Data, RAID1: total=22.00GiB, used=21.02GiB
>     System, RAID1: total=32.00MiB, used=12.00KiB
>     System, single: total=4.00MiB, used=0.00
>     Metadata, RAID1: total=1.00GiB, used=419.60MiB
> 
> Hmmm.
> 
> Well, it's better, but the extra allocation for System is baffling.  I
> believe that this happened sometime after creating the file system.

Keep in mind that btrfs remains under development, still improving old 
features and growing new ones as well as bugfixing (and of course 
unfortunately still adding new bugs with the new code occasionally, it 
comes with the development filesystem territory).

Having seen the same thing happen here, I think the extra allocations 
were there all the time, but simply weren't originally reported.  After 
some improvements in btrfs fi df, it more accurately reported the empty 
chunk-stub relics of mkfs.btrfs where it didn't before, so they appeared 
to be new even if they'd been there all the time.  But a balance normally 
does remove them.

Tho that doesn't explain why the balance didn't remove that 4 MiB single-
mode system stub.  It did on all my btrfs here.  But I run gentoo and 
build/install gentoo's live-git btrfs-progs, and build/run the mainline 
development kernel from live-git as well, so I'm well into the 3.13-rcs 
by now, while you haven't even upgraded to 3.12 yet and are still on 3.11-
stable series, which might account for that.  Or perhaps another balance 
would kill the system-stub as well?  I don't know.

> Also balance on a RAID1 file system with exactly two drives doesn't make
> much sense to me.  Why would any "chunks" have to be relocated? I'm
> clearly missing something here.

You haven't read up on how btrfs balance works at the wiki, have you?  
Which means you're probably missing other information that might be 
helpful in administering your btrfs as well.  It'll likely be worth your 
while to spend some time reading the user documentation there (and to 
bookmark it for further reference, too =:^) :

https://btrfs.wiki.kernel.org/

For balance in particular, see:

https://btrfs.wiki.kernel.org/index.php/FAQ#What_does_.22balance.22_do.3F

Also of interest:

https://btrfs.wiki.kernel.org/index.php/Balance_Filters

Of course, the btrfs manpage is also useful.

Basically, unless you limit it with the -d/-m/-s switches and/or filters, 
balance blindly rewrites/relocates every chunk on the filesystem, 
cleaning up and if applicable converting between redundancy types as it 
does so.  So all chunks are relocated/rewritten.

But the above documentation should also suggest trying this to see if it 
addresses that remaining single-mode system chunk stub:

btrfs balance start -fsconvert=raid1 /home

Especially if you're on spinning rust (not SSD), that should take quite a 
bit less time than a full balance as well, because you're only rebalancing 
the few MiB of system chunks, not the GiBs of data and metadata.

Hopefully that'll kill the single-mode system stub-chunk.  If not, you've 
probably hit a bug and should report it as such, tho you might wish to 
try it with the latest 3.12 stable or 3.13-rc first, in case the bug has 
already been fixed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34818 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1757208AbcLAITH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 03:19:07 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cCMa4-00058j-Mm
        for linux-btrfs@vger.kernel.org; Thu, 01 Dec 2016 09:19:00 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Metadata balance fails ENOSPC
Date: Thu, 1 Dec 2016 08:18:54 +0000 (UTC)
Message-ID: <pan$b62ac$c6e47486$e02dd52$a58b7862@cox.net>
References: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
        <CAJCQCtQJV5jCLbON3Fk+DHCztRqAVN35rfMcHiWKWRT3yg+c_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 30 Nov 2016 16:02:29 -0700 as excerpted:

> On Wed, Nov 30, 2016 at 2:03 PM, Stefan Priebe - Profihost AG
> <s.priebe@profihost.ag> wrote:
>> Hello,
>>
>> # btrfs balance start -v -dusage=0 -musage=1 /ssddisk/
>> Dumping filters: flags 0x7, state 0x0, force is off
>>   DATA (flags 0x2): balancing, usage=0
>>   METADATA (flags 0x2): balancing, usage=1
>>   SYSTEM (flags 0x2): balancing, usage=1
>> ERROR: error during balancing '/ssddisk/': No space left on device
>> There may be more info in syslog - try dmesg | tail
> 
> You haven't provided kernel messages at the time of the error.
> 
> Also useful is the kernel version.

I won't disagree here as often it's kernel-version-specific behavior in 
question, but in this case I think the behavior is generic and the 
question can thus be answered on that basis, without the kernel version 
or dmesg output.

@ Chris: Note that the ENOSPC wasn't during ordinary use, but 
/specifically/ during balance, which behaves a bit differently regarding 
ENOSPC, and I believe it's that version-generic behavior difference 
that's in focus, here.

>> # btrfs filesystem show /ssddisk/
>> Label: none  uuid: a69d2e90-c2ca-4589-9876-234446868adc
>>         Total devices 1 FS bytes used 305.67GiB
>          devid    1 size 500.00GiB used 500.00GiB path /dev/vdb1

Device line says 100% used (meaning allocated).  The below simply shows 
it a different way, confirming the 100% used.

>> # btrfs filesystem usage /ssddisk/
>> Overall:
>>     Device size:                 500.00GiB
>>     Device allocated:            500.00GiB
>>     Device unallocated:            1.05MiB
> 
> Drive is actually fully allocated so if Btrfs needs to create a new
> chunk right now, it can't.

... And that right there is the problem.

When doing chunk consolidation, with one exception noted below, btrfs 
balance creates new chunks to write into, then rewrites the content from 
the old into the new.  But there's no space left (1 MiB isn't enough) 
unallocated to allocate new chunks from, so balance errors out with 
ENOSPC.

>> Data,single: Size:483.97GiB, Used:298.18GiB
>>    /dev/vdb1     483.97GiB
>>
>> Metadata,single: Size:16.00GiB, Used:7.51GiB
>>    /dev/vdb1      16.00GiB
>>
>> System,single: Size:32.00MiB, Used:144.00KiB
>>    /dev/vdb1      32.00MiB
> 
> All three chunk types have quite a bit of unused space in them, so it's
> unclear why there's a no space left error.

Normal usage can still write into the existing chunks since they're not 
yet entirely full, but that's not where the error occurred.  There's no 
space left unallocated to allocate further chunks from, and that's what 
balance, with one single exception, must do first, allocate a new chunk 
in ordered to write into, so it errors out.

The one single exception is when there's actually nothing to rewrite, the 
usage=0 case, in which case balance will simply erase any entirely empty 
chunks of the appropriate type (-d=data, -m=metadata).

This _used_ to be required somewhat regularly, as the kernel knew how to 
allocate new chunks but couldn't deallocate chunks, even entirely empty 
chunks, without a balance.  However, since 3.16 (IIRC), the kernel has 
been able to deallocate entirely empty chunks entirely on its own 
(automatically), and does so reasonably regularly in normal usage, so the 
issue of zero-sized chunks is far rarer than it used to be.

But apparently there's still a bug or two somewhere, as we still get 
reports of the usage=0 filter actually deallocating some empty chunks 
back to unallocated, even on kernels that should be doing that 
automatically.  It's not as common as it once was, but it does still 
happen.

So the usage=0 filter, the only case where the kernel doesn't have to 
create a new chunk in ordered to clear space during a balance, because 
it's not actually writing a new chunk, only deleting an empty one, does 
still make sense to try, because sometimes it _does_ work, and in the 
100% allocated case it's the simplest thing to try so it's worth trying 
even tho there's a good chance it won't work, because the kernel is 
/supposed/ to be removing those chunks automatically now, and /usually/ 
does just that.


OK, so what was wrong with the above command, and what should be tried 
instead?

The above command used TWO filters, -dusage=0 -musage=1 .  It choked on 
the -musage=1, apparently because it tried a less-than 1% full but not /
entirely/ empty metadata chunk first, before trying data chunks with the 
-dusuage=0, which should have succeeded, even if it found no empty data 
chunks to remove.

So the fix is to try either -dusage=0 -musage=0 together, first, or to 
try -dusage by itself first (and possibly -musage=0 after that), before 
trying -musage=1.

If it works and there are empty chunks of either type that can be 
removed, hopefully that will free up enough space to write at least one 
more metadata chunk, leaving room to create at least the one more (it'd 
be two with dup metadata, but here it's single so just one, typically 256 
MiB tho it can be larger), and the -musage= can be slowly incremented as 
necessary until there's enough space unallocated to work more freely once 
again.

The reason to tackle metadata first, once the usage=0 filters have 
cleared the entirely empty chunks out, is that metadata chunks are 
typically only 256 MiB, while data chunks are nominally 1 GiB in size.  
So if the usage=0 filters clear out more than 256 MiB but under a GiB, 
space will still be tight enough to only do metadata, but hopefully doing 
it will clear even more space (it should given the numbers, but you may 
have to increment the usage= some, first), GiBs worth, so then data can 
be done as well.

If neither -dusage=0 nor -musage=0 clear anything, as may well be the 
case if the kernel is indeed clearing the empty chunks as it should, then 
it's time for more drastic measures.

Since you still have free space in both data and metadata, you're not in 
/too/ bad a shape, and deleting some files (which should be backed up 
anyway, given that btrfs is still stabilizing and ready backups are 
strongly recommended) or snapshots should eventually empty out some 
chunks.  The trouble is, it's a bit of trial and error to know what and 
how much to delete in ordered to empty some chunks (unless you use the 
debug commands to trace files down to individual chunks, but that'd be 
quite some manual work if nobody's written a tool to help with the task, 
alread, tho they may), which is time and hassle.

The other alternative is to btrfs device add a temporary device of 
perhaps 30-60 GiB or so -- a thumbdrive will work if necessary.  Then do 
the balance (being sure to specify single profile metadata as it'll 
default to raid1 as soon as there's a second device) using usage= to 
rewrite and combine chunks as necessary to free up some of that allocated 
but unused data and metadata space.  Then once a suitable amount of space 
has been freed, btrfs device remove the temporary device once again, thus 
triggering balance to write everything from it back to the original 
device once again.


Which is why the usage=0 is still worth trying, even tho it doesn't work 
a lot of the time these days, because there's no empty chunks -- it's by 
far the easiest of the three alternatives, and when it /does/ work it's 
very fast and nearly hassle-free, certainly compared to either of the 
other two alternatives, deleting stuff, or doing the temporary device 
dance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


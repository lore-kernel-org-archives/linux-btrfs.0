Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41058 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbbHLETk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 00:19:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZPNVr-0000SL-5X
	for linux-btrfs@vger.kernel.org; Wed, 12 Aug 2015 06:19:39 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 06:19:39 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 06:19:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-progs: btrfs balance returns enospc error on a system
 with 80% free space
Date: Wed, 12 Aug 2015 04:19:33 +0000 (UTC)
Message-ID: <pan$d7061$7a20efe8$b09a34a0$bddb6e81@cox.net>
References: <CAJwcFg-Y5q2xBGnoohy0zSzpjtFZAq9U+HWS+erTcskUDgdWRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Catalin posted on Tue, 11 Aug 2015 12:18:28 +0300 as excerpted:

> I have a recently installed an Arch Linux x86_64 system on a 50GB btrfs
> partition and every time I try btrfs balance start it gives me an enospc
> error even though I have less than 20% of the available space full.
> 
> I have tried the recommended method (from
> https://btrfs.wiki.kernel.org/index.php/Balance_Filters) and with
> -dusage I can go up to -dusage=100 with no problems but with -musage it
> works until 34 and then at musage=35 it fails with the enospc error.
> 
> Here is more detailed information about my setup and output of several
> commands:
> 
> uname -[r] 4.1.4-1-ARCH
> 
> btrfs --version btrfs-progs v4.1.2

Thanks.  That's about the first thing we ask for, and you're current on 
both kernel and userspace. =:^)

> btrfs fi show
> Label: 'ArchLinux'  uuid: 6816726f-71ed-4b64-9071-60684a445e71
>     Total devices 1 FS bytes used 9.86GiB
>     devid    1 size 50.00GiB used 12.31GiB path /dev/sda2
> 
> btrfs fi df /
> Data, single: total=10.00GiB, used=9.52GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=1.12GiB, used=354.31MiB
> GlobalReserve, single: total=128.00MiB, used=0.00B

Second thing we ask for. =:^)  (FWIW, usage is a newer command that 
basically combines the info of both of these, printing it in an often 
more understandable format.  But regulars are used to dealing with these 
older ones, so I omitted your usage output.)

50 GiB single-device filesystem, only 12.31 GiB allocated, default single 
data, dup metadata.  All healthy here. =:^)

[btrfs check and scrub returned no errors]

> btrfs balance start output with the following options:
> 
> -dusage 100:
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=100
> Done, had to relocate 2 out of 13 chunks
> 
> -dusage 100, second, third, ... run:
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=100
> Done, had to relocate 1 out of 13 chunks

It's unlikely to help, but when you're doing 100% anyway, you can simply 
use -d, IOW, tell balance data-only, but no filters.  Again, -d should 
work, but shouldn't help.  Of course you can do the same with metadata, 
but that's unlikely to work, since we already know a metadata balance 
dies with a chunk that's between 33 and 35 percent full, and as soon as 
it hits it...

> -musage 33, first run:
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=33 SYSTEM (flags 0x2):
>   balancing, usage=33
> Done, had to relocate 2 out of 13 chunks
> 
> -musage 33, second, third,.... run:
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=33 SYSTEM (flags 0x2):
>   balancing, usage=33
> Done, had to relocate 1 out of 12 chunks
> 
> -musage 35 always gives an error:
> Dumping filters: flags 0x6, state 0x0, force is off
>   METADATA (flags 0x2): balancing, usage=35 SYSTEM (flags 0x2):
>   balancing, usage=35
> ERROR: error during balancing '/' - No space left on device There may be
> more info in syslog - try dmesg | tail




> output of dmesg | tail (after repeated trying):

[Nothing much, reallocating blocks, ENOSPC error.]

> cat /etc/fstab
> # /dev/sda2 LABEL=ArchLinux
> UUID=6816726f-71ed-4b64-9071-60684a445e71    /	btrfs	
> rw,noatime,compress-force=lzo,space_cache,autodefrag 0 0

[subvolume mounts of the same btrfs omitted, subvolume/snapshot list 
omitted.]

> (like I said I have also tried with all the snapshots deleted)
> 
> I have tried running the command both from inside the system and mounted
> from a rescue cd with different combinations of mount options like
> enabling and disabling space-cache / nospace_cache , clear_cache,
> enospc_debug, enable and disable compression or autodefrag.
> I have tried defragmenting everything, filling all the space, adding
> files, deleting files, making snapshots, deleting snapshots still the
> same problem.
> I have run the balance command on both the root subvolume and on
> subvolid=0.
> I have tried putting the balance commands with options that work inside
> a for to run 1000 times hoping that maybe that one relocated chunk it
> says about might actually solve something in time but it doesn't (I am
> new to btrfs and not 100% about how balance works).
> 
> Everything else works fine, the system is very fast, good compression,
> no other errors and I have no other problems but the fact that I have
> this error means something is wrong and I don't know what is the problem
> and how to solve it.

You really have both included all sorts of info, and tried all sorts of 
stuff.  Top marks on that!  But unfortunately it's not helping with the 
problem...

One question.  You said you _recently_ installed.  Just how recently, or 
more directly, what version of btrfs-progs did you use for the 
mkfs.btrfs?  Or was it perhaps a conversion from ext*?

I ask, because...  the mkfs.btrfs from btrfs-progs v4.1.1 had a critical 
bug, with v4.1.2 released along with a message not to use the mkfs.btrfs 
from 4.1.1, and to redo any filesystems created with it, as it was 
creating broken btrfs.

If you installed recently enough that you might have used mkfs.btrfs from 
btrfs-progs v4.1.1, that's very likely your problem.  The filesystem is 
broken and your data is at risk as long as you continue to use it.  So 
ASAP, save off everything that's not already backed up that you want to 
keep, and do a clean mkfs.btrfs with v4.1.2.

Similarly with convert, except that its issue, while known to exist, 
hasn't yet been fully traced down, let alone fixed, AFAIK.  What we know 
is that people are reporting problems (often with balance) with the 
converted filesystem, even after removing the saved rollback subvolume.  
The recommendation there is not to use convert at all -- start with a 
clean mkfs.btrfs and either copy over from the ext*, which can then 
function as a backup if desired, or restore from backups to the new 
btrfs, either way, creating a new filesystem instead of doing a convert.

With luck the cause is one of those, and you can use the recommended 
solutions.  If your install was to a freshly mkfs.btrfs-ed btrfs, and it 
wasn't the known-bad mkfs.btrfs version, then it's a different problem, 
and one of the devs will need to take a look.  (I'm just another btrfs-
using admin and list regular, here.)

But... you /did/ mention running with the enospc_debug mount option.  
That won't fix the problem but it should provide more information in dmesg 
when the enospc occurs.  If it's not the bad mkfs.btrfs or a converted 
filesystem, you can try running the balance -musage=35 with the 
filesystem mounted with the enospc_debug option, and seeing what sort of 
dmesg output you get from that.  That's what I'd try next, were it my 
problem.  The debug output is targeted at the devs, however, so don't be 
dismayed if it doesn't make a lot of sense to you; it should help the 
devs make sense of things, at least.

Beyond that, you may be asked if you can do a btrfs-image of the 
filesystem, and send the devs the output.  This is metadata only, no file 
content, but it's still up to you, as the metadata does include directory 
tree and filename information, which can still be sensitive, depending on 
what you have stored on that btrfs.  (There's the sanitize option, which 
masks the names, but the quick version of that uses garbage names, thus 
limiting the usefulness somewhat, and the hash-collision version of it is 
*VERY* cpu and time intensive, and thus not particularly practical, 
unless you happen to have a very new CPU with the latest fancy CPU 
instructions, as that can actually speed it up to semi-practical, again.  
In any case, if you get asked for a btrfs image and don't want to send 
the clear-name version, ask if a sanitized image will still give them 
what they need.  It might or might not.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


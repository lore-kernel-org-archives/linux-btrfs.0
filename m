Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35425 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbaFNCxd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 22:53:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wve5z-0000Zv-1s
	for linux-btrfs@vger.kernel.org; Sat, 14 Jun 2014 04:53:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jun 2014 04:53:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Jun 2014 04:53:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Sat, 14 Jun 2014 02:53:20 +0000 (UTC)
Message-ID: <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<pan$22693$6b452195$976b783a$e4956372@cox.net>
	<20140612232453.GR9508@dastard> <539B78F3.9070607@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Sat, 14 Jun 2014 00:19:31 +0200 as
excerpted:

> On 06/13/2014 01:24 AM, Dave Chinner wrote:
>> On Thu, Jun 12, 2014 at 12:37:13PM +0000, Duncan wrote:
>>>
>>> FWIW, either 4 byte or 8 MiB fallocate calls would be bad, I think
>>> actually pretty much equally bad without NOCOW set on the file.
>> 
>> So maybe it's been fixed in systemd since the last time I looked.
>> Yup:
>> 
>> http://cgit.freedesktop.org/systemd/systemd/commit/src/journal/journal-
file.c?id=eda4b58b50509dc8ad0428a46e20f6c5cf516d58
>> 
>> The reason it was changed? To "save a syscall per append", not to
>> prevent fragmentation of the file, which was the problem everyone was
>> complaining about...
> 
> thanks for pointing that. However I am performing my tests on a fedora
> 20 with systemd-208, which seems have this change
>> 
>>> Why?  Because btrfs data blocks are 4 KiB.  With COW, the effect for
>>> either 4 byte or 8 MiB file allocations is going to end up being the
>>> same, forcing (repeated until full) rewrite of each 4 KiB block into
>>> its own extent.
> 
> I am reaching the conclusion that fallocate is not the problem. The
> fallocate increase the filesize of about 8MB, which is enough for some
> logging. So it is not called very often.

But... 

If a file isn't (properly[1]) set NOCOW (and the btrfs isn't mounted with 
nodatacow), then an fallocate of 8 MiB will increase the file size by 8 
MiB and write that out.  So far so good as at that point the 8 MiB should 
be a single extent.  But then, data gets written into 4 KiB blocks of 
that 8 MiB one at a time, and because btrfs is COW, the new data in the 
block must be written to a new location.

Which effectively means that by the time the 8 MiB is filled, each 4 KiB 
block has been rewritten to a new location and is now an extent unto 
itself.  So now that 8 MiB is composed of 2048 new extents, each one a 
single 4 KiB block in size.

=:^(

Tho as I already stated, for file sizes upto 128 MiB or so anyway[2], the 
btrfs autodefrag mount option should at least catch that and rewrite 
(again), this time sequentially.

> I have to investigate more what happens when the log are copied from
> /run to /var/log/journal: this is when journald seems to slow all.

That's an interesting point.

At least in theory, during normal operation journald will write to 
/var/log/journal, but there's a point during boot at which it flushes the 
information accumulated during boot from the volatile /run location to 
the non-volatile /var/log location.  /That/ write, at least, should be 
sequential, since there will be > 4 KiB of journal accumulated that needs 
to be transferred at once.  However, if it's being handled by the forced 
pre-write fallocate described above, then that's not going to be the 
case, as it'll then be a rewrite of already fallocated file blocks and 
thus will get COWed exactly as I described above.

=:^(


> I am prepared a PC which reboot continuously; I am collecting the time
> required to finish the boot vs the fragmentation of the system.journal
> file vs the number of boot. The results are dramatic: after 20 reboot,
> the boot time increase of 20-30 seconds. Doing a defrag of
> system.journal reduces the boot time to the original one, but after
> another 20 reboot, the boot time still requires 20-30 seconds more....
> 
> It is a slow PC, but I saw the same behavior also on a more modern pc
> (i5 with 8GB).
> 
> For both PC the HD is a mechanical one...

The problem's duplicable.  That's the first step toward a fix. =:^)

>> And that's now a btrfs problem.... :/
> 
> Are you sure ?

As they say, "Whoosh!"

At least here, I interpreted that remark as primarily sarcastic 
commentary on the systemd devs' apparent attitude, which can be 
(controversially) summarized as: "Systemd doesn't have problems because 
it's perfect.  Therefore, any problems you have with systemd must instead 
be with other components which systemd depends on."

IOW, it's a btrfs problem now in practice, not because it is so in a 
technical sense, but because systemd defines it as such and is unlikely 
to budge, so the only way to achieve progress is for btrfs to deal with 
it. 

An arguably fairer and more impartial assessment of this particular 
situations suggests that neither btrfs, which as a COW-based filesystem, 
like all COW-based filesystems has the existing-file-rewrite as a major 
technical challenge that it must deal with /somehow/, nor systemd, which 
in choosing to use fallocate is specifically putting itself in that 
existing-file-rewrite class, are entirely at fault.

But that doesn't matter if one side refuses to budge, because then the 
other side must do so regardless of where the fault was, if there is to 
be any progress at all.

Meanwhile, I've predicted before and do so here again, that as btrfs 
moves toward mainstream and starts supplanting ext* as the assumed Linux 
default filesystem, some of these problems will simply "go away", because 
at that point, various apps are no longer optimized for the assumed 
default filesystem, and they'll either be patched at some level (distro 
level if not upstream) to work better on the new default filesystem, or 
will be replaced by something that does.  And neither upstream nor distro 
level does that patching, then at some point, people are going to find 
that said distro performs worse than other distros that do that patching.

Another alternative is that distros will start setting /var/log/journal 
NOCOW in their setup scripts by default when it's btrfs, thus avoiding 
the problem.  (Altho if they do automated snapshotting they'll also have 
to set it as its own subvolume, to avoid the first-write-after-snapshot-
is-COW problem.)  Well, that, and/or set autodefrag in the default mount 
options.

Meanwhile, there's some focus on making btrfs behave better with such 
rewrite-pattern files, but while I think the problem can be made /some/ 
better, hopefully enough that the defaults bother far fewer people in far 
fewer cases, I expect it'll always be a bit of a sore spot because that's 
just how the technology works, and as such, setting NOCOW for such files 
and/or using autodefrag will continue to be recommended for an optimized 
setup.

---
[1] "Properly" set NOCOW:  Btrfs doesn't guarantee the effectiveness of 
setting NOCOW (chattr +C) unless the attribute is set while the file is 
still zero size, effectively, at file creation.  The easiest way to do 
that is to set NOCOW on the subdir that will contain the file, such that 
when the file is created it inherits the NOCOW attribute automatically.

[2] File sizes upto 128 MiB ... and possibly upto 1 GiB.  Under 128 MiB 
should be fine, over 1 GiB is known to cause issues, between the two is a 
gray area that depends on the speed of the hardware and the incoming 
write-stream.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


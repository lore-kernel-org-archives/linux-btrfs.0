From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: blocked tasks right after mounting (was: Hang when trying to
 access fs)
Date: Sun, 29 Jan 2012 02:59:23 +0000 (UTC)
Message-ID: <pan.2012.01.29.02.59.23@cox.net>
References: <874nvf50bm.fsf@vostro.rath.org>
	<87zkd73l6e.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Nikolaus Rath posted on Sat, 28 Jan 2012 10:23:53 -0500 as excerpted:

> Nikolaus Rath <Nikolaus@rath.org> writes:
>> Hello,
>>
>> When trying to rsync to btrfs, the process just hangs. dmesg output
>> alternates between:
> [...]
> 
> I guess I should also mention that this is reproducible, and I don't
> even need to run rsync. Simply mounting the file system produces a
> similar warning soon afterwards:
> 
> [  678.316046] usb 1-4: new high speed USB device number 7 using 
ehci_hcd

> [  678.450429] scsi7 : usb-storage 1-4:1.0

> [  681.659675] sd 7:0:0:0: [sdg] No Caching mode page present
> [  681.659679] sd 7:0:0:0: [sdg] Assuming drive cache: write through

> [  681.673562] sd 7:0:0:0: [sdg] Attached SCSI disk
> [  791.512475] Btrfs loaded
> [  791.513625] device label Videos devid 1 transid 142 /dev/mapper/
> udisks-luks-uuid-7adf0c16-c741-485e-86dd-8a209fe4ce85-uid1000
> [  791.567843] btrfs: disk space caching is enabled
> [  960.456073] INFO: task sync:4930 blocked for more than 120 seconds.

Two points, based on the wiki at:  https://btrfs.wiki.kernel.org/

1) In the first post you mention kernel 3.1.  Here's what the wiki has to 
say about kernel versions right at the top of the "Getting started" page:

>>>>>
btrfs is a fast-moving target. There are typically a great many bug fixes 
and enhancements between one kernel release and the next. Therefore:

** If you have btrfs filesystems, run the latest kernel.

If you are running a kernel two or more versions behind the latest one 
available from kernel.org, the first thing you will be asked to when you 
report a problem is to upgrade to the latest kernel.
<<<<<

It goes on to mention the userspace tools as well.  Note that the last 
btrfs-tools release version, (0.19 IIRC), is from (IIRC) 2010.  You 
REALLY want to be running a recently rebuilt live-git btrfs-tools build.

Elsewhere (I don't see the reference ATM) I believe I saw a 
recommendation to run the rc kernels as well (tho you might wish to wait 
until rc 3 or 4 just to be sure, I personally run git kernels but don't 
normally update during the merge window, so not until after rc1), for 
much the same reason -- they'll have fixes before a stable kernel will.

Given that we're past 3.3-rc1 at this point and there's been a couple 3.2-
stable updates, you really should be running at LEAST 3.2 stable, if not
3.3-rc1+.  3.1 is really a bit old, given that btrfs really /is/ still in 
heavy development.


2) I saw that /dev/mapper/udisks-luks-* message in the log and it 
reminded me of the following from the wiki gotchas page.  I don't run 
encryption here and thus haven't sorted out all the various encryption 
setups and don't know if luks is dm-crypt or something else, but it may 
apply regardless.  If you've had a power outage or unplugged without 
umounting, you're likely corrupted, and that's what's triggering your 
issue, since there's no indication that write-caching is turned off in 
the log you posted (tho it may not register in the log, I'll grant).

>>>>>
btrfs volumes on top of dm-crypt block devices (and possibly LVM) require 
write-caching to be turned off on the underlying HDD. Failing to do so, 
in the event of a power failure, may result in corruption not yet handled 
by btrfs code. (2.6.33) 
<<<<<

Despite the above warning, it may be that the first procedure listed at 
the top of the problem FAQ, zeroing out the log, may help, altho it's not 
clear from your post whether it actually mounted, or not.  You can try 
it.  There's also a note about the zero-log procedure in the (main) FAQ, 
under "Is btrfs stable", "Pragmantic, personal and anecdotal answer", 
which states (as of 2011-08-21):

>>>>>
In the last few months, the vast majority of the problems with broken and 
unmountable filesystems I've seen on IRC and the mailing list have been 
caused by power outages in the middle of a write to the FS, and have been 
fixable by use of the btrfs-zero-log tool.
<<<<<

But I'm not sure if that overrides the caveat on dm-crypt or if that has 
been fixed by now, since the dm-crypt note is from ~2010 since it 
mentions 2.6.33.

You can also try mounting read-only, which I found mentioned as a hint 
somewhere, as well, and there's a newer tool (that I don't see covered on 
the wiki, I read about it elsewhere) that will often let you at least 
copy the data out of a bad btrfs partition, if it's necessary.  That 
might allow you to get the data off, at least, if you don't have proper 
backups, which you DEFINITELY should have, given that btrfs is still 
experimental and under rapid development.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


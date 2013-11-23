Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58174 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517Ab3KWQdU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Nov 2013 11:33:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VkG91-0005vs-La
	for linux-btrfs@vger.kernel.org; Sat, 23 Nov 2013 17:33:19 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 17:33:19 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Nov 2013 17:33:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Nagios probe for btrfs RAID status?
Date: Sat, 23 Nov 2013 16:32:57 +0000 (UTC)
Message-ID: <pan$98b65$bf0f3e19$35b6bfa7$de9e854@cox.net>
References: <528F6085.4020603@pocock.com.au> <52902808.8020706@oracle.com>
	<5290695E.80506@pocock.com.au>
	<pan$13621$9e5c77ca$1502a49b$4b791baa@cox.net>
	<52909519.7080508@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Pocock posted on Sat, 23 Nov 2013 12:44:25 +0100 as excerpted:

>> [btrfs manpage quote]
>> btrfs device stats [-z] {<path>|<device>}
>> 
>> Read and print the device IO stats for all devices of the filesystem
>> identified by <path> or for a single <device>.

>> -z   Reset stats to zero after reading them.

>> Here's the output for my (dual device btrfs raid1) rootfs, here:
>> 
>> btrfs dev stat /
>> [/dev/sdc5].write_io_errs   0
>> [/dev/sdc5].read_io_errs    0
>> [/dev/sdc5].flush_io_errs   0
>> [/dev/sdc5].corruption_errs 0
>> [/dev/sdc5].generation_errs 0
>> [/dev/sda5].write_io_errs   0
>> [/dev/sda5].read_io_errs    0
>> [/dev/sda5].flush_io_errs   0
>> [/dev/sda5].corruption_errs 0
>> [/dev/sda5].generation_errs 0
>> 
>> As you can see, for multi-device filesystems it gives the stats per
>> component device.  Any errors accumulate until a reset using -z, so you
>> can easily see if the numbers are increasing over time and by how much.

> That looks interesting - are these explained anywhere?

I'd guess in the sources...  There's nothing more in the manpage about 
them, and nothing on the wiki.  Some weeks ago I scanned some of the 
whitepapers listed on the wiki, and found most of them frustratingly "big 
picture" vague on such details as well. =:^(  There was one that had a 
bit of detail, but only about half of what I was looking for at the time 
(the difference between leafsize, sectorsize and nodesize, three option 
knobs available on the mkfs.btrfs commandline, and what they actually 
tuned, and while I was at it, how they related to btrfs chunks) was there 
either, and even then not really explained very clearly).  So it seems a 
lot of the documentation is sources-only at this point. =:^(

> Should a Nagios plugin just look for any non-zero value or just focus on
> some of those?

I could guess at what some of them are and their significance based on 
what I've seen here, but I'm afraid my guesses wouldn't rate well in SNR 
terms, so I'll abstain...

> Are they runtime stats (since system boot) or are they maintained in the
> filesystem on disk?

The records are maintained across mounts/boots so must be stored on-
disk.  Only the -z switch zeroes.

> My own version of the btrfs utility doesn't have that command though, I
> am using a Debian stable system.  I tried a newer version and it gives
> 
> ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS)
> 
> so I probably need to update my kernel too.

You've likely read it before, but btrfs remains a filesystem under heavy 
development, with every kernel bringing fixes for known bugs and 
userspace tools developed in tandem, and every btrfs user at this point 
is by definition a development filesystem tester.  While there are 
reasons one may wish to be conservative and stick with a known stable 
system, they really tend to be antithetical with the reasons one would 
have for testing something as development edge as btrfs at this point.  
Thus, upgrading to a current kernel (3.12.x at this point, if not 3.13 
development kernel as rc1 just came out) and btrfs-progs (at least, you 
can keep the rest of the system stable Debian if you like) is very 
strongly recommended if you're testing btrfs, in any case.

(For btrfs-progs, development happens in git branches, with merges to the 
master branch only when changes are considered release-ready.  So current 
git-master btrfs-progs is always the reference.  FWIW, here's what btrfs 
--version outputs here, btrfs-progs from git updated as of yesterday as 
it happens, tho I usually keep within a week or two: Btrfs v0.20-rc1-598-
g8116550.)

See the btrfs wiki for more:  https://btrfs.wiki.kernel.org.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


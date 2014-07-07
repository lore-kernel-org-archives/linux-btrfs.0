Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56354 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbaGGPsf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jul 2014 11:48:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X4B9b-0001v8-61
	for linux-btrfs@vger.kernel.org; Mon, 07 Jul 2014 17:48:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 17:48:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 17:48:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount time of multi-disk arrays
Date: Mon, 7 Jul 2014 15:48:19 +0000 (UTC)
Message-ID: <pan$e34e1$34425a38$28d282d8$6ffde053@cox.net>
References: <53BAA2E5.2090801@lianse.eu> <53BAA67D.1050101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Konstantinos Skarlatos posted on Mon, 07 Jul 2014 16:54:05 +0300 as
excerpted:

> On 7/7/2014 4:38 μμ, André-Sebastian Liebe wrote:
>>
>> can anyone tell me how much time is acceptable and assumable for a
>> multi-disk btrfs array with classical hard disk drives to mount?
>>
>> I'm having a bit of trouble with my current systemd setup, because it
>> couldn't mount my btrfs raid anymore after adding the 5th drive. With
>> the 4 drive setup it failed to mount once in a few times. Now it fails
>> everytime because the default timeout of 1m 30s is reached and mount is
>> aborted.
>> My last 10 manual mounts took between 1m57s and 2m12s to finish.

> I have the exact same problem, and have to manually mount my large
> multi-disk btrfs filesystems, so I would be interested in a solution as
> well.

I don't have a direct answer, as my btrfs devices are all SSD, but...

a) Btrfs, like some other filesystems, is designed not to need a
pre-mount (or pre-rw-mount) fsck, because it does what /should/ be a 
quick-scan at mount-time.  However, that isn't always as quick as it 
might be for a number of reasons:

a1) Btrfs is still a relatively immature filesystem and certain 
operations are not yet optimized.  In particular, multi-device btrfs 
operations tend to still be using a first-working-implementation type of 
algorithm instead of a well optimized for parallel operation algorithm, 
and thus often serialize access to multiple devices where a more 
optimized algorithm would parallelize operations across multiple devices 
at the same time.  That will come, but it's not there yet.

a2) Certain operations such as orphan cleanup ("orphans" are files that 
were deleted while they were in use and thus weren't fully deleted at the 
time; if they were still in use at unmount (remount-read-only), cleanup 
is done at mount-time) can delay mount as well.

a3) Inode_cache mount option:  Don't use this unless you can explain 
exactly WHY you are using it, preferably backed up with benchmark 
numbers, etc.  It's useful only on 32-bit, generally high-file-activity 
server systems and has general-case problems, including long mount times 
and possible overflow issues that make it inappropriate for normal use.  
Unfortunately there's a lot of people out there using it that shouldn't 
be, and I even saw it listed on at least one distro (not mine!) wiki. =:^(

a4) The space_cache mount option OTOH *IS* appropriate for normal use 
(and is in fact enabled by default these days), but particularly in 
improper shutdown cases can require rebuilding at mount time -- altho 
this should happen /after/ mount, the system will just be busy for some 
minutes, until the space-cache is rebuilt.  But the IO from a space_cache 
rebuild on one filesystem could slow down the mounting of filesystems 
that mount after it, as well as the boot-time launching of other post-
mount launched services.

If you're seeing the time go up dramatically with the addition of more 
filesystem devices, however, and you do /not/ have inode_cache active, 
I'd guess it's mainly the not-yet-optimized multi-device operations.


b) As with any systemd launched unit, however, there's systemd 
configuration mechanisms for working around specific unit issues, 
including timeout issues.  Of course most systems continue to use fstab 
and let systemd auto-generate the mount units, and in fact that is 
recommended, but either with fstab or directly created mount units, 
there's a timeout configuration option that can be set.

b1) The general systemd *.mount unit [Mount] section option appears to be 
TimeoutSec=.  As is usual with systemd times, the default is seconds, or 
pass the unit(s, like "5min 20s").

b2) I don't see it /specifically/ stated, but with a bit of reading 
between the lines, the corresponding fstab option appears to be either
x-systemd.timeoutsec= or x-systemd.TimeoutSec= (IOW I'm not sure of the 
case).  You may also want to try x-systemd.device-timeout=, which /is/ 
specifically mentioned, altho that appears to be specifically the timeout 
for the device to appear, NOT for the filesystem to mount after it does.

b3) See the systemd.mount (5) and systemd-fstab-generator (8) manpages 
for more, that being what the above is based on.

So it might take a bit of experimentation to find the exact command, but 
based on the above anyway, it /should/ be pretty easy to tell systemd to 
wait a bit longer for that filesystem.

When you find the right invocation, please reply with it here, as I'm 
sure there's others who will benefit as well.  FWIW, I'm still on 
reiserfs for my spinning rust (only btrfs on my ssds), but I expect I'll 
switch them to btrfs at some point, so I may well use the information 
myself.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50900 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbcDIHYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Apr 2016 03:24:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aonG8-0003oc-Hl
	for linux-btrfs@vger.kernel.org; Sat, 09 Apr 2016 09:24:44 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Apr 2016 09:24:44 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Apr 2016 09:24:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Missing device handling (was: 'unable to mount btrfs pool...')
Date: Sat, 9 Apr 2016 07:24:37 +0000 (UTC)
Message-ID: <pan$b9ec0$9af87166$9880d70a$1ad778e5@cox.net>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
	<57064231.2070201@gmail.com>
	<CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
	<5707961D.6000803@gmail.com>
	<CAJCQCtT1Pt__k+aYqSjNPLmcgpH7F4N+ueJ3b+z+aVTYTYtGEg@mail.gmail.com>
	<57080530.7030805@gmail.com>
	<20160408195259.GA23661@jeknote.loshitsa1.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yauhen Kharuzhy posted on Fri, 08 Apr 2016 22:53:00 +0300 as excerpted:

> On Fri, Apr 08, 2016 at 03:23:28PM -0400, Austin S. Hemmelgarn wrote:
>> On 2016-04-08 12:17, Chris Murphy wrote:
>> 
>> I would personally suggest adding a per-filesystem node in sysfs to
>> handle both 2 and 5. Having it open tells BTRFS to not automatically
>> attempt countermeasures when degraded, select/epoll on it will return
>> when state changes, reads will return (at minimum): what devices
>> comprise the FS, per disk state (is it working, failed, missing, a
>> hot-spare, etc), and what effective redundancy we have (how many
>> devices we can lose and still be mountable, so 1 for raid1, raid10, and
>> raid5, 2 for raid6, and 0 for raid0/single/dup, possibly higher for
>> n-way replication (n-1), n-order parity (n), or erasure coding). This
>> would make it trivial to write a daemon to monitor the filesystem,
>> react when something happens, and handle all the policy decisions.
> 
> Hm, good proposal. Personally I tried to use uevents for this but they
> cause locking troubles, and I didn't continue this attempt.

Except that... in sysfs (unlike proc) there's a rather strictly enforced 
rule of one property per file.

So you could NOT hold a single sysfs file open, that upon read would 
return 1) what devices comprise the FS, 2) per device (um, disk in the 
original, except that it can be a non-disk device, so changed to device 
here) state, 3) effective number of can-be-lost devices.

The sysfs style interface would be a filesystem directory containing a 
devices subdir, with (read-only?) per-device state-files in that subdir.  
The listing of per-device state-files would thus provide #1, with the 
contents of each state-file being the status of that device, therefore 
providing #2.  Back in the main filesystem dir, there'd be a devices-
loseable file, which would provide #3.

There could also be a filesystem-level state file which could be read for 
the current state of the filesystem as a whole or selected/epolled for 
state-changes, and probably yet another file, we'll call it leave-be here 
simply because I don't have a better name, that would be read/write 
allowing reading or setting the no-countermeasures property.


Actually, after looking at the existing /sys/fs/btrfs layout, we already 
have filesystem directories, each with a devices subdir, tho the symlinks 
therein point to the /sys/devices tree device dirs.  The listing thereof 
already provides #1, at least for operational devices.

I'm not going to go testing what happens to the current sysfs devices 
listings when a device goes missing, but we already know btrfs doesn't 
dynamically use that information.  Presumably, once it does, the symlinks 
could be replaced with subdirs for missing devices, with the still known 
information in the subdir (which could then be named as either the btrfs 
device ID or as missing-N), and the status of the device being detectable 
by whether it's a symlink to a devices tree device (device online) or a 
subdir (device offline).

The per-filesystem devices-losable, fs-status, and leave-be files could 
be added to the existing syfs btrfs interface.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


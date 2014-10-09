Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40209 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbaJINtk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Oct 2014 09:49:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XcE67-0002Lx-5J
	for linux-btrfs@vger.kernel.org; Thu, 09 Oct 2014 15:49:39 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 15:49:39 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 15:49:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What is the vision for btrfs fs repair?
Date: Thu, 9 Oct 2014 13:49:27 +0000 (UTC)
Message-ID: <pan$be94c$47b1139c$477c562b$8f545371@cox.net>
References: <54358C77.2070808@redhat.com> <54367193.6000202@gmail.com>
	<pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
	<20141009053402.7dc286f0@ws> <54368B1E.4040901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 09 Oct 2014 09:18:22 -0400 as
excerpted:

> On 2014-10-09 08:34, Duncan wrote:

>> The only way a read-only
>> mount should be writable is if it's mounted (bind-mounted or
>> btrfs-subvolume-mounted) read-write elsewhere, and the write occurs to
>> that mount, not the read-only mounted location.

> In theory yes, but there are caveats to this, namely:
> * atime updates still happen unless you have mounted the fs with noatime

I've been mounting noatime for well over a decade now, exactly due to 
such problems.  But I believe at least /some/ filesystems are truly read-
only when they're mounted as such, and atime updates don't happen on them.

These days I actually apply a patch that changes the default relatime to 
noatime, so I don't even have to have it in my mount-options. =:^)

> * The superblock gets updated if there are 'any' writes

Yeah.  At least in theory, there shouldn't be, however.  As I said, in 
theory, even journal replay and orphan delete shouldn't hit media, altho 
handling it in memory and dirtying the cache, so if the filesystem is 
ever remounted read-write they get written, is reasonable.

> * The free space cache 'might' be updated if there are any writes

Makes sense.  But of course that's what I'm arguing, there shouldn't /be/ 
any writes.  Read-only should mean exactly that, don't touch media, 
period.

I remember at one point activating an mdraid1 degraded, read-only, just a 
single device of the 4-way raid1 I was running at the time, to recover 
data from it after the system it was running in died.  The idea was don't 
write to the device at all, because I was still testing the new system, 
and in case I decided to try to reassemble the raid at some point.  Read-
only really NEEDS to be read-only, under such conditions.

Similarly for forensic examination, of course.  If there's a write, any 
write, it's evidence tampering.  Read-only needs to MEAN read-only!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


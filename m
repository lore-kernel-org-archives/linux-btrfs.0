Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41768 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbbJDDiA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 23:38:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zia7Z-0006rI-9s
	for linux-btrfs@vger.kernel.org; Sun, 04 Oct 2015 05:37:57 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 05:37:57 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2015 05:37:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 4/4] btrfs-progs: change -t option for subvolume list to
 print a simple space-separated table (making it machine-readable)
Date: Sun, 4 Oct 2015 03:37:51 +0000 (UTC)
Message-ID: <pan$c5775$3f0b408b$41f20753$9ede78d@cox.net>
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
	<1443804083-876-5-git-send-email-axel@tty0.ch>
	<560FA665.6000700@libero.it> <560FA944.3050606@digint.ch>
	<5610134D.9070807@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Sat, 03 Oct 2015 19:41:33 +0200 as
excerpted:

> On 2015-10-03 12:09, Axel Burri wrote:
>> 
>> 
>> On 2015-10-03 11:56, Goffredo Baroncelli wrote:
>>> On 2015-10-02 18:41, axel@tty0.ch wrote:
>>>> Old implementation used tabs "\t", and tried to work around problems
>>>> by guessing amount of tabs needed (e.g. "\t\t" after top level", with
>>>> buggy output as soon as empty uuids are printed). This will never
>>>> work correctly, as tab width is a user-defined setting in the
>>>> terminal.
>>>
>>>
>>> Why not use string_table() and table_*() functions  ?
>> 
>> string_table(), as well as all table functions by nature, needs to know
>> the maximum size of all cells in a row before printing, and therefore
>> buffers all the output before printing. It would eat up a lot of memory
>> for large tables (it is not unusual to have 1000+ subvolumes in btrfs
>> if you make heavy use of snapshotting). Furthermore, it would slow down
>> things by not printing the output linewise.
> 
> 
> Assuming 200bytes per row (== subvolume) x 1000 subvolumes = 200kB... I
> don't think that this could be a problem, nor in terms of memory used
> nor in terms of speed: if you have 1000+ subvolumes the most time
> consuming activity is traversing the filesystem looking at the
> snapshot...

Perhaps unfortunately, scaling to millions of snapshots/subvolumes really 
*is* expected by some people.  You'd be surprised at the number of folks 
that setup automated per-minute snapshotting with no automated thinning, 
and expect to be able to keep several years' worth of snapshots, and then 
wonder why btrfs maintenance commands such as balance take weeks/months...

5 years * 365 days/year * 24 hours/day * 60 minutes/hour * 1 snapshot/
minute = ...

(years, days, hours, minutes cancel out, leaving snapshots... yeah, the 
math should be right)

2.6 million plus snapshots.  And that's just one subvolume.  Multiply 
that by a half dozen subvolumes...

Over 15 million snapshots.  Multiply that by 200 bytes/snapshot...

Several gigs of buffer memory, now.

Obviously btrfs doesn't scale to that level now, and if it did, someone 
making the mistake of trying to get a listing of millions of snapshots 
would very likely change their mind before even hitting 10%...

But that's why actually processing line-by-line is important, so they'll 
actually /see/ what happened and ctrl-C it, instead of the program 
aborting as it runs into (for example) the 32-bit user/kernel memory 
barrier, without printing anything useful...

The line-by-line way... "Oops, that's waayyy too many snapshots to be 
practical, maybe I should start thinning..."

The buffer-it-all-way... "Oops, there's a bug in the program; it crashed."

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


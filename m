Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54211 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbbF2CvD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jun 2015 22:51:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z9P9w-0004H5-TH
	for linux-btrfs@vger.kernel.org; Mon, 29 Jun 2015 04:51:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 04:51:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 04:51:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs replace seems to corrupt the file system
Date: Mon, 29 Jun 2015 02:50:55 +0000 (UTC)
Message-ID: <pan$5bec1$ed013fe$31c92a4b$42a55f45@cox.net>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CA+xOVSO+Lx09CnwCP8nvTf-1JOAvzLsgZubP-QF16wtMSzqLhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mordechay Kaganer posted on Sun, 28 Jun 2015 19:31:31 +0300 as excerpted:

> On Sun, Jun 28, 2015 at 2:17 AM, Mordechay Kaganer <mkaganer@gmail.com>
> wrote:
>> B.H.
>>
>> Hello. I'm running our backup archive on btrfs. We have MD-based RAID5
>> array with 4 6TB disks then LVM on top of it, and btrfs volume on the
>> LV (we don't use btrfs's own RAID features because we want RAID5 and as
>> far as i understand the support is only partial).

(I see people already helping with the primary issue so won't address 
that here.  However, addressing the above...)

FWIW... btrfs raid56 (5 and 6) support is now (from kernel 3.19) "code 
complete".  However, "code complete" is far from "stable and mature", and 
I (as a list regular but not a dev) have been recommending that people 
continue to hold off a few kernels until it has had some time to 
stabilize to more or less about the same point as btrfs itself is at, 
unless of course their purpose is actually to test the code with data 
they're prepared to lose, report bugs and help get them fixed, in which 
case, welcome aboard! =:^)

Of course btrfs itself isn't really mature or entirely stable yet, tho 
it's reasonable for ordinary use, provided the sysadmins' rule of backups 
is observed: (a) If it's not backed up, by definition the data is worth 
less to you than the time and media required to do the backups, despite 
any claims to the contrary, and (b) for purposes of this rule, a would-be 
backup that hasn't been tested restorable isn't yet a backup.

But back to raid56, my recommendation has been to wait at LEAST TWO 
kernel cycles, which would be the just released 4.1, and even then, 
consider it bleeding edge and be prepared to deal with bugs.  For 
stability comparable to btrfs in general, my recommendation is to wait at 
least a year, which happens to be about five kernel cycles, so until at 
least 4.4.  At that point, either check a few weeks of list traffic and 
decide for yourself based on that, or ask, but that's a reasonably 
educated guess.

Btrfs raid56 bottom line, 4.1 is the minimal 2 kernel cycles code 
maturity I suggested; if you're prepared to be bleeding edge, try it.  
Else wait the full year, kernel 4.4 or so.

(More below...)

>> I wanted to move the archive to another MD array of 4 8TB drives (this
>> time without LVM). So i did:
>>
>> btrfs replace start 1 /dev/md1 <mount_point>
>>
>> Where 1 is the only devid that was present and /dev/md1 is the new
>> array.

FWIW, I hadn't even considered the possibility of doing a replace from a 
single device.  I had thought it required raid mode.  But if it appeared 
to work...

>> The replace run successfully until finished after more than 5 days.
>> The system downloaded some fresh backups and created new snapshots
>> during the ongoing replace. I've go 2 kernel warnings about replace
>> task waiting for more than 120 seconds in the middle, but process
>> seamed to go on anyway.
>>
>> After the replace have finished i did btrfs fi resize 1:max
>> <mount_point> then unmounted and mounted again using the new drive.
>>
>> Then i've run a scrub on the FS - and got a lot of checksum errors.

Had you done a pre-replace scrub on the existing device?  If not, is the 
corruption actually new, or from before the replace and simply 
transferred?  You don't know.

Meanwhile, one reason not to particularly like the idea of btrfs over 
something like mdraid, is that btrfs is checksumming and operationally 
verifying, mdraid is not.  If btrfs reports an error, was it at the media 
level and which raid device if so, the raid level, the btrfs level, 
or ??  Tho for mdraid5/6 you can do a raid scrub, and hopefully detect 
and correct media and raid level errors, but you still don't have raid 
level checksum verification.  And with multiple terabyte drives that's 
definitely going to take awhile!

With btrfs raid1/10 there will be a second, hopefully checksum-valid, 
copy, to use and rebuild from.  And btrfs raid56 should be able to 
reconstruct a hopefully valid checksum from parity, tho of course at its 
maturity level one can't yet assume it's entirely bug-free.

(Again, as I observed above the problem resolution is occurring on 
another subthread, so I'll leave this at the above.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


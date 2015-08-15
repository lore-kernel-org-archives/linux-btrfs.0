Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44761 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbHOFLH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Aug 2015 01:11:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZQTkE-0006Se-Ql
	for linux-btrfs@vger.kernel.org; Sat, 15 Aug 2015 07:11:02 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 07:11:02 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Aug 2015 07:11:02 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Deleted files cause btrfs-send to fail
Date: Sat, 15 Aug 2015 05:10:57 +0000 (UTC)
Message-ID: <pan$8c3e$358182b2$bcc0178b$ca1ab807@cox.net>
References: <20150813003419.09f13c1a@thetick>
	<20150813090541.77f5c821@thetick>
	<pan$1dd35$9501221a$dce0e6ab$9d04fcea@cox.net>
	<20150813105458.676c884a@thetick> <20150814233737.5403f9fe@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Fri, 14 Aug 2015 23:37:37 +0200 as excerpted:

> (One other thing I found interesting was that "btrfs scrub" didn't care
> about the link count errors.)

A lot of people are confused about exactly what btrfs scrub does, and 
expect it to detect and possibly fix stuff it has nothing to do with.  
It's *not* an fsck.

Scrub does one very useful, but limited, thing.  It systematically 
verifies that the computed checksums for all data and metadata covered by 
checksums match the corresponding recorded checksums.  For dup/raid1/
raid10 modes, if there's a match failure, it will look up the other copy 
and see if it matches, replacing the invalid block with a new copy of the 
other one, assuming it's valid.  For raid56 modes, it attempts to compute 
the valid copy from parity and, again assuming a match after doing so, 
does the replace.  If a valid copy cannot be found or computed, either 
because it's damaged too or because there's no second copy or parity to 
fall back on (single and raid0 modes), then scrub will detect but cannot 
correct the error.

In routine usage, btrfs automatically does the same thing if it happens 
to come across checksum errors in its normal IO stream, but it has to 
come across them first.  Scrub's benefit is that it systematically 
verifies (and corrects errors where it can) checksums on the entire 
filesystem, not just the parts that happen to appear in the normal IO 
stream.

Such checksum errors can be for a few reasons...

I have one ssd that's gradually failing and returns checksum errors 
fairly regularly.  Were I using a normal filesystem I'd have had to 
replace it some time ago.  But with btrfs in raid1 mode and regular 
scrubs (and backups, should they be needed; sometimes I let them get a 
bit stale, but I do have them and am prepared to live with the stale 
restored data if I have to), I've been able to keep using the failing 
device.  When the scrubs hit errors and btrfs does the rewrite from the 
good copy, a block relocation on the failing device is triggered as well, 
with the bad block taken out of service and a new one from the set of 
spares all modern devices have takes its place.  Currently, smartctl -A 
reports 904 reallocated sectors raw value, with a standardized value of 
92.  Before the first reallocated sector, the standardized value was 253, 
perfect.  With the first reallocated sector, it immediately dropped to 
100, apparently the rounded percentage of spare sectors left.  It has 
gradually dropped since then to its current 92, with a threshold value of 
36.  So while it's gradually failing, there's still plenty of spare 
sectors left.  Normally I would have replaced the device even so, but 
I've never actually had the opportunity to actually watch a slow failure 
continue to get worse over time, and now that I do I'm a bit curious how 
things will go, so I'm just letting it happen, tho I do have a 
replacement device already purchased and ready, when the time comes. 

So real media failure, bitrot, is one reason for bad checksums.  The data 
read back from the device simply isn't the same data that was stored to 
it, and the checksum fails as a result.

Of course bad connector cables or storage chipset firmware or hardware is 
another "hardware" cause.

Sudden reboot or power loss, with data being actively written and one 
copy either already updated or not yet touched, while the other is 
actually being written at the time of the crash so the write isn't 
completed, is yet another reason for checksum failure.  This one is 
actually why a scrub can appear to do so much more than it does, because 
where there's a second copy (or parity) of the data available, scrub can 
use it to recover the partially written copy (which being partially 
written fails its checksum verification) to either the completed write 
state, if the other copy was already written, or the pre-write state, if 
the other copy hadn't been written at all, yet.  In this way the result 
is often the same one an fsck would normally produce, detecting and 
fixing the error, but the mechanism is entirely different -- it only 
detected and fixed the error because the checksum was bad and it had a 
good copy it could replace it with, not because it had any smarts about 
how the filesystem actually worked, and could actually tell what the 
error was and correct it by actually correcting it.


Meanwhile, in your case the problem was an actual btrfs logic bug -- it 
didn't track the inode ref-counts correctly, and didn't remove the inode 
when the last reference to it was deleted, because it still thought there 
were more references.  So the metadata actually written to storage was 
incorrect due to the logic flaw, but the checksum covering it was indeed 
the correct checksum for that metadata, as wrong as the metadata actually 
happened to be.  So scrub couldn't detect the error, because it was an 
error not in checksum, which was computed correctly over the metadata, 
but in the logic of the metadata itself as it was written.  Scrub 
therefore had nothing to do with that error and was in fact totally 
oblivious to the fact that the valid checksum covered flawed data in the 
first place.  Only a tool that could follow the actual logic, send in 
this case, since it has to follow the logic in ordered to properly send 
it, could detect the error, and only btrfs check knew enough about the 
logic to both detect the problem and correct it -- tho even then, it 
couldn't totally fix it, as part of the metadata was irretrievably 
missing, so it simply dropped what it could retrieve in lost-and-found.


That should make the answer to the question of why scrub couldn't detect 
and fix the problem clearer -- scrub only detects and possibly fixes a 
very specific problem. checksum verification failure, and that's not the 
problem you had.  As far as scrub was concerned, the checksums were fine, 
and that's all it knows about, so to it, the data and metadata were fine.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44991 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbKHUjT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 Nov 2015 15:39:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZvWk9-0006yK-6B
	for linux-btrfs@vger.kernel.org; Sun, 08 Nov 2015 21:39:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2015 21:39:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2015 21:39:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: strange "No space left on device"
Date: Sun, 8 Nov 2015 20:39:09 +0000 (UTC)
Message-ID: <pan$1751c$67da8858$62f444f5$4f9a54fc@cox.net>
References: <1446938562.7297.7.camel@scientia.net>
	<CAPmG0jb_ynq6qnxf-bysNaLut+5SOGqHrizLMaMN-1o6r2SZwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Sun, 08 Nov 2015 19:18:19 +0100 as excerpted:

> [...]
>>    3     3145728     4194303   512.0 MiB   8300  Linux filesystem
> [...]
>> root@heisenberg:~# mkfs.btrfs --nodiscard --label boot-data /dev/sdb3
>> btrfs-progs v4.2.2 See http://btrfs.wiki.kernel.org for more
>> information.
>>
>> Label:              boot-data
>> UUID:               b1c1fc77-c965-4f0c-a2b5-44a301fd8772
>> Node size:          16384
>> Sector size:        4096
>> Filesystem size:    1.00GiB
>> Block group profiles:
>>   Data:             single            8.00MiB
>>   Metadata:         DUP              59.19MiB
>>   System:           DUP              12.00MiB
>> SSD detected:       no
>> Incompat features:  extref, skinny-metadata
>> Number of devices:  1 Devices:
>>    ID        SIZE  PATH
>>     1     1.00GiB  /dev/sdb3
> 
> Somehow your mkfs.btrfs (or some other part of the system) assumed the
> wrong size for partition 3. To me, that sounds like a possible cause of
> the errors and 'EiB' reported size.

Wow, yes!  Good catch, Henk! =:^)  Hugo obviously didn't catch it, and I 
wouldn't have either, as the bad size detection behavior is so 
unexpected, it just wouldn't occur to me to look!

Something's clearly wrong, and as it could clearly either overwrite the 
next partition(s) if the partitioning detection is at fault and doesn't 
stop it, or throw all sorts of monkey wrenches into btrfs behavior if it 
does, this is rather alarming behavior indeed!  Clearly we need devs to 
take a look and figure out what bugged out, and how to fix it.

That potentially explains why you got separate data/metadata instead of 
mixed mode, and why it worked most of the time but failed occasionally, 
since presumably when it worked the size detection worked as well.

(Apparently, btrfs-progs-4.3 does away with the default to mixed-mode at 
1 GiB or under, tho it is still recommended.  I'm not exactly sure of 
why, tho I think it had to do with being able to use sub-GiB btrfs for 
testing without having to worry about mixed mode.  Still, one would 
think, since it's recommended, that they'd simply provide an option to 
make it split mode, instead of changing the default to something that's 
not recommended.  So from 4.3 userspace you'd have to specifically set 
mixed, but you're on 4.2.2 userspace, so that shouldn't be the case yet.  
And in any case that doesn't explain the very badly detected size and an 
attempt to create a 1 GiB btrfs on a 1/2 GiB partition, which is 
obviously the real problem, regardless of whatever layer it occurred in.)

Meanwhile, btrfs fi usage doesn't understand mixed-mode yet, and returns 
8 EiB for some values if it is used, which is originally what I thought 
was happening.  But the problem is elsewhere, as it wasn't mixed mode, 
but rather, a very /very/ screwed up size detection.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


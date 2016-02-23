Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55012 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbcBWXXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 18:23:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aYMIN-00053n-B8
	for linux-btrfs@vger.kernel.org; Wed, 24 Feb 2016 00:23:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 00:23:07 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 00:23:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Documentation for BTRFS error (device dev): bdev /dev/xx errs:
 wr 22, rd 0, flush 0, corrupt 0, gen 0
Date: Tue, 23 Feb 2016 23:22:47 +0000 (UTC)
Message-ID: <pan$84c48$1f5c952c$5c23be23$5799c3a@cox.net>
References: <20160223215911.GA13811@merlins.org>
	<pan$1ce2f$38765775$42544d39$1c9fd0a5@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Tue, 23 Feb 2016 23:17:06 +0000 as excerpted:

> Marc MERLIN posted on Tue, 23 Feb 2016 13:59:11 -0800 as excerpted:
> 
>> I have a freshly created md5 array, with drives that I specifically
>> scanned one by one block by block, and for good measure, I also scanned
>> the entire software raid with a check command which took 3 days to run.
>> 
>> Everything passed.
>> 
>> Then, I made a bcache of that device, an ssd that seems to work fine
>> otherwise (brand new), and dmcrypted the result
>> 
>> md5 - bache - dmcrypt - btrfs ssd /
>> 
>> Now, I'm copying data over with btrfs send, and I'm seeing these slowly
>> show up and the write counter go up one by one.
>> BTRFS error (device dm-7): bdev /dev/mapper/oldds1 errs: wr 17, rd 0,
>> flush 0, corrupt 0, gen 0
>> 
>> Where is the documentation for those counters?
>> Is the write error fatal, or a recovered error?
>> Should I consider that my filesystem is corrupted as soon as any of
>> those counters go up?
>> (I couldn't find an exact meaning of each of them)
> 
> I believe all formal documentation of what the error counters actually
> mean is developer-level -- "Trust the Source, Luke."

Forgot to mention, tho you're probably already considering it, if this is 
the same raid5-backed btrfs you were complaining about being slow in the 
other thread, and considering redoing with bcache to an ssd added, as 
seems very likely, if it /is/ actually storage device or bus errors, that 
could be one reason the previous one was getting so slow...  Maybe it 
wasn't btrfs after all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


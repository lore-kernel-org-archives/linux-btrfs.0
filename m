Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47370 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932828AbcECPJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 11:09:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1axbwr-0002kK-1k
	for linux-btrfs@vger.kernel.org; Tue, 03 May 2016 17:09:17 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 17:09:17 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 17:09:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
Date: Tue, 3 May 2016 15:09:07 +0000 (UTC)
Message-ID: <pan$91ed1$9e1cfbb6$39479d0e$5d5c9013@cox.net>
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
	<pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
	<13265330-f402-8c50-4bb0-5ae41d3ca8cb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 02 May 2016 09:13:41 -0400 as
excerpted:

>> Direct from that section of my /etc/sysctl.conf:
>>
>>
>> # write-cache, foreground/background flushing 
>> # vm.dirty_ratio = 10 (% of RAM)
>> # make it 3% of 16G ~ half a gig 
>> vm.dirty_ratio = 3 
>> # vm.dirty_bytes = 0
>>
>> # vm.dirty_background_ratio = 5 (% of RAM)
>> # make it 1% of 16G ~ 160 M
>> vm.dirty_background_ratio = 1
>> # vm.dirty_background_bytes = 0
>>
>> The commented values are normal defaults.  Either ratio, percentage of
>> RAM, or direct bytes can be set.  Setting one clears (zeros) the other.
>>  While the ratio isn't of total RAM but of available RAM, total RAM's a
>> reasonable approximation on most modern systems.
>>
>> Taking the foreground, vm.dirty_ratio setting first:
>> [I] set that to 3%, which with 16 gigs of RAM is ~half a gig, or about
>> 16 seconds worth of writeback at 30 MB/sec.  That's only about half the
>> 30 second time expiry and isn't /too/ bad to wait, tho you'll probably
>> notice if it takes that full 16 seconds.  But it's reasonable, and
>> given the integer setting and that we want background set lower, 3% is
>> getting about as low as practical.  (Obviously if I upped to 32 GiB
>> RAM, I'd want to switch to the bytes setting for this very reason.)
>>
>> The background vm.dirty_background_ratio setting is where the lower
>> priority background writeback kicks in, so with luck the higher
>> priority foreground limit is never reached, tho it obviously will be
>> for something doing a lot of writing, like rsync often will.  So this
>> should be lower than foreground.
>>
>> With foreground set to 3%, that doesn't leave much room for background,
>> but 1% is still reasonable.  That's about 160 MB or 5 seconds worth of
>> writeback at 30 MB/sec, so it's reasonable.

> I think you've got things a bit confused here (at least, what you are
> saying doesn't match the documentation, and also doesn't match my
> (limited) understanding of the code).  The background values are
> system-wide values, while the unlabeled ones (what you call foreground)
> are per-process.  IOW, the background value provides an upper bound for
> the whole system, while the foreground ones provide an upper bound for
> each individual process.  As a result, it is actually somewhat
> nonsensical to use a background value that is lower than the foreground
> value unless you don't want to limit things per-process as well as
> system wide.

Why is the background value lower (5% background compared to 10% 
unlabeled/foreground) by default, then?

AFAIK, you're partially but not entirely correct.  The values are both 
global, and it's the kernel via the various block and filesystem drivers 
(well, except for fuse, etc, in userspace) that's actually doing the 
writing.  Where processes come into the picture with the unlabeled/
foreground value is that above that value, the kernel charges writes to 
the processes dirtying even more memory, effectively throttling them as 
more of their timeslice is spent by the kernel writing stuff out, leaving 
less of it to actually dirty even more cache pages, until a process can't 
dirty memory any faster than that memory can be written to backing store.

So while writeback with dirty memory above the unlabeled/foreground value 
is indeed happening in process context, because the kernel is charging 
write time to individual processes at that point (the part you got 
right), the value is still global and it's still actually the kernel 
doing the writing -- it's just charging the process for it at that point, 
whereas when the dirty memory drops below the unlabeled/foreground value, 
processes don't get penalized for dirtying memory -- handling the dirty 
memory is then simply a service provided by the kernel with no penalty in 
terms of process timeslice.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60123 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbaBRWyq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 17:54:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WFtYr-0000KE-4l
	for linux-btrfs@vger.kernel.org; Tue, 18 Feb 2014 23:54:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 23:54:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 23:54:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Read i/o errs and disk replacement
Date: Tue, 18 Feb 2014 22:54:18 +0000 (UTC)
Message-ID: <pan$7318b$591fdc9$be7ce577$8412a779@cox.net>
References: <8051054.BLVnDBVVi7@fuckup>
	<4122CB7E-0AF1-4808-9FF6-91E875D6E1E9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 18 Feb 2014 11:48:49 -0700 as excerpted:

>> This is not btrfs' fault but due to an hd error. I saw in the system
>> logs
>>    btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
>> and a subsequent check on btrfs showed
>>    [/dev/sdb].write_io_errs   0 [/dev/sdb].read_io_errs    2
>>    [/dev/sdb].flush_io_errs   0 [/dev/sdb].corruption_errs 0
>>    [/dev/sdb].generation_errs 0
>> 
>> So, I have a read error on sdb.
>>

It's worth noting that those errors don't reset automatically at boot or 
whatever.  The idea is to give a sysadmin some idea how many errors have 
happened in the filesystem's lifetime or since the last manual reset.  So 
as long as the number of errors isn't increasing at each boot, it's 
probably a historical and long since corrected error.


btrfs device stats -z

can be used to reset to zero if desired.  See the btrfs (8) manpage.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


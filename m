Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49908 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaJaB1T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 21:27:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xk0zk-0007Wn-Gb
	for linux-btrfs@vger.kernel.org; Fri, 31 Oct 2014 02:27:16 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Oct 2014 02:27:16 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Oct 2014 02:27:16 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID1 fails to recover chunk tree
Date: Fri, 31 Oct 2014 01:27:03 +0000 (UTC)
Message-ID: <pan$2cd78$85acd913$95d42126$8a9a4137@cox.net>
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com>
	<54517338.7090606@pobox.com> <54523D86.5040906@gmail.com>
	<58060F93-3CB7-4575-9AF7-59DAF895CE7B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 30 Oct 2014 12:04:48 -0600 as excerpted:

>> Rob, That second drive was immediately put to use elsewhere. I figured
>> having only the metadata on that drive, it wouldn't matter. The data
>> stayed single and wasn't part of the second drive, only the metadata
>> was. I must not be capable of understanding why that wouldn't work.
> 
> single profile means all devices get btrfs chunks. If you do something
> like:
> 
> # mkfs.btfs /dev/sda
> 
> By default you get data profile = single, and metadata profile = DUP. If
> you then
> 
> # btrfs add /dev/sdb /mnt/btrfs # btrfs -mconvert=raid1  /mnt/btrfs
> 
> you now have a volume that is data = single and metadata = raid1. The 
way
> the allocator works is that it will first allocate 1GiB data chunks to 
the
> device with the most free space remaining, so if that's /dev/sdb it will
> allocate 1GiB data chunks there until free space is the same for both 
sda
> and sdb. And once they have equal space btrfs allocates 1GiB data chunks
> alternating sda and sdb.
> 
> Single profile doesn't mean only one device gets data chunks. Is that 
the
> misunderstanding?

Just what I was going to say.

Single profile means there's just one copy, and the normal chunk 
allocation algorithm allocates new chunks from the device with the most 
space left.  The freshly added device almost certainly had the most space 
left, so as soon as the existing data chunk was full, probably all new 
data chunks were allocated from the freshly added device.

Then you (OP) go and kill that device as far as btrfs is concerned, and 
all that new data written to it in single mode is ONLY on it because it 
was written in single mode, so now it has suddenly disappeared!

No WONDER that filesystem's having problems!

Even old files, due to copy on write, would have likely been partially or 
entirely moved to the new chunks on the new device if they were updated 
during the time the filesystem was mounted writable with the new device 
there.  And some desktop environments, for instance, have a habit of 
rewriting what might well be the exact same thing back to their config 
files, every time they shutdown, or sometimes as soon as they read it in 
at startup, as well.  So much of your desktop config may well have been 
on that second device, even if you didn't actively change any config 
during that time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46112 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422665AbaJaCJ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 22:09:59 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:57667 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xk1f4-0031ZA-Du
	for linux-btrfs@vger.kernel.org; Thu, 30 Oct 2014 20:09:58 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RAID1 fails to recover chunk tree
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$2cd78$85acd913$95d42126$8a9a4137@cox.net>
Date: Thu, 30 Oct 2014 20:09:55 -0600
Message-Id: <FC480E52-012E-41E7-902E-2EE3ECFFB90B@colorremedies.com>
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com> <54517338.7090606@pobox.com> <54523D86.5040906@gmail.com> <58060F93-3CB7-4575-9AF7-59DAF895CE7B@colorremedies.com> <pan$2cd78$85acd913$95d42126$8a9a4137@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 30, 2014, at 7:27 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Chris Murphy posted on Thu, 30 Oct 2014 12:04:48 -0600 as excerpted:
> 
>>> Rob, That second drive was immediately put to use elsewhere. I figured
>>> having only the metadata on that drive, it wouldn't matter. The data
>>> stayed single and wasn't part of the second drive, only the metadata
>>> was. I must not be capable of understanding why that wouldn't work.
>> 
>> single profile means all devices get btrfs chunks. If you do something
>> like:
>> 
>> # mkfs.btfs /dev/sda
>> 
>> By default you get data profile = single, and metadata profile = DUP. If
>> you then
>> 
>> # btrfs add /dev/sdb /mnt/btrfs # btrfs -mconvert=raid1 /mnt/btrfs

          ^device


> 
> Then you (OP) go and kill that device as far as btrfs is concerned, and 
> all that new data written to it in single mode is ONLY on it because it 
> was written in single mode, so now it has suddenly disappeared!
> 
> No WONDER that filesystem's having problems!

So what *is* possible in this case is still mount -o degraded,ro and try to extract what he can from the remaining device. 
> 
> Even old files, due to copy on write, would have likely been partially or 
> entirely moved to the new chunks on the new device if they were updated 
> during the time the filesystem was mounted writable with the new device 
> there.  And some desktop environments, for instance, have a habit of 
> rewriting what might well be the exact same thing back to their config 
> files, every time they shutdown, or sometimes as soon as they read it in 
> at startup, as well.  So much of your desktop config may well have been 
> on that second device, even if you didn't actively change any config 
> during that time.

Is hard to say. If a balance hasn't recently been done, the original device may have a good amount of free space in allocated chunks. I'm pretty sure Btrfs will write first to already allocated chunks with free space before allocating new chunks? So a bunch of stuff could actually still be on the original device - it just needs -o degraded,ro to get access to it. And if the current version of the file isn't retrievable because all or part of it's on the other drive, it'll just cause an error to occur. I think rsync and the like can be set to not fail on such errors, so anything that can be retrieved, is.


Chris Murphy
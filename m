Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56094 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932927AbaDVRmL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 13:42:11 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:58482 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wcehu-002Zwe-Lx
	for linux-btrfs@vger.kernel.org; Tue, 22 Apr 2014 11:42:10 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size Drives
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$ced8d$1ee3475f$a3c53cfd$a3dfb247@cox.net>
Date: Tue, 22 Apr 2014 11:42:09 -0600
Message-Id: <BDB8ED64-0A92-4C22-A07D-C06D790410ED@colorremedies.com>
References: <53540367.4050707@aeb.io> <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com> <5354A4EA.3000209@aeb.io> <pan$ced8d$1ee3475f$a3c53cfd$a3dfb247@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 21, 2014, at 3:09 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Adam Brenner posted on Sun, 20 Apr 2014 21:56:10 -0700 as excerpted:
> 
>> So ... BTRFS at this point in time, does not actually "stripe" the data
>> across N number of devices/blocks for aggregated performance increase
>> (both read and write)?
> 
> What Chris says is correct, but just in case it's unclear as written, let 
> me try a reworded version, perhaps addressing a few uncaught details in 
> the process.

Another likely problem is terminology. It's 2014 and still we don't have consistency in basic RAID terminology. We're functionally in the 19th century uncoordinated disagreement of weights and measures, except maybe worse because we sometimes have multiple words that mean the same thing; as if there were multiple words for the term gram or meter. It's just nonsensical and selfish that this continues to persist across various file system projects.

It's not immediately obvious to the btrfs newcomer that the md raid chunk isn't the same thing as the btrfs chunk, for example.

And strip, chunk, stripe unit, and stripe size get used interchangeably to mean the same thing, while just as often stripe size means something different. The best definition I've found so far is IBM's stripe unit definition: "granularity at which data is stored on one drive of the array before subsequent data is stored on the next drive of the array" which is in bytes. So that's the smallest raid unit we find on a drive, therefore it is a base unit in RAID, and yet we have no agreement on what word to use.

And it's not really like the storage industry trade association, SNIA, who published a dictionary of terms in 2013, really helps in this area. I'll argue they make it worse because they deprecate the term chunk, in favor of the terms strip and stripe element. NO kidding, two terms mean the same thing. Yet strip and stripe are NOT the same thing.

strip = stripe element
stripe = set of strips
strip size = stripe depth
stripe size = strip size * extents not including parity extents

Also the units are in blocks (sectors, not fs blocks and not bytes). The terms stripe unit, stripe width, and stride aren't found in the SNIA dictionary at all although they are found as terms in other file system projects.

So no matter how we look at it, everyone else is doing it wrong.



Chris Murphy
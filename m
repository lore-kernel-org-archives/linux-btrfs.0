Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34150 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751490AbaANVhu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:37:50 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55126 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3BgC-000TT7-EA
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 14:37:48 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140115031927.4fd1d44b@natsu>
Date: Tue, 14 Jan 2014 14:37:46 -0700
Message-Id: <6F3D91C0-8CCA-4713-BFEC-244E3D65F306@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com> <20140115013703.33bb2799@natsu> <1207CF09-B2A4-4DB6-9CA8-C3C78C1DA0F3@colorremedies.com> <20140115031927.4fd1d44b@natsu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2014, at 2:19 PM, Roman Mamedov <rm@romanrm.net> wrote:

> On Tue, 14 Jan 2014 14:05:11 -0700
> Chris Murphy <lists@colorremedies.com> wrote:
> 
>> 
>> On Jan 14, 2014, at 12:37 PM, Roman Mamedov <rm@romanrm.net> wrote:
>>> 
>>> I vaguely remember having some drives that were not able to remap a single
>>> block on write, but doing that successfully if I overwrote a sizable area
>>> around (and including) that block, or overwrite the whole drive. And after
>>> that they worked without issue not exhibiting further bad blocks.
>> 
>> Presumably the SMART self-assessment for this drive was FAIL? 
> 
> No of course not, why?

Reserve sectors are fundamental to ECC. If there are no more reserves, the status should be a failed drive, it can no longer do its own relocation of data experiencing transient read errors in this case.

> SMART goes to FAIL only if one of the attributes falls
> below threshold, in this case that would be Reallocated Sector Count having
> too much sectors. But nope, it either had zero, or in single-digit numbers.

It sounds like we aren't talking about the same thing. I'm considering persistent write failure as a result of no more reserve sectors being available.

> I don't ever remember seeing a SMART FAIL drive that would function in any
> usual sense of that word.

Oh I have. For a week a drive was reporting failure imminent before we got around to replacing it. It hadn't actually failed at that time still.


>> And if so what's the point of the work around when we only have a pass/fail
>> level granularity for drive health?
> 
> Not sure what you're referring to here. As said above, the FAIL/PASS status is
> largely useless, and the more important indicators are the values and dynamics
> in Reallocated sector count, Current pending sectors, Reported uncorrectable,
> etc.

Well, not totally useless, if it flags the user with an hour's notice in Gnome, they can do some minimal backup. I've seen that happen on OS X Server (client doesn't produce SMART warnings in user space).


> 
>> a way to send a command to the firmware to persistently increase the reserve
>> sectors at the expensive of available space - in effect it reduces the LBA
>> count by e.g. 10MB, thereby increasing the reserve pool by 10MB.
> 
> Yes please that, and also a pony. :)

That seems a lot easier to implement than anything else being discussed. 

Chris Murphy


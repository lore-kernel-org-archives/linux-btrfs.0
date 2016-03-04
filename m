Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54227 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbcCDMb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 07:31:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abotd-0002wi-QL
	for linux-btrfs@vger.kernel.org; Fri, 04 Mar 2016 13:31:53 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 13:31:53 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 13:31:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Date: Fri, 4 Mar 2016 12:31:44 +0000 (UTC)
Message-ID: <pan$a7a0b$d1f1da3$f3b73157$2f7e8e17@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<pan$1a785$dbfe4789$bdc8f4d5$778788dd@cox.net>
	<CAOE4rSw_+PQEjAiHJkk03ec=J3ti9t9VCOD-zJSi=rP4dPnsjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dāvis Mosāns posted on Thu, 03 Mar 2016 17:39:12 +0200 as excerpted:

> 2016-03-03 6:57 GMT+02:00 Duncan <1i5t5.duncan@cox.net>:
>>
>> You're issue isn't the same, because all your space was allocated,
>> leaving only 1 MiB unallocated, which isn't normally enough to allocate
>> a new chunk to rewrite the data or metadata from the old chunks into.
>>
>> That's a known issue, with known workarounds as dealt with in the FAQ.
>>
>>
> Ah, thanks, well it was surprising for me that balance failed with out
> of space when both data and metadata had not all been used and I thought
> it could just use space from those...
> 
> especially as from FAQ:
>> If there is a lot of allocated but unused data or metadata chunks,
>> a balance may reclaim some of that allocated space. This is the main
>> reason for running a balance on a single-device filesystem.
> 
> so I think regular balance should be smart enough that it could solve
> this on own and wouldn't need to specify any options.

Well it does solve the problem on its own... to the extent that it 
eliminates empty chunks (kernel 3.17+, it didn't before that).  But if 
there's even a single 4 KiB file block used in the (nominal 1 GiB sized 
data) chunk, it's no longer empty and thus not eliminated by the empty 
chunk cleanup routines.

Additionally, balance, which was originally called the restriper, by 
definition, must have enough space to create at least one empty chunk in 
ordered to copy the data from existing chunks into, such that it can 
consolidate that data into fewer new chunks when the old ones were partly 
empty.  If there's not enough unallocated space left to write even one 
chunk, balance can't do its thing, because there's nowhere to create the 
new chunk it needs to be able to copy over the data from the old chunk.

With nominal 1 GiB data chunk size (up to 10 GiB in some instances if the 
filesystem is large enough), that means you need at least 1 GiB of free 
unallocated space in ordered to have room to create that single chunk 
that starts the rewrite process off.  Without it, you're stuck, tho there 
are workarounds like trying to balance the smaller (256 MiB nominal) 
metadata chunks first, hoping that frees the minimum 1 GiB space needed 
for a data chunk, or temporarily adding another device a few GiB in size 
to the filesystem, to give it somewhere to write the new chunk to so it 
can start off the rewrite and shrinking process.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


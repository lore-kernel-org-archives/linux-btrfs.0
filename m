Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33284 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaJXBFw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 21:05:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XhTKA-0001tv-W3
	for linux-btrfs@vger.kernel.org; Fri, 24 Oct 2014 03:05:51 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 03:05:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 03:05:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: device balance times
Date: Fri, 24 Oct 2014 01:05:39 +0000 (UTC)
Message-ID: <pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
	<5446BEC0.8070009@siedziba.pl>
	<02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
	<5447A5CF.9060405@siedziba.pl> <5448C81E.4060701@cn.fujitsu.com>
	<5448E8F0.7070004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 23 Oct 2014 07:39:28 -0400 as
excerpted:

> On 2014-10-23 05:19, Miao Xie wrote:
>>
>> Now my colleague and I is implementing the scrub/replace for RAID5/6
>> and I have a plan to reimplement the balance and split it off from the
>> metadata/file data process. the main idea is
>> - allocate a new chunk which has the same size as the relocated one,
>>   but don't insert it into the block group list, so we don't allocate
>>   the free space from it.
>> - set the source chunk to be Read-only
>> - copy the data from the source chunk to the new chunk
>> - replace the extent map of the source chunk with the one of the new
>>   chunk(The new chunk has the same logical address and the length as
>>   the old one)
>> - release the source chunk
>>
>> By this way, we needn't deal the data one extent by one extent, and
>> needn't do any space reservation, so the speed will be very fast even
>> [if] we have lots of snapshots.
>>
> Even if balance gets re-implemented this way, we should still provide
> some way to consolidate the data from multiple partially full chunks.
> Maybe keep the old balance path and have some option (maybe call it
> aggressive?) that turns it on instead of the new code.

IMO:

* Keep normal default balance behavior as-is.

* Add two new options, --fast, and --aggressive.

* --aggressive behaves as today and is the normal default.

* --fast is the new chunk-by-chunk behavior.  This becomes the default if 
the convert filter is used, or if balance detects that it /is/ changing 
the mode, thus converting or filling in missing chunk copies, even when 
the convert filter was not specifically set.  Thus, if there's only one 
chunk copy (single or raid0 mode, or raid1/10 or dup with a missing/
invalid copy) and the balance would result in two copies, default to
--fast.  Similarly, if it's raid1/10 and switching to single/raid0, 
default to --fast.  If no conversion is being done, keep the normal
--aggressive default.

* Users could always specify the behavior they want, overriding the 
default, using the appropriate option.

* Of course defaults may result in some chunks being rebalanced in fast 
mode, while others are rebalanced in aggressive mode, if for instance 
it's 3+ device raid1 mode filesystem with one device missing, since in 
that case there'd be the usual two copies of some chunks and those would 
default to aggressive, while there'd be one copy of chunks where the 
other one was on the missing device.  However, users could always specify 
the desired behavior using the last point above, thus getting the same 
behavior for the entire balance.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


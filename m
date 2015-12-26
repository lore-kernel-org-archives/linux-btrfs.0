Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46527 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbbLZKrZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 05:47:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aCmNe-0007pU-E0
	for linux-btrfs@vger.kernel.org; Sat, 26 Dec 2015 11:47:22 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 11:47:22 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 11:47:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs problems on new file system
Date: Sat, 26 Dec 2015 10:47:17 +0000 (UTC)
Message-ID: <pan$a2c8c$6af1fa21$56a24ebc$40b50ca8@cox.net>
References: <16107.1451037790@ccs.covici.com>
	<CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com>
	<18552.1451078098@ccs.covici.com>
	<CAJCQCtTQ-73RbohA9wdrttj_uSnF5f8x1Opa0a6O2ZF-5NVqhQ@mail.gmail.com>
	<5117.1451114951@ccs.covici.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

covici posted on Sat, 26 Dec 2015 02:29:11 -0500 as excerpted:

> Chris Murphy <lists@colorremedies.com> wrote:
> 
>> If you can post the entire dmesg somewhere that'd be useful. MUAs tend
>> to wrap that text and make it unreadable on list. I think the problems
>> with your volume happened before the messages, but it's hard to say.
>> Also, a generation of nearly 5000 is not that new?
> 
> The file system was only a few days old.  It was on an lvm volume group
> which consisted of two ssd drives, so I am not sure what you are saying
> about lvm cache -- how could I do anything different?
> 
>> On another thread someone said you probably need to specify the device
>> to mount when using Btrfs and lvmcache? And the device to specify is
>> the combined HDD+SSD logical device, for lvmcache that's the "cache
>> LV", which is the OriginLV + CachePoolLV. If Btrfs decides to mount the
>> origin, it can result in corruption.
> 
> See above.

I think he mixed up two threads and thought you were running lvm-cache, 
not just regular lvm, which should be good unless you're exposing lvm 
snapshots and thus letting btrfs see multiple supposed UUIDs that aren't 
actually universal.  Since btrfs is multi-device and uses the UUID to 
track which devices belong to it (because they're _supposed_ to be 
universally unique, it's even in the _name_!), if it sees the same UUID 
it'll consider it part of the same filesystem, thus potentially causing 
corruption if it's a snapshot or something that's not actually supposed 
to be part of the (current) filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


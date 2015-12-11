Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:32836 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbbLKMdz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 07:33:55 -0500
Received: by mail-ig0-f170.google.com with SMTP id mv3so38744353igc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Dec 2015 04:33:54 -0800 (PST)
Subject: Re: Subvolume UUID, data corruption?
To: Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <20151204120529.37E47D5A28@emkei.cz>
 <20151204130758.GR8775@carfax.org.uk>
 <1449286104.18841.14.camel@scientia.net>
 <20151205120103.GA2376@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <566AC2AD.1030207@gmail.com>
Date: Fri, 11 Dec 2015 07:33:49 -0500
MIME-Version: 1.0
In-Reply-To: <20151205120103.GA2376@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-05 07:01, Hugo Mills wrote:
> On Sat, Dec 05, 2015 at 04:28:24AM +0100, Christoph Anton Mitterer wrote:
>> On Fri, 2015-12-04 at 13:07 +0000, Hugo Mills wrote:
>>> I don't think it'll cause problems.
>> Is there any guaranteed behaviour when btrfs encounters two filesystems
>> (i.e. not talking about the subvols now) with the same UUID?
>
>     Nothing guaranteed, but the likelihood is that things will go badly
> wrong, in the sense of corrupt filesystems.
>
>> Given that it's long standing behaviour that people could clone
>> filesystems (dd, etc.) and this just worked™, btrfs should at least
>> handle such case gracefully.
>> For example, when already more than one block device with a btrfs of
>> the same UUID are known, then it should refuse to mount any of them.
>> And if one is already known and another device pops up it should refuse
>> to mount that and continue to normally use the already mounted one.
>
>     Except that that's exactly the mechanism that btrfs uses to handle
> multi-device filesystems, so you've just broken anything with more
> than one device in the FS.
>
>     If you inspect the devid on each device as well, and refuse
> duplicates of those, you've just broken any multipathing
> configurations.
This already potentially breaks multipath configurations, as well as 
dm-cache, some soft raid configurations, and probably other things as well.
>
>     Even if you can handle that, if you have two copies of dev1, and
> two copies of dev2, how do you guarantee that the "right" pair of dev1
> and dev2 is selected? (e.g. if you have them as network devices, and
> the device enumeration order is unstable on each boot).
In some cases it can be done without much effort.  Take dm-cache for 
example.  The hierarchy of devices in a dm-cache device looks like this:
cached-device
+ backing-device
+ cache-pool
   + pool-storage
   + pool-metadata

At a minimum, the cached device and the backing device contain identical 
data (the cached-device just has a writeback or writethrough cache on 
it), and the pool storage device may under some circumstances look like 
a BTRFS filesystem as well.  In this case, it's pretty obvious that the 
only device that BTRFS should be accessing is the cached device, not the 
backing device or the pool storage device.  For this, if we simply 
blacklist all devices that are themselves components in device-mapper 
tables, then we avoid the issue here, and possibly in some other as of 
yet undiscovered cases.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48330 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbcHTGwV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 02:52:21 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bb08g-0003zA-6S
        for linux-btrfs@vger.kernel.org; Sat, 20 Aug 2016 08:52:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
Date: Sat, 20 Aug 2016 06:52:10 +0000 (UTC)
Message-ID: <pan$5e14a$65553781$21ea4bb9$dc874b@cox.net>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bearcat Şándor posted on Fri, 19 Aug 2016 22:00:17 -0600 as excerpted:

> I have a btrfs non-raid file system that i'd like to convert to raid10.
> This single device has my efi boot partion on it, so it's partitioned
> into sda1 and sda2. I have 3 other discs (sdc-sde) that i'd like to make
> partition-less systems and then add them to the first disc (sda) using
> the steps in the conversion section of the wiki
> (https://btrfs.wiki.kernel.org/index.php/
Using_Btrfs_with_Multiple_Devices#Conversion).
> 
> My concern in that i'll be mixing a partitioned and partition-less
> system.  Will that work or will i hose myself?

It should work fine as far as btrfs is concerned.

Since you mentioned raid10, however, it's worth noting a difference 
between btrfs raid10 and conventional raid10 that takes some people by 
surprise, tho I don't know whether it'll be a factor for you or not.  
Btrfs raid is per-chunk, not per-device, and different chunks can be 
assigned differently.  What that tends to mean in practice is that while 
with conventional raid10 you can lose a second device without loss of 
data as long as it's from the other raid1 underneath the raid0, with 
btrfs raid10, losing a second device is likely to lose data, because with 
the per-chunk assignment, it's relatively likely that the two bad devices 
will contain both copies of the data for at least some chunks.  So with 
btrfs raid10, don't expect to be able to lose more than one device 
without data-loss, no matter /which/ devices they are.

One way around that, that still retains the checksum error correction 
features of btrfs raid1/10, is to put btrfs raid1 on top of a pair of md/
dmraid0s.  That's normally considered a raid01 instead of a raid10 and is 
discouraged as it makes rebuild more difficult, but btrfs' checksummed 
data error detection and with raid1/10, correction from the remaining 
good copy, makes it worth doing anyway.   And that way you can for 
instance put one of the underlying raid0s in one data cabinet and the 
other in another, and lose the connection to everything in the one, 
without loss of data as raid0 on the other leg of the btrfs raid1 will 
still be operating.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


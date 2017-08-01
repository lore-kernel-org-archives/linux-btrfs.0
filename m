Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51339 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbdHABMj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 21:12:39 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dcLjZ-0006Xn-Cw
        for linux-btrfs@vger.kernel.org; Tue, 01 Aug 2017 03:12:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow mounting raid1
Date: Tue, 1 Aug 2017 01:12:19 +0000 (UTC)
Message-ID: <pan$1eb89$fa81c30b$fe750acd$9555f678@cox.net>
References: <20170731183047.x2p4vyqd2pvf7t4g@tiamat>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leonidas Spyropoulos posted on Mon, 31 Jul 2017 19:30:47 +0100 as
excerpted:

> Hello,
> 
> I got a raid1 setup of btrfs on a HDD array of 2 disks. The fstab has
> the following mount settings:
>   # cat /etc/fstab | grep raid1
>   UUID=c9db91e6-0ba8-4ae6-b471-8fd4ff7ee72d /media/raid1 btrfs
>   rw,relatime,compress=lzo,space_cache 0 0

If you're doing any snapshotting, you almost certainly want noatime, not 
the default relatime.  Even without snapshotting and regardless of the 
filesystem, tho on btrfs it's a bigger factor due to COW, noatime is a 
recommended performance optimization.

The biggest caveat with that is if you're running something that actually 
depends on atime.  Few if any modern applications depend on atime, with 
mutt in some configurations being an older application that still does.  
But AFAIK it only does in some configurations...

Tho I haven't the foggiest whether it'd affect your mount times...

(FWIW I have a number of pair-device btrfs raid1s, but I'm all-ssd these 
days and mounts seem to be fast enough here.)

> When I try to mount the array it's consistent about 5 seconds+
>   # time umount /media/raid1
>   
>   real    0m0.358s user    0m0.010s sys     0m0.010s # time mount
>   /media/raid1
>   
>   real    0m5.605s user    0m0.504s sys     0m0.071s
> 
> I have this setup for sometime now and from the time I made it the mount
> time went up (I notice that on boot). When I first build that was almost
> instant. In terms of maintenance I regularly run a scrub and rebalance
> every now and then.
> 
> Running kernel 4.11.12 (with -ck patchs)
> 
> Is there something I can do to speed it up (apart buying 2 SSDs :D ). I
> feel like I'm missing something as the usage of the raid is not really
> frequent - just backup mainly.

Is there anything suspect in dmesg during the mount?  What does smartctl 
say about the health of the devices?  (smartctl -AH at least, the selftest 
data is unlikely to be useful unless you actually run the selftests.)

To my awareness there's a few things that can affect mount speed, tho as 
I said I'm on ssd so I really don't know if 5 seconds for spinning rust 
is unusual or not, you'll need the experience of others on that.

1) Attempting to mount filesystems with many devices is of course 
slower.  But two devices shouldn't be a problem.

2) Sometimes a device might take awhile to "spin up" and initialize 
itself.  Since you're still on spinning rust, are the devices perhaps 
spinning down to save power, and the delay you see is them spinning back 
up?

SSDs may have a similar, tho generally shorter and for different reasons, 
delay.  SSDs often have a capacitor that charges up so they can finish a 
write and avoid corrupting themselves in the event of an unexpected power 
loss in the middle of a write.  A lower end device might allow the device 
to appear ready while the capacitor is still charging to avoid long power-
on response times, while higher end devices both tend to have higher 
capacity capacitors, and don't signify ready until they are sufficiently 
charged to avoid issues in "blink" situations where the power supply 
comes back on but isn't immediately steady and might go out again right 
away.

If a device takes too long and times out you'll see resets and the like 
in dmesg, but that normally starts at ~30 seconds, not the 5 seconds you 
mention.  Still, doesn't hurt to check.

3) If the space cache is damaged the mount may take longer, but btrfs 
will complain so you'll see it in dmesg.


[OT but quoting the signature]

> A: Because it messes up the order in which people normally read text.
> Q: Why is it such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing on usenet and in e-mail?

My sentiments exactly! (Well, except that HTML's even more annoying!) =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57356 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab3JGKit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 06:38:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VT8D9-0005UO-5T
	for linux-btrfs@vger.kernel.org; Mon, 07 Oct 2013 12:38:47 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 12:38:47 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2013 12:38:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs device delete problem
Date: Mon, 7 Oct 2013 10:38:27 +0000 (UTC)
Message-ID: <pan$c82c4$81d08e2c$7fe5940b$26a9f83b@cox.net>
References: <CAKZ=RP9a6A8ni-4s7WdUWfqUhhRHyFGFVkN42kmYOJqnu=4dyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alfredo Esteban posted on Sun, 06 Oct 2013 13:10:49 +0200 as excerpted:

> I'm getting an error when trying to delete a device from a raid1 (data
> and metadata mirrored).
> 
>> btrfs filesystem show
> failed to read /dev/sr0
> Label: none  uuid: 78b5162b-489e-4de1-a989-a47b91adef50
>     Total devices 2 FS bytes used 107.64GB
>     devid    2 size 149.05GB used 109.01GB path /dev/sdh1
>     devid    1 size 156.81GB used 109.03GB path /dev/sdb6
> 
> Btrfs v0.20-rc1
> 
>> btrfs device delete /dev/sdh1 /mnt/raid-data/
> ERROR: error removing the device '/dev/sdh1' - Inappropriate ioctl for
> device
> 
> Raid has been working fine for a long time. Both devices are present but
> /dev/sdh1 is a new empty btrfs partition at the moment.
> 
> I should like to know whether this is an error or "btrfs device delete"
> command is not the appropriate one. I just want to know how to delete
> sdh1 from raid, add a new partition and balance.
> 
> My kernel version is: 3.8.0-31

Two points in addition to what Chris Murphy said...

1)  Btrfs still has the experimental label and is still under heavy 
development.  Those choosing to run it are volunteering to test it as 
such.  As an experimental filesystem under heavy development, each new 
kernel brings fixes as well as new features, and running a current kernel 
is *STRONGLY* recommended, both because it'll have more bugs fixed, AND 
because if/when there IS a problem, the output and logs generated are 
going to be far more valuable if the kernel is current than if it's 
several kernels behind.

And several kernels behind is EXACTLY what 3.8 is.  The current stable 
kernel is 3.11.4, with 3.12-rc3 just out as well.  Why are you still back 
on 3.8?  Do you WANT trouble from already fixed bugs, and output that's 
not as valuable to the devs as that of a current kernel?  As a btrfs 
tester you should be no farther back then second stable series AT THE 
OLDEST (so 3.10 series, presently), and even that is old and of limited 
value.  Preferred is the latest stable series (3.11 at this point) or the 
development kernel (3.12-rc*).

Note that there are reasons people might be a bit conservative and want 
to run old kernels, but those reasons don't fit very well with being a 
tester of an experimental status filesystem such as btrfs.  If you have 
reason to be conservative and run and old kernel, and you might, you 
really should reconsider whether testing btrfs is appropriate for you or 
not, since running an experimental status filesystem is anything BUT 
conservative.

2) Btrfs raid modes won't allow you to reduce the number of devices below 
the minimum number necessary for undegraded use of that raid mode.  So 
raid1 and raid0 modes require two devices minimum, raid10 and the new 
raid6 modes require four devices minimum, and raid5 requires three 
minimum.  (Note that raid5/6 aren't considered ready for ordinary use 
yet.)

Since your btrfs in raid1 mode has two devices currently, you won't be 
able to delete one of them as-is.  You will need to ADD a device first 
(bringing the total to three devices), optionally do a balance, and THEN 
delete the failed/missing/to-be-removed device (bringing the total back 
to two, which you never go below that way).

This, among other things, is covered on the btrfs wiki.  If you've not 
read it recently, you're probably missing other useful hints and 
information that it covers too, and I'd recommend spending some time 
reading it.

https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


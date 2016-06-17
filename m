Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51551 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbcFQGZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 02:25:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bDnDq-0007Kr-6V
	for linux-btrfs@vger.kernel.org; Fri, 17 Jun 2016 08:25:42 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 08:25:42 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 08:25:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
Date: Fri, 17 Jun 2016 06:25:37 +0000 (UTC)
Message-ID: <pan$3594e$4c401d86$d4f1dfb6$6063b7a8@cox.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
	<38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net>
	<0AC846B3-C8B0-45FF-BCA9-F681811A23D7@bueechi.net>
	<e4c67cb3-b5f3-5dbb-1fb1-4d9a3b9a2f60@gmail.com>
	<E0C7FC1F-AEEE-4A79-9031-51FF616D027B@bueechi.net>
	<pan$b3671$36ea03da$e28136e8$8de0280e@cox.net>
	<2FE8C51A-285F-48E5-B939-CA5977B3A75B@bueechi.net>
	<BCC1C109-01F3-4E10-A138-756E105F4F13@bueechi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

boli posted on Thu, 16 Jun 2016 20:18:50 +0200 as excerpted:

> This second replace is now finished, and it looks OK now:
> 
> 	# btrfs replace status /data
> 	Started on 16.Jun 01:15:17, finished on 16.Jun 11:40:30,
>       0 write errs, 0 uncorr. read errs


> However, while the replace was in progress, it showed weird stuff,
> like this percentage > 100 today at 9am (~3 hours before completion):
> 
> 	# btrfs replace status /data       
> 	272.1% done, 0 write errs, 0 uncorr. read errs
> 
> Also, contrary to he first replace, filesystem info was not updated
> during the replace


> I'm happy it worked, just wondering why it behaved
> weirdly this second time.
> 
> During the first replace, my Fedora 23 was booted in emergency mode,
> whereas for the second time it was booted normally.
> 
> I'm going to reboot now to update Kernel 4.5.5 to 4.5.6
> and then continue replacing drives.


I'm guessing you were either running differing kernels,
or it had something to do with the information available...
/sys and /proc mounted, udev and lvm/device-mapper possibly
in different states due to the differing systemd target states,
possibly different btrfs, udev and lvm/dm versions in initr*
vs the main system, etc.

In particular, I know there have been some patches to fix problems
where it would count only one device, generally the one it was mounted
with, as 100%, when the balance affected multiple devices, so it could
get to multiple-hundred percent done.  And there have been patches
having to do with resolving names to the canonical form, vs the various
symlinked udev/lvm/mdraid/etc names.

But I wouldn't be surprised if there's still inconsistencies,
particularly related to udev/lvm state differences that may well appear
between systemd emergency and multi-user target modes or between initr*
and main system boot, especially if the initr* is running differing
versions of one or more affected utilities.

So if it was the same kernel version, it's likely that in the one case
it simply wasn't mapping the full filesystem for the purpose of
calculating percentages and current filesystem numbers, correctly.
That should be corrected in time, and Fedora is likely to see it
pretty early compared to everyone else given the number of upstream
devs that package for it and sometimes pre-release or first release
deployment versions with systemd/udev/lvm patches that others simply
don't have yet, but it could yet be a few years before it /fully/
settles down.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


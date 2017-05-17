Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46524 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753869AbdEQJWv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 05:22:51 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dAvAG-00043j-Ud
        for linux-btrfs@vger.kernel.org; Wed, 17 May 2017 11:22:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't remount a BTRFS partition read write after a drive failure
Date: Wed, 17 May 2017 09:22:31 +0000 (UTC)
Message-ID: <pan$af7cc$8b1ee5a8$c11d0b13$ce53f@cox.net>
References: <84408781-722d-6c87-b510-0497c4f36443@chicoree.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sylvain Leroux posted on Tue, 16 May 2017 14:56:37 +0200 as excerpted:

> I'm investigating BTRFS using an external USB HDD on a Linux Debian
> Stretch/Sid system.
> 
> The drive is not reliable. And I noticed when there is an error and the
> USB device appears to be dead to the kernel, I am later unable to
> remount rw the drive. I can mount it read only though.
> 
> This seems to be a systematic behavior. And it occasionally happens when
> the computer wake up from sleep and the drive is still attached.
> 
> Power cycling the disk do not change anything, but restarting the
> computer "solves" the issue.
> 
> 
> I believe this may be caused by BTRFS having issues since the kernel
> assign a different device name to the drive when it bring it back
> inline? Or BTRFS didn't realize the "original" drive has gone away?

> Initially, the drive was mounted rw and associated to the /dev/sdb
> device, the btrfs partition being /dev/sdb1 After the failure, I power
> cycled the drive, and the kernel brought it back as /dev/sdc
> 
> I can mount /dev/sdc1 read only.
> But I'm unable to mount it read-write. Interestingly, the message in
> dmesg still mention /dev/sdb1 as the device whereas it should be
> /dev/sdc1.
> 
> sylvain@bulbizarre:~$ uname -[r]
> 4.9.0-2-amd64

This is a known issue.  Btrfs doesn't yet properly track devices and is 
thus unaware that the old device (/dev/sdb1) has gone away.  It does see 
the new device (/dev/sdc1, after btrfs device scan, which udev normally 
runs automatically when a new device appears), and can thus mount it, but 
because it still thinks the old device is there as well, as Chris Murphy 
says, it gets confused, and to be safe, only allows mounting read-only.


There's a patch set in the wings that makes btrfs properly device aware, 
allowing it to track disappearing devices and act accordingly, as a 
prerequisite to the hot-spares feature which the patch set introduces, 
but that patch set is tied up waiting for a different patch series (IIRC 
a change in the device-flush handling, I'm not a dev and haven't tracked 
the specifics), so it could be awhile, 4.13 at absolute minimum, since 
4.12 is the current dev kernel series.

Meanwhile, the history of USB connection flakiness and problems in 
general means btrfs is not generally recommended for USB attached 
devices, at least until those above mentioned patches go in.  For some 
people on specific hardware it works... until it doesn't and we get the 
reports here.  But there's enough of those reports that we simply don't 
recommend btrfs, if the device(s) hosting the filesystem are going to be 
USB-attached.

FWIW, direct SATA connections (eSATA for external) seem to be a better 
choice.  Or choose a different filesystem that's more stable and mature 
(btrfs is still stabilizing, not yet fully stable and mature), and proven 
ready to handle such issues in a better way.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


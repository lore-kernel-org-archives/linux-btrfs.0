Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48671 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbeIGINh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 04:13:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fy7Ve-00085H-6I
        for linux-btrfs@vger.kernel.org; Fri, 07 Sep 2018 05:32:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Re-mounting removable btrfs on different device
Date: Fri, 7 Sep 2018 03:32:30 +0000 (UTC)
Message-ID: <pan$d71b0$8d25ba8$5bb37179$bc1641a5@cox.net>
References: <990de394-15d2-55f3-c5ae-bef2de734978@georgianit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remi Gauvin posted on Thu, 06 Sep 2018 20:54:17 -0400 as excerpted:

> I'm trying to use a BTRFS filesystem on a removable drive.
> 
> The first drive drive was added to the system, it was /dev/sdb
> 
> Files were added and device unmounted without error.
> 
> But when I re-attach the drive, it becomes /dev/sdg (kernel is fussy
> about re-using /dev/sdb).
> 
> btrfs fi show: output:
> 
> Label: 'Archive 01'  uuid: 221222e7-70e7-4d67-9aca-42eb134e2041
> 	Total devices 1 FS bytes used 515.40GiB
> 	devid    1 size 931.51GiB used 522.02GiB path /dev/sdg1
> 
> This causes BTRFS to fail mounting the device [errors snipped]

> I've seen some patches on this list to add a btrfs device forget option,
> which I presume would help with a situation like this.  Is there a way
> to do that manually?

Without the mentioned patches, the only way (other than reboot) is to 
remove and reinsert the btrfs kernel module (assuming it's a module, not 
built-in), thus forcing it to forget state.

Of course if other critical mounted filesystems (such as root) are btrfs, 
or if btrfs is a kernel-built-in not a module and thus can't be removed, 
the above doesn't work and a reboot is necessary.  Thus the need for 
those patches you mentioned.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60521 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752797AbdKATqN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 15:46:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e9yxb-0000RQ-Qf
        for linux-btrfs@vger.kernel.org; Wed, 01 Nov 2017 20:45:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Error During Balancing - No Space Left on Device
Date: Wed, 1 Nov 2017 19:45:52 +0000 (UTC)
Message-ID: <pan$44703$f2eabaf1$fdaf8636$ed495365@cox.net>
References: <8E856F12-DA15-4396-8B5D-B2609D1461BE@networkinsanity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ben Hooper posted on Wed, 01 Nov 2017 16:18:25 +0000 as excerpted:

> Hello,
> 
> I am trying to upgrade capacity on by btrfs filesystem by replacing
> smaller disks with larger ones. I added 2x8TB drives to the existing
> RAID10 but am not seeing the expected increase in space and am
> experiencing enospc errors during balance. This array has been extended
> several times but this is the first time I have seen any issues.
> 
> Looking at the list archives, it seems that some others have had similar
> problems. Has anyone found a solution or any recommendations?


> # btrfs balance start -v -dusage=0 /data
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=0
> ERROR: error during balancing '/data': No space left on device
> There may be more info in syslog - try dmesg | tail

 
> # uname -a
> Linux nas 4.13.9-1.el7.elrepo.x86_64 #1 SMP
> Sun Oct 22 10:02:34 EDT 2017 x86_64 x86_64 x86_64 GNU/Linux

There's a known bug with kernel 4.13 with balance on TB+ sized 
filesystems.  A reserve-space calculation goes haywire and attempts to 
reserve orders of magnitude more space than it actually needs, and given 
that PB-sized storage isn't particularly common yet, more space than it 
actually has, as well.  (Not that PB would fix it, the problem seems to 
be one of scale, hundred-GB sized filesystems don't seem to be as badly 
affected, so PB-sized filesystems may actually make the bug worse and 
it'd think it needed EB-sized!)

Try waiting for 4.14 if it's not urgent, or try the latest 4.14-rc or 
downgrade to, say the latest LTS series 4.9.x kernel, and try the balance 
again.  In theory 4.13 stable series should get the fix as well, but in 
practice, not being an LTS, as late in the 4.14 cycle as it is already, 
I'm not sure whether the fix will make it to 4.13 before it goes 
unsupported, or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


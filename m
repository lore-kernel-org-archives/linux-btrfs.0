Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48316 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbeAFJl2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Jan 2018 04:41:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eXkwb-0001wa-W8
        for linux-btrfs@vger.kernel.org; Sat, 06 Jan 2018 10:39:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs quota exceeded notifications through netlink sockets
Date: Sat, 6 Jan 2018 09:39:00 +0000 (UTC)
Message-ID: <pan$3d8d7$c8b149c2$8a47644$e2fce472@cox.net>
References: <660251B721353E428446B0F99FE510A2A508D507@ITS-HCWNEM102.ds.vanderbilt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Karsai, Gabor posted on Sat, 06 Jan 2018 01:34:09 +0000 as excerpted:

> I created a subvolume on a btrfs, set a limit and the quota is enforced
> - dumping too much data into the subvolume results in a 'quota exceeded'
> message (from dd, for example). But when I am trying to get netlink
> socket notifications, nothing arrives on the socket (I am using pyroute2
> which is supposedly able to receive disk quota notifications)
> 
> $ uname -a
> Linux riaps-dev 4.10.0-42-generic #46~16.04.1-Ubuntu SMP
> Mon Dec 4 15:57:59 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs: whatever Ubuntu 16.04 has
> 
> Kconfig:
> CONFIG_QUOTA_NETLINK_INTERFACE=y

Someone with a bit more knowledge of quotas in general and btrfs quotas 
in particular will hopefully confirm (I'm just a btrfs user and list 
regular, without quotas in my own use-case, so this is only what I've 
seen on-list), but sometimes a fast non-authoritative answer can be more 
useful than a slower authoritative answer, so here's the first...

Btrfs quotas don't use the normal kernel quota mechanism as they work 
somewhat differently.  Indeed, the kernel-config help for CONFIG_QUOTA 
doesn't mention btrfs support at all.  As such, I don't believe the btrfs 
quota subsystem uses the normal kernel quota netlink interface at all.  
At least, I've never seen it mentioned, and it would surprise me if btrfs 
quotas /did/ use that interface, because they are different enough to be 
unlikely to properly match the expected interface API.

Meanwhile, be aware that until recently btrfs quotas were too buggy to be 
used reliably.  While they work rather better now, more minor fixes are 
still being made, with every recent kernel including 4.14 having quota 
fixes.  For this feature a current kernel is definitely recommended, and 
4.10 is neither an LTS kernel series (4.9 and 4.14 are the two most 
recent and best supported LTS series, 4.10 was simply a normal kernel and 
only had upstream support thru 4.11) nor within the latest two current 
kernels, so on-list support won't be as good as if you were running an LTS 
or current kernel.

And even with the fixes, enabling quotas increases btrfs scaling issues 
when running commands such as btrfs balance and check, tho normal runtime 
performance isn't so severely affected.  Balance in particular takes /
much/ longer when quotas are enabled due to constant quota updates as the 
blockgroups are moved around, so temporarily disabling them during 
balances is recommended to speed up the balance.  Unfortunately, the 
scenarios under which you're likely to need to run check, when the 
filesystem won't mount, prevent disabling quotas then.

So while quota numbers should be reliable with supported kernels now, 
leaving them off unless you really need the feature is still recommended.

The one good thing for use-cases that /do/ need quotas is that such use-
cases tend to be commercial systems with proper backups, where the 
performance of commands such as balance and check may not matter so much, 
since maintenance in such use-cases often consists of failing the entire 
filesystem and falling back to the hot-spare, rather than trying to do on-
the-fly filesystem maintenance such as rebalancing to a new device or 
raid layout or checking and trying to repair a filesystem that won't 
mount.  Since normal runtime performance isn't particularly affected, 
quotas tend to be fine for such use-cases.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44595 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754418AbdCaLuX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:50:23 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ctv4B-0003ze-D5
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 13:50:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Do different btrfs volumes compete for CPU?
Date: Fri, 31 Mar 2017 11:49:54 +0000 (UTC)
Message-ID: <pan$8edd9$3260f40b$e8e8873f$59ccb7af@cox.net>
References: <43a14754-1047-552e-78a9-6503dfc0d121@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marat Khalili posted on Fri, 31 Mar 2017 10:05:20 +0300 as excerpted:

> Approximately 16 hours ago I've run a script that deleted >~100
> snapshots and started quota rescan on a large USB-connected btrfs volume
> (5.4 of 22 TB occupied now). Quota rescan only completed just now, with
> 100% load from [btrfs-transacti] throughout this period, which is
> probably ~ok depending on your view on things.
> 
> What worries me is innocent process using _another_, SATA-connected
> btrfs volume that hung right after I started my script and took >30
> minutes to be sigkilled. There's nothing interesting in the kernel log,
> and attempts to attach strace to the process output nothing, but I of
> course suspect that it freezed on disk operation.
> 
> I wonder:
> 1) Can there be a contention for CPU or some mutexes between kernel
> btrfs threads belonging to different volumes?
> 2) If yes, can anything be done about it other than mounting volumes
> from (different) VMs?
> 
> 
>> $ uname -a; btrfs --version
>> Linux host 4.4.0-66-generic #87-Ubuntu SMP
>> Fri Mar 3 15:29:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>> btrfs-progs v4.4

What would have been interesting would have been if you had any reports 
from for instance htop during that time, showing wait percentage on the 
various cores and status (probably D, disk-wait) of the innocent 
process.  iotop output would of course have been even better, but also 
rather more special-case so less commonly installed.

I believe you will find that the problem isn't btrfs, but rather, I/O 
contention, and that if you try the same thing with one of the 
filesystems being for instance ext4, you'll see the same problem there as 
well, which because the two filesystems are then not the same type should 
well demonstrate that it's not a problem at the filesystem level, but 
rather elsewhere.

USB is infamous for being an I/O bottleneck, slowing things down both for 
it, and on less than perfectly configured systems, often for data access 
on other devices as well.  SATA can and does do similar things too, but 
because it tends to be more efficient in general, it doesn't tend to make 
things as drastically bad for as long as USB can.

There's some knobs you can twist for better interactivity, but I need to 
be up to go to work in a couple hours so will leave it to other posters 
to make suggestions in that regard at this point.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


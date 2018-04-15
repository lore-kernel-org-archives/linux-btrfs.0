Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46713 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752486AbeDOOKQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 10:10:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1f7iJz-0006c4-AE
        for linux-btrfs@vger.kernel.org; Sun, 15 Apr 2018 16:07:59 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: remounted ro during operation, unmountable since
Date: Sun, 15 Apr 2018 14:07:47 +0000 (UTC)
Message-ID: <pan$69d8c$1966de5f$5e730915$d1c0476d@cox.net>
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
        <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
        <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>
        <ccc7a5d1-2605-20fb-0523-e2bdaabb9d69@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Sat, 14 Apr 2018 22:41:50 +0800 as excerpted:

>> sectorsize        4096
>> nodesize        4096
> 
> Nodesize is not the default 16K, any reason for this?
> (Maybe performance?)
> 
>>> 3) Extra hardware info about your sda
>>>     Things like SMART and hardware model would also help here.

>> Model Family:     Samsung based SSDs Device Model:     SAMSUNG SSD 830
>> Series
> 
> At least I haven't hear much problem about Samsung SSD, so I don't think
> it's the hardware to blamce. (Unlike Intel 600P)

830 model is a few years old, IIRC (I have 850s, and I think I saw 860s 
out in something I read probably on this list, but am not sure of it).  I 
suspect the filesystem was created with an old enough btrfs-tools that 
the default nodesize was still 4K, either due to older distro, or simply 
due to using the filesystem that long.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


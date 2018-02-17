Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44603 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeBQDGX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Feb 2018 22:06:23 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1emsn9-0001Rq-JL
        for linux-btrfs@vger.kernel.org; Sat, 17 Feb 2018 04:03:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Ongoing Btrfs stability issues
Date: Sat, 17 Feb 2018 03:03:30 +0000 (UTC)
Message-ID: <pan$44d82$cdc95127$80ea1d4a$cb43d97@cox.net>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
        <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Fri, 16 Feb 2018 14:44:07 -0500 as
excerpted:

> This will probably sound like an odd question, but does BTRFS think your
> storage devices are SSD's or not?  Based on what you're saying, it
> sounds like you're running into issues resulting from the
> over-aggressive SSD 'optimizations' that were done by BTRFS until very
> recently.
> 
> You can verify if this is what's causing your problems or not by either
> upgrading to a recent mainline kernel version (I know the changes are in
> 4.15, I don't remember for certain if they're in 4.14 or not, but I
> think they are), or by adding 'nossd' to your mount options, and then
> seeing if you still have the problems or not (I suspect this is only
> part of it, and thus changing this will reduce the issues, but not
> completely eliminate them).  Make sure and run a full balance after
> changing either item, as the aforementioned 'optimizations' have an
> impact on how data is organized on-disk (which is ultimately what causes
> the issues), so they will have a lingering effect if you don't balance
> everything.

According to the wiki, 4.14 does indeed have the ssd changes.

According to the bug, he's running 4.13.x on one server and 4.14.x on 
two.  So upgrading the one to 4.14.x should mean all will have that fix.

However, without a full balance it /will/ take some time to settle down 
(again, assuming btrfs was using ssd mode), so the lingering effect could 
still be creating problems on the 4.14 kernel servers for the moment.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


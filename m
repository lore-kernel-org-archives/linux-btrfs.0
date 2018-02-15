Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52229 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1032245AbeBOB2F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 20:28:05 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1em8Iy-0006Ac-AO
        for linux-btrfs@vger.kernel.org; Thu, 15 Feb 2018 02:25:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
Date: Thu, 15 Feb 2018 01:25:22 +0000 (UTC)
Message-ID: <pan$4ac0$69992a27$e9c3c183$c0ebac21@cox.net>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Wed, 14 Feb 2018 23:19:20 +0900 as excerpted:

> Just FYI, how dangerous running btrfs can be - we had a fatal,
> unrecoverable MySQL corruption when btrfs decided to do one of these "I
> have ~50 GB left, so let's do out of space (and corrupt some files at
> the same time, ha ha!)".

Ouch!

> Running btrfs RAID-1 with kernel 4.14.

Kernel 4.14... quite current... good.  But 4.14.0 first release, 4.14.x 
current stable, or somewhere (where?) in between?

And please post the output of btrfs fi usage for that filesystem.  
Without that (or fi sh and fi df, the pre-usage method of getting nearly 
the same info), it's hard to say where or what the problem was.

Meanwhile, FWIW there was a recent metadata over-reserve bug that should 
be fixed in 4.15 and the latest 4.14 stable, but IDR whether it affected 
4.14.0 original or only the 4.13 series and early 4.14-rcs and was fixed 
by 4.14.0.  The bug seemed to trigger most frequently when doing balances 
or other major writes to the filesystem, on middle to large sized 
filesystems.  (My all under quarter-TB each btrfs didn't appear to be 
affected.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46995 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdISC7f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 22:59:35 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1du8kv-0000Sv-NO
        for linux-btrfs@vger.kernel.org; Tue, 19 Sep 2017 04:59:25 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to run balance successfully (No space left on device)?
Date: Tue, 19 Sep 2017 02:59:19 +0000 (UTC)
Message-ID: <pan$7ed29$8cce4f45$b9679fc8$79ad166d@cox.net>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
        <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
        <CAA91j0W5YNU-StfRY_M4YUC=aLY-W+VEZ+wP2XciiHmDB1q7gQ@mail.gmail.com>
        <d4dce3d04c11e171b44a1924114f5ddd@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Mon, 18 Sep 2017 18:27:09 +0900 as excerpted:

> And perhaps more important - can I assume that right now, with the
> latest stable kernel (4.13.2 right now), running "btrfs balance" is not
> safe and can lead to data corruption or loss?
> 
> 
> Consider the following case:
> 
> - system admin runs btrfs balance on a filesystem with 100 GB free and
> assumes it is enough space to complete successfully
> 
> - btrfs balance fails due to some bug with "No space left on device"
> 
> - at the same time, a database using this filesystem will fail with "No
> space left on device", apt/rpm will fail a package upgrade, some program
> using temp space will fail, log collector will fail to catch some data,
> because of "No space left on device" and so on?

To the best of my knowledge that shouldn't be a problem, certainly not 
one I'd worry about if you're following the sysadmin's first rule of 
backups, the true value of data to you is defined not by any claims but 
by the number of backups you consider it worth having of that data, so it 
follows that no backups means you've defined the data as worth less than 
the time/trouble/resources it would take to create at least that one 
backup.

The ENOSPC is because the internal calculation for the reserved-space 
requirement is buggy ATM, but AFAIK it's just that, an /internal/ 
calculation, that goes waayyy wild, and stops any action it's going to 
stop before it goes anywhere -- it doesn't get to the point of affecting 
anything else because the reserve space calculation goes wild and stops 
it before it can actually reserve the space.

Talking about which... I've not seen it mentioned in the bug discussion, 
but I wonder if doing a btrfs balance start -d, followed by a another 
balance with -m replacing the -d, thus separating the data and metadata 
balances, might work around the problem.  At least you could know for 
sure which is causing it that way, and complete a balance of the other 
one.  And if that blocks on one or the other, you could split the job up 
further using the devid= and drange= filters (see the btrfs-balance 
manpage), doing only part of the filesystem at a time.  My speculation is 
that you should be able to divide the operation up enough so that even if 
the reserve space calculation is off, it'll still complete.

Meanwhile, I don't believe it's just balance that's affected, either, tho 
it's the most commonly reported.  By my understanding, any sufficiently 
large operation could trigger it, tho obviously a full btrfs balance is 
about the largest operation a btrfs is likely to have, so it stands to 
reason that would trigger it more reliably than common generic filesystem 
operations.

Of course if you're paranoid, you can refrain from doing balances until 
you know the bug is fixed, but then I'd have to ask, if you're that 
paranoid of a filesystem failure, why are you running the still 
stabilizing, not yet entirely stable and mature, btrfs, in the first 
place?  Seems a bit like the folks still running RHEL/CentOS 6 with their 
stable kernels because they want stability, yet choosing to run the still 
not entirely stable btrfs, definitely not entirely stable on that old a 
kernel, on top of them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


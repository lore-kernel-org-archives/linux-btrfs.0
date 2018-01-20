Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40753 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbeATGfb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Jan 2018 01:35:31 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ecmiN-00089U-9y
        for linux-btrfs@vger.kernel.org; Sat, 20 Jan 2018 07:33:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs volume corrupt. btrfs-progs bug or need to rebuild volume?
Date: Sat, 20 Jan 2018 06:32:59 +0000 (UTC)
Message-ID: <pan$2713d$bb24c7f5$b5fab30e$2e2a6027@cox.net>
References: <CAKxU2N_4A_bC7xKEhvRTu0+H3Bgm58hvnFx-bLSK39WH0BtWEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rosen Penev posted on Fri, 19 Jan 2018 13:45:35 -0800 as excerpted:

> v2: Add proper subject

=:^)

> I've been playing around with a specific kernel on a specific device
> trying to figure out why btrfs keeps throwing csum errors after ~15
> hours. I've almost nailed it down to some specific CONFIG option in the
> kernel, possibly related to IRQs.
> 
> Anyway, I managed to get my btrfs RAID5 array corrupted to the point
> where it will just mount to read-only mode.

[...]

> This is with version 4.14 of btrfs-progs. Do I need a newer version or
> should I just reinitialize my array and copy everything back?
> 
> Log on mount attached below:

[...]

> Fri Jan 19 14:26:08 2018 kern.warn kernel:
> [168383.378239] CPU: 0 PID:
> 2496 Comm: kworker/u8:2 Tainted: G        W       4.9.75 #0

Tho as the penultimate LTS kernel series 4.9 is still on the btrfs-list 
supported list in general... 4.9 still had known btrfs raid56 mode issues 
and is strongly negatively recommended for use with btrfs raid56 mode.  
Those weren't fixed until 4.12, which /finally/ brought raid56 mode into 
generally working and not negatively recommended state.

While as an LTS applicable general btrfs bug fixes would be backported to 
4.9, because raid56 mode had never worked /well/ at that point, I'm not 
sure those fixes were backported.

So you really need either kernel 4.12+, presumably the LTS 4.14 series 
since you're on LTS 4.9 series now, for btrfs raid56 mode, or don't use 
raid56 mode if you plan on staying with the 4.9 LTS, as it still had 
severe known issues back then and I haven't seen on-list confirmation 
that the 4.12 btrfs raid56 mode fixes were backported to 4.9-LTS.  

If you need/choose to stick with 4.9 and dump raid56 mode, the 
recommended alternative depends on the number of devices in the 
filesystem.

For a small number of devices in the filesystem, btrfs raid1 is 
effectively as stable as the still stabilizing and maturing btrfs itself 
is at this point and is recommended.

For a larger number of devices, btrfs raid1 is still a good choice 
because it /is/ the most mature, but btrfs raid10 is /reasonably/ stable 
tho IMO not quite as stable as raid1, or for better performance (due to 
btrfs raid10 not being read-optimized yet) while keeping btrfs 
checksumming and error repair from the second copy when available, 
consider a layered approach, with btrfs raid1 on top of a pair of mdraid0s 
(or dmraid0s, or hardware raid0s).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


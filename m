Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52817 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1032345AbdDTUN1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 16:13:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d1IS5-0008OY-Ne
        for linux-btrfs@vger.kernel.org; Thu, 20 Apr 2017 22:13:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH ping] btrfs: warn about RAID5/6 being experimental at
 mount time
Date: Thu, 20 Apr 2017 20:13:11 +0000 (UTC)
Message-ID: <pan$9c654$fc7a9a58$350415c4$8a82638f@cox.net>
References: <20170419210745.15263-1-kilobyte@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Wed, 19 Apr 2017 23:07:45 +0200 as excerpted:

> Too many people come complaining about losing their data -- and indeed,
> there's no warning outside a wiki and the mailing list tribal knowledge.
> Message severity chosen for consistency with XFS -- "alert" makes dmesg
> produce nice red background which should get the point across.

Commenting on the idea and comment, because as a non-coder list regular, 
that's what I can evaluate fairly. =:^)

A kernel dmesg warning like this makes more sense to me than trying to 
put it in, for instance, mkfs.btrfs, because the instability is primarily 
kernel code and at least the message can stay synced with it, being 
removed when considered appropriate, unlike userspace code which can't, 
because people often run userspace and kernelspace versions well out of 
sync with each other.

> I intend to ask for inclusion of this one (or an equivalent) in 4.9,
> either in Debian or via GregKH -- while for us kernels "that old" are
> history, regular users expect stable releases to be free of known
> serious data loss bugs.

Arguably it should go in the LTS-4.4 series as well, because we at least 
try to support the last two LTS series on-list, more or less giving up 
beyond that, and that's the relatively new 4.9 and the now going stale 
but we really should be still trying to support it 4.4.  Older than that, 
4.1 was the only LTS after initial code completion, but since it should 
be simple enough even before that and certainly would be true, queuing 
the patch for any still being updated LTS back to initial partial support 
(3.9 IIRC) is arguably worthwhile.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


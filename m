Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49598 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbdKTV6W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 16:58:22 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eGu4p-0004lH-Ch
        for linux-btrfs@vger.kernel.org; Mon, 20 Nov 2017 22:58:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Issues while doing btrfs delete missing in raid6
Date: Mon, 20 Nov 2017 21:57:47 +0000 (UTC)
Message-ID: <pan$5ba16$591e9570$7efd0d56$66c0e056@cox.net>
References: <20171120014344.7a5d8bd2@Vantage.cJ>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jérôme Carretero posted on Mon, 20 Nov 2017 01:43:44 -0500 as excerpted:

> While doing a test (to evaluate drives), where I'm filling a bunch of
> drives in RAID6, one of the disks failed in the process.
> (System with v4.14 / ECC).

FWIW, see raid56 status in the status page (table and below raid56 note).

https://btrfs.wiki.kernel.org/index.php/Status

Basically, after the fixes in 4.12, it mostly works as long as things 
don't go too badly wrong, but due to the write hole and corner cases such 
as the checksum repair failure you ran into, it's not something people on 
this list can in good conscience recommend for general use, because it 
simply lacks the reliability people tend to want raid56 for, at least in 
combination with the file-integrity/checksumming features btrfs may be 
chosen for.  The two together simply aren't as reliable as the separate 
features might imply they should be, and there are known to be better 
alternatives.

Unfortunately that's likely to remain the case for awhile due to the 
complexity of a real fix, despite the 4.12 fixes to the worst of the 
problems.

One reasonably performant and reliable alternative, tho it's more 
directly an alternative to btrfs raid10, where it's better performing due 
to btrfs raid10 not yet being performance optimized, is btrfs raid1 on 
top of two raid0s (mdraid0, for instance).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


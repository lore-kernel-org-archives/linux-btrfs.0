Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52915 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752719AbeGCHSJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 03:18:09 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1faFXW-0007Jt-PP
        for linux-btrfs@vger.kernel.org; Tue, 03 Jul 2018 09:15:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how to best segment a big block device in resizeable btrfs
 filesystems?
Date: Tue, 3 Jul 2018 07:15:48 +0000 (UTC)
Message-ID: <pan$3326b$1b5189ef$d6f2b03e$a3db8011@cox.net>
References: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
        <20180629064354.kbaepro5ccmm6lkn@merlins.org>
        <20180701232202.vehg7amgyvz3hpxc@merlins.org>
        <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
        <20180702032259.GD5567@merlins.org>
        <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
        <20180702140527.wfbq5jenm67fvvjg@merlins.org>
        <3728d88c-29c1-332b-b698-31a0b3d36e2b@gmx.com>
        <20180702151853.mwlrinipbihq46zu@merlins.org>
        <e8e78a5b-1db2-ddf0-f8ea-38f8ac9be654@gmail.com>
        <20180702173438.7c2vhflvtncfb5gz@merlins.org>
        <8de54b29-c718-0230-09b2-f849e3ad01df@gmail.com>
        <9e79a4b4-af3c-20bf-ff8e-748b9ab46bf6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Borzenkov posted on Tue, 03 Jul 2018 07:25:14 +0300 as excerpted:

> 02.07.2018 21:35, Austin S. Hemmelgarn пишет:
>> them (trimming blocks on BTRFS gets rid of old root trees, so it's a
>> bit dangerous to do it while writes are happening).
> 
> Could you please elaborate? Do you mean btrfs can trim data before new
> writes are actually committed to disk?

No.

But normally old roots aren't rewritten for some time simply due to odds 
(fuller filesystems will of course recycle them sooner), and the btrfs 
mount option usebackuproot (formerly recovery, until the norecovery mount 
option that parallels that of other filesystems was added and this option 
was renamed to avoid confusion) can be used to try an older root if the 
current root is too damaged to successfully mount.

But other than simply by odds not using them again immediately, btrfs has 
no special protection for those old roots, and trim/discard will recover 
them to hardware-unused as it does any other unused space, tho whether it 
simply marks them for later processing or actually processes them 
immediately is up to the individual implementation -- some do it 
immediately, killing all chances at using the backup root because it's 
already zeroed out, some don't.

In the context of the discard mount option, that can mean there's never 
any old roots available ever, as they've already been cleaned up by the 
hardware due to the discard option telling the hardware to do it.

But even not using that mount option, and simply doing the trims 
periodically, as done weekly by for instance the systemd fstrim timer and 
service units, or done manually if you prefer, obviously potentially 
wipes the old roots at that point.  If the system's effectively idle at 
the time, not much risk as the current commit is likely to represent a 
filesystem in full stasis, but if there's lots of writes going on at that 
moment *AND* the system happens to crash at just the wrong time, before 
additional commits have recreated at least a bit of root history, again, 
you'll potentially be left without any old roots for the usebackuproot 
mount option to try to fall back to, should it actually be necessary.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


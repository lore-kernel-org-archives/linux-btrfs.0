Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58711 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbcLZDwV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Dec 2016 22:52:21 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cLMKZ-0007Ok-5y
        for linux-btrfs@vger.kernel.org; Mon, 26 Dec 2016 04:52:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Date: Mon, 26 Dec 2016 03:52:04 +0000 (UTC)
Message-ID: <pan$8c5dd$219346e7$7ef2e02e$288572ab@cox.net>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
        <1482515316.585d63747d460@webmail.adria.it>
        <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08>
        <26479704.a8Su2NvQ2R@exnet.gdb.it>
        <trinity-3b871d96-6d50-44af-9f6d-3fbf2f7fbfd8-1482610539986@3capp-mailcom-bs13>
        <pan$75761$bfdd58c9$f0dc28fc$33093136@cox.net>
        <trinity-3c499d54-80d4-4e77-992f-fa53b112c5a0-1482719769501@3capp-mailcom-bs14>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xin Zhou posted on Mon, 26 Dec 2016 03:36:09 +0100 as excerpted:

> One interesting thing to investigate might be the btrfs send / receive
> result, under a disruptive network environment. If the connection breaks
> in the middle of transfer (at different phase, maybe), see what could be
> the file system status.

Btrfs send, sends from a read-only snapshot, so the sending filesystem 
shouldn't be harmed no matter what happens to send.

Btrfs receive does all its work in a new subvolume (basically a snapshot 
in an incremental send, tho I'm not sure it's a full snapshot in the 
technical sense), modifying the files therein using standard calls used 
in other contexts as well, so absent bugs that should appear in those 
other contexts too if they exist, the worst damage that a receive should 
be able to do is an unfaithful replay of the send stream, such that an 
appropriate copy of the sent snapshot doesn't appear on the receiver.

Which means even in the case of error, cleanup is as simple as deleting 
the aborted/incompletely-received subvolume.  Unless there are bugs that 
would show up in other situations as well (or an out-of-space condition 
is triggered that would likewise show up in other situations with a 
similar amount of data/metadata written), there should be no effects 
outside that received subvolume.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


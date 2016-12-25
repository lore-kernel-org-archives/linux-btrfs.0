Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59291 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbcLYW54 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Dec 2016 17:57:56 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cLHjd-0001Bn-8z
        for linux-btrfs@vger.kernel.org; Sun, 25 Dec 2016 23:57:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Date: Sun, 25 Dec 2016 22:57:35 +0000 (UTC)
Message-ID: <pan$75761$bfdd58c9$f0dc28fc$33093136@cox.net>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
        <1482515316.585d63747d460@webmail.adria.it>
        <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08>
        <26479704.a8Su2NvQ2R@exnet.gdb.it>
        <trinity-3b871d96-6d50-44af-9f6d-3fbf2f7fbfd8-1482610539986@3capp-mailcom-bs13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xin Zhou posted on Sat, 24 Dec 2016 21:15:40 +0100 as excerpted:

> The code is relatively new to me, I did not see retry logic in stream
> handling, please correct me if I am wrong about this.
> So, I am not quite sure about the transfer behavior, if the system
> subject to network issues in heavy workload,
> in which packets missing or connect issues are not rare.

As you likely know I'm neither a dev, just a list regular and btrfs user 
myself, and I'm not particularly familiar with send/receive as I don't 
use it myself, but...

AFAIK, the send and receive sides are specifically designed to be 
separate and to work with STDOUT/STDIN, so it's possible with STDOUT 
redirection to "send" to a local file instead of directly to receive, and 
then to replay that file on the other end by cat-ing it to receive.

As such, transfer behavior isn't really a factor at the btrfs layer, 
since handling problems in the transfer layer is the responsibility of 
whatever method the user is using to do that transfer, and the user is 
presumed to use a transfer method with whatever reliability guarantees 
they deem necessary.  So network behavior isn't really a factor at the 
btrfs level as that's the transfer layer and btrfs isn't worrying about 
that, simply assuming it to have the necessary reliability.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


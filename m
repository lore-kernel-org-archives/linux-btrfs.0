Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55658 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbcLZCgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Dec 2016 21:36:14 -0500
MIME-Version: 1.0
Message-ID: <trinity-3c499d54-80d4-4e77-992f-fa53b112c5a0-1482719769501@3capp-mailcom-bs14>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Dec 2016 03:36:09 +0100
In-Reply-To: <pan$75761$bfdd58c9$f0dc28fc$33093136@cox.net>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
 <1482515316.585d63747d460@webmail.adria.it>
 <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08>
 <26479704.a8Su2NvQ2R@exnet.gdb.it>
 <trinity-3b871d96-6d50-44af-9f6d-3fbf2f7fbfd8-1482610539986@3capp-mailcom-bs13>,
 <pan$75761$bfdd58c9$f0dc28fc$33093136@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
For free software with open source code, that is quite good.
Most commercial product has a very robust error handling in transport, to guarantee no corruption due to transfer issues.
One interesting thing to investigate might be the btrfs send / receive result, under a disruptive network environment.
If the connection breaks in the middle of transfer (at different phase, maybe), see what could be the file system status.

Thanks,
Xin

 
 

Sent: Sunday, December 25, 2016 at 2:57 PM
From: Duncan <1i5t5.duncan@cox.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
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
they deem necessary. So network behavior isn't really a factor at the
btrfs level as that's the transfer layer and btrfs isn't worrying about
that, simply assuming it to have the necessary reliability.

--
Duncan - List replies preferred. No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master." Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html

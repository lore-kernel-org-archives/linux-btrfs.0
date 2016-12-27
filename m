Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51288 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752026AbcL0DUa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Dec 2016 22:20:30 -0500
MIME-Version: 1.0
Message-ID: <trinity-5d6e6c7c-a910-4c9d-945e-bbbbbe6d0ad0-1482808825364@3capp-mailcom-bs01>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Dec 2016 04:20:25 +0100
In-Reply-To: <pan$8c5dd$219346e7$7ef2e02e$288572ab@cox.net>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
 <1482515316.585d63747d460@webmail.adria.it>
 <trinity-8b1613bd-b3dc-4e8b-96ac-53275b6cad7c-1482518120336@3capp-mailcom-bs08>
 <26479704.a8Su2NvQ2R@exnet.gdb.it>
 <trinity-3b871d96-6d50-44af-9f6d-3fbf2f7fbfd8-1482610539986@3capp-mailcom-bs13>
 <pan$75761$bfdd58c9$f0dc28fc$33093136@cox.net>
 <trinity-3c499d54-80d4-4e77-992f-fa53b112c5a0-1482719769501@3capp-mailcom-bs14>,
 <pan$8c5dd$219346e7$7ef2e02e$288572ab@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>Unless there are bugs that
>would show up in other situations as well (or an out-of-space condition
>is triggered that would likewise show up in other situations with a
>similar amount of data/metadata written),
 
That is exactly some bugs come from.
For simple cases, it is ok to assume the send/receive always succeed.
And if it errors out, assumes the delete always succeed, and the file system is in consistent status,
and good luck with the data.



Xin




Sent: Sunday, December 25, 2016 at 7:52 PM
From: Duncan <1i5t5.duncan@cox.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
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
the aborted/incompletely-received subvolume. Unless there are bugs that
would show up in other situations as well (or an out-of-space condition
is triggered that would likewise show up in other situations with a
similar amount of data/metadata written), there should be no effects
outside that received subvolume.

--
Duncan - List replies preferred. No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master." Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html

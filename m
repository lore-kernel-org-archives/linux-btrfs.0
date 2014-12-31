Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:50945 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751104AbaLaR1Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 12:27:16 -0500
Message-ID: <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
In-Reply-To: <54A3633C.3040609@ubuntu.com>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>
    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>
    <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>
    <54A31CAE.4020606@ubuntu.com>
    <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>
    <54A3633C.3040609@ubuntu.com>
Date: Wed, 31 Dec 2014 09:27:14 -0800
Subject: Re: I need to P. are we almost there yet?
From: ashford@whisperpc.com
To: "Phillip Susi" <psusi@ubuntu.com>
Cc: ashford@whisperpc.com,
        "Jose Manuel Perez Bethencourt" <jmperezbeth@gmail.com>,
        "Chris Murphy" <lists@colorremedies.com>,
        "sys.syphus" <syssyphus@gmail.com>,
        "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Phillip

> I had a similar question a year or two ago (
> specifically about raid10  ) so I both experimented and read the code
> myself to find out.  I was disappointed to find that it won't do
> raid10 on 3 disks since the chunk metadata describes raid10 as a
> stripe layered on top of a mirror.
>
> Jose's point was also a good one though; one chunk may decide to
> mirror disks A and B, so a failure of A and C it could recover from,
> but a different chunk could choose to mirror on disks A and C, so that
> chunk would be lost if A and C fail.  It would probably be nice if the
> chunk allocator tried to be more deterministic about that.

I see this as a CRITICAL design flaw.  The reason for calling it CRITICAL
is that System Administrators have been trained for >20 years that RAID-10
can usually handle a dual-disk failure, but the BTRFS implementation has
effectively ZERO chance of doing so.

According to every description of RAID-10 I've ever seen (including
documentation from MaxStrat), RAID-10 stripes mirrored pairs/sets of
disks.  The device-level description is a critical component of what makes
an array "RAID-10", and is the reason for many of the attributes of
RAID-10.  This is NOT what BTRFS has implemented.

While BTRFS may be distributing the chunks according to a RAID-10
methodology, that is NOT what the industry considers to be RAID-10.  While
the current methodology has the data replication of RAID-10, and it may
have the performance of RAID-10, it absolutely DOES NOT have the
robustness or uptime benefits that are expected of RAID-10.

In order to remove this potentially catestrophic confusion, BTRFS should
either call their "RAID-10" implementation something else, or they should
adhere to the long-established definition of RAID-10.

Peter Ashford


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38367 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdEJHsL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 03:48:11 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: runtime btrfsck
Date: Wed, 10 May 2017 09:48:07 +0200
Message-ID: <1801706.Ls22q1bWhG@merkaba>
In-Reply-To: <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag> <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag> <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe - Profihost AG - 10.05.17, 09:02:
> I'm now trying btrfs progs 4.10.2. Is anybody out there who can tell me
> something about the expected runtime or how to fix bad key ordering?

I had a similar issue which remained unresolved.

But I clearly saw that btrfs check was running in a loop, see thread:

[4.9] btrfs check --repair looping over file extent discount errors

So it would be interesting to see the exact output of btrfs check, maybe there 
is something like repeated numbers that also indicate a loop.

I was about to say that BTRFS is production ready before this issue happened. 
I still think it for a lot of setup mostly is, as at least the "I get stuck on 
the CPU while searching for free space" issue seems to be gone since about 
anything between 4.5/4.6 kernels. I also think so regarding absence of data 
loss. I was able to copy over all of the data I needed of the broken 
filesystem.

Yet, when it comes to btrfs check? Its still quite rudimentary if you ask me.  
So unless someone has a clever idea here and shares it with you, it may be 
needed to backup anything you can from this filesystem and then start over from 
scratch. As to my past experience something like xfs_repair surpasses btrfs 
check in the ability to actually fix broken filesystem by a great extent.

Ciao,
-- 
Martin

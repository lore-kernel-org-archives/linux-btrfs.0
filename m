Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:47964 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751756AbdEJImK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 04:42:10 -0400
Subject: Re: runtime btrfsck
To: Martin Steigerwald <martin@lichtvoll.de>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
 <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
 <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
 <1801706.Ls22q1bWhG@merkaba>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <bed8c67a-1ad1-64a0-a04d-16fa9ecd3423@profihost.ag>
Date: Wed, 10 May 2017 10:42:08 +0200
MIME-Version: 1.0
In-Reply-To: <1801706.Ls22q1bWhG@merkaba>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
Am 10.05.2017 um 09:48 schrieb Martin Steigerwald:
> Stefan Priebe - Profihost AG - 10.05.17, 09:02:
>> I'm now trying btrfs progs 4.10.2. Is anybody out there who can tell me
>> something about the expected runtime or how to fix bad key ordering?
> 
> I had a similar issue which remained unresolved.
> But I clearly saw that btrfs check was running in a loop, see thread:
> [4.9] btrfs check --repair looping over file extent discount errors
> 
> So it would be interesting to see the exact output of btrfs check, maybe there 
> is something like repeated numbers that also indicate a loop.

Output is just:
enabling repair mode
Checking filesystem on /dev/mapper/crypt_md0
UUID: 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
bad key ordering 39 40
checking extents [.]

even after 2,5 weeks running.

Stefan

> I was about to say that BTRFS is production ready before this issue happened. 
> I still think it for a lot of setup mostly is, as at least the "I get stuck on 
> the CPU while searching for free space" issue seems to be gone since about 
> anything between 4.5/4.6 kernels. I also think so regarding absence of data 
> loss. I was able to copy over all of the data I needed of the broken 
> filesystem.
> 
> Yet, when it comes to btrfs check? Its still quite rudimentary if you ask me.  
> So unless someone has a clever idea here and shares it with you, it may be 
> needed to backup anything you can from this filesystem and then start over from 
> scratch. As to my past experience something like xfs_repair surpasses btrfs 
> check in the ability to actually fix broken filesystem by a great extent.
> 
> Ciao,
> 

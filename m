Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54093 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752173AbdHNNKS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:10:18 -0400
Subject: Re: btrfs-progs-v4.12: cross compiling
To: Hallo32 <Hallo32@gmx.net>, linux-btrfs@vger.kernel.org
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3a460074-3cbb-a941-306a-bb6af9f48f1e@gmx.com>
Date: Mon, 14 Aug 2017 21:10:11 +0800
MIME-Version: 1.0
In-Reply-To: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月14日 20:17, Hallo32 wrote:
> Hello at all,
> 
> I'm new at this list. If the mail is not in line with your standards 
> please inform me.
> 
> Since versions 4.12 btrfs-progs is complicated to cross compile for 
> other systems.
> The problem is, that this version includes mktables, which needs to be 
> compiled for the host system and executed there for the creation of 
> tables.c.
> 
> Are there any changes planed for the next version of btrfs-progs to make 
> the cross compiling as simple as in the past? A included tables.c for 
> example?

Including tables.c seems quite crazy for me.
Just check how many lines tables.c has.

If we screw up any number of it, RAID6 is screwed up and we will never 
find the bug by reviewing the such meaningless numbers.

We could enhance the makefile to use host-cc to compile and execute mktable.
But it may make the makefile more complicated just for one file.
(Well, I just don't want to screw traditional Makefile/configure any more)

Another solution is to generate tables.c using scripts, other binary 
executable.
I'll try to port mktable to bash or python, which should solve the 
problem withouth further complicating makefile.
(And maybe I can update kernel too, but kernel has its host-cc and 
cross-cc already distinguished well, so it may not help much)

Thanks,
Qu

> 
> Best regards
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

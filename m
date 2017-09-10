Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:44164 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdIJRT4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 13:19:56 -0400
Date: Sun, 10 Sep 2017 20:19:17 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Ferenc-Levente Juhos <feci1024@gmail.com>
Cc: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Help me understand what is going on with my RAID1 FS
Message-ID: <20170910201917.480261ad@demfloro.ru>
In-Reply-To: <CAOsOv4k3LoCUFt0kAg2mvT9hF6NzEE45FrsYghmk1TD=6kLn2g@mail.gmail.com>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
        <20170910174750.544a4146@jupiter.sol.kaishome.de>
        <CAOsOv4k3LoCUFt0kAg2mvT9hF6NzEE45FrsYghmk1TD=6kLn2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> @Kai and Dmitrii
> thank you for your explanations if I understand you correctly, you're
> saying that btrfs makes no attempt to "optimally" use the physical
> devices it has in the FS, once a new RAID1 block group needs to be
> allocated it will semi-randomly pick two devices with enough space and
> allocate two equal sized chunks, one on each. This new chunk may or
> may not fall onto my newly added 8 TB drive. Am I understanding this
> correctly?
If I remember correctly chunk allocator allocates new chunks on device
which has the most unallocated space. 

> Is there some sort of balance filter that would speed up this sort of
> balancing? Will balance be smart enough to make the "right" decision?
> As far as I read the chunk allocator used during balance is the same
> that is used during normal operation. If the allocator is already
> sub-optimal during normal operations, what's the guarantee that it
> will make a "better" decision during balancing?

I don't really see any way that being possible in raid1 profile. How
can you fill all three devices if you can split data only twice? There
will be moment when two of three disks are full and BTRFS can't
allocate new raid1 block group because it has only one drive with
unallocated space.

> 
> When I say "right" and "better" I mean this:
> Drive1(8) Drive2(3) Drive3(3)
> X1            X1
> X2                            X2
> X3            X3
> X4                            X4
> I was convinced until now that the chunk allocator at least tries a
> best possible allocation. I'm sure it's complicated to develop a
> generic algorithm to fit all setups, but it should be possible.
 

Problem is that each raid1 block group contains two chunks on two
separate devices, it can't utilize fully three devices no matter what.
If that doesn't suit you then you need to add 4th disk. After
that FS will be able to use all unallocated space on all disks in raid1
profile. But even then you'll be able to safely lose only one disk
since BTRFS still will be storing only 2 copies of data.

This behavior is not relevant for single or raid0 profiles of
multidevice BTRFS filesystems.

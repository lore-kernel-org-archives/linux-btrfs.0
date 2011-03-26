From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Compress=lzo a good idea for Swapfiles on SSD?
Date: Sat, 26 Mar 2011 08:54:07 -0400
Message-ID: <1301143968-sup-9251@think>
References: <AANLkTi=b9hzJ5zs2qNm1ZbbkQLdmua8zQfJJhpVs4nYd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: John McCabe-Dansted <gmatht@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=b9hzJ5zs2qNm1ZbbkQLdmua8zQfJJhpVs4nYd@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from John McCabe-Dansted's message of 2011-03-25 23:47:02 -0400:
> I understand that modern SSDs can withstand a significant amount of
> writes, and so using an SSD for swap seems like a reasonable
> proposition. However minimising writes still seems like a good idea.
> My experience with compcache/ramzswap suggests that swap compresses
> quite well, I tend to get a 4:1 compression ratio. Furthermore, I
> understand that we can work around the data corruption that usually
> occurs when using a swapfile on a btrfs partion, by using a loopback
> device. Given this, my question is:
> 
> Does it sound like a good idea to use compress=lzo for swapfiles to
> reduce the amount of data written to the SSD, when using SSD drives
> that do not use compression internally?
> 

I would tend to say no, only because using compression leads to more
allocations required to actually write the blocks.  So you're swapping
because you need to free ram but you have to allocate ram in order to
swap.

There are projects for in kernel swapfile compression that have good
results though, so I'd have to study it in more detail.

-chris

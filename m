From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs Slowdown (due to Memory Handling?)
Date: Thu, 04 Aug 2011 10:22:01 -0400
Message-ID: <1312467261-sup-951@shiny>
References: <CAKcLGm_VFTjLPJjQXe9Vg2C5Cm3kwx_H8tthXsu+kJb1mxZB0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAKcLGm_VFTjLPJjQXe9Vg2C5Cm3kwx_H8tthXsu+kJb1mxZB0g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mitch Harder's message of 2011-08-02 10:35:54 -0400:
> I'm running into a significant slowdown in Btrfs (> 10x slower than
> normal) that appears to be due to some issue between how Btrfs is
> allocating memory, and how the kernel is expecting Btrfs to allocate
> memory.
> 
> The problem does seem to be somewhat hardware specific.  I can
> reproduce on two of my computers (an older AMD Athlon(tm) XP 2600+
> with PATA, and a newer ACER Aspire netbook with an Atom CPU).  My
> Core2Duo computer with SATA seems unaffected by this slowdown.
> 
> I've replicated this on 2.6.38, 2.6.39, and 3.0 kernels.  The
> following information was all obtained running on a 3.0 kernel merged
> with the latest 'for-linus' branch of Chris' git repo.  I've also
> tested on ext4 (no slow down encountered) to make sure the issue
> wasn't completely unrelated to Btrfs.

Just to double check, what was the top commit of for-linus when you did
this?

The tracing shows that you're spending your time in mmap'd readahead.
So one of three things is happening:

1) The VM is favoring our metadata over data pages for the git packed
file

2) We're reading ahead too aggressively, or not aggressively enough

3) The git pack file is somehow more fragmented, and this is making the
read ahead much less effective.

The very first thing I'd check is to make sure the .git repo between the
slow machines and the fast machines are identical.  Git does a lot of
packing behind the scenes, and so an older repo that isn't freshly
cloned is going to be slower than a new repo.

-chris

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43693 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbcHYEXI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 00:23:08 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bckTO-00028Q-Hp
        for linux-btrfs@vger.kernel.org; Thu, 25 Aug 2016 04:32:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs partition fails to mount - kernel BUG at
 ../fs/btrfs/extent-tree.c:1872
Date: Thu, 25 Aug 2016 02:32:47 +0000 (UTC)
Message-ID: <pan$b3826$8f0dd137$587e562b$4d394f85@cox.net>
References: <CAC8ULPbST1tMtfW8MBdEXiFSxknQtUHYneZu8FpQij5DRon_gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert Munteanu posted on Thu, 25 Aug 2016 01:19:27 +0300 as excerpted:

> Using Kernel 4.7.1 ( openSUSE Tumbleweed x86_64 ), btrfsprogs 4.7 I
> always get a hard lockup when trying to mount my btrfs root partition.
> 
> This may be due to some previous errors which only manifested themselves
> now, as it's been converted from an ext4 partition.
> 
> Using mount -o ro works. Using mount -o recovery or mounting without
> arguments does not. I've managed to capture one of the error messages,
> but via screenshot only. I've transcribed some of it below, more at
> 
>   http://i.imgur.com/OSIddHE.jpg
> 
> BTRFS info (device sda1): disk space caching is enabled
> BTRFS info (device sda1): detected SSD devices, enabling SSD mode
> BTRFS info (device sda1): checking UUID tree
> BTRFS info (device sda1): continuing balance
> BTRFS info (device sda1): relocating block group 1047892328448 flags 1
> BTRFS info (device sda1): found 805 extents
> (...)
> kernel BUG at ../fs/btrfs/extent-tree.c:1872
> invalid opcode: 0000 [#1] PREEMPT SMP
> (...)

I'm just a btrfs user and list regular, and won't attempt to deal with 
the real problem, but this might help, and the results should help pin 
down the problem a bit better as well, so...

So it's trying to restart a balance.

What happens if you try mounting with the skip_balance mount option?  
Will that let you mount writable without immediate crashing?

If that lets you mount, you can then btrfs balance cancel to cancel it 
entirely, so you won't have to skip_balance every time.

Of course that doesn't fix the real problem, but if it's the balance 
that's triggering the lockup, that should avoid that and hopefully let 
you run more or less normally, altho if you try to access whatever file 
or metadata the balance is choking on, you'd still be in trouble.  And 
the results should pin down whether it's the balance, or something else, 
triggering the problem.

Beyond that I'll leave for the real experts.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman


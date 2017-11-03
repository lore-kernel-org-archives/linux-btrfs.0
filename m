Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48147 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754742AbdKCH0k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Nov 2017 03:26:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eAWMz-0002FI-Sl
        for linux-btrfs@vger.kernel.org; Fri, 03 Nov 2017 08:26:25 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Fri, 3 Nov 2017 08:26:24 +0100
Message-ID: <20171103082624.5a2e12e9@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
        <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
        <20170914172434.39eae89d@jupiter.sol.kaishome.de>
        <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
        <59BBB15E.8010002@sarach.com.pl>
        <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
        <59BBDFA6.4020500@sarach.com.pl>
        <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
        <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
        <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
        <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
        <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
        <23033.512.820691.680916@tree.ty.sabi.co.uk>
        <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
        <20171102221610.006c1e9c@jupiter.sol.kaishome.de>
        <CAH=dxU636fRCN8-gm2fL6TBiT+-h0b8KZtzip9qQuSN5Dd13PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 2 Nov 2017 22:47:31 -0400
schrieb Dave <davestechshop@gmail.com>:

> On Thu, Nov 2, 2017 at 5:16 PM, Kai Krakow <hurikhan77@gmail.com>
> wrote:
> 
> >
> > You may want to try btrfs autodefrag mount option and see if it
> > improves things (tho, the effect may take days or weeks to apply if
> > you didn't enable it right from the creation of the filesystem).
> >
> > Also, autodefrag will probably unshare reflinks on your snapshots.
> > You may be able to use bees[1] to work against this effect. Its
> > interaction with autodefrag is not well tested but it works fine
> > for me. Also, bees is able to reduce some of the fragmentation
> > during deduplication because it will rewrite extents back into
> > bigger chunks (but only for duplicated data).
> >
> > [1]: https://github.com/Zygo/bees  
> 
> I will look into bees. And yes, I plan to try autodefrag. (I already
> have it enabled now.) However, I need to understand something about
> how btrfs send-receive works in regard to reflinks and fragmentation.
> 
> Say I have 2 snapshots on my live volume. The earlier one of them has
> already been sent to another block device by btrfs send-receive (full
> backup). Now defrag runs on the live volume and breaks some percentage
> of the reflinks. At this point I do an incremental btrfs send-receive
> using "-p" (or "-c") with the diff going to the same other block
> device where the prior snapshot was already sent.
> 
> Will reflinks be "made whole" (restored) on the receiving block
> device? Or is the state of the source volume replicated so closely
> that reflink status is the same on the target?
> 
> Also, is fragmentation reduced on the receiving block device?
> 
> My expectation is that fragmentation would be reduced and duplication
> would be reduced too. In other words, does send-receive result in
> defragmentation and deduplication too?

As far as I understand, btrfs send/receive doesn't create an exact
mirror. It just replays the block operations between generation
numbers. That is: If it finds new blocks referenced between
generations, it will write a _new_ block to the destination.

So, no, it won't reduce fragmentation or duplication. It just keeps
reflinks intact as long as such extents weren't touched within the
generation range. Otherwise they are rewritten as new extents.

Autodefrag and deduplication processes will as such probably increase
duplication at the destination. A developer may have a better clue, tho.


-- 
Regards,
Kai

Replies to list-only preferred.


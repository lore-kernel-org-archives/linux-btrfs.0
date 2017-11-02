Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43440 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S934407AbdKBVQ0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 17:16:26 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eAMqS-0004TW-TG
        for linux-btrfs@vger.kernel.org; Thu, 02 Nov 2017 22:16:12 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Thu, 2 Nov 2017 22:16:10 +0100
Message-ID: <20171102221610.006c1e9c@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
        <20170912162843.GA32233@rus.uni-stuttgart.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 31 Oct 2017 20:37:27 -0400
schrieb Dave <davestechshop@gmail.com>:

> > Also, you can declare the '.firefox/default/' directory to be
> > NOCOW, and that "just works".  
> 
> The cache is in a separate location from the profiles, as I'm sure you
> know.  The reason I suggested a separate BTRFS subvolume for
> $HOME/.cache is that this will prevent the cache files for all
> applications (for that user) from being included in the snapshots. We
> take frequent snapshots and (afaik) it makes no sense to include cache
> in backups or snapshots. The easiest way I know to exclude cache from
> BTRFS snapshots is to put it on a separate subvolume. I assumed this
> would make several things related to snapshots more efficient too.
> 
> As far as the Firefox profile being declared NOCOW, as soon as we take
> the first snapshot, I understand that it will become COW again. So I
> don't see any point in making it NOCOW.

Ah well, not really. The files and directories will still be nocow -
however, the next write to any such file after a snapshot will make a
cow operation. So you still see the fragmentation effect but to a much
lesser extent. But the files itself will remain in nocow format.

You may want to try btrfs autodefrag mount option and see if it
improves things (tho, the effect may take days or weeks to apply if you
didn't enable it right from the creation of the filesystem).

Also, autodefrag will probably unshare reflinks on your snapshots. You
may be able to use bees[1] to work against this effect. Its interaction
with autodefrag is not well tested but it works fine for me. Also, bees
is able to reduce some of the fragmentation during deduplication
because it will rewrite extents back into bigger chunks (but only for
duplicated data).

[1]: https://github.com/Zygo/bees


-- 
Regards,
Kai

Replies to list-only preferred.


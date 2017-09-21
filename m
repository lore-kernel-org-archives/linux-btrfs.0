Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38581 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdIUUKW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 16:10:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dv7nY-0002Gn-OM
        for linux-btrfs@vger.kernel.org; Thu, 21 Sep 2017 22:10:12 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: defragmenting best practice?
Date: Thu, 21 Sep 2017 22:10:13 +0200
Message-ID: <20170921221013.5576f90e@jupiter.sol.kaishome.de>
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
        <6ab6ffd8-a556-800d-b812-e5361b13ea8d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 20 Sep 2017 07:46:52 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> >      Fragmentation: Files with a lot of random writes can become
> > heavily fragmented (10000+ extents) causing excessive multi-second
> > spikes of CPU load on systems with an SSD or large amount a RAM. On
> > desktops this primarily affects application databases (including
> > Firefox). Workarounds include manually defragmenting your home
> > directory using btrfs fi defragment. Auto-defragment (mount option
> > autodefrag) should solve this problem.
> > 
> > Upon reading that I am wondering if fragmentation in the Firefox
> > profile is part of my issue. That's one thing I never tested
> > previously. (BTW, this system has 256 GB of RAM and 20 cores.)  
> Almost certainly.  Most modern web browsers are brain-dead and insist
> on using SQLite databases (or traditional DB files) for everything, 
> including the cache, and the usage for the cache in particular kills 
> performance when fragmentation is an issue.

At least in Chrome, you can turn on simple cache backend, which, I
think, is using many small instead of one huge file. This suit btrfs
much better:

chrome://flags/#enable-simple-cache-backend


And then I suggest also doing this (as your login user):

$ cd $HOME
$ mv .cache .cache.old
$ mkdir .cache
$ lsattr +C .cache
$ rsync -av .cache.old/ .cache/
$ rm -Rf .cache.old

This makes caches for most applications nocow. Chrome performance was
completely fixed for me by doing this.

I'm not sure where Firefox puts its cache, I only use it on very rare
occasions. But I think it's going to .cache/mozilla last time looked
at it.

You may want to close all apps before converting the cache directory.

Also, I don't see any downsides in making this nocow. That directory
could easily be also completely volatile. If something breaks due to no
longer protected by data csum, just clean it out.


-- 
Regards,
Kai

Replies to list-only preferred.


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56044 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754443AbdKARtI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 13:49:08 -0400
Received: from 82-132-219-145.dab.02.net ([82.132.219.145]:15435 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e9x8T-0003hY-GS
        for linux-btrfs@vger.kernel.org; Wed, 01 Nov 2017 17:49:05 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e9x8F-0007SA-NL
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 17:48:51 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23034.2305.527872.772343@tree.ty.sabi.co.uk>
Date: Wed, 1 Nov 2017 17:48:49 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: defragmenting best practice?
In-Reply-To: <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
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
From: pg@btfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> When defragmenting individual files on a BTRFS filesystem with
> COW, I assume reflinks between that file and all snapshots are
> broken. So if there are 30 snapshots on that volume, that one
> file will suddenly take up 30 times more space... [ ... ]

Defragmentation works by effectively making a copy of the file
contents (simplistic view), so the end result is one copy with
29 reflinked contents, and one copy with defragmented contents.

> Can you also give an example of using find, as you suggested
> above? [ ... ]

Well, one way is to use 'find' as a filtering replacement for
'defrag' option '-r', as in for example:

  find "$HOME" -xdev '(' -name '*.sqlite' -o -name '*.mk4' ')' \
    -type f  -print0 | xargs -0 btrfs fi defrag

Another one is to find the most fragmented files first or all
files of at least 1M with with at least say 100 fragments as in:

  find "$HOME" -xdev -type f -size +1M -print0 | xargs -0 filefrag \
    | perl -n -e 'print "$1\0" if (m/(.*): ([0-9]+) extents/ && $1 > 100)' \
    | xargs -0 btrfs fi defrag

But there are many 'find' web pages and that is not quite a
Btrfs related topic.

> [ ... ] The easiest way I know to exclude cache from
> BTRFS snapshots is to put it on a separate subvolume. I assumed this
> would make several things related to snapshots more efficient too.

Only slightly.

> Background: I'm not sure why our Firefox performance is so terrible

As I always say, "performance" is not the same as "speed", and
probably your Firefox "performance" is sort of OKish even if the
"speed" is terrile, and neither is likely related to the profile
or the cache being on Btrfs: most JavaScript based sites are
awfully horrible regardless of browser:

  http://www.sabi.co.uk/blog/13-two.html?130817#130817

and if Firefox makes a special contribution it tends to leak
memory on several odd but common cases:

  https://utcc.utoronto.ca/~cks/space/blog/web/FirefoxResignedToLeaks?showcomments

Plus it tends to cache too much, e.g. recently close tabs.

But Firefox is not special because most web browsers are not
designed to run for a long time without a restart, and
Chromium/Chrome simply have a different set of problem sites.
Maybe the new "Quantum" Firefox 57 will improve matters because
it has a far more restrictive plugin API.

The overall problem is insoluble, hipster UX designers will be
the second the the wall when the revolution comes :-).

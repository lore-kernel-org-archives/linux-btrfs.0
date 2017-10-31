Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:48100 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbdJaXHJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 19:07:09 -0400
Received: from 82-132-215-175.dab.02.net ([82.132.215.175]:9867 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e9fch-00077P-N4
        for linux-btrfs@vger.kernel.org; Tue, 31 Oct 2017 23:07:07 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e9fcI-0005OK-J7
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 23:06:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23033.512.820691.680916@tree.ty.sabi.co.uk>
Date: Tue, 31 Oct 2017 23:06:40 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: defragmenting best practice?
In-Reply-To: <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
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
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'm following up on all the suggestions regarding Firefox performance
> on BTRFS. [ ... ]

I haven't read that yet, so maybe I am missing something, but I
use Firefox with Btrfs all the time and I haven't got issues.

[ ... ]
> 1. BTRFS snapshots have proven to be too useful (and too important to
>    our overall IT approach) to forego.
[ ... ]
> 3. We have large amounts of storage space (and can add more), but not
>    enough to break all reflinks on all snapshots.

Firefox profiles get fragmented only in the databases containes
in them, and they are tiny, as in dozens of MB. That's usually
irrelevant.

Also nothing forces you to defragment a whole filesystem, you
can just defragment individual files or directories by using
'find' with it.

My top "$HOME" fragmented files are the aKregator RSS feed
databases, usually a few hundred fragments each, and the
'.sqlite' files for Firefox. Occasionally like just now I do
this:

  tree$  sudo filefrag .firefox/default/*.sqlite | sort -t: -k 2n | tail -4
  .firefox/default/cleanup.sqlite: 43 extents found
  .firefox/default/content-prefs.sqlite: 67 extents found
  .firefox/default/formhistory.sqlite: 87 extents found
  .firefox/default/places.sqlite: 3879 extents found

  tree$  sudo btrfs fi defrag .firefox/default/*.sqlite

  tree$  sudo filefrag .firefox/default/*.sqlite | sort -t: -k 2n | tail -4
  .firefox/default/webappsstore.sqlite: 1 extent found
  .firefox/default/favicons.sqlite: 2 extents found
  .firefox/default/kinto.sqlite: 2 extents found
  .firefox/default/places.sqlite: 44 extents found

> 2. Put $HOME/.cache on a separate BTRFS subvolume that is mounted
> nocow -- it will NOT be snapshotted

The cache can be simply deleted, and usually files in it are not
updated in place, so don't get fragmented, so no worry.

Also, you can declare the '.firefox/default/' directory to be
NOCOW, and that "just works". I haven't even bothered with that.

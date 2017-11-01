Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fenrir.routify.me ([155.94.238.126]:44952 "EHLO
        fenrir.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdKAHwy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 03:52:54 -0400
Date: Wed, 1 Nov 2017 00:43:38 -0700
From: Sean Greenslade <sean@seangreenslade.com>
To: Dave <davestechshop@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: defragmenting best practice?
Message-ID: <20171101074338.GA32211@coach>
References: <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
 <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl>
 <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
 <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 05:47:54PM -0400, Dave wrote:
> I'm following up on all the suggestions regarding Firefox performance
> on BTRFS. 
>
> <SNIP>
>
> 5. Firefox profile sync has not worked well for us in the past, so we
> don't use it.
> 6. Our machines generally have plenty of RAM so we could put the
> Firefox cache (and maybe profile) into RAM using a technique such as
> https://wiki.archlinux.org/index.php/Firefox/Profile_on_RAM. However,
> profile persistence is important.

> 4. Put the Firefox cache in RAM
> 
> 5. If needed, consider putting the Firefox profile in RAM

Have you looked into profile-sync-daemon?

https://wiki.archlinux.org/index.php/profile-sync-daemon

It basically does the "keep the profile in RAM but also sync it to HDD"
for you. I've used it for years, it works quite well.

--Sean


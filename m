Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:42563 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751636AbdIUTe5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 15:34:57 -0400
Date: Thu, 21 Sep 2017 12:28:29 -0700
In-Reply-To: <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de> <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com> <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com> <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com> <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de> <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com> <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: defragmenting best practice?
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
From: Sean Greenslade <sean@seangreenslade.com>
Message-ID: <5B24F020-5B02-41F2-915E-938CC79DC4C9@seangreenslade.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On September 19, 2017 11:38:13 PM PDT, Dave <davestechshop@gmail.com> wrote:
>>On Thu 2017-08-31 (09:05), Ulli Horlacher wrote:
> <snip>
>Here's my scenario. Some months ago I built an over-the-top powerful
>desktop computer / workstation and I was looking forward to really
>fantastic performance improvements over my 6 year old Ubuntu machine.
>I installed Arch Linux on BTRFS on the new computer (on an SSD). To my
>shock, it was no faster than my old machine. I focused a lot on
>Firefox performance because I use Firefox a lot and that was one of
>the applications in which I was most looking forward to better
>performance.
>
> <snip>
>
>What would you guys do in this situation?

Check out profile sync daemon:

https://wiki.archlinux.org/index.php/profile-sync-daemon

It keeps the active profile files in a ramfs, periodically syncing them back to disk. It works quite well on my 7 year old netbook.

--Sean


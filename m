From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Btrfs development plans
Date: Mon, 20 Apr 2009 10:39:21 -0700
Message-ID: <gsj87t$cvu$1@ger.gmane.org>
References: <1240238253.16213.48.camel@think.oraclecorp.com> <20090420153118.GB6195@mother.fordon.pl.eu.org> <3da3b5b40904200910x63e4e26cqe058ce0e4bc7f8c8@mail.gmail.com> <2a31deca0904200957v39badd2eu4b26844e78fdcde3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andrey Kuzmin wrote:

<snip>
> Personally, I don't see any. Porting zfs to Linux will cost (quite)
> some time and effort, but this is peanuts compared to what's needed to
> get btrfs  (no offense meant) to maturity level/feature parity with
> zfs. The only thing that could prevent this is CDDL licensing issues
> and patent claims from NTAP over zfs snapshots  and other features;
> btrfs is free from both.
<snip>

There's one thing you're overlooking: the core kernel developers have 
already stated that ZFS is a "rampant layering violation" and otherwise 
indicated they do not want ZFS in the Linux kernel, whereas BtrFS has
gotten a much more positive response. It may well be that on the /Oracle/ 
side, the political and technical problems with porting ZFS are smaller than 
those with finishing BtrFS, but if the kernel developers wouldn't accept it, 
_any_ money and effort spent on it would be wasted money and effort.



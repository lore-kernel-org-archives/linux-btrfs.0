From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [2.6.31-rc6, BTRFS] potential memory leaks...
Date: Sun, 16 Aug 2009 22:38:47 +0100
Message-ID: <1250458727.8085.6.camel@pc1117.cambridge.arm.com>
References: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
	 <tnxab228ibo.fsf@pc1117.cambridge.arm.com>
	 <6278d2220908160555m2aba699euf2133e07c1626941@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6278d2220908160555m2aba699euf2133e07c1626941@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-08-16 at 13:55 +0100, Daniel J Blueman wrote:
> On Fri, Aug 14, 2009 at 5:35 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> > Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> >> There is good chance that the BTRFS kmemleak reports using 2.6.31-rc6
> >> [1] are false-positives, due to the overwriting of the static pointers
> >> [2]. Does this ring true with anyone else?
> >
> > If you do a few echo scan > /sys/kernel/debug/kmemleak, do they
> > disappear?
> >
> > The static pointers are scanned by kmemleak, unless they are in the
> > .data.init section (which is removed anyway).
> 
> The above reports I picked _are_ transient indeed.

In earlier versions of kmemleak, a block required two successive
classifications as leak before being reported. Maybe I should go back to
this approach.

> Directed more to LKML, every mount (at least on ext4 and BTRFS), we do
> see persistent reports [1], even after scanning, unmount and more
> scanning.

The ext4 leak is real and a patch was proposed here:
http://lkml.org/lkml/2009/7/15/62

It seems that this patch hasn't been merged into mainline yet (in the
meantime I merged it in my "kmemleak-fixes" branch on
git://linux-arm.org/linux-2.6.git)

-- 
Catalin


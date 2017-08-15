Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55592 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751494AbdHOMtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Aug 2017 08:49:31 -0400
Date: Tue, 15 Aug 2017 14:48:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Hallo32 <Hallo32@gmx.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, kreijack@inwind.it, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs-v4.12: cross compiling
Message-ID: <20170815124807.GZ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
 <20170814130608.GS2866@twin.jikos.cz>
 <46edbc7c-8bd9-0507-950e-be5182356772@gmx.com>
 <20170814140341.GU2866@suse.cz>
 <159b3db0-6eae-7cff-d166-3c4b0c2513ac@gmx.com>
 <20170814151052.GV2866@twin.jikos.cz>
 <340e3677-4abd-5390-58bb-a64160a31862@libero.it>
 <880007a9-4882-e4a6-7411-a262e5296ab0@gmx.com>
 <082833d5-8f2a-6ed6-fa22-042a161a0dec@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <082833d5-8f2a-6ed6-fa22-042a161a0dec@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 15, 2017 at 02:44:07PM +0200, Hallo32 wrote:
> Am 15.08.2017 um 01:39 schrieb Qu Wenruo:
> > On 2017年08月15日 02:57, Goffredo Baroncelli wrote:
> >> On 08/14/2017 05:10 PM, David Sterba wrote:
> >>> On Mon, Aug 14, 2017 at 10:14:42PM +0800, Qu Wenruo wrote:
> >> [...]
> >>> mktables.c is synced from kernel sources, taking updates from there is
> >>> easier than porting any changes to the proposed scripted 
> >>> implementation.
> >>>
> >>> The workflow is simple:
> >>> - copy kernel mktables.c changes to btrfs-progs mktables.c
> >>
> >> How the kernel deals with this kind of problem ?
> >> Looking at the source of btrfs Makefile, it is more simple to replace
> >>
> >>    mktables: kernel-lib/mktables.c
> >>          @echo "    [CC]     $@"
> >>          $(Q)$(CC) $(CFLAGS) $< -o $@
> >>
> >> with
> >>
> >>
> >>    mktables: kernel-lib/mktables.c
> >>          @echo "    [HOSTCC] $@"
> >>          $(Q)$(HOSTCC) $(CFLAGS) $< -o $@
> >>
> >> where HOSTCC is defined as
> >>
> >> HOSTCC=gcc
> >>
> >>
> >> (may be the same applied also to CFLAGS <-> HOSTCFLAGS ?)
> >
> > If using HOSTCC then I'm fine with it.
> 
> CFLAGS needs also be replaced by something like HOSTCFLAGS, because if 
> you use something like mips/architecture specific CFLAGS, they may be 
> not applicably on the host system.

Good point. Without a regular/automated cross-compilation build testing
I think we could break it quite easily. I'm going to keep the
pregenerated file in git.

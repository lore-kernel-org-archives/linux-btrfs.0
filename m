Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44109 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750876AbdHNOFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 10:05:04 -0400
Date: Mon, 14 Aug 2017 16:03:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Hallo32 <Hallo32@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs-v4.12: cross compiling
Message-ID: <20170814140341.GU2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <e8d480c6-758e-0e7d-a024-e9d12d7bf852@gmx.net>
 <20170814130608.GS2866@twin.jikos.cz>
 <46edbc7c-8bd9-0507-950e-be5182356772@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <46edbc7c-8bd9-0507-950e-be5182356772@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 09:17:08PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年08月14日 21:06, David Sterba wrote:
> > On Mon, Aug 14, 2017 at 02:17:26PM +0200, Hallo32 wrote:
> >> Since versions 4.12 btrfs-progs is complicated to cross compile for
> >> other systems.
> >> The problem is, that this version includes mktables, which needs to be
> >> compiled for the host system and executed there for the creation of
> >> tables.c.
> >>
> >> Are there any changes planed for the next version of btrfs-progs to make
> >> the cross compiling as simple as in the past? A included tables.c for
> >> example?
> > 
> > Yes, keeping the generated tables.c around is fine. There's no reason it
> > needs to be generated each time during build. I'll fix that in 4.12.1.
> 
> But the number of lines and impossibility to review it makes it not 
> suitable to be managed by git.

I don't understand your concern. The file is generated from a set of
formulas, not intended to be updated directly.
> 
> What about using script to generate it?

We do have the mktables utility to generate it and I'll regenerate it
should there be a change to kernel-lib/mktables.c

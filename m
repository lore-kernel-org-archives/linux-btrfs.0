Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaJ0Pfe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 11:35:34 -0400
Date: Mon, 27 Oct 2014 16:35:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: suspicious number of devices: 72057594037927936
Message-ID: <20141027153532.GF22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <alpine.DEB.2.19.4.1410270333250.9302@trent.utfs.org>
 <CAL3q7H4MbLCVXxLzT5d4vim1pp8ffZRsLX2GwDqgXNK3p5+sLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4MbLCVXxLzT5d4vim1pp8ffZRsLX2GwDqgXNK3p5+sLg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 27, 2014 at 10:57:59AM +0000, Filipe David Manana wrote:
> > The only thing fancy may be the machine: PowerBook G4 (powerpc 32 bit),
> > running Debian/Linux (stable).
> >
> > The message comes from the newly added fs/btrfs/disk-io.c:
> >
> > if (sb->num_devices > (1UL << 31))
> >      printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
> >               sb->num_devices);
> >
> > And 72057594037927936 is 2^56, so maybe there's an endianess problem here?
> 
> Sounds like you need to revert this patch:
> https://patchwork.kernel.org/patch/5004701/ (which ignored endianess)
> or go back to an older kernel (don't use 3.17 or 3.17.1 however, due
> to other serious issues, latest 3.16.x should be safe). There's a v2
> of that patch that fixes the endianess issue, but it didn't make it to
> 3.18-rc1/2 (https://patchwork.kernel.org/patch/5082701/)

Yeah sorry, I sent the v2 too late, here's an incremental that applies
on top of current 3.18-rc

https://patchwork.kernel.org/patch/5160651/

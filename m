Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758753AbcCDJQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 04:16:19 -0500
Date: Fri, 4 Mar 2016 10:16:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Will Deacon <will.deacon@arm.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs_get_token_64() alignment problem on ARM (was: Re: DWord
 alignment on ARMv7)
Message-ID: <20160304091602.GH29310@suse.cz>
Reply-To: dsterba@suse.cz
References: <56D8BA3F.7050508@pengutronix.de>
 <20160303235426.GA11237@arm.com>
 <56D940E8.2030202@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D940E8.2030202@pengutronix.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 04, 2016 at 09:01:44AM +0100, Marc Kleine-Budde wrote:
> Hello,
> 
> On 03/04/2016 12:54 AM, Will Deacon wrote:
> > Hi Marc,
> > 
> > On Thu, Mar 03, 2016 at 11:27:11PM +0100, Marc Kleine-Budde wrote:
> >> I'm using btrfs on am ARMv7 and it turns out, that the kernel has to
> >> fixup a lot of kernel originated alignment issues.
> >>
> >> See /proc/cpu/alignment (~4h of uptime):
> >>> System: 22304815 (btrfs_get_token_64+0x13c/0x148 [btrfs])
> >>
> >> For example, when compiling the kernel on a btrfs volume the counter
> >> increases by 100...1000 per second.
> >>
> >> The function shown "btrfs_get_token_64()" is defined here:
> >>> http://lxr.free-electrons.com/source/fs/btrfs/struct-funcs.c#L53
> >> ...it already uses get_unaligned_leXX accessors.
> >>
> >> Quoting a comment in arch/arm/mm/alignment.c:
> >>
> >>          * ARMv6 and later CPUs can perform unaligned accesses for
> >>          * most single load and store instructions up to word size.
> >>          * LDM, STM, LDRD and STRD still need to be handled.
> >>
> >> But on a 32bit ARMv7 64bits are not word-sized.
> >>
> >> Is the exception and fixup overhead neglectable? Do we have to introduce
> >> something like HAVE_EFFICIENT_UNALIGNED_64BIT_ACCESS?
> > 
> > Ouch, that trap/emulate is certainly going to have an effect on your
> > performance. I doubt that HAVE_EFFICIENT_UNALIGNED_ACCESS applies to
> > types bigger than the native word size on many architectures, so my
> > hunch is that the btrfs code should be checking BITS_PER_LONG or similar
> > to establish whether or not to break the access up into word accesses.
> 
> I've added the btrfs maintainers on Cc.

Can this be done transparently via the the get_unaligned_le* helpers?
This seems to be too arch-specific to fix it in btrfs.

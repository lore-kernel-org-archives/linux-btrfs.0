Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbcG1SEe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 14:04:34 -0400
Date: Thu, 28 Jul 2016 20:04:13 +0200
From: David Sterba <dsterba@suse.cz>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Anatoly Pugachev <matorola@gmail.com>,
        debian-sparc <debian-sparc@lists.debian.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
Message-ID: <20160728180413.GY30795@suse.cz>
Reply-To: dsterba@suse.cz
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz>
 <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz>
 <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
 <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 04:28:41PM +0200, John Paul Adrian Glaubitz wrote:
> On 07/28/2016 04:25 PM, John Paul Adrian Glaubitz wrote:
> > On 07/28/2016 04:01 PM, Anatoly Pugachev wrote:
> >> Program received signal SIGBUS, Bus error.
> >> 0x0000000000177dfc in raid6_gen_syndrome (disks=4, bytes=65536,
> >> ptrs=0x2c4510) at raid6.c:87
> >> 87                      wq0 = wp0 = *(unative_t *)&dptr[z0][d+0*NSIZE];
> > 
> > That should be easy to fix. Just make the R values aligned with the
> > appropriate get_aligned functions, see David's previous commit [1]:
> 
> Argh, those are called get_UNaligned_*, not get_aligned_*.
> 
> > There are more lines in raid6.c which need the same fix, basically everything
> > with * (unative_t *).
> 
> Oh, and you will somehow need to guard this with #if BITS_PER_LONG == 64 ...
> #else ... #endif respectively since you need to use different versions
> (64 vs. 32) of get_unaligned_* depending on the size of unative_t.

And I've fixed it that way, now pushed to devel ("btrfs-progs: fix
unaligned access in raid6 calculations" [1]). Would be great if you or
Anatoly can test it so I can add it to the 4.7 release (ETA tomorrow).

[1] https://github.com/kdave/btrfs-progs/commit/44b35e94facf820d2c2d8e1be631bf40d68dff8d

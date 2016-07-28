Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:44594 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758244AbcG1O2o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 10:28:44 -0400
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: Anatoly Pugachev <matorola@gmail.com>, dsterba@suse.cz
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <20160727195609.GN30795@twin.jikos.cz> <20160728094441.GO30795@twin.jikos.cz>
 <CADxRZqwTUaZyDipvmGcfk8Q9P2X_NLQ=9svtc8BbKeFqoFVPdw@mail.gmail.com>
 <5cef3bff-a0bf-e4f9-7906-1b784171e266@physik.fu-berlin.de>
 <20160728122439.GW30795@twin.jikos.cz>
 <CADxRZqyzOtHmpaO9FHhvi0DJjmabRYL0eGYBXBPXSaYa0WcWEw@mail.gmail.com>
 <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
Cc: debian-sparc <debian-sparc@lists.debian.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <b2ac0d76-f2e3-81d7-0ab1-35960426d412@physik.fu-berlin.de>
Date: Thu, 28 Jul 2016 16:28:41 +0200
MIME-Version: 1.0
In-Reply-To: <f56a1b71-cd68-3d83-0650-a10df01f5d5c@physik.fu-berlin.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/28/2016 04:25 PM, John Paul Adrian Glaubitz wrote:
> On 07/28/2016 04:01 PM, Anatoly Pugachev wrote:
>> Program received signal SIGBUS, Bus error.
>> 0x0000000000177dfc in raid6_gen_syndrome (disks=4, bytes=65536,
>> ptrs=0x2c4510) at raid6.c:87
>> 87                      wq0 = wp0 = *(unative_t *)&dptr[z0][d+0*NSIZE];
> 
> That should be easy to fix. Just make the R values aligned with the
> appropriate get_aligned functions, see David's previous commit [1]:

Argh, those are called get_UNaligned_*, not get_aligned_*.

> There are more lines in raid6.c which need the same fix, basically everything
> with * (unative_t *).

Oh, and you will somehow need to guard this with #if BITS_PER_LONG == 64 ...
#else ... #endif respectively since you need to use different versions
(64 vs. 32) of get_unaligned_* depending on the size of unative_t.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

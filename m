Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:47618 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757334AbcG0Uku (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 16:40:50 -0400
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: Anatoly Pugachev <matorola@gmail.com>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <2844b246-52ab-ecd8-334b-11b6fd7c246e@physik.fu-berlin.de>
Date: Wed, 27 Jul 2016 22:40:46 +0200
MIME-Version: 1.0
In-Reply-To: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/27/2016 03:59 PM, Anatoly Pugachev wrote:
> Program received signal SIGBUS, Bus error.
> 0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
> eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570) at
> volumes.c:2156
> 2156                                    *(unsigned long *)(p_eb->data + i) ^=

Well, that pretty much looks some creative pointer arithmetics that will provoke
unaligned access. Just check what the declaration of p_eb->data is. If it's
not "unsigned long", then you know why the code breaks here.

You should be able to fix this issue by replacing the code line with:

unsigned long tmp;
memcpy(&tmp, &(ebs[j]->data + i), sizeof(unsigned long));
tmp ^= tmp;
memcpy(&(p_eb->data + i), &tmp, sizeof(unsigned long));

I'm currently not sure whether this can be done more elegantly without
provoking unaligned access due to the bitwise XOR (^). In either case,
your problem is the casting and using memcpy() should fix the problem.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

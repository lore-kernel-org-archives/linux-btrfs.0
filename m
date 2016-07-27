Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33797 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbcG0Us3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 16:48:29 -0400
Received: by mail-qt0-f194.google.com with SMTP id c52so2298167qte.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 13:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2844b246-52ab-ecd8-334b-11b6fd7c246e@physik.fu-berlin.de>
References: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
 <2844b246-52ab-ecd8-334b-11b6fd7c246e@physik.fu-berlin.de>
From: Patrick Baggett <baggett.patrick@gmail.com>
Date: Wed, 27 Jul 2016 15:48:28 -0500
Message-ID: <CAEk2StkGxyBOL6hSs54Uh=FkJuAdBMuiH28bWYBXXknt4dM1TQ@mail.gmail.com>
Subject: Re: [sparc64] mkfs.btrfs bus error / align issue?
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Anatoly Pugachev <matorola@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        debian-sparc <debian-sparc@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 27, 2016 at 3:40 PM, John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On 07/27/2016 03:59 PM, Anatoly Pugachev wrote:
>> Program received signal SIGBUS, Bus error.
>> 0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
>> eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570) at
>> volumes.c:2156
>> 2156                                    *(unsigned long *)(p_eb->data + i) ^=
>
> Well, that pretty much looks some creative pointer arithmetics that will provoke
> unaligned access. Just check what the declaration of p_eb->data is. If it's
> not "unsigned long", then you know why the code breaks here.
>

Yeah, so basically, the best solution (assuming you can't change the
alignment of `data` somehow) would look something like:

Compare lower 'n' bits of `data` pointers (n=2 for ILP32, n=3 for
LP64), something like (data1 & sizeof(long)-1) == (data2 &
sizeof(long)-1). If they are equal, fast loop possible. Not equal ->
slow loop (all byte-by-byte copy).

fast loop path:
do byte-by-byte XOR until lower n bits of (data+i) are zero.

do word-by-word XOR until < 1 word

do byte-by-bye XOR until last bytes done.

This sort of processing is pretty standard for "chunking". If this was
done with some cool SIMD instruction set, it would have similar sort
of approach, I'd imagine.

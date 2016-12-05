Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751592AbcLESLs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Dec 2016 13:11:48 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 69999203B6
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Dec 2016 18:11:46 +0000 (UTC)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com [209.85.213.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1054A20251
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Dec 2016 18:11:45 +0000 (UTC)
Received: by mail-vk0-f52.google.com with SMTP id 137so183373279vkl.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Dec 2016 10:11:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com> <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com> <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk> <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com> <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk> <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 5 Dec 2016 10:11:23 -0800
Message-ID: <CALCETrX9+eS3KYdN2UBvmBsMhKr3f-PBSC8UHqrnK8WhE6_guw@mail.gmail.com>
Subject: Re: bio linked list corruption.
To: Vegard Nossum <vegard.nossum@gmail.com>, Borislav Petkov <bp@alien8.de>
Cc: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 4, 2016 at 3:04 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On 23 November 2016 at 20:58, Dave Jones <davej@codemonkey.org.uk> wrote:
>> On Wed, Nov 23, 2016 at 02:34:19PM -0500, Dave Jones wrote:
>>
>>  > [  317.689216] BUG: Bad page state in process kworker/u8:8  pfn:4d8fd4
>>  > trace from just before this happened. Does this shed any light ?
>>  >
>>  > https://codemonkey.org.uk/junk/trace.txt
>>
>> crap, I just noticed the timestamps in the trace come from quite a bit
>> later.  I'll tweak the code to do the taint checking/ftrace stop after
>> every syscall, that should narrow the window some more.
>
> FWIW I hit this as well:
>
> BUG: unable to handle kernel paging request at ffffffff81ff08b7

We really ought to improve this message.  If nothing else, it should
say whether it was a read, a write, or an instruction fetch.

> IP: [<ffffffff8135f2ea>] __lock_acquire.isra.32+0xda/0x1a30
> PGD 461e067 PUD 461f063
> PMD 1e001e1

Too lazy to manually decode this right now, but I don't think it matters.

> Oops: 0003 [#1] PREEMPT SMP KASAN

Note this is SMP, but that just means CONFIG_SMP=y.  Vegard, how many
CPUs does your kernel think you have?

> RIP: 0010:[<ffffffff8135f2ea>]  [<ffffffff8135f2ea>]
> __lock_acquire.isra.32+0xda/0x1a30
> RSP: 0018:ffff8801bab8f730  EFLAGS: 00010082
> RAX: ffffffff81ff071f RBX: 0000000000000000 RCX: 0000000000000000

RAX points to kernel text.

> Code: 89 4d b8 44 89 45 c0 89 4d c8 4c 89 55 d0 e8 ee c3 ff ff 48 85
> c0 4c 8b 55 d0 8b 4d c8 44 8b 45 c0 4c 8b 4d b8 0f 84 c6 01 00 00 <3e>
> ff 80 98 01 00 00 49 8d be 48 07 00 00 48 ba 00 00 00 00 00

  2b:    3e ff 80 98 01 00 00     incl   %ds:*0x198(%rax)        <--
trapping instruction

That's very strange.  I think this is:

atomic_inc((atomic_t *)&class->ops);

but my kernel contains:

    3cb4:       f0 ff 80 98 01 00 00    lock incl 0x198(%rax)

So your kernel has been smp-alternatived.  That 3e comes from
alternatives_smp_unlock.  If you're running on SMP with UP
alternatives, things will break.

What's your kernel command line?  Can we have your entire kernel log from boot?

Adding Borislav, since he's the guru for this code.

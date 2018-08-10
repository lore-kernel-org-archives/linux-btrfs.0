Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:42230 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727288AbeHJNMM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 09:12:12 -0400
Received: by mail-oi0-f46.google.com with SMTP id b16-v6so14974662oic.9
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 03:42:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
 <06f0c899-bb33-54d5-8a87-20f138642f70@gmx.com> <CAPL5yKdhTAZjG00xwd=2Z7PsNO7ixBY9gTYMS6c2-7DSBeMapA@mail.gmail.com>
 <6389f50e-3ce5-1f3d-0c2c-d169cf431b57@gmx.com> <CAPL5yKfPvmJKtgLTtpAAh_DJ91_M-_mUeX_upQ0-rgO4XwJZDA@mail.gmail.com>
 <e3b0929f-9415-5816-2a68-0e46f11454ba@gmx.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Fri, 10 Aug 2018 06:42:51 -0400
Message-ID: <CAPL5yKds7f2NeGqBx_+LP62FU-EOge74DeW=VJGocDbiZHoztw@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 10, 2018 at 6:05 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>
> Although not sure about the details, but the fs looks pretty huge.
> Tons of subvolume and its free space cache inodes.

11TB, 3 or so subvolumes and two snapshots I think.  Not particularly
large for NAS.

> But only 3 tree reloc trees, unless you have tons of reflinked files
> (off-line deduped), it shouldn't cause a lot of problem.

There's going to be a ton of reflinked files.  Both cp --reflink and
via the wholefile dedup.

I freed up ~1/2 TB last month doing dedup.

> At least, we have some progress dropping tree reloc tree for subvolume 6482.

Is there a way to get an idea of how much work is left to be done on
the reloc tree?  Can I walk it
with btrfs-inspect?

dump-tree -t TREE_RELOC is quite enormous (13+ million lines before I gave up)

> If you check the dump-tree output for the following data, the "drop key"
> should change during mount: (inspect dump-tree can be run mounted)
>         item 175 key (TREE_RELOC ROOT_ITEM 6482) itemoff 8271 itemsize 439
>                 <snip>
>                 drop key (2769795 EXTENT_DATA 12665933824) level 2
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> So for the worst case scenario, there is some way to determine whether
> it's processing.

I'll keep an eye on that.

> And according to the level (3), which is not small for each subvolume, I
> doubt that's the reason why it's so slow.
>
> BTW, for last skip_balance mount, is there any kernel message like
> "balance: resume skipped"?

No, the only reference to balance in kern.log is a hung
btrfs_cancel_balance from the first reboot.

> Have you tried mount the fs readonly with skip_balance? And then remount
> rw, still with skip_balance?

No, every operation takes a long time.  It's still running the btrfs
check, although I'm
going to cancel it and try mount -o ro,skip_balance before I go to
sleep and see where it is tomorrow.

Thank you for taking the time to help me with this.

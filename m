Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:48027 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbdJOIbe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Oct 2017 04:31:34 -0400
Received: by mail-it0-f41.google.com with SMTP id p138so15809257itp.2
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Oct 2017 01:31:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
From: =?UTF-8?B?Wm9sdMOhbiBJdsOhbmZp?= <zoltan1980@gmail.com>
Date: Sun, 15 Oct 2017 10:30:52 +0200
Message-ID: <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for the replies.

As you both pointed out, I shouldn't have described the issue having
to do with hotplugging. I got confused by this use-case being somewhat
emphasized in the description of the bug I linked to. As for the
question of why I think that I got bitten by that bug in particular:
It matches my experiences as I can recall them (used RAID on SATA+USB,
got bio too big device error messages, data got corrupted).

You assumed correctly that what I really wanted to ask about was btrfs
on SATA+USB, thanks for answering that questions as well. Based on
your replies I feel assured that btrfs should not be affected by this
particular issue due to operating on the filesystem level and not on
the block device level; but USB connectivity issues can still lead to
problems.

Do these USB connectivity issues lead to data corruption? Naturally
for raid0 they will, but for raid1 I suppose they shouldn't as one
copy of the data remains intact.

Thanks,

Zoltan

On Sat, Oct 14, 2017 at 9:00 PM, Zoltán Ivánfi <zoltan1980@gmail.com> wrote:
> Dear Btrfs Experts,
>
> A few years ago I tried to use a RAID1 mdadm array of a SATA and a USB
> disk, which lead to strange error messages and data corruption. I did
> some searching back then and found out that using hot-pluggable
> devices with mdadm is a paved road to data corruption. Reading through
> that old bug again I see that it was autoclosed due to old age but
> still hasn't been addressed:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/320638
>
> I would like to ask whether btrfs may also be prone to data corruption
> issues in this scenario (due to the same underlying issue as the one
> described in the bug above for mdadm), or is btrfs unaffected by the
> underlying issue and is safe to use with a mix of regular and
> hot-pluggable devices as well?
>
> Thanks,
>
> Zoltan

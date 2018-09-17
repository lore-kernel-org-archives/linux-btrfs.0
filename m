Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f177.google.com ([209.85.208.177]:33365 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbeIQRWl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 13:22:41 -0400
Received: by mail-lj1-f177.google.com with SMTP id s12-v6so12906455ljj.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 04:55:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
 <cbb66b3b-1b21-cb3c-c446-c44e861f36bc@gmx.com> <CAMrg+aTNK1cBG7rGVfudpydD6hMJz9UW0-3mdS8Yx4tqAQZE6Q@mail.gmail.com>
 <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com>
In-Reply-To: <ecac52ad-70ed-e0e3-5660-1717f0d4f5e0@gmx.com>
From: Adrian Bastholm <adrian@javaguru.org>
Date: Mon, 17 Sep 2018 13:55:05 +0200
Message-ID: <CAMrg+aTtyOSOnZMj+4q13f7pv9wMydFgTDZ5KLbQSRz8HHcbKw@mail.gmail.com>
Subject: Re: btrfs problems
To: quwenruo.btrfs@gmx.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Well, I'd say Debian is really not your first choice for btrfs.
> The kernel is really old for btrfs.
>
> My personal recommend is to use rolling release distribution like
> vanilla Archlinux, whose kernel is already 4.18.7 now.

I just upgraded to Debian Testing which has the 4.18 kernel

> Anyway, enjoy your stable fs even it's not btrfs anymore.

My new stable fs is too rigid. Can't grow it, can't shrink it, can't
remove vdevs from it , so I'm planning a comeback to BTRFS. I guess
after the dust settled I realize I like the flexibility of BTRFS.


 This time I'm considering BTRFS as rootfs as well, can I do an
in-place conversion ? There's this guide
(https://www.howtoforge.com/how-to-convert-an-ext3-ext4-root-file-system-to-btrfs-on-ubuntu-12.10)
I was planning on following.

Another thing is I'd like to see a "first steps after getting started
" section in the wiki. Something like take your first snapshot, back
up, how to think when running it - can i just set some cron jobs and
forget about it, or does it need constant attention, and stuff like
that.

BR Adrian


-- 
Vänliga hälsningar / Kind regards,
Adrian Bastholm

``I would change the world, but they won't give me the sourcecode``

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36545 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdHGCZa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Aug 2017 22:25:30 -0400
Received: by mail-wm0-f49.google.com with SMTP id t201so57461213wmt.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Aug 2017 19:25:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANT5p=rpTpO8svMzkbtQEb0_CK=OjS5gr55nNdyTjFbbeOAGrA@mail.gmail.com>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
 <20170804060007.blgcu5khfo4juwfe@angband.pl> <CANT5p=qvu9tCf73+_PuAj9Ryy69p3JjAyHFY_pAA9eUsTz_ELA@mail.gmail.com>
 <20170804072229.4h534hr54ne3d764@angband.pl> <CANT5p=r9gMUu1F8Vkgs6=O1UBfBLn=96XAZBzB6OsHnSQw0C5A@mail.gmail.com>
 <20170804145401.78e50990@job> <CANT5p=rpTpO8svMzkbtQEb0_CK=OjS5gr55nNdyTjFbbeOAGrA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 6 Aug 2017 20:25:28 -0600
Message-ID: <CAJCQCtSScyxYSObrLo4MwZqiJiuKsudne+fAtoJPmtJdZ4kDhg@mail.gmail.com>
Subject: Re: Power down tests...
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 4, 2017 at 6:09 AM, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> Thanks guys. I've enabled that option now. Let's see how it goes.
> One general question regarding the stability of btrfs in kernel
> version 4.4. Is this okay for power off test cases? Or are there many
> important fixes in newer kernels?


$ git log --grep=power tags/v4.4...tags/v4.12 -- fs/btrfs

The answer is yes there are power failure related fixes since 4.4. I
can't tell you off hand to what degree they're backported, you'd have
to do a search with whatever specific sub version of 4.4 you're using.



-- 
Chris Murphy

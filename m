Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43795 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbeIPX70 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 19:59:26 -0400
Received: by mail-lj1-f193.google.com with SMTP id m84-v6so11286710lje.10
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2018 11:35:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
References: <CAMrg+aRfS0NymyKo2Wwk75+TVBBbGPshnG_Yku403CwnhsimxQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 16 Sep 2018 12:35:35 -0600
Message-ID: <CAJCQCtRx7gL+EYKGa1GaM6Q8B=c_gcEixMrRYRb5FdbVDnxBJg@mail.gmail.com>
Subject: Re: btrfs problems
To: Adrian Bastholm <adrian@javaguru.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 16, 2018 at 7:58 AM, Adrian Bastholm <adrian@javaguru.org> wrote:
> Hello all
> Actually I'm not trying to get any help any more, I gave up BTRFS on
> the desktop, but I'd like to share my efforts of trying to fix my
> problems, in hope I can help some poor noob like me.

There's almost no useful information provided for someone to even try
to reproduce your results, isolate cause and figure out the bugs.

No kernel version. No btrfs-progs version. No description of the
hardware and how it's laid out, and what mkfs and mount options are
being used. No one really has the time to speculate.


>BTRFS check --repair is not recommended

Right. So why did you run it anyway?

man btrfs check:

Warning
           Do not use --repair unless you are advised to do so by a
developer or an experienced user


It is always a legitimate complaint, despite this warning, if btrfs
check --repair makes things worse, because --repair shouldn't ever
make things worse. But Btrfs repairs are complicated, and that's why
the warning is there. I suppose the devs could have made the flag
--riskyrepair but I doubt this would really slow users down that much.
A big part of --repair fixes weren't known to make things worse at the
time, and edge cases where it made things worse kept popping up, so
only in hindsight does it make sense --repair maybe could have been
called something different to catch the user's attention.

But anyway, I see this same sort of thing on the linux-raid list all
the time. People run into trouble, and they press full forward making
all kinds of changes, each change increases the chance of data loss.
And then they come on the list with WTF messages. And it's always a
lesson in patience for the list regulars and developers... if only
you'd come to us with questions sooner.

> Please have a look at the console logs.

These aren't logs. It's a record of shell commands. Logs would include
kernel messages, ideally all of them. Why is device 3 missing? We have
no idea. Most of Btrfs code is in the kernel, problems are reported by
the kernel. So we need kernel messages, user space messages aren't
enough.

Anyway, good luck with openzfs, cool project.


-- 
Chris Murphy

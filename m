Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:39945 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeIOMQP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Sep 2018 08:16:15 -0400
MIME-Version: 1.0
References: <CAJDTihzzLV3qwg0tGH_D4xAjCrgMy+oc4H9snpnMC_RC2q7nyw@mail.gmail.com>
 <20180914222336.GD16550@dastard>
In-Reply-To: <20180914222336.GD16550@dastard>
From: =?UTF-8?B?54Sm5pmT5Yas?= <milestonejxd@gmail.com>
Date: Sat, 15 Sep 2018 14:58:07 +0800
Message-ID: <CAJDTihx2MEpdWdp6V6AsOD35Lh_6R=uFXBGtO8fL8s0o5C_t8Q@mail.gmail.com>
Subject: Re: metadata operation reordering regards to crash
To: david@fromorbit.com, cmumford@cmumford.com, linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 15, 2018 at 6:23 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Sep 14, 2018 at 05:06:44PM +0800, 焦晓冬 wrote:
> > Hi, all,
> >
> > A probably bit of complex question:
> > Does nowadays practical filesystems, eg., extX, btfs, preserve metadata
> > operation order through a crash/power failure?
>
> Yes.
>
> Behaviour is filesystem dependent, but we have tests in fstests that
> specifically exercise order preservation across filesystem failures.
>
> > What I know is modern filesystems ensure metadata consistency
> > after crash/power failure. Journal filesystems like extX do that by
> > write-ahead logging of metadata operations into transactions. Other
> > filesystems do that in various ways as btfs do that by COW.
> >
> > What I'm not so far clear is whether these filesystems preserve
> > metadata operation order after a crash.
> >
> > For example,
> > op 1.  rename(A, B)
> > op 2.  rename(C, D)
> >
> > As mentioned above,  metadata consistency is ensured after a crash.
> > Thus, B is either the original B(or not exists) or has been replaced by A.
> > The same to D.
> >
> > Is it possible that, after a crash, D has been replaced by C but B is still
> > the original file(or not exists)?
>
> Not for XFS, ext4, btrfs or f2fs. Other filesystems might be
> different.

Thanks, Dave,

I found this archive:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31937.html

It seems btrfs people thinks reordering could happen.

It is a relatively old reply. Has the implement changed? Or is there
some new standard that requires reordering not happen?

> Cheers,
>
> Dave,
> --
> Dave Chinner
> david@fromorbit.com

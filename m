Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35494 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbcITUCH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 16:02:07 -0400
Received: by mail-oi0-f49.google.com with SMTP id w11so35499532oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 13:02:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8b497ae5-7ed4-e22a-3f8c-fc3cb2d705df@gmail.com>
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com> <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com> <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com> <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
 <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com> <CAJCQCtQT=j+P=Dy=VtNOBGkpwenK0AngB2k5xk40BE=hZnEfjA@mail.gmail.com>
 <df35fe50-8195-b2b9-e6d9-687b0c883a28@gmail.com> <689d4d03-a122-502d-fda0-8b055ee4a182@gmail.com>
 <8b497ae5-7ed4-e22a-3f8c-fc3cb2d705df@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Sep 2016 14:02:05 -0600
Message-ID: <CAJCQCtQUPxZHof4feS9Oxkm-tPUAc=gOib3Hf98W-j0ww59uwQ@mail.gmail.com>
Subject: Re: multi-device btrfs with single data mode and disk failure
To: Alexandre Poux <pums974@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 1:54 PM, Alexandre Poux <pums974@gmail.com> wrote:
>
> OK, good idea, but to be able to do that, I have to use the patch that
> allow me to mount the partition in rw, otherwise I won't be able to
> shrink it I suppose..
> And even with the patch I'm not sure that I won't get an IO error the
> same way I get it when I try to remove the device.
> I will try it on my virtual machine.

The shrink itself is pretty trivial in that its just moving block
groups around if necessary, it's part of the balance code, there's not
much metadata being changed, just CoW the block groups, and then
update the chunk tree and supers. It is trickier when it comes to
either partition map changes while the fs is still mounted; or doing
it the way I was describing by deleting one of the present devices in
which case you can then just use that now empty partition as a starter
for a new file system.

It's a catch 22 either way.

Note that by default if you don't specify a devid for shrink, it's
only resizing devid1.



-- 
Chris Murphy

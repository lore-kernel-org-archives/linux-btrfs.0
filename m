Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33380 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbeBHDDM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:03:12 -0500
Received: by mail-oi0-f50.google.com with SMTP id l8so2311521oig.0
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Feb 2018 19:03:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-droxO-K9RM9uCLie=6bg3cgC5uqo_wcscc0BmB9HyKM5gQQ@mail.gmail.com>
References: <CAH-droxO-K9RM9uCLie=6bg3cgC5uqo_wcscc0BmB9HyKM5gQQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 7 Feb 2018 20:03:11 -0700
Message-ID: <CAJCQCtTqJQkLmsowxun7YuRsy4MkN9A4iO5LVwp3tO_6G=LqNQ@mail.gmail.com>
Subject: Re: IO Error (.snapshots is not a btrfs subvolume)
To: Nick Gilmour <nickeforos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 7, 2018 at 6:26 PM, Nick Gilmour <nickeforos@gmail.com> wrote:
> Hi all,
>
> I have successfully restored a snapshot of root but now when I try to
> make a new snapshot I get this error:
> IO Error (.snapshots is not a btrfs subvolume).
> My snapshots were within @ which I renamed to @_old.
> What can I do now? How can I move the snapshots from @_old/ into @ and
> be able to make snapshots again?
>
> This is an excerpt of my subvolumes list:
>
> # btrfs subvolume list /
> ID 257 gen 175397 top level 5 path @_old
> ID 258 gen 175392 top level 5 path @pkg
> ID 260 gen 175447 top level 5 path @tmp
> ID 262 gen 19 top level 257 path @_old/var/lib/machines
> ID 268 gen 175441 top level 5 path @test
> ID 291 gen 175394 top level 257 path @_old/.snapshots
> ID 292 gen 1705 top level 291 path @_old/.snapshots/1/snapshot
> ...
>
> ID 3538 gen 175398 top level 291 path @_old/.snapshots/1594/snapshot
> ID 3540 gen 175447 top level 5 path @
>


This is a snapper behavior. It creates .snapshots as a subvolume and
then puts snapshots into that subvolume. If you snapshot a subvolume
that contains another subvolume, the nested subvolume is not snapshot,
instead a plain directory placeholder is created instead. So your
restored snapshot contains a .snapshot directory rather than a
.snapshot subvolume. Possibly if you delete the directory and create a
new subvolume .snapshot, the problem will be fixed.

I can't tell you how this will confuse snapper though, or how to
unconfuse it. It pretty much expects to be in control of all
snapshots, creation, deletion, and rollbacks. So if you do it manually
for whatever reason, I think it can confuse snapper.


-- 
Chris Murphy

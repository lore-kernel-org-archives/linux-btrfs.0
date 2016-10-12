Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:35552 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752512AbcJLBeH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 21:34:07 -0400
Received: by mail-yw0-f180.google.com with SMTP id t193so24737855ywc.2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 18:33:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
From: Dan Mons <dmons@cuttingedge.com.au>
Date: Wed, 12 Oct 2016 11:33:06 +1000
Message-ID: <CACa6TydFOQJgF_6=Uyhddyw_aqDJZZrWHLkiuqX=sigg481+iA@mail.gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
To: Philip Louis Moetteli <Philip.Moetteli@unige.ch>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ignoring the RAID56 bugs for a moment, if you have mismatched drives,
BtrFS RAID1 is a pretty good way of utilising available space and
having redundancy.

My home array is BtrFS with a hobbled together collection of disks
ranging from 500GB to 3TB (and 5 of them, so it's not an even number).
I have a grand total of 8TB of linear space, and with BtrFS RAID1 I
can use exactly 50% of this (4TB) even with the weird combination of
disks.  That's something other RAID1 implementations can't do (they're
limited to the size of the smallest disk of any pair, and need an even
number of disks all up), and I get free compression and snapshotting,
so yay for that.

As drives die of natural old age, I replace them ad-hoc with bigger
drives (whatever is the sane price-point at the time).  A replace
followed by a rebalance later, and I'm back to using all available
space (which grows every time I throw a bigger drive in the mix),
which again is incredibly handy when you're a home user looking for
sane long-term storage that doesn't require complete rebuilds of your
array.

-Dan

----------------
Dan Mons - VFX Sysadmin
Cutting Edge
http://cuttingedge.com.au


On 12 October 2016 at 01:14, Philip Louis Moetteli
<Philip.Moetteli@unige.ch> wrote:
> Hello,
>
>
> I have to build a RAID 6 with the following 3 requirements:
>
>         • Use different kinds of disks with different sizes.
>         • When a disk fails and there's enough space, the RAID should be able to reconstruct itself out of the degraded state. Meaning, if I have e. g. a RAID with 8 disks and 1 fails, I should be able to chose to transform this in a non-degraded (!) RAID with 7 disks.
>         • Also the other way round: If I add a disk of what size ever, it should redistribute the data, so that it becomes a RAID with 9 disks.
>
> I don’t care, if I have to do it manually.
> I don’t care so much about speed either.
>
> Is BTrFS capable of doing that?
>
>
> Thanks a lot for your help!
>

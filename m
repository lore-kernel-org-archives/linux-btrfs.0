Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36778 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934111AbcJLUtt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 16:49:49 -0400
Received: by mail-oi0-f50.google.com with SMTP id m72so74905383oik.3
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 13:49:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161012171936.GD26140@hungrycats.org>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk> <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com> <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com> <20161012171936.GD26140@hungrycats.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 12 Oct 2016 14:41:56 -0600
Message-ID: <CAJCQCtSrG+2AudyPjgfqZw0FbJkGNdN3UN6pdSmAx7+G4FD32w@mail.gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 11:19 AM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:

> Degraded RAID5 is not RAID0.  RAID5 has strict constraints that RAID0
> does not.  The way a RAID5 implementation behaves in degraded mode is
> the thing that usually matters after a disk fails.

Is there degraded raid5 xfstesting happening? Or are the tests mainly
done non-degraded? In particular, 2x device fail degraded raid6,
because it's so expensive, has potential to expose even more bugs.


> So...metadata blocks would be 256K on the 5-disk RAID5 example above,
> and any file smaller than 256K would be stored inline?  Ouch.  That would
> also imply the compressed extent size limit (currently 128K) has to become
> much larger.

There are patches to set strip size. Does it make sense to specify
4KiB strip size for metadata block groups and 64+KiB for data block
groups?



-- 
Chris Murphy

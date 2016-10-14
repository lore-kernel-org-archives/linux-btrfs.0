Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35548 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbcJNHQH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 03:16:07 -0400
Received: by mail-oi0-f42.google.com with SMTP id d132so127153028oib.2
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2016 00:16:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d1646e74-004d-737f-671a-4ca30f518819@cn.fujitsu.com>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk> <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
 <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com> <20161012043718.GW21290@hungrycats.org>
 <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com> <20161012171936.GD26140@hungrycats.org>
 <16a02312-a74c-6e2d-08ae-7fa479823341@cn.fujitsu.com> <20161013210346.GY21290@hungrycats.org>
 <d1646e74-004d-737f-671a-4ca30f518819@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Oct 2016 01:16:05 -0600
Message-ID: <CAJCQCtRxN+5+8Kfr8TM8+gVx62CUQ+Vhkiz7auWJa_tYKZVsXA@mail.gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK so we know for raid5 data block groups there can be RMW. And
because of that, any interruption results in the write hole. On Btrfs
thought, the write hole is on disk only. If there's a lost strip
(failed drive or UNC read), reconstruction from wrong parity results
in a checksum error and EIO. That's good.

However, what happens in the metadata case? If metadata is raid5, and
there's a crash or power failure during metadata RMW, same problem,
wrong parity, bad reconstruction, csum mismatch, and EIO. So what's
the effect of EIO when reading metadata? And how common is RMW for
metadata operations?

I wonder where all of these damn strange cases where people can't do
anything at all with a normally degraded raid5 - one device failed,
and no other failures, but they can't mount due to a bunch of csum
errors.


Chris Murphy

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60223 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753657AbcK3Tgz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 14:36:55 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Wilson Meier <wilson.meier@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Convert from RAID 5 to 10
Date: Wed, 30 Nov 2016 20:36:51 +0100
Message-ID: <2106513.UkuxMIuvWQ@merkaba>
In-Reply-To: <CAJCQCtRnqp15QZ9V+AtBu1_7QwChdoRMs0nHg3stWnJOyy8qMw@mail.gmail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de> <19671a71-5d1c-c42e-db3d-c870ec08b2ff@gmail.com> <CAJCQCtRnqp15QZ9V+AtBu1_7QwChdoRMs0nHg3stWnJOyy8qMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 30. November 2016, 12:09:23 CET schrieb Chris Murphy:
> On Wed, Nov 30, 2016 at 7:37 AM, Austin S. Hemmelgarn
> 
> <ahferroin7@gmail.com> wrote:
> > The stability info could be improved, but _absolutely none_ of the things
> > mentioned as issues with raid1 are specific to raid1.  And in general, in
> > the context of a feature stability matrix, 'OK' generally means that there
> > are no significant issues with that specific feature, and since none of
> > the
> > issues outlined are specific to raid1, it does meet that description of
> > 'OK'.
> 
> Maybe the gotchas page needs a one or two liner for each profile's
> gotchas compared to what the profile leads the user into believing.
> The overriding gotcha with all Btrfs multiple device support is the
> lack of monitoring and notification other than kernel messages; and
> the raid10 actually being more like raid0+1 I think it certainly a
> gotcha, however 'man mkfs.btrfs' contains a grid that very clearly
> states raid10 can only safely lose 1 device.

Wow, that manpage is quite an resource.

Developers, documentation people definitely improved the official BTRFS 
documentation.

Thanks,
-- 
Martin

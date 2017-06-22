Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:32833 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdFVCnT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 22:43:19 -0400
Received: by mail-wr0-f171.google.com with SMTP id r103so4190269wrb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 19:43:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1d88f12a-bd2a-9fff-cb53-da847f4526c7@cn.fujitsu.com>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com> <CAJCQCtRM4L1DSbWU7okANdimoO6F-KgSV=y2KEovj0zMW7h6bA@mail.gmail.com>
 <1d88f12a-bd2a-9fff-cb53-da847f4526c7@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Jun 2017 20:43:17 -0600
Message-ID: <CAJCQCtSwSfWKB7ic_Dh=NOJV4WQdwCJfbQE6RfuUrSVFcx3ewA@mail.gmail.com>
Subject: Re: Exactly what is wrong with RAID5/6
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, waxhead <waxhead@dirtcellar.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 21, 2017 at 8:12 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

>
> Well, in fact, thanks to data csum and btrfs metadata CoW, there is quite a
> high chance that we won't cause any data damage.

But we have examples where data does not COW, we see a partial stripe
overwrite. And if that is interrupted it's clear that both old and new
metadata pointing to that stripe is wrong. There are way more problems
where we see csum errors on Btrfs raid56 after crashes, and there are
no bad devices.



>
> For the example I gave above, no data damage at all.
>
> First the data is written and power loss, and data is always written before
> metadata, so that's to say, after power loss, superblock is still using the
> old tree roots.
>
> So no one is really using that newly written data.

OK but that assumes that the newly written data is always COW which on
Btrfs raid56 is not certain, there's a bunch of RMW code which
suggests overwrites are possible.

And for raid56 metadata it suggests RMW could happen for metadata also.

There's fairly strong anecdotal evidence that people have less
problems with Btrfs raid5 when raid5 applies to data block groups, and
metadata block groups use some other non-parity based profile like
raid1.



-- 
Chris Murphy

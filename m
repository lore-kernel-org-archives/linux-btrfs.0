Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:38784 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753190AbeCUU1a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 16:27:30 -0400
Received: by mail-io0-f171.google.com with SMTP id b20so8221506iof.5
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 13:27:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
References: <CAJVZm6dkZmSpnV3wz4sfOMzMCP36Mrt+-2J7o0mU4z=dEYQqQQ@mail.gmail.com>
 <CANQeFDDxZSZ4jYDPvW-Q=AoyPrGzpp0fVywjFOJtkeD+Ysgmew@mail.gmail.com>
From: Menion <menion@gmail.com>
Date: Wed, 21 Mar 2018 21:27:09 +0100
Message-ID: <CAJVZm6f=WzZub7K5=jOdt7A6pHjdeo7Pm8MgO9S28n5PXqK=VA@mail.gmail.com>
Subject: Re: Status of RAID5/6
To: Liu Bo <obuil.liubo@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am on 4.15.5 :)
Yes I agree that Journaling is better on the same array,  still should
be unit failure tolerant, so maybe it should go in a RAID1 scheme.
Will a raid56 array built with older kernel be compatible with the new
forecoming code?
Bye

2018-03-21 18:24 GMT+01:00 Liu Bo <obuil.liubo@gmail.com>:
> On Wed, Mar 21, 2018 at 9:50 AM, Menion <menion@gmail.com> wrote:
>> Hi all
>> I am trying to understand the status of RAID5/6 in BTRFS
>> I know that there are some discussion ongoing on the RFC patch
>> proposed by Liu bo
>> But it seems that everything stopped last summary. Also it mentioned
>> about a "separate disk for journal", does it mean that the final
>> implementation of RAID5/6 will require a dedicated HDD for the
>> journaling?
>
> Thanks for the interest on btrfs and raid56.
>
> The patch set is to plug write hole, which is very rare in practice, tbh.
> The feedback is to use existing space instead of another dedicate
> "fast device" as the journal in order to get some extent of raid
> protection.  I'd need some time to pick it up.
>
> With that being said, we have several data reconstruction fixes for
> raid56 (esp. raid6) in 4.15, I'd say please deploy btrfs with the
> upstream kernel or some distros which do kernel updates frequently,
> the most important one is
>
> 8810f7517a3b Btrfs: make raid6 rebuild retry more
> https://patchwork.kernel.org/patch/10091755/
>
> AFAIK, no other data corruptions showed up.
>
> thanks,
> liubo

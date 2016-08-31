Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34679 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753967AbcHaXEN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 19:04:13 -0400
Received: by mail-oi0-f51.google.com with SMTP id l203so92577549oib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 16:04:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO-WwM8hN9OxWZfbac60iXDZ8=WZ8=fokKdCqYcSpEdu6g@mail.gmail.com>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
 <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com>
 <CA+WRLO_6q2cZqPPkmtqjjkq7tfdh5DDyE_oHFswFoQVz8FguKw@mail.gmail.com>
 <CA+WRLO8XVaK5FK9VUt=pOgoyqYm30_yxTnCd+5zdYx5Xx6jAcw@mail.gmail.com>
 <CA+WRLO-cvepjj53xCoq=RiEmTV-6cqL+G6nQe+WnTPyWNDOUZA@mail.gmail.com>
 <CA+WRLO-1oJLZ56EivVTg=bycNhfpOt8ovLrLbgnNeCVKgvbxhQ@mail.gmail.com>
 <CAJCQCtQddXz26cjp=tGcO5d5E9N=Zmjdd=qwonjGdh+NJ7aLQQ@mail.gmail.com>
 <CAJCQCtRGpAgGq9dpv432ES9OUHG4fDkt+DviapaCyg0Jtc2gVA@mail.gmail.com>
 <CA+WRLO8kTBoPHx3jkeN+zdygEMZz9ejTeWGwQireRtDGDNrncQ@mail.gmail.com> <CA+WRLO-WwM8hN9OxWZfbac60iXDZ8=WZ8=fokKdCqYcSpEdu6g@mail.gmail.com>
From: Gareth Pye <gareth@cerberos.id.au>
Date: Thu, 1 Sep 2016 09:04:12 +1000
Message-ID: <CA+WRLO9ZazygSMfLjpfXO_bYMmJVecd3be44EKJWMDORFXiVKg@mail.gmail.com>
Subject: Re: Recommendation on raid5 drive error resolution
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ro,degraded has mounted it nicely and my rsync of the more useful data
is progressing at the speed of WiFi.

There are repeated read errors from one drive still but the rsync
hasn't bailed yet, which I think means there isn't any overlapping
errors in any of the files it has touched thus far. Am I right or is
their likely to be corrupt data in the files I've synced off?

On Wed, Aug 31, 2016 at 7:46 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
> Or I could just once again select the right boot device in the bios. I
> think I want some new hardware :)
>
> On Wed, Aug 31, 2016 at 7:23 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
>> On Wed, Aug 31, 2016 at 4:28 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>> But I'd try a newer kernel before you
>>> give up on it.
>>
>>
>> Any recommendations on liveCDs that have recent kernels & btrfs tools?
>> For no apparent reason system isn't booting normally either, and I'm
>> reluctant to fix that before at least confirming the things I at least
>> partially care about have a recent backup.
>>
>> --
>> Gareth Pye - blog.cerberos.id.au
>> Level 2 MTG Judge, Melbourne, Australia
>
>
>
> --
> Gareth Pye - blog.cerberos.id.au
> Level 2 MTG Judge, Melbourne, Australia



-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia

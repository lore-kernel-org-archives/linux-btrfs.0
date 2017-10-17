Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:54178 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754519AbdJQMk0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 08:40:26 -0400
Received: by mail-it0-f54.google.com with SMTP id n195so2181291itg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 05:40:25 -0700 (PDT)
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: Zoltan <zoltan1980@gmail.com>
Cc: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
 <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
 <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
 <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
Date: Tue, 17 Oct 2017 08:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-17 07:42, Zoltan wrote:
> Hi,
> 
> On Tue, Oct 17, 2017 at 1:26 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>> I forget sometimes that people insist on storing large volumes of data on
>> unreliable storage...
> 
> In my opinion the unreliability of the storage is the exact reason for
> wanting to use raid1. And I think any problem one encounters with an
> unreliable disk can likely happen with more reliable ones as well,
> only less frequently, so if I don't feel comfortable using raid1 on an
> unreliable medium then I wouldn't trust it on a more reliable one
> either.
The thing is that you need some minimum degree of reliability in the 
other components in the storage stack for it to be viable to use any 
given storage technology.  If you don't meet that minimum degree of 
reliability, then you can't count on the reliability guarantees of the 
storage technology.

As a more concrete example, reliable operation of a RAID5 array requires 
a functional guarantee that a second disk won't fail during a rebuild of 
the array.  That fact gives an upper limit on the practical size of a 
RAID5 array as a function of the failure rate of the disks and the time 
it takes to rebuild the array.   More specifically, the array has to be 
small enough that it's a statistical impossibility that a second device 
will fail during a rebuild of the array.  Once the failure rate goes 
above a certain value proportionate to the rebuild time, you end up in a 
situation where you shouldn't be using RAID5 to protect against device 
failure because it won't provide any net benefit (and FWIW< we're past 
that point on most modern hardware when talking about typical enterprise 
scale storage requirements).

As of right now, a rate of device disconnects above 0 invalidates that 
reliability requirement for multi-device BTRFS (and it doesn't have to 
be much above zero to invalidate it for MD and LVM, it just needs to be 
high enough to make it statistically possible that it happens more than 
once during a rebuild), and thus USB is not something that should be 
considered a viable option for hosting a multi-device BTRFS array in 
most cases.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36398 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753150AbcJKUpk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 16:45:40 -0400
Received: by mail-oi0-f50.google.com with SMTP id m72so38402551oik.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 13:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e8701d223f1$c7ea0960$57be1c20$@com>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com> <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com>
 <5ce201d22364$96702780$c3507680$@com> <CAJCQCtR_zOd=1hVrKAD_kKfE_EKZQ2omfWQV556Rg=OSbvEd0w@mail.gmail.com>
 <5e8501d223d7$715a9bb0$540fd310$@com> <CAJCQCtQ12AZQ9x2ddSSceGHpWYvB7sSVE0qty+=Ln9oibmiHRw@mail.gmail.com>
 <5e8601d223da$0cbf6c00$263e4400$@com> <CAJCQCtSBn1+CqqDkeHx+bBR8zSbN8hYQ9R4p9C2EtpBoVBP+Ww@mail.gmail.com>
 <5e8701d223f1$c7ea0960$57be1c20$@com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 11 Oct 2016 14:38:12 -0600
Message-ID: <CAJCQCtT4g0kQ3bhEmOGfyEM62r8a1w4B6S_AqW3Q-e+k+QHgag@mail.gmail.com>
Subject: Re: raid6 file system in a bad state
To: "Jason D. Michaelson" <jasondmichaelson@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

readding btrfs

On Tue, Oct 11, 2016 at 1:00 PM, Jason D. Michaelson
<jasondmichaelson@gmail.com> wrote:
>
>
>> -----Original Message-----
>> From: chris@colorremedies.com [mailto:chris@colorremedies.com] On
>> Behalf Of Chris Murphy
>> Sent: Tuesday, October 11, 2016 12:41 PM
>> To: Jason D. Michaelson
>> Cc: Chris Murphy; Btrfs BTRFS
>> Subject: Re: raid6 file system in a bad state
>>
>> On Tue, Oct 11, 2016 at 10:10 AM, Jason D. Michaelson
>> <jasondmichaelson@gmail.com> wrote:
>> > superblock: bytenr=65536, device=/dev/sda
>> > ---------------------------------------------------------
>> > generation              161562
>> > root                    5752616386560
>>
>>
>>
>> > superblock: bytenr=65536, device=/dev/sdh
>> > ---------------------------------------------------------
>> > generation              161474
>> > root                    4844272943104
>>
>> OK so most obvious is that the bad super is many generations back than
>> the good super. That's expected given all the write errors.
>>
>>
>
> Is there any chance/way of going back to use this generation/root as a source for btrfs restore?

Yes with -t option and that root bytenr for the generation you want to
restore. Thing is, that's so far back the metadata may be gone
(overwritten) already. But worth a shot. I've recovered recently
deleted files this way.


OK at this point I'm thinking that fixing the super blocks won't
change anything because it sounds like it's using the new ones anyway
and maybe the thing to try is going back to a tree root that isn't in
any of the new supers. That means losing anything that was being
written when the lost writes happened. However, for all we know some
overwrites happened so this won't work. And also it does nothing to
deal with the fragile state of having at least two flaky devices, and
one of the system chunks with no redundancy.


Try 'btrfs check' without repair. And then also try it with -r flag
using the various tree roots we've seen so far. Try explicitly using
5752616386560, which is what it ought to use first anyway. And then
also 4844272943104.

That might go far enough back before the bad sectors were a factor.
Normally what you'd want is for it to use one of the backup roots, but
it's consistently running into a problem with all of them when using
recovery mount option.





-- 
Chris Murphy

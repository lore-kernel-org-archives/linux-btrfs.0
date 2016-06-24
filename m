Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35786 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbcFXRVT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:21:19 -0400
Received: by mail-lf0-f49.google.com with SMTP id l188so119188541lfe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 10:21:18 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org>
 <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org>
 <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk>
 <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <576D6C0A.7070502@gmail.com>
Date: Fri, 24 Jun 2016 20:21:14 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

24.06.2016 20:06, Chris Murphy пишет:
> On Fri, Jun 24, 2016 at 3:52 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> On Fri, Jun 24, 2016 at 11:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> eta)data and RAID56 parity is not data.
>>>
>>>    Checksums are not parity, correct. However, every data block
>>> (including, I think, the parity) is checksummed and put into the csum
>>> tree. This allows the FS to determine where damage has occurred,
>>> rather thansimply detecting that it has occurred (which would be the
>>> case if the parity doesn't match the data, or if the two copies of a
>>> RAID-1 array don't match).
>>>
>>
>> Yes, that is what I wrote below. But that means that RAID5 with one
>> degraded disk won't be able to reconstruct data on this degraded disk
>> because reconstructed extent content won't match checksum. Which kinda
>> makes RAID5 pointless.
> 
> I don't understand this. Whether the failed disk means a stripe is
> missing a data strip or parity strip, if any other strip is damaged of
> course the reconstruction isn't going to match checksum. This does not
> make raid5 pointless.
> 

Yes, you are right. We have double failure here. Still, in current
situation we apparently may end with btrfs reconstructing missing block
using wrong information. As was mentioned elsewhere, btrfs does not
verify checksum of reconstructed block, meaning data corruption.

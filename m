Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35047 "EHLO
	mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcFXSUD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 14:20:03 -0400
Received: by mail-it0-f52.google.com with SMTP id g127so21404366ith.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 11:20:02 -0700 (PDT)
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
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
 <576D6C0A.7070502@gmail.com>
 <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
Date: Fri, 24 Jun 2016 14:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-24 13:52, Chris Murphy wrote:
> On Fri, Jun 24, 2016 at 11:21 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> 24.06.2016 20:06, Chris Murphy пишет:
>>> On Fri, Jun 24, 2016 at 3:52 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>>> On Fri, Jun 24, 2016 at 11:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>> eta)data and RAID56 parity is not data.
>>>>>
>>>>>    Checksums are not parity, correct. However, every data block
>>>>> (including, I think, the parity) is checksummed and put into the csum
>>>>> tree. This allows the FS to determine where damage has occurred,
>>>>> rather thansimply detecting that it has occurred (which would be the
>>>>> case if the parity doesn't match the data, or if the two copies of a
>>>>> RAID-1 array don't match).
>>>>>
>>>>
>>>> Yes, that is what I wrote below. But that means that RAID5 with one
>>>> degraded disk won't be able to reconstruct data on this degraded disk
>>>> because reconstructed extent content won't match checksum. Which kinda
>>>> makes RAID5 pointless.
>>>
>>> I don't understand this. Whether the failed disk means a stripe is
>>> missing a data strip or parity strip, if any other strip is damaged of
>>> course the reconstruction isn't going to match checksum. This does not
>>> make raid5 pointless.
>>>
>>
>> Yes, you are right. We have double failure here. Still, in current
>> situation we apparently may end with btrfs reconstructing missing block
>> using wrong information. As was mentioned elsewhere, btrfs does not
>> verify checksum of reconstructed block, meaning data corruption.
>
> Well that'd be bad, but also good in that it would explain a lot of
> problems people have when metadata is also raid5. In this whole thread
> the premise is the metadata is raid1, so the fs doesn't totally face
> plant we just get a bunch of weird data corruptions. The metadata
> raid5 case were sorta "WTF happened?" and not much was really said
> about it other than telling the user to scrape off what they can and
> start over.
>
> Anyway, while not good I still think this is not super problematic to
> at least *do* check EXTENT_CSUM after reconstruction from parity
> rather than assuming that reconstruction happened correctly. The data
> needed to pass fail the rebuild is already on the disk. It just needs
> to be checked.
>
> Better would be to get parity csummed and put into the csum tree. But
> I don't know how much that helps. Think about always computing and
> writing csums for parity, which almost never get used vs keeping
> things the way they are now and just *checking our work* after
> reconstruction from parity. If there's some obvious major advantage to
> checksumming the parity I'm all ears but I'm not thinking of it at the
> moment.
>
Well, the obvious major advantage that comes to mind for me to 
checksumming parity is that it would let us scrub the parity data itself 
and verify it.  I'd personally much rather know my parity is bad before 
I need to use it than after using it to reconstruct data and getting an 
error there, and I'd be willing to be that most seasoned sysadmins 
working for companies using big storage arrays likely feel the same 
about it.  I could see it being practical to have an option to turn this 
off for performance reasons or similar, but again, I have a feeling that 
most people would rather be able to check if a rebuild will eat data 
before trying to rebuild (depending on the situation in such a case, it 
will sometimes just make more sense to nuke the array and restore from a 
backup instead of spending time waiting for it to rebuild).


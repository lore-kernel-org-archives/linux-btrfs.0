Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33006 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcFXRGN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:06:13 -0400
Received: by mail-oi0-f47.google.com with SMTP id u201so123448536oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 10:06:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk> <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 24 Jun 2016 11:06:09 -0600
Message-ID: <CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 3:52 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> On Fri, Jun 24, 2016 at 11:50 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>eta)data and RAID56 parity is not data.
>>
>>    Checksums are not parity, correct. However, every data block
>> (including, I think, the parity) is checksummed and put into the csum
>> tree. This allows the FS to determine where damage has occurred,
>> rather thansimply detecting that it has occurred (which would be the
>> case if the parity doesn't match the data, or if the two copies of a
>> RAID-1 array don't match).
>>
>
> Yes, that is what I wrote below. But that means that RAID5 with one
> degraded disk won't be able to reconstruct data on this degraded disk
> because reconstructed extent content won't match checksum. Which kinda
> makes RAID5 pointless.

I don't understand this. Whether the failed disk means a stripe is
missing a data strip or parity strip, if any other strip is damaged of
course the reconstruction isn't going to match checksum. This does not
make raid5 pointless.



-- 
Chris Murphy

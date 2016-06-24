Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33803 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbcFXRk7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:40:59 -0400
Received: by mail-oi0-f53.google.com with SMTP id s66so124647010oif.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 10:40:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160624101658.GI3325@carfax.org.uk>
References: <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <20160622203504.GQ15597@hungrycats.org> <5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
 <CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
 <20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
 <20160624085014.GH3325@carfax.org.uk> <CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
 <20160624101658.GI3325@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 24 Jun 2016 11:40:56 -0600
Message-ID: <CAJCQCtT1erMUphkn_-NPhT3A0gV1b-7O+OTxO=OsFHefRd53dA@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Hugo Mills <hugo@carfax.org.uk>, Andrei Borzenkov <arvidjaar@gmail.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Chris Murphy <lists@colorremedies.com>, kreijack@inwind.it,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 4:16 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Jun 24, 2016 at 12:52:21PM +0300, Andrei Borzenkov wrote:

>> Yes, that is what I wrote below. But that means that RAID5 with one
>> degraded disk won't be able to reconstruct data on this degraded disk
>> because reconstructed extent content won't match checksum. Which kinda
>> makes RAID5 pointless.
>
>    Eh? How do you come to that conclusion?
>
>    For data, say you have n-1 good devices, with n-1 blocks on them.
> Each block has a checksum in the metadata, so you can read that
> checksum, read the blocks, and verify that they're not damaged. From
> those n-1 known-good blocks (all data, or one parity and the rest
> data) you can reconstruct the remaining block. That reconstructed
> block won't be checked against the csum for the missing block -- it'll
> just be written and a new csum for it written with it.

The last sentence is hugely problematic. Parity doesn't appear to be
either CoW'd or checksummed. If it is used for reconstruction and the
reconstructed data isn't compared to the data's EXTENT_CSUM entry, but
that entry is rather recomputed and written, that's just like blindly
trusting the parity is correct and then authenticating it with a csum.

It's  not difficult to test. Corrupt one byte of parity. Yank a drive.
Add a new one. Start a reconstruction with scrub or balance (or both
to see if they differ) and find out what happens. What should happen
is the reconstruct should work for everything except that one file. If
it's reconstructed silently, it should contain visible corruption and
we all collectively raise our eyebrows.

-- 
Chris Murphy

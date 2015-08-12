Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35662 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbHLUTy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 16:19:54 -0400
Received: by igbjg10 with SMTP id jg10so50733119igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 13:19:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150812073104.GL12976@carfax.org.uk>
References: <CAMUoZtY7Or1+4-XmxWQjrmkAk-x62e13XMoTbWApRAn_zhd2DQ@mail.gmail.com>
	<20150812073104.GL12976@carfax.org.uk>
Date: Wed, 12 Aug 2015 13:19:53 -0700
Message-ID: <CAMUoZtb3LF1_tn+Z=k6aKjoyYeScZPa-41qVvSx9vLe16z4qUw@mail.gmail.com>
Subject: Re: Scaling to 100k+ snapshots/subvolumes
From: Tristan Zajonc <tristan@sense.io>
To: Hugo Mills <hugo@carfax.org.uk>, Tristan Zajonc <tristan@sense.io>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, this is helpful.

We are primarily scaling the number of snapshots. Unfortunately these
snapshots typically have very minor changes compared their parent, so
this sounds potentially problematic.

It sounds like I will need to do some testing of both snapshots and
quotas to determine scalability for our exact uses cases.  We can
control which tools / actions we take pretty carefully but do require
significant scalability along both the snapshot and quota subvolume
dimensions.

Any lessons here are helpful in terms of knowing what to test.

Thanks,
Tristan
---
Tristan Zajonc, PhD | Cofounder/CEO at Sense | https://sense.io |
@tristanzajonc | m: 617-953-2204


On Wed, Aug 12, 2015 at 12:31 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Aug 11, 2015 at 11:33:45AM -0700, Tristan Zajonc wrote:
>> In an early thread Duncan mentioned that btrfs does not scale well in
>> the number of subvolumes (including snapshots).  He recommended
>> keeping the total number under 1000.  I just wanted to understand this
>> limitation further.  Is this something that has been resolved or will
>> be resolved in the future or is it something inherent to the design of
>> btrfs?
>
>    We've already discussed this on IRC yesterday, but I was reminded
> this morning of one specific instance of poor scalability with lots of
> snapshots, which is that balancing metadata scales poorly as the
> number of copies of the same data increases. (So it's OK to have lots
> of unrelated subvolumes, but many subvolumes that are snapshots of the
> same thing would br problematic).
>
>    I don't know what the exact scaling is, but it's superlinear, and
> may be as bad as O(n^2).
>
>> We have an application that could easily generate 100k-1M snapshots
>> and 10s of thousands of subvolumes.  We use snapshots to track very
>> fine-grained filesystem histories and subvolumes to enforce quotas
>> across a large number of distinct projects.
>
>    1e4 subvolumes and 1e6 snapshots will probably be OK, although
> slow, when balancing. That's only 100 snapshots per subvolume, and
> I've got that kind of scale here on my home machine -- it's very slow
> (takes a couple of hours for some of the metadata chunks), but it's
> not unusable.
>
>    Hugo.
>
>> Thanks,
>> Tristan
>>
>> Duncan >
>> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/43910
>>
>> The question of number of subvolumes normally occurs in the context of
>> snapshots, since snapshots are a special kind of subvolume.  Ideally,
>> you'll want to keep the total number of subvolumes (including snapshots)
>> to under 1000, with the number of snapshots of any single subvolume
>> limited to 250-ish (say under 300).  However, even just four subvolumes
>> being snapshotted to this level will reach the thousand, and 2000-3000
>> total isn't /too/ bad as long as it's no more than 250-300 snapshots per
>> subvolume.  But DEFINITELY try to keep it under 3000, and preferably
>> under 2000, as the scaling really does start to go badly as the number of
>> subvolumes increases beyond that.  If you're dealing with 10k subvolumes/
>> snapshots, that's too many and you ARE likely to find yourself with
>> problems.
>>
>> (With something like snapper, configuring it for say half-hour or hourly
>> snapshots at the shortest time, with twice-daily or daily being more
>> reasonable in many circumstances, and then thinning it down to say daily
>> after a few days and weekly after four weeks, goes quite a long way
>> toward reducing the number of snapshots per subvolume.  Keeping it near
>> 250-ish per subvolume is WELL within reason, and considering that a month
>> or a year out, you're not likely to /care/ whether it's this hour or
>> that, just pick a day or a week and if it's not what you want, go back or
>> forward a day or a week, is actually likely to be more practical than
>> having hundreds of half-hourly snapshots a year old to choose from.  And
>> 250-ish snapshots per subvolume really does turn out to be VERY
>> reasonable, provided you're doing reasonable thinning.)
>
> --
> Hugo Mills             | Some days, it's just not worth gnawing through the
> hugo@... carfax.org.uk | straps
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |

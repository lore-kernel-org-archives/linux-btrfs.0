Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33985 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbcAKXFu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 18:05:50 -0500
Received: by mail-wm0-f44.google.com with SMTP id u188so233992340wmu.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 15:05:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160111223017.GE422@carfax.org.uk>
References: <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk> <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
 <20160111090318.GG6060@carfax.org.uk> <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
 <20160111221056.GD422@carfax.org.uk> <CAJCQCtSR1fCPH_TgVYYgjmRC-phh5Zdku4f0iHoFg7CjZAQ7hw@mail.gmail.com>
 <20160111223017.GE422@carfax.org.uk>
From: "cheater00 ." <cheater00@gmail.com>
Date: Tue, 12 Jan 2016 00:05:29 +0100
Message-ID: <CA+9GZUiDXS098k4UY8RdzUtAPththbWHT196-YbnZFj17OJXPg@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 11, 2016 at 11:30 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Jan 11, 2016 at 03:20:36PM -0700, Chris Murphy wrote:
>> On Mon, Jan 11, 2016 at 3:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> > On Mon, Jan 11, 2016 at 02:31:41PM -0700, Chris Murphy wrote:
>> >> On Mon, Jan 11, 2016 at 2:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> > On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
>> >> >> On Sat, Jan 9, 2016 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> >> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
>> >> >> >> OK. How do we track down that bug and get it fixed?
>> >> >> >
>> >> >> >    I have no idea. I'm not a btrfs dev, I'm afraid.
>> >> >> >
>> >> >> >    It's been around for a number of years. None of the devs has, I
>> >> >> > think, had the time to look at it. When Josef was still (publicly)
>> >> >> > active, he had it second on his list of bugs to look at for many
>> >> >> > months -- but it always got trumped by some new bug that could cause
>> >> >> > data loss.
>> >> >>
>> >> >>
>> >> >> Interesting. I did not know of this bug. It's pretty rare.
>> >> >
>> >> >    Not really. It shows up maybe on average once a week on IRC. It
>> >> > gets reported much less on the mailing list.
>> >>
>> >> Is there a pattern? Does it only happen at a 2TiB threshold?
>> >
>> >    No, and no.
>> >
>> >    There is, as far as I can tell from some years of seeing reports of
>> > this bug, no correlation with RAID level, hardware, OS, kernel
>> > version, FS size, usage of the FS at failure, or allocation level of
>> > either data or metadata at failure.
>> >
>> >    I haven't tried correlating with the phase of the moon or the
>> > losses on Lloyds Register yet.
>>
>> Huh. So it's goofy cakes.
>>
>> This is specifically where btrfs_free_extent produces errno -28 no
>> space left, and then the fs goes read-only?
>
>    The symptoms I'm using for a diagnosis of this bug are that the FS
> runs out of (usually data) space when there's still unallocated space
> remaining that it could use for another block group.
>
>    Forced RO isn't usually a symptom, although the FS can get into a
> state where you can't modify it (as distinct from being explicitly
> read-only).

In my case, the fs always remounts as RO immediately, so maybe you're
encountering another bug. It might make sense to keep those separate
in our heads.

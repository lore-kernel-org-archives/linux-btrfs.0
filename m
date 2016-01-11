Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33739 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbcAKXMk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 18:12:40 -0500
Received: by mail-wm0-f48.google.com with SMTP id f206so232461185wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 15:12:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160111230727.GF422@carfax.org.uk>
References: <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk> <CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
 <20160111090318.GG6060@carfax.org.uk> <CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
 <20160111221056.GD422@carfax.org.uk> <CAJCQCtSR1fCPH_TgVYYgjmRC-phh5Zdku4f0iHoFg7CjZAQ7hw@mail.gmail.com>
 <20160111223017.GE422@carfax.org.uk> <CAJCQCtQBUFkPc_Tqfx5HCbVvNEhBbGhxRzHAZ+j75e1f74NUjg@mail.gmail.com>
 <20160111230727.GF422@carfax.org.uk>
From: "cheater00 ." <cheater00@gmail.com>
Date: Tue, 12 Jan 2016 00:12:19 +0100
Message-ID: <CA+9GZUiCFOSxDrNCiZXk_wuvRmhyDO9mO2dBEFiZE1oi5ipVcw@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

yeah it's -o enospc_debug. I forgot to enable it this time. I'll
enable it and see where that goes. I'll put it in fstab.

On Tue, Jan 12, 2016 at 12:07 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Jan 11, 2016 at 03:39:43PM -0700, Chris Murphy wrote:
>> On Mon, Jan 11, 2016 at 3:30 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> > On Mon, Jan 11, 2016 at 03:20:36PM -0700, Chris Murphy wrote:
>> >> On Mon, Jan 11, 2016 at 3:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> > On Mon, Jan 11, 2016 at 02:31:41PM -0700, Chris Murphy wrote:
>> >> >> On Mon, Jan 11, 2016 at 2:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> >> > On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
>> >> >> >> On Sat, Jan 9, 2016 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> >> >> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
>> >> >> >> >> OK. How do we track down that bug and get it fixed?
>> >> >> >> >
>> >> >> >> >    I have no idea. I'm not a btrfs dev, I'm afraid.
>> >> >> >> >
>> >> >> >> >    It's been around for a number of years. None of the devs has, I
>> >> >> >> > think, had the time to look at it. When Josef was still (publicly)
>> >> >> >> > active, he had it second on his list of bugs to look at for many
>> >> >> >> > months -- but it always got trumped by some new bug that could cause
>> >> >> >> > data loss.
>> >> >> >>
>> >> >> >>
>> >> >> >> Interesting. I did not know of this bug. It's pretty rare.
>> >> >> >
>> >> >> >    Not really. It shows up maybe on average once a week on IRC. It
>> >> >> > gets reported much less on the mailing list.
>> >> >>
>> >> >> Is there a pattern? Does it only happen at a 2TiB threshold?
>> >> >
>> >> >    No, and no.
>> >> >
>> >> >    There is, as far as I can tell from some years of seeing reports of
>> >> > this bug, no correlation with RAID level, hardware, OS, kernel
>> >> > version, FS size, usage of the FS at failure, or allocation level of
>> >> > either data or metadata at failure.
>> >> >
>> >> >    I haven't tried correlating with the phase of the moon or the
>> >> > losses on Lloyds Register yet.
>> >>
>> >> Huh. So it's goofy cakes.
>> >>
>> >> This is specifically where btrfs_free_extent produces errno -28 no
>> >> space left, and then the fs goes read-only?
>> >
>> >    The symptoms I'm using for a diagnosis of this bug are that the FS
>> > runs out of (usually data) space when there's still unallocated space
>> > remaining that it could use for another block group.
>> >
>> >    Forced RO isn't usually a symptom, although the FS can get into a
>> > state where you can't modify it (as distinct from being explicitly
>> > read-only).
>> >
>> >    Block-group level operations, like balance, device delete, device
>> > add sometimes seem to have some kind of (usually small) effect on the
>> > point at which the error occurs. If you hit the problem and run a
>> > balance, you might end up making things worse by a couple of
>> > gigabytes, or making things better by the same amount, or having no
>> > effect at all.
>>
>> Are there any compile time options not normally set that would help find it?
>> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
>> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
>> # CONFIG_BTRFS_DEBUG is not set
>> # CONFIG_BTRFS_ASSERT is not set
>>
>> Once it starts to happen, it sounds like it's straightforward to
>> reproduce in a short amount of time. I'm kinda surprised I've never
>> run into this.
>
>    It does sometimes have a repeating nature: I'm reasonably sure
> we've seen a few people get it repeatedly on different filesystems.
> This might point at a particular workload needed to trigger it. (Or
> just bad luck / statistical likelihood). Some people have never hit
> it.
>
>    There is (or at least, was) an ENOSPC debugging option. I think
> that's a mount option. That's probably the most useful one, but the
> range of usefulness of existing debug output may be very small. :)
>
>    (Sorry for the vague nature of this reply -- it's been a very long
> day).
>
>    Hugo.
>
> --
> Hugo Mills             | "What are we going to do tonight?"
> hugo@... carfax.org.uk | "The same thing we do every night, Pinky. Try to
> http://carfax.org.uk/  | take over the world!"
> PGP: E2AB1DE4          |

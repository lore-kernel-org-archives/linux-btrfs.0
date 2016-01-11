Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33508 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbcAKWUh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 17:20:37 -0500
Received: by mail-ig0-f178.google.com with SMTP id z14so129893305igp.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 14:20:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160111221056.GD422@carfax.org.uk>
References: <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
	<CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
	<CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
	<CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
	<20160109202659.GC6060@carfax.org.uk>
	<CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
	<20160109210429.GD6060@carfax.org.uk>
	<CAJCQCtSkoAxbc3eXQYPQuYuM12ObBtutZMaavq9iWnQit0zwYw@mail.gmail.com>
	<20160111090318.GG6060@carfax.org.uk>
	<CAJCQCtSbiowwna1JmVdJ=+L-jrXawty9PA9oMMAMW-r8t-kKag@mail.gmail.com>
	<20160111221056.GD422@carfax.org.uk>
Date: Mon, 11 Jan 2016 15:20:36 -0700
Message-ID: <CAJCQCtSR1fCPH_TgVYYgjmRC-phh5Zdku4f0iHoFg7CjZAQ7hw@mail.gmail.com>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 11, 2016 at 3:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Jan 11, 2016 at 02:31:41PM -0700, Chris Murphy wrote:
>> On Mon, Jan 11, 2016 at 2:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> > On Sun, Jan 10, 2016 at 05:13:28PM -0700, Chris Murphy wrote:
>> >> On Sat, Jan 9, 2016 at 2:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> >> > On Sat, Jan 09, 2016 at 09:59:29PM +0100, cheater00 . wrote:
>> >> >> OK. How do we track down that bug and get it fixed?
>> >> >
>> >> >    I have no idea. I'm not a btrfs dev, I'm afraid.
>> >> >
>> >> >    It's been around for a number of years. None of the devs has, I
>> >> > think, had the time to look at it. When Josef was still (publicly)
>> >> > active, he had it second on his list of bugs to look at for many
>> >> > months -- but it always got trumped by some new bug that could cause
>> >> > data loss.
>> >>
>> >>
>> >> Interesting. I did not know of this bug. It's pretty rare.
>> >
>> >    Not really. It shows up maybe on average once a week on IRC. It
>> > gets reported much less on the mailing list.
>>
>> Is there a pattern? Does it only happen at a 2TiB threshold?
>
>    No, and no.
>
>    There is, as far as I can tell from some years of seeing reports of
> this bug, no correlation with RAID level, hardware, OS, kernel
> version, FS size, usage of the FS at failure, or allocation level of
> either data or metadata at failure.
>
>    I haven't tried correlating with the phase of the moon or the
> losses on Lloyds Register yet.

Huh. So it's goofy cakes.

This is specifically where btrfs_free_extent produces errno -28 no
space left, and then the fs goes read-only?

-- 
Chris Murphy

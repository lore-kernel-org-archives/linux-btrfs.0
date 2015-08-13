Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33924 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbHMX3b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 19:29:31 -0400
Received: by wicne3 with SMTP id ne3so2103497wic.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:29:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150813225406.GQ12976@carfax.org.uk>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
	<55CC830D.2070304@gmail.com>
	<CA+WRLO9ZbjZyNnMM951xrkE5OqymO3E8gMeebOpkX1a4qCS+6g@mail.gmail.com>
	<20150813225406.GQ12976@carfax.org.uk>
Date: Fri, 14 Aug 2015 09:29:30 +1000
Message-ID: <CA+WRLO9ub4gX1Rj9+f1APNujL7zk_p7NApUUS-ExkfbuPjMQDQ@mail.gmail.com>
Subject: Re: RAID0 wrong (raw) device?
From: Gareth Pye <gareth@cerberos.id.au>
To: Hugo Mills <hugo@carfax.org.uk>, Gareth Pye <gareth@cerberos.id.au>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I would have been surprised if any generic file system copes well with
being mounted in several locations at once, DRBD appears to fight
really hard to avoid that happening :)

And yeah I'm doing the second thing, I've successfully switched which
of the servers is active a few times with no ill effect (I would
expect scrub to give me some significant warnings if one of the disks
was a couple of months out of date) so I'm presuming that DRBD copes
reasonably well or I've been very lucky. Either that luck is very
deterministic, DRBD copes correctly, or I've been very very lucky.

Very very lucky doesn't sound likely.

On Fri, Aug 14, 2015 at 8:54 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Aug 14, 2015 at 08:32:46AM +1000, Gareth Pye wrote:
>> On Thu, Aug 13, 2015 at 9:44 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>> > 3. See the warnings about doing block level copies and LVM snapshots of
>> > BTRFS volumes, the same applies to using it on DRBD currently as well (with
>> > the possible exception of remote DRBD nodes (ie, ones without a local copy
>> > of the backing store) (in this case, we need to blacklist backing devices
>> > for stacked storage (I think the same issue may be present with BTRFS on a
>> > MD based RAID1 set).
>>
>>
>> I've been using BTRFS on top of DRBD for several years now, what
>> specifically am I meant to avoid?
>>
>> I have 6 drives mirrored across a local network, this is done with DRBD.
>> At any one time only a single server has the 6 drives mounted with btrfs.
>> Is this a ticking time bomb?
>
>    There are two things which are potentially worrisome here:
>
>  - Having the same filesystem mounted on more than one machine at a
>    time (which you're not doing).
>
>  - Having one or more of the DRBD backing store devices present on the
>    same machine that the DRBD filesystem is mounted on (which you may
>    be doing).
>
>    Of these, the first is definitely going to be dangerous. The second
> may or may not be, depending on how well DRBD copes with direct writes
> to its backing store, and how lucky you are about the kernel
> identifying the right devices to use for the FS.
>
>    Hugo.
>
> --
> Hugo Mills             | "Big data" doesn't just mean increasing the font
> hugo@... carfax.org.uk | size.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"

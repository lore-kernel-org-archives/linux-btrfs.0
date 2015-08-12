Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:33273 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbHLRxE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 13:53:04 -0400
Received: by vkbc123 with SMTP id c123so8866521vkb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 10:53:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150812174352.GN12976@carfax.org.uk>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
	<CAJCQCtRTvn-Xu_ipM7pCTtVuxUm0m7kjqt=F=+q6cj0vOOhF7g@mail.gmail.com>
	<20150812174352.GN12976@carfax.org.uk>
Date: Wed, 12 Aug 2015 11:53:03 -0600
Message-ID: <CAJCQCtQcp36g1OC5Y5Wjz4Lnj1izNCWke2e4oZdEvhVOZYK=RQ@mail.gmail.com>
Subject: Re: RAID0 wrong (raw) device?
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 12, 2015 at 11:43 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> [adding Ulli back into the cc list]
>
> On Wed, Aug 12, 2015 at 11:03:00AM -0600, Chris Murphy wrote:
>> On Wed, Aug 12, 2015 at 7:07 AM, Ulli Horlacher
>> <framstag@rus.uni-stuttgart.de> wrote:
>>
>> > /dev/sdb and /dev/sde are in reality the same physical disk!
>>
>> When does all of this confusion happen? Is it already confused before
>> mkfs or only after mkfs or only after mount? I would find out what
>> instigates it, wipe all signatures from everything, reboot, start from
>> scratch, and then strace the command that causes the confusion. And
>> attach that output as well as the entire dmesg to a bug report. Just
>> my 2 cents, I have no idea what's going on but sounds like a block
>> layer and/or drdb bug that's triggered by Btrfs multiple device
>> setups.
>
>    If (some of) the DRBD host devices are also physically present on
> the machine to which the DRBDs are exported, then you're in the same
> situation as having block-level snapshots or dd copies of the data --
> the FS will see two devices (the backing store and the DRBD) which are
> have the same UUID. It will pick an arbitrary one to write to, which
> is probably not something that the DRBD driver will cope with very
> well, I suspect.
>
>    I think the solution here would be to blacklist the backing store
> from btrfs dev scan. I recall that there was such a capability at some
> point -- I don't know if it made it into the userspace tools?

That makes sense. But then this would also affect XFS also I'd think,
except XFS will refuse to mount if the kernel sees two of the same fs
UUID.

-- 
Chris Murphy

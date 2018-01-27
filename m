Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:44835 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbeA0WmB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 17:42:01 -0500
Date: Sat, 27 Jan 2018 23:42:00 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180127224200.GA16927@polanet.pl>
References: <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20180127132641.mhmdhpokqrahgd4n@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 27, 2018 at 14:26:41 +0100, Adam Borowski wrote:

> It's quite obvious who's the culprit: every single remaining rc system
> manages to mount degraded btrfs without problems.  They just don't try to
> outsmart the kernel.

Yes. They are stupid enough to fail miserably with any more complicated
setups, like stacking volume managers, crypto layer, network attached
storage etc.
Recently I've started mdadm on top of bunch of LVM volumes, with others
using btrfs and others prepared for crypto. And you know what? systemd
assembled everything just fine.

So with argument just like yours:

It's quite obvious who's the culprit: every single remaining filesystem
manages to mount under systemd without problems. They just expose
informations about their state.

>> This is not a systemd issue, but apparently btrfs design choice to allow
>> using any single component device name also as volume name itself.
> 
> And what other user interface would you propose? The only alternative I see
> is inventing a device manager (like you're implying below that btrfs does),
> which would needlessly complicate the usual, single-device, case.

The 'needless complication', as you named it, usually should be the default
to use. Avoiding LVM? Then take care of repartitioning. Avoiding mdadm?
No easy way to RAID the drive (there are device-mapper tricks, they are
just way more complicated). Even attaching SSD cache is not trivial
without preparations (for bcache being the absolutely necessary, much
easier with LVM in place).

>> If btrfs pretends to be device manager it should expose more states,
> 
> But it doesn't pretend to.

Why mounting sda2 requires sdb2 in my setup then?

>> especially "ready to be mounted, but not fully populated" (i.e.
>> "degraded mount possible"). Then systemd could _fallback_ after timing
>> out to degraded mount automatically according to some systemd-level
>> option.
> 
> You're assuming that btrfs somehow knows this itself.

"It's quite obvious who's the culprit: every single volume manager keeps
track of it's component devices".

>  Unlike the bogus
> assumption systemd does that by counting devices you can know whether a
> degraded or non-degraded mount is possible, it is in general not possible to
> know whether a mount attempt will succeed without actually trying.

There is a term for such situation: broken by design.

> Compare with the 4.14 chunk check patchset by Qu -- in the past, btrfs did
> naive counting of this kind, it had to be replaced by actually checking
> whether at least one copy of every block group is actually present.

And you still blame systemd for using BTRFS_IOC_DEVICES_READY?

[...]
> just slow to initialize (USB...).  So, systemd asks sda how many devices
> there are, answer is "3" (sdb and sdc would answer the same, BTW).  It can
> even ask for UUIDs -- all devices are present.  So, mount will succeed,
> right?

Systemd doesn't count anything, it asks BTRFS_IOC_DEVICES_READY as
implemented in btrfs/super.c.

> Ie, the thing systemd can safely do, is to stop trying to rule everything,
> and refrain from telling the user whether he can mount something or not.

Just change the BTRFS_IOC_DEVICES_READY handler to always return READY.

-- 
Tomasz Pala <gotar@pld-linux.org>

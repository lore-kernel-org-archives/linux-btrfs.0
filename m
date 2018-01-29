Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:39952 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeA2Nmh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 08:42:37 -0500
Received: by mail-it0-f65.google.com with SMTP id 196so9331826iti.5
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 05:42:37 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Tomasz Pala <gotar@polanet.pl>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
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
 <20180127224200.GA16927@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6b6b8e07-27b2-c181-49dc-3fbd1cd9e023@gmail.com>
Date: Mon, 29 Jan 2018 08:42:32 -0500
MIME-Version: 1.0
In-Reply-To: <20180127224200.GA16927@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-27 17:42, Tomasz Pala wrote:
> On Sat, Jan 27, 2018 at 14:26:41 +0100, Adam Borowski wrote:
> 
>> It's quite obvious who's the culprit: every single remaining rc system
>> manages to mount degraded btrfs without problems.  They just don't try to
>> outsmart the kernel.
> 
> Yes. They are stupid enough to fail miserably with any more complicated
> setups, like stacking volume managers, crypto layer, network attached
> storage etc.
I think you mean any setup that isn't sensibly layered.  BCP for over a 
decade has been to put multipathing at the bottom, then crypto, then 
software RAID, than LVM, and then whatever filesystem you're using. 
Multipathing has to be the bottom layer for a given node because it 
interacts directly with hardware topology which gets obscured by the 
other layers.  Crypto essentially has to be next, otherwise you leak 
info about the storage stack.  Swapping LVM and software RAID ends up 
giving you a setup which is difficult for most people to understand and 
therefore is hard to reliably maintain.

Other init systems enforce things being this way because it maintains 
people's sanity, not because they have significant difficulty doing 
things differently (and in fact, it is _trivial_ to change the ordering 
in some of them, OpenRC on Gentoo for example quite literally requires 
exactly N-1 lines to change in each of N files when re-ordering N 
layers), provided each layer occurs exactly once for a given device and 
the relative ordering is the same on all devices.  And you know what? 
Given my own experience with systemd, it has exactly the same constraint 
on relative ordering.  I've tried to run split setups with LVM and 
dm-crypt where one device had dm-crypt as the bottom layer and the other 
had it as the top layer, and things locked up during boot on _every_ 
generalized init system I tried.

> Recently I've started mdadm on top of bunch of LVM volumes, with others
> using btrfs and others prepared for crypto. And you know what? systemd
> assembled everything just fine.
> 
> So with argument just like yours:
> 
> It's quite obvious who's the culprit: every single remaining filesystem
> manages to mount under systemd without problems. They just expose
> informations about their state.
No, they don't (except ZFS).  There is no 'state' to expose for anything 
but BTRFS (and ZFS) except possibly if the filesystem needs checked or 
not.  You're conflating filesystems and volume management.

The alternative way of putting what you just said is:
Every single remaining filesystem manages to mount under systemd without 
problems, because it doesn't try to treat them as a block layer.
> 
>>> This is not a systemd issue, but apparently btrfs design choice to allow
>>> using any single component device name also as volume name itself.
>>
>> And what other user interface would you propose? The only alternative I see
>> is inventing a device manager (like you're implying below that btrfs does),
>> which would needlessly complicate the usual, single-device, case.
> 
> The 'needless complication', as you named it, usually should be the default
> to use. Avoiding LVM? Then take care of repartitioning. Avoiding mdadm?
> No easy way to RAID the drive (there are device-mapper tricks, they are
> just way more complicated). Even attaching SSD cache is not trivial
> without preparations (for bcache being the absolutely necessary, much
> easier with LVM in place).
For a bog-standard client system, all of those _ARE_ overkill (and 
actually, so is BTRFS in many cases too, it's just that we're the only 
option for main-line filesystem-level snapshots at the moment).
> 
>>> If btrfs pretends to be device manager it should expose more states,
>>
>> But it doesn't pretend to.
> 
> Why mounting sda2 requires sdb2 in my setup then?
First off, it shouldn't unless you're using a profile that doesn't 
tolerate any missing devices and have provided the `degraded` mount 
option.  It doesn't in your case because you are using systemd.

Second, BTRFS is not a volume manager, it's a filesystem with 
multi-device support.  The difference is that it's not a block layer, 
despite the fact that systemd is treating it as such.   Yes, BTRFS has 
failure modes that result in regular operations being refused based on 
what storage devices are present, but so does every single distributed 
filesystem in existence, and none of those are volume managers either.
> 
>>> especially "ready to be mounted, but not fully populated" (i.e.
>>> "degraded mount possible"). Then systemd could _fallback_ after timing
>>> out to degraded mount automatically according to some systemd-level
>>> option.
>>
>> You're assuming that btrfs somehow knows this itself.
> 
> "It's quite obvious who's the culprit: every single volume manager keeps
> track of it's component devices".
> 
>>   Unlike the bogus
>> assumption systemd does that by counting devices you can know whether a
>> degraded or non-degraded mount is possible, it is in general not possible to
>> know whether a mount attempt will succeed without actually trying.
> 
> There is a term for such situation: broken by design.
So in other words, it's broken by design to try to connect to a remote 
host without pinging it first to see if it's online?  Or to try to send 
a signal to a given process without first checking that it's still 
running, or to open a file without first checking if we have permission 
to read it, or to try to mount any other filesystem without first 
checking if the superblock is valid?

In all of those cases, there is no advantage to trying to figure out if 
what you're trying to do is going to work before doing it, because every 
one of those operations is functionally atomic (it either happens or it 
doesn't, period), and has a clear-cut return code that tells you 
directly if it succeeded or not.

There's a name for the type of design you're saying we should have here, 
it's called a time of check time of use (TOCTOU) race condition.  It's 
one of the easiest types of race conditions to find, and also one of the 
easiest to fix.  Ask any sane programmer, and he will say that _that_ is 
broken by design.
> 
>> Compare with the 4.14 chunk check patchset by Qu -- in the past, btrfs did
>> naive counting of this kind, it had to be replaced by actually checking
>> whether at least one copy of every block group is actually present.
> 
> And you still blame systemd for using BTRFS_IOC_DEVICES_READY?
Given that it's been proven that it doesn't work and the developers 
responsible for it's usage don't want to accept that it doesn't work?  Yes.
> 
> [...]
>> just slow to initialize (USB...).  So, systemd asks sda how many devices
>> there are, answer is "3" (sdb and sdc would answer the same, BTW).  It can
>> even ask for UUIDs -- all devices are present.  So, mount will succeed,
>> right?
> 
> Systemd doesn't count anything, it asks BTRFS_IOC_DEVICES_READY as
> implemented in btrfs/super.c.
> 
>> Ie, the thing systemd can safely do, is to stop trying to rule everything,
>> and refrain from telling the user whether he can mount something or not.
> 
> Just change the BTRFS_IOC_DEVICES_READY handler to always return READY.
> 
Or maybe we should just remove it completely, because checking it _IS 
WRONG_, which is why no other init system does it, and in fact no 
_human_ who has any kind of basic knowledge of how BTRFS operates does 
it either.

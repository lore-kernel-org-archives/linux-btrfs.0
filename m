Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:47388 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752759AbeA3PJv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 10:09:51 -0500
Date: Tue, 30 Jan 2018 16:09:50 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130150950.GB7126@polanet.pl>
References: <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <20180127224200.GA16927@polanet.pl>
 <6b6b8e07-27b2-c181-49dc-3fbd1cd9e023@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <6b6b8e07-27b2-c181-49dc-3fbd1cd9e023@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 29, 2018 at 08:42:32 -0500, Austin S. Hemmelgarn wrote:

>> Yes. They are stupid enough to fail miserably with any more complicated
>> setups, like stacking volume managers, crypto layer, network attached
>> storage etc.
> I think you mean any setup that isn't sensibly layered.

No, I mean any setup that wasn't considered by init system authors.
Your 'sensibly' is not sensible for me.

> BCP for over a 
> decade has been to put multipathing at the bottom, then crypto, then 
> software RAID, than LVM, and then whatever filesystem you're using. 

Really? Let's enumerate some caveats of this:

- crypto below software RAID means double-encryption (wasted CPU),

- RAID below LVM means you're stuck with the same RAID-profile for all
  the VGs. What if I want 3-way RAID1+0 for crucial data, RAID1 for
  system and RAID0 for various system caches (like ccache on software
  builder machine) or transient LVM-level snapshots.

- RAID below filesystem means loosing btrfs-RAID extra functionality,
  like recovering data from different mirror when CRC mismatch happens,

- crypto below LVN means encrypting everything, including data that is
  not sensitive - more CPU wasted,

- RAID below LVM means no way to use SSD acceleration of part of the HDD
  space using MD write-mostly functionality.

What you present is only some sane default, which doesn't mean it covers
all the real-world cases.

My recent server is using:
- raw partitioning for base volumes,
- LVM,
- MD on top of some LVs (varying levels),
- paritioned SSD cache attached to specific VGs,
- crypto on top of selected LV/MD,
- btrfs RAID1 on top of non-MDed LVs.

> Multipathing has to be the bottom layer for a given node because it 
> interacts directly with hardware topology which gets obscured by the 
> other layers.

It is the bottom layer, but I might be attached into volumes at virtually
any place of the logical topology tree. E.g. bare network drive added as
device-mapper mirror target for on-line volume cloning.

> Crypto essentially has to be next, otherwise you leak
> info about the storage stack.

I'm encrypting only the containers that require block-level encryption.
Others might have more effective filesystem-level encryption or even be
some TrueCrypt/whatever images.

> Swapping LVM and software RAID ends up 
> giving you a setup which is difficult for most people to understand and 
> therefore is hard to reliably maintain.

It's more difficult, as you need to maintain manually two (or more) separate VGs with
matching LVs inside. Harder, but more flexible.

> Other init systems enforce things being this way because it maintains 
> people's sanity, not because they have significant difficulty doing 
> things differently (and in fact, it is _trivial_ to change the ordering 
> in some of them, OpenRC on Gentoo for example quite literally requires 
> exactly N-1 lines to change in each of N files when re-ordering N 
> layers), provided each layer occurs exactly once for a given device and 
> the relative ordering is the same on all devices.  And you know what? 

The point is: mainaining all of this logic is NOT the job for init system.
With systemd you need exactly N-N=0 lines of code to make this work.

The appropriate unit files are provided by MD and LVM upstream.
And they include fallback mechanism for degrading volumes.

> Given my own experience with systemd, it has exactly the same constraint 
> on relative ordering.  I've tried to run split setups with LVM and 
> dm-crypt where one device had dm-crypt as the bottom layer and the other 
> had it as the top layer, and things locked up during boot on _every_ 
> generalized init system I tried.

Hard to tell without access to the failing system, but this MIGHT have been:

- old/missing/broken-by-distro-maintainers-who-know-better LVM rules,
- old/bugged systemd, possibly with broken/old cryptsetup rules.

>> It's quite obvious who's the culprit: every single remaining filesystem
>> manages to mount under systemd without problems. They just expose
>> informations about their state.
> No, they don't (except ZFS).

They don't expose informations (as there are none), but they DO mount.

> There is no 'state' to expose for anything but BTRFS (and ZFS)

Does ZFS expose it's state or not?

> except possibly if the filesystem needs checked or 
> not.  You're conflating filesystems and volume management.

btrfs is a filesystem, device manager and volume manager.
I might add DEVICE to a btrfs-thingy.
I might mount the same btrfs-thingy selecting different VOLUME (subVOL=something_other)

> The alternative way of putting what you just said is:
> Every single remaining filesystem manages to mount under systemd without 
> problems, because it doesn't try to treat them as a block layer.

Or: every other volume manager exposes separate block devices.

Anyway - however we put this into words, it is btrfs that behaves differently.

>> The 'needless complication', as you named it, usually should be the default
>> to use. Avoiding LVM? Then take care of repartitioning. Avoiding mdadm?
>> No easy way to RAID the drive (there are device-mapper tricks, they are
>> just way more complicated). Even attaching SSD cache is not trivial
>> without preparations (for bcache being the absolutely necessary, much
>> easier with LVM in place).
> For a bog-standard client system, all of those _ARE_ overkill (and 
> actually, so is BTRFS in many cases too, it's just that we're the only 
> option for main-line filesystem-level snapshots at the moment).

Such standard systems don't have multidevice btrfs volumes neither, so
they are beyond the problem discussed here.

>>>> If btrfs pretends to be device manager it should expose more states,
>>>
>>> But it doesn't pretend to.
>> 
>> Why mounting sda2 requires sdb2 in my setup then?
> First off, it shouldn't unless you're using a profile that doesn't 
> tolerate any missing devices and have provided the `degraded` mount 
> option.  It doesn't in your case because you are using systemd.

I have written this previously (19-22 Dec, "Unexpected raid1 behaviour"):

1. create 2-volume btrfs, e.g. /dev/sda and /dev/sdb,
2. reboot the system into clean state (init=/bin/sh), (or remove btrfs-scan tool),
3. try
mount /dev/sda /test - fails
mount /dev/sdb /test - works
4. reboot again and try in reversed order
mount /dev/sdb /test - fails
mount /dev/sda /test - works

mounting btrfs without "btrfs device scan" doesn't work at
all without udev rules (that mimic behaviour of the command).

> Second, BTRFS is not a volume manager, it's a filesystem with 
> multi-device support.

What is the designatum difference between 'volume' and 'subvolume'?

> The difference is that it's not a block layer, 

As a de facto design choice only.

> despite the fact that systemd is treating it as such.   Yes, BTRFS has 
> failure modes that result in regular operations being refused based on 
> what storage devices are present, but so does every single distributed 
> filesystem in existence, and none of those are volume managers either.

Great example - how is systemd mounting distributed/network filesystems?
Does it mount them blindly, in a loop, or fires some checks against
_plausible_ availability?

In other words, is it:
- the systemd that threats btrfs WORSE than distributed filesystems, OR
- btrfs that requires from systemd to be threaded BETTER than other fss?

>> There is a term for such situation: broken by design.
> So in other words, it's broken by design to try to connect to a remote 
> host without pinging it first to see if it's online?

Trying to connect to remote host without checking if OUR network is
already up and if the remote target MIGHT be reachable using OUR routes.

systemd checks LOCAL conditions: being online in case of network, being
online in case of hardware, being online in case of virtual devices.

> In all of those cases, there is no advantage to trying to figure out if 
> what you're trying to do is going to work before doing it, because every 

...provided there are some measures taken for the premature operation to be
repeated. There is non in btrfs-ecosystem.

> There's a name for the type of design you're saying we should have here, 
> it's called a time of check time of use (TOCTOU) race condition.  It's 
> one of the easiest types of race conditions to find, and also one of the 
> easiest to fix.  Ask any sane programmer, and he will say that _that_ is 
> broken by design.

Explained before.

>> And you still blame systemd for using BTRFS_IOC_DEVICES_READY?
> Given that it's been proven that it doesn't work and the developers 
> responsible for it's usage don't want to accept that it doesn't work?  Yes.

Remove it then.

>> Just change the BTRFS_IOC_DEVICES_READY handler to always return READY.
>> 
> Or maybe we should just remove it completely, because checking it _IS 
> WRONG_,

That's right. But before commiting upstream, check for consequences.
I've already described a few today, pointed the source and gave some
possible alternate solutions.

> which is why no other init system does it, and in fact no 

Other init systems either fail at mounting degraded btrfs just like
systemd does, or have buggy workarounds in their code reimplemented in
each other just to handle thing, that should be centrally organized.

-- 
Tomasz Pala <gotar@pld-linux.org>

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:53307 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753427AbeA3TYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 14:24:55 -0500
Date: Tue, 30 Jan 2018 20:24:53 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130192452.GA1823@polanet.pl>
References: <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <20180127224200.GA16927@polanet.pl>
 <6b6b8e07-27b2-c181-49dc-3fbd1cd9e023@gmail.com>
 <20180130150950.GB7126@polanet.pl>
 <246588cf-01dd-9754-a96b-9fc44e2fd74d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <246588cf-01dd-9754-a96b-9fc44e2fd74d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 11:30:31 -0500, Austin S. Hemmelgarn wrote:

>> - crypto below software RAID means double-encryption (wasted CPU),
> It also means you leak no information about your storage stack.  If 

JBOD

> you're sufficiently worried about data protection that you're using 
> block-level encryption, you should be thinking _very_ hard about whether 
> or not that's an acceptable risk (and it usually isn't).

Nonsense. Block-level encryption is the last resource protection, your
primary concern is to encrypt at the highest level possible. Anyway,
I don't need to care at all about encryption, one of my customer might.
Just stop extending justification of your tight usage pattern to the
rest of the world.

BTW if YOU are sufficiently worried about data protection you need to
use some hardware solution, like OPAL and completely avoid using
consumer-grade (especially SSD) drives. This also saves CPU cycles,
but let's not discuss here the gory details.

If you can't imagine people have different requirements than you, then
this is your mental problem, go solve it somewhere else.

>> - RAID below LVM means you're stuck with the same RAID-profile for all
>>    the VGs. What if I want 3-way RAID1+0 for crucial data, RAID1 for
>>    system and RAID0 for various system caches (like ccache on software
>>    builder machine) or transient LVM-level snapshots.
> Then you skip MD and do the RAID work in LVM with DM-RAID (which 
> technically _is_ MD, just with a different frontend).

1. how is write-mostly handled by LVM-initiated RAID1?
2. how can one split LVM RAID1 to separate volumes in case of bit-rot
situation that requires manual intervention to recover specific copy of
a data (just like btrfs checksumming does automatically in raid1 mode)?

>> - RAID below filesystem means loosing btrfs-RAID extra functionality,
>>    like recovering data from different mirror when CRC mismatch happens,
> That depends on your choice of RAID and the exact configuration of the 

There is no data checksumming in MD-RAID, there is no voting in MD-RAID.
There is FEC mode in dm-verity.

> storage stack.  As long as you expose two RAID devices, BTRFS 
> replication works just fine on top of them.

Taking up 4 times the space? Or going crazy with 2*MD-RAID0?

>> - crypto below LVN means encrypting everything, including data that is
>>    not sensitive - more CPU wasted,
> Encrypting only sensitive data is never a good idea unless you can prove 

Encrypting the sensitive data _AT_or_ABOVE_ the filesystem level is
crucial for any really sensitive data.

> with certainty that you will keep it properly segregated, and even then 
> it's still a pretty bad idea because it makes it obvious exactly where 
> the information you consider sensitive is stored.

ROTFL

Do you really think this would make breaking the XTS easier, than in
would be if the _entire_ drive would be encrypted using THE SAME secret?
With attacker having access to the plain texts _AND_ ciphers?

Wow... - stop doing the crypto, seriously. You do this wrong.

Do you think that my customer or cooperative would happily share HIS
secret with mine, just because we're running on the same server?

Have you ever heard about zero-knowledge databases?
Can you imagine, that some might want to do the decryption remotely,
when he doesn't trust me as the owner of the machine?

How is that me KNOWING, that their data is encrypted, eases the attack?

>> - RAID below LVM means no way to use SSD acceleration of part of the HDD
>>    space using MD write-mostly functionality.
> Again, just use LVM's DM-RAID and throw in DM-cache.  Also, there were 

Obviously you've never used write-mostly, as you're apparently not aware
about the difference in maintenance burden.

> some patches just posted for BTRFS that indirectly allow for this 
> (specifically, they let you change the read-selection algorithm, with 
> the option of specifying to preferentially read from a specific device).

When they will be available in LTS kernel, some will definitely use it
and create even more complicated stacks.

>> It is the bottom layer, but I might be attached into volumes at virtually
>> any place of the logical topology tree. E.g. bare network drive added as
>> device-mapper mirror target for on-line volume cloning.
> And you seriously think that that's going to be a persistent setup? 

Persistent setups are archeology in IT.

> One-shot stuff like that is almost never an issue unless your init 
> system is absolutely brain-dead _and_ you need it working as it was 
> immediately (and a live-clone of a device doesn't if you're doing it right).

Brain-dead is a state of mind, when you reject usage scenarios that you
completely don't understand, hopefully due to the small experience only.

>> The point is: mainaining all of this logic is NOT the job for init system.
>> With systemd you need exactly N-N=0 lines of code to make this work.
> So, I find it very hard to believe that systemd requires absolutely zero 
> configuration of per-device dependencies.

You might resolve your religion doubts in church of your choice, but
technical issues are better verified by experiment.

> If it really doesn't, then 
> that's just more reason I will never use it, as auto-detection opens you 
> up to some quite nasty physical attacks on the system.

ROTFL
There is no auto-detection, but - read my mouth: METADATA. The same
metadata that allows btrfs to mount filesystem after scanning all the
components. The same metadata that incrementally assembles MD.
The same metadata that is called UUID or DEVPATH (of various type).

Ever peeked into /dev/disk, /dev/mapper or /dev/dm-*?

>>> There is no 'state' to expose for anything but BTRFS (and ZFS)
>> 
>> Does ZFS expose it's state or not?
> Yes,

Morons! They could have made dozen of init-scripts maintainers to handle
the logic inside bunch of shell scripts!

> but I'm not quite4 sure exactly how much.

Well, if more than btrfs (i.e. if ANY) - are they morons?

> I assume it exposes enough to check if datasets can be mounted,

Oh, they are sooo-morons!

> but it's also not quite the 
> same situation as BTRFS, because you can start a ZFS volume with half a 
> pool and selectively mount only those datasets that are completely 
> provided by the set of devices you do have.

Isn't it only temporary btrfs limitation? It was supposed to allow
per-subvolume mount options and per-object profile.

>> btrfs is a filesystem, device manager and volume manager.
> BTRFS is a filesystem, it does not manage volumes except in the very 
> limited sense that MD or hardware RAID do, and it does not manage 
> devices (the kernel and udev do so).
> 
>> I might add DEVICE to a btrfs-thingy.
>> I might mount the same btrfs-thingy selecting different VOLUME (subVOL=something_other)
> Except subvolumes aren't really applicable here because they're all or 
> nothing.  If you don't have the base filesystem, you don't have any 
> subvolumes (because what mounting a subvolume actually does is mount the 
> root of the filesystem, and then bind-mount the subvolume onto the 
> specified mount-point).

Technical detail - with not a single subvolume there is no btrfs
filesystem at all.

>> 1. create 2-volume btrfs, e.g. /dev/sda and /dev/sdb,
>> 2. reboot the system into clean state (init=/bin/sh), (or remove btrfs-scan tool),
>> 3. try
>> mount /dev/sda /test - fails
>> mount /dev/sdb /test - works
>> 4. reboot again and try in reversed order
>> mount /dev/sdb /test - fails
>> mount /dev/sda /test - works
>> 
>> mounting btrfs without "btrfs device scan" doesn't work at
>> all without udev rules (that mimic behaviour of the command).
> Actually, try your first mount command above with `-o 
> device=/dev/sda,device=/dev/sdb` and it will work.

Dude... stop writing this bullshit. I got this in fstab _AND_ in
rootflags of kernel cmdline and this DIDN'T work. Haven't seen any
commits improving this behavious since, did I missed one?!

btrfs can NOT be assembled by rootflags=device=... cmdline in contrary
to MD RAID (only with 0.9 metadata BTW, not the 1.0+ ones).

> You don't need 
> global scanning or the udev rules unless you want auto-detection.  The 

You've probably forgot to disable udev or simply didn't check this at all.

> things is, using this mount option (which effectively triggers the scan 
> code directly on the specified devices as part of the mount call) makes 

Show me the code, in case it's really me writing the bullshit here.

> it work in pretty much all init systems except systemd (which still 
> tries to check with udev regardless).

Oh, this is definitely bullshit - btrfs-scanning devices changes state
of IOCTL, so this has no other option than work under systemd.

Have you actually ever used systemd? Or just read too much of
systemd-flame by various wannabies?

>>> Second, BTRFS is not a volume manager, it's a filesystem with
>>> multi-device support.
>> 
>> What is the designatum difference between 'volume' and 'subvolume'?This is largely orthogonal to my comment above, but:
> 
> A volume is an entirely independent data set.  So, the following are all 
> volumes:
> * A partition on a storage device containing a filesystem that needs no 
> other devices.
> * A device-mapper target exposed by LVM.
> * A /dev/md* device exposed by MDADM.
> * The internal device mapping used by BTRFS (which is not exposed 
> _anywhere_ outside of the given filesystem).
> * A ZFS storage pool.

That are technical differences - what is the designatum difference?

> A sub-volume is a BTRFS-specific concept referring to a mostly 
> independent filesystem tree within a BTRFS volume that still depends on 
> the super-blocks, chunk-tree, and a couple of other internal structures 
> from the main filesystem.

LVM volumes also depend on VG metadata. Main btrfs 'volume', that
handles other subvolumes, is only technical difference.

>> Great example - how is systemd mounting distributed/network filesystems?
>> Does it mount them blindly, in a loop, or fires some checks against
>> _plausible_ availability?
> Yes, but availability there is a boolean value.

No, systemd won't try to mount remote filesystems until network is up.

> In BTRFS it's tri-state 
> (as of right now, possibly four to six states in the future depending on 
> what gets merged), and the intermediate (not true or false) state can't 
> be checked in a trivial manner.

All the udev need is: "am I ALLOWED to force-mount this, even if degraded".

And this 'permission' must change after a user-supplied timeout.

>> In other words, is it:
>> - the systemd that threats btrfs WORSE than distributed filesystems, OR
>> - btrfs that requires from systemd to be threaded BETTER than other fss?
> Or maybe it's both?  I'm more than willing to admit that what BTRFS does 
> expose currently is crap in terms of usability.  The reason it hasn't 
> changed is that we (that is, the BTRFS people and the systemd people) 
> can't agree on what it should look like.

This might be ANY way, that allows udev to work just like it works with MD.

>> ...provided there are some measures taken for the premature operation to be
>> repeated. There is non in btrfs-ecosystem.
> Yes, because we expect the user to do so, just like LVM, and MD, and 
> pretty much every other block layer you're claiming we should be 
> behaving like.

MD and LVM export their state, so the userspace CAN react. btrfs doesn't.

>> Other init systems either fail at mounting degraded btrfs just like
>> systemd does, or have buggy workarounds in their code reimplemented in
>> each other just to handle thing, that should be centrally organized.
>> 
> Really? So the fact that I can mount a 2-device volume with RAID1 
> profiles degraded using OpenRC without needing anything more than adding 
> rootflags=degraded to the kernel parameters must be a fluke then...

We are talking about automatic fallback after timeout, not manually
casting any magic spells! Since OpenRC doesn't read rootflags at all:

grep -iE 'rootflags|degraded|btrfs' openrc/**/*

it won't support this without some extra code.

> The thing is, it primarily breaks if there are hardware issues, 
> regardless of the init system being used, but at least the other init 
> systems _give you an error message_ (even if it's really the kernel 
> spitting it out) instead of just hanging there forever with no 
> indication of what's going on like systemd does.

If your systemd waits forever and you have no error messages, report bug
to your distro maintainer, as he is probably the one to blame for fixing
what ain't broken.

-- 
Tomasz Pala <gotar@pld-linux.org>

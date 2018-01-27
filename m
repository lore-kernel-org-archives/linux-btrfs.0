Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:33745 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752685AbeA0Ogv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 09:36:51 -0500
Reply-To: kreijack@inwind.it
Subject: Re: degraded permanent mount option
To: Adam Borowski <kilobyte@angband.pl>, Tomasz Pala <gotar@polanet.pl>
Cc: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
 <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
 <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <0df2d269-e442-d383-7b4b-bccdfcb7c608@libero.it>
Date: Sat, 27 Jan 2018 15:36:48 +0100
MIME-Version: 1.0
In-Reply-To: <20180127132641.mhmdhpokqrahgd4n@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/27/2018 02:26 PM, Adam Borowski wrote:
> On Sat, Jan 27, 2018 at 12:06:19PM +0100, Tomasz Pala wrote:
>> On Sat, Jan 27, 2018 at 13:26:13 +0300, Andrei Borzenkov wrote:
>>
>>>> I just tested to boot with a single drive (raid1 degraded), even with
>>>> degraded option in fstab and grub, unable to boot !  The boot process
>>>> stop on initramfs.
>>>>
>>>> Is there a solution to boot with systemd and degraded array ?
>>>
>>> No. It is finger pointing. Both btrfs and systemd developers say
>>> everything is fine from their point of view.
> 
> It's quite obvious who's the culprit: every single remaining rc system
> manages to mount degraded btrfs without problems.  They just don't try to
> outsmart the kernel.

I think that the real problem relies that the mounting a btrfs filesystem cannot be a responsibility of systemd (or whichever rc-system). Unfortunately in the past it was thought that it would be sufficient to assemble a devices list in the kernel, then issue a simple mount...

I think that all the possible scenarios of a btrfs filesystem are a lot wider than a conventional one; and this approach is too much basic.

Systemd is another factor (which spread the responsibilities); but it is not the real problem.

In the past[*] I proposed a mount helper, which would perform all the device registering and mounting in degraded mode (depending by the option). My idea is that all the policies should be placed only in one place. Now some policies are in the kernel, some in udev, some in systemd... It is a mess. And if something goes wrong, you have to look to several logs to understand which/where is the problem..

I have to point out that there is not a sane default for mounting in degraded mode or not. May be that now RAID1/10 are "mount-degraded" friendly, so it would be a sane default; but for other (raid5/6) I think that this is not mature enough. And it is possible to exist hybrid filesystem (both RAID1/10 and RAID5/6)

Mounting in degraded mode would be better for a root filesystem, than a non-root one (think about remote machine)....

BR
G.Baroncelli

[*]
https://www.spinics.net/lists/linux-btrfs/msg39706.html




> 
>> Treating btrfs volume as ready by systemd would open a window of
>> opportunity when volume would be mounted degraded _despite_ all the
>> components are (meaning: "would soon") be ready - just like Chris Murphy
>> wrote; provided there is -o degraded somewhere.
> 
> For this reason, currently hardcoding -o degraded isn't a wise choice.  This
> might chance once autoresync and devices coming back at runtime are
> implemented.
> 
>> This is not a systemd issue, but apparently btrfs design choice to allow
>> using any single component device name also as volume name itself.
> 
> And what other user interface would you propose?  The only alternative I see
> is inventing a device manager (like you're implying below that btrfs does),
> which would needlessly complicate the usual, single-device, case.
>  
>> If btrfs pretends to be device manager it should expose more states,
> 
> But it doesn't pretend to.
> 
>> especially "ready to be mounted, but not fully populated" (i.e.
>> "degraded mount possible"). Then systemd could _fallback_ after timing
>> out to degraded mount automatically according to some systemd-level
>> option.
> 
> You're assuming that btrfs somehow knows this itself.  Unlike the bogus
> assumption systemd does that by counting devices you can know whether a
> degraded or non-degraded mount is possible, it is in general not possible to
> know whether a mount attempt will succeed without actually trying.
> 
> Compare with the 4.14 chunk check patchset by Qu -- in the past, btrfs did
> naive counting of this kind, it had to be replaced by actually checking
> whether at least one copy of every block group is actually present.
> 
> An example scenario: you have a 3-device filesystem, sda sdb sdc.  Suddenly,
> sda goes offline due to a loose cable, controller hiccup, evil fairies, or
> something of this kind.  The sysadmin notices this, rushes in with an
> USB-attached disk (sdd), rebalances.  After reboot, sda works well (or got
> its cable reseated, etc), while sdd either got accidentally removed or is
> just slow to initialize (USB...).  So, systemd asks sda how many devices
> there are, answer is "3" (sdb and sdc would answer the same, BTW).  It can
> even ask for UUIDs -- all devices are present.  So, mount will succeed,
> right?
>  
>> Unless there is *some* signalling from btrfs, there is really not much
>> systemd can *safely* do.
> 
> Btrfs already tells everything it knows.  To learn more, you need to do most
> of the mount process (whether you continue or abort is another matter). 
> This can't be done sanely from outside the kernel.  Adding finer control
> would be reasonable ("wait and block" vs "try and return immediately") but
> that's about all.  It's be also wrong to have a different interface for
> daemon X than for humans.
> 
> Ie, the thing systemd can safely do, is to stop trying to rule everything,
> and refrain from telling the user whether he can mount something or not.
> And especially, unmounting after the user mounts manually...
> 
> 
> Meow!
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

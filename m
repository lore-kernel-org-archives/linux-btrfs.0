Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:38886 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3AGVlr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 16:41:47 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130107214146.GXTL6475.eastrmfepo202.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>; Mon, 7 Jan 2013 16:41:46 -0500
Message-ID: <50EB4111.4040904@czarc.net>
Date: Mon, 07 Jan 2013 16:41:37 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
CC: Chris Murphy <lists@colorremedies.com>
Subject: Re: /boot as a btrfs subvolume
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com> <50E9CDB3.3010401@petaramesh.org> <50E9D909.1020207@czarc.net> <795F4F16-84AD-4815-9CCB-B3C34BD33BC6@colorremedies.com> <50EAECED.8060809@czarc.net> <31843ED0-51CB-4724-BEB1-5414F25386EC@colorremedies.com>
In-Reply-To: <31843ED0-51CB-4724-BEB1-5414F25386EC@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/07/2013 01:42 PM, Chris Murphy wrote:
> On Jan 7, 2013, at 8:42 AM, Gene Czarcinski <gene@czarc.net> wrote:
>
>> On 01/06/2013 09:00 PM, Chris Murphy wrote:
>>> On Jan 6, 2013, at 1:05 PM, Gene Czarcinski <gene@czarc.net> wrote:
>>>
>>>> On 01/06/2013 02:17 PM, Swâmi Petaramesh wrote:
>>>>> Le 06/01/2013 20:11, Chris Murphy a écrit :
>>>>>> If you use UUID, and you use subvol=, and you don't rename/move your subvolume, it's perfectly safe. Nevertheless, GRUB becoming subvolid aware seems like a good idea to me, but I have no idea what's involved in that.
>>>>> I actually run several machines on which I have /boot in a separate
>>>>> BTRFS subvol, without any issue. I have a multiboot between several
>>>>> different distros (typically Ubuntu, Mint, LMDE, Bodhi... All Ubuntu
>>>>> derivatives except for LMDE which is Debian-based...) sharing the same
>>>>> BTRFS container and using different subvols i.e. UBUNTU/@boot,
>>>>> LMDE/@boot etc...
>>>>>
>>>>> Works just great.
>>>>>
>>>> I assume you have a "grub partition" (or its equivalent) with a grub.cfg file having menuentry definitions [pointing to the different grub.cfg file for each system ... that seems to work well (at least for me).  Currently, os-prober does not support btrfs.
>>>>
>>>> I have taken a little look at the grub2 source code and there is some mention of both btrfs and zfs (and also btrfs subvolumes) in the changelogs.  However, it is not clear to me (and I have not had the time yet) to explore exactly what the source code is doing or not doing.
>>> Well, at least with the f18 version of GRUB 2 2.00, whether alternative Btrfs bootable systems are mounted or not, -mkconfig isn't searching/finding for the /etc/fstab and /etc/default/grub of the other system like it appears to do with other file systems. I don't get any additional entries other than the currently booted Btrfs system.
>>>
>>> So it looks like I'd need to manually add a configfile menu entry, pointing to each Btrfs bootable system. Chainloading from one grub to another is not useful. Better if they're all on the same GRUB, and use configfile.
>>>
>> There appear to be two situations where you have multiple software systems installed on the same hardware (real or virtual) -- root on a btrfs subvolume or /boot installed on an LV.
> I'm unclear on the use case. If /boot is on its own LV, why not just use ext4? If Btrfs, then I'd expect boot to be included in one Btrfs volume, along with home and rootfs. If that's on an LV, the use cases I'm envisioning for that the boot loader wouldn't be aware of the LV (e.g. VM, iSCSI, etc).
Oops.  It is me that was not clear.

Case 1: You have multiple systems installed on one piece of real or 
virtual hardware.  These could be different releases or even different 
distributions.  At least one of these systems has root installed on a 
btrfs subvolume.  When grub2-mkconfig is run on that system everything 
is OK.  Now you are on a different system and you run grub2-mkconfig 
with os-prober enabled so it will look for other systems that could be 
booted.  It will not "see" the system with root on the btrfs subvolume.  
That is because os-prober does not understand btrfs.

Case2: This is similar to the above situation except that you have /boot 
installed in an LV rather than a regular partition with the LV formated 
with ext4.  Similar to the above, if, from a different installed system 
you run grub2-mkconfig with os-prober enabled, the system with the /boot 
in the LV will not be "seen".  I have not looked into this one so it may 
be os-prober or grub2 itself.

Seeing this convinced me to avoid using os-prober and simply have a 
"boot director" with simple menuentry definitions pointing to the 
various grub.cfg files for each system.
>
>> Since developing those patches, I have had second thoughts about how multiboot should be done and now believe that it should involve a grub partition with a simple grub.cfg file and os-prober disabled. The simple grub.cfg file had menuentry definitions which point to the "real" grub.cfg file for each system.
> It's messy without agreement on how to boot all distributions. I've also thought of this primary/public grub.cfg, and secondary/private grub.cfg. The first "forwards" to the grub.cfg for each distribution using configfile or legacyconfigfile. However, that primary GRUB instance necessarily would need to contain the entry for Windows, etc.
>
> So each distribution's grub-mkconfig would need to know to write out a distribution specific grub.cfg which is based on os-prober disabled; but then also be capable of updating the primary grub.cfg - not merely write out a new one.
>
> And then if a distribution is deleted from the system, how is this discovered, and the old entry in the primary grub.cfg removed? Messy.
The hardware systems have four or five software systems on each.  It is 
not so much of deleting an distribution as much as just ignoring it.  
Disk space really is pretty inexpensive these days.
>
>> I do not actually use a grub partition but, instead, a minimal system with grub2 and installation into the MBR.
> grub's core.img can accept a baked in grub.cfg
If this was a true production situation then this would be a good choice 
but I am dealing with more of a laboratory environment with things that 
change a lot.

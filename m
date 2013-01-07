Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo101.cox.net ([68.230.241.213]:33248 "EHLO
	eastrmfepo101.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3AGPmj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 10:42:39 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo101.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130107154238.JDHA2891.eastrmfepo101.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>; Mon, 7 Jan 2013 10:42:38 -0500
Message-ID: <50EAECED.8060809@czarc.net>
Date: Mon, 07 Jan 2013 10:42:37 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
CC: Chris Murphy <lists@colorremedies.com>
Subject: Re: /boot as a btrfs subvolume
References: <50E8986A.2050002@czarc.net> <EEB5FCDE-687D-4EEF-9A85-68703266704C@colorremedies.com> <50E98DC6.3030304@czarc.net> <06B00D7F-F963-4A55-AAA2-7F209DF0AD35@colorremedies.com> <50E9CDB3.3010401@petaramesh.org> <50E9D909.1020207@czarc.net> <795F4F16-84AD-4815-9CCB-B3C34BD33BC6@colorremedies.com>
In-Reply-To: <795F4F16-84AD-4815-9CCB-B3C34BD33BC6@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2013 09:00 PM, Chris Murphy wrote:
> On Jan 6, 2013, at 1:05 PM, Gene Czarcinski <gene@czarc.net> wrote:
>
>> On 01/06/2013 02:17 PM, Swâmi Petaramesh wrote:
>>> Le 06/01/2013 20:11, Chris Murphy a écrit :
>>>> If you use UUID, and you use subvol=, and you don't rename/move your subvolume, it's perfectly safe. Nevertheless, GRUB becoming subvolid aware seems like a good idea to me, but I have no idea what's involved in that.
>>> I actually run several machines on which I have /boot in a separate
>>> BTRFS subvol, without any issue. I have a multiboot between several
>>> different distros (typically Ubuntu, Mint, LMDE, Bodhi... All Ubuntu
>>> derivatives except for LMDE which is Debian-based...) sharing the same
>>> BTRFS container and using different subvols i.e. UBUNTU/@boot,
>>> LMDE/@boot etc...
>>>
>>> Works just great.
>>>
>> I assume you have a "grub partition" (or its equivalent) with a grub.cfg file having menuentry definitions [pointing to the different grub.cfg file for each system ... that seems to work well (at least for me).  Currently, os-prober does not support btrfs.
>>
>> I have taken a little look at the grub2 source code and there is some mention of both btrfs and zfs (and also btrfs subvolumes) in the changelogs.  However, it is not clear to me (and I have not had the time yet) to explore exactly what the source code is doing or not doing.
> Well, at least with the f18 version of GRUB 2 2.00, whether alternative Btrfs bootable systems are mounted or not, -mkconfig isn't searching/finding for the /etc/fstab and /etc/default/grub of the other system like it appears to do with other file systems. I don't get any additional entries other than the currently booted Btrfs system.
>
> So it looks like I'd need to manually add a configfile menu entry, pointing to each Btrfs bootable system. Chainloading from one grub to another is not useful. Better if they're all on the same GRUB, and use configfile.
>
There appear to be two situations where you have multiple software 
systems installed on the same hardware (real or virtual) -- root on a 
btrfs subvolume or /boot installed on an LV.

I worked up a patch to os-prober and a small update to grub2 which 
addresses the root on a btrfs subvolume -- see 
https://bugzilla.redhat.com/show_bug.cgi?id=888341

I have not looked into the /boot in a LV so it may involve os-prober 
also and I am also not sure that it will work with /boot on a btrfs 
subvolume.

Since developing those patches, I have had second thoughts about how 
multiboot should be done and now believe that it should involve a grub 
partition with a simple grub.cfg file and os-prober disabled. The simple 
grub.cfg file had menuentry definitions which point to the "real" 
grub.cfg file for each system.

One of these simple definitions would look like:

menuentry "F18 on BTRFS" {
      insmod  part_msdos
      insmod  btrfs
      set  root='hd0,msdos5'
      configfile  /boot1/grub2/grub.cfg
}

where /boot is on btrfs subvol boot1

I do not actually use a grub partition but, instead, a minimal system 
with grub2 and installation into the MBR.

Gene

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:54899 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab2FTUWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 16:22:00 -0400
Message-ID: <4FE230F2.7060406@libero.it>
Date: Wed, 20 Jun 2012 22:22:10 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: helmut@hullen.de
CC: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <CBFXBeteCXB@helmut.hullen.de>
In-Reply-To: <CBFXBeteCXB@helmut.hullen.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 09:15 PM, Helmut Hullen wrote:
> Hallo, Goffredo,
Hi Helmut,

> 
> Du meintest am 20.06.12:
> 
> [...]
> 
>> Am not saying that we *should* move the kernel away from /boot. I am
>> only saying that having the kernel near /lib/modules *has* some
>> advantages.
> 
>> Few year ago there are some gains to have a separate /boot (ah, the
>> time when the bios were unable to address the bigger disk), where
>> there are the minimum things to bootstrap the system.
> 
>> Now we have the possibility to move the kernel near the modules, and
>> this could lead some interesting possibility: think about different
>> linux installations, with an own kernel version and an own modules
>> version; what are the reasons to put together under /boot different
>> kernel which potential conflicting names ?
> 
> Where is the big problem?
> I use separate subdirectories for different kernels, p.e. "/boot/ 
> 2.6.38.4" or "/boot/3.3.4" or "/boot/3.3.4-big". And these subdirs  
> contain (p.e.) ".config", "vmlinuz", "initrd", "System.map".
> 
> It's a very clear design. No incredibly long filenames.

Let me to explain my set-up.
My filesystem is in a subvolume; only /boot is in another filesystem.
Every time I upgrade, remove, or change the system I take a snapshot,
and regenerate the grub.cfg in order to take in account the new/old
subvolume (a script generates a menu entry for every subvolume, so I am
theoretically able to launch last kernel on every subvolume).

The point is that every snapshot could have a different set of kernel
module, depending by the upgrade history. Often the latest kernel cannot
boot^w work properly with old snapshot.

I am sure that there would be a lot of solutions, like:
- the script could be more smart, adding a grub menu entry only for
valid kernel/subvolume pairs
- the /boot filesystem could have a subdir for each subvolume
[...]

To me it seems that make sense to put the kernel near the /lib/modules
directories: the kernel is coupled with the modules, so why put them in
different three ? Today the modern bootloader could address the full
filesystem, so I don't see any reason to mandate the kernel to be under
/boot.

May be that there is another more rationale solution to my problem. I am
open to suggestions.
To me it was more traumatic the (re)moval of /sbin,/bin,/lib to
/usr/sbin,/usr/sbin,/usr/lib :-) [*]

Thanks
G.Baroncelli

[*] http://fedoraproject.org/wiki/Features/UsrMove

> 
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 


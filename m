Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay01.libero.it ([212.52.84.101]:42399 "EHLO
	outrelay01.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab2FTMKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 08:10:40 -0400
Message-ID: <11261111.239491340194228411.JavaMail.defaultUser@defaultHost>
Date: Wed, 20 Jun 2012 14:10:28 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <list@fajar.net>, "H. Peter Anvin" <hpa@zytor.com>
Subject: R: Re: Subvolumes and /proc/self/mountinfo
Cc: <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

>----Messaggio originale----
>Da: list@fajar.net
>Data: 20/06/2012 8.31
>A: "H. Peter Anvin"<hpa@zytor.com>
>Cc: <linux-btrfs@vger.kernel.org>
>Ogg: Re: Subvolumes and /proc/self/mountinfo
>
>On Wed, Jun 20, 2012 at 10:22 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> a. Make a snapshot of the current root;
>> b. Mount said snapshot;
>> c. Install the new distro on the snapshot;
>> d. Change the bootloader configuration *inside* the snapshot to point
>>   to the snapshot as the root;

Or (as I wrote in an another replay), let the bootloader to start a subvolume 
identified by a path, and  swapping the subvolume via a simple rename.

>> e. Install the bootloader on the snapshot, thereby making the boot
>>   block point to it and making it "live".
>
>
>IMHO a more elegant solution would be similar to what
>(open)solaris/indiana does: make the boot parts (bootloader,
>configuration) as a separate area, separate from root snapshots. In
>solaris case IIRC this is will br /rpool/grub.
>
>A similar approach should be implementable in linux, at least on
>certain configurations, since if you put /boot as part of "/" (thus,
>also on btrfs), AND you don't change the default subvolume, AND the
>roots are on their own subvolume, the paths to vmlinuz and initrd on
>grub.cfg will have subvols name in it. So it's possible to have a
>single grub.cfg having several entries that points to different
>subvols. So you don't need to install a new bootloader to make a
>particular subvol live, you only need to select it from the boot menu.
>
>I'm doing this currently with ubuntu precise, but with
>manually-created grub.cfg though. Still haven't found a way to manage
>this automatically.

My /boot directory is an ext4 filesystem. During a "grup-update", I added an 
hook in the scripts which generates some entries for grub.cfg on the basis of 
the subvolumes which exist. Every entry is equal to the
default one but the options rootflags=subvol=<subvol>. So at the boot I can 
select different root (typicalli the default one and the one before an
aptitude update/upgrade)


Br
G.Baroncelli
>
>-- 
>Fajar
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



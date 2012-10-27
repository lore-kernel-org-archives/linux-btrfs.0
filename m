Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38053 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934354Ab2J0DDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 23:03:18 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so3251101oag.19
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 20:03:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com>
References: <1351168220.1923.6.camel@hughsie-work.lan>
	<64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com>
	<CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com>
	<B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com>
	<CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com>
Date: Sat, 27 Oct 2012 10:03:17 +0700
Message-ID: <CAG1y0seHi9G79XxHqb7XzUFPbOyPX=ft_CNzC+HMS8S87LSCPQ@mail.gmail.com>
Subject: Re: Naming of subvolumes
From: "Fajar A. Nugraha" <list@fajar.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 27, 2012 at 8:58 AM, cwillu <cwillu@cwillu.com> wrote:
>> I haven't tried btrfs send/receive for this purpose, so I can't compare. But btrfs subvolume set-default is faster than the release of my finger from the return key. And it's easy enough the user could do it themselves if they had reasons for regression to a snapshot that differ than the automagic determination of the upgrade pass/fail.
>>
>> The one needed change, however, is to get /etc/fstab to use an absolute reference for home.
>>
>>
>> Chris Murphy

> I'd argue that everything should be absolute references to subvolumes
> (/@home, /@, etc), and neither set-default nor subvolume id's should
> be touched.  There's no need, as you can simply mv those around (even
> while mounted).  More importantly, it doesn't result in a case where
> the fstab in one snapshot points its mountpoint to a different
> snapshot, with all the hilarity that would cause over time, and also
> allows multiple distros to be installed on the same filesystem without
> having them stomp on each others set-defaults: /@fedora, /@rawhide,
> /@ubuntu, /@home, etc.


What I do with zfs, which might also be applicable on btrfs:

- Have a separate dataset to install grub: poolname/boot. This can
also be a dedicated partition, if you want. The sole purpose for this
partition/dataset is to select which dataset's grub.cfg to load next
(using "configfile" directive). The grub.cfg here is edited manually.

- Have different datasets for each versioned OS (e.g. before and after
upgrades): poolname/ROOT/ubuntu-1, poolname/ROOT/ubuntu-2, etc. Each
dataset is independent of each other, contains their own /boot
(complete with grub/grub.cfg, kernel, and initrd). grub.cfg on each
dataset selects its own dataset to boot using "bootfs" kernel command
line.

- Have a common home for all environment: poolname/home

- Have zfs set the mountpoint (or mounted in initramfs, in root case),
so I can get away with an empty fstab.

- Do upgrades/modifications in the currently-booted root environment,
but create a clone of current environment (and give it a different
name) so I can roll back to it if needed.


It works great for me so far, since:
- each boot environment is portable-enough to move around when needed,
with only about four config files needed to be changed (e.g. grub.cfg)
when moving between different computers, or when renaming a root
dataset.

- I can rename each root environment easily, or even move it to
different pool/disk when needed.

- I can move back and forth between multiple versions of the boot
environment (all are ubuntu so far, cause IMHO it currently has best
zfs root support).


So back to the original question, I'd suggest NOT to use either
send/receive or set-default. Instead, setup multiple boot environment
(e.g. old version, current version) and let user choose which one to
boot using a menu. However for this to work, grub (the bootloader, and
the userland programs like "update-grub") needs to be able to refer to
each grub.cfg/kernel/initrd in a global manner regardless of what the
current default subvolume is (zfs' grub code uses something like
/poolname/dataset_name/@/path/to/file/in/dataset).

-- 
Fajar

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:49808 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759140Ab2J0RXC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Oct 2012 13:23:02 -0400
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Naming of (bootable) subvolumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAG1y0seHi9G79XxHqb7XzUFPbOyPX=ft_CNzC+HMS8S87LSCPQ@mail.gmail.com>
Date: Sat, 27 Oct 2012 11:22:59 -0600
Message-Id: <52C8A7E3-239C-45C8-BB50-D66F4C2312D7@colorremedies.com>
References: <1351168220.1923.6.camel@hughsie-work.lan> <64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com> <CAD2FfiExmofSpVsLTpZaZo86gEnPn11Uzd=B7qu0SKv8Ybo7TA@mail.gmail.com> <B7B1C115-D370-4B85-9119-E09152105BCB@colorremedies.com> <CAE5mzvhaM9Y-Dp1WSZSgseFYR=aFjcQqVWcxXOQ05YhXfXFUTA@mail.gmail.com> <CAG1y0seHi9G79XxHqb7XzUFPbOyPX=ft_CNzC+HMS8S87LSCPQ@mail.gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 26, 2012, at 9:03 PM, Fajar A. Nugraha <list@fajar.net> wrote:

> 
> So back to the original question, I'd suggest NOT to use either
> send/receive or set-default. Instead, setup multiple boot environment
> (e.g. old version, current version) and let user choose which one to
> boot using a menu.

Is it possible to make a functioning symbolic or hard link of a subvolume? 

I'm fine with "current" and "previous" options. More than that seems unnecessary. But then, how does the user choose? What's the UI? Is this properly the domain of GRUB2 or something else?

On BIOS machines, perhaps GRUB. On UEFI, I'd say distinctly not GRUB (I think it's a distinctly bad idea to have a combined boot manager and bootloader in a UEFI context, but that's a separate debate).


> However for this to work, grub (the bootloader, and
> the userland programs like "update-grub") needs to be able to refer to
> each grub.cfg/kernel/initrd in a global manner regardless of what the
> current default subvolume is (zfs' grub code uses something like
> /poolname/dataset_name/@/path/to/file/in/dataset).


Example. The following are all subvolumes, subvolume set-default 0, fstab uses subvol=home, subvol=root, subvol=boot for mount options.

toplevel
├── boot
├── home
├── root
├── fedora18
│   ├── boot
│   └── root

On this system, grub-mkconfig produces a grub.cfg only for the system I'm currently booted from. It does not include any entries for fedora18/boot, fedora18/root, even though they are well within the normal search path. And the reference used is relative,  i.e. the kernel parameter in the grub.cfg is rootflags=subvol=root

If it were to create entries potentially for every snapshotted system, it would be a very messy grub.cfg indeed.

It stands to reason that each distro will continue to have their own grub.cfg. 

For BIOS machines, it could be useful if a single core.img containing a single standardized prefix specifying a grub location could be agreed upon. And then merely changing the set-default subvolume would allow different distro grub.cfg's to be found, read and workable with the relative references now in place, (except for home which likely needs to be mounted using subvolid).

For UEFI machines, the plan needs to work with other bootloaders, including the linux kernel's EFISTUB.



Chris Murphy


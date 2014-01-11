Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40841 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750800AbaAKXDX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 18:03:23 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52643 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W27aM-000Gai-54
	for linux-btrfs@vger.kernel.org; Sat, 11 Jan 2014 16:03:22 -0700
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS over LVM remounts read-only
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52D19217.3060106@dblaci.hu>
Date: Sat, 11 Jan 2014 16:03:20 -0700
Message-Id: <600B31B7-08B2-4A72-B8C3-518A736B9DE5@colorremedies.com>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>	<20140111150454.GV15634@carfax.org.uk> <CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com> <52D19217.3060106@dblaci.hu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 11, 2014, at 11:48 AM, Szalma László <dblaci@dblaci.hu> wrote:

> but the grub itself has to be on a standard bios bootable partition (as far as I know)

Negative. GRUB2 has support for pretty much everything out there: ZFS, Btrfs, LVM, LUKS, md raid 0, 1, 10, 5, 6. It will boot Btrfs multiple devices, single, raid1, raid0, and raid10, and zlib or lzo.

The proper modules are baked into core.img during grub-install which determines the requirements for finding grub's root (which is typically /boot/grub). Core.img is embedded in the MBR gap (or into grubx64.efi). And that core.img is all that's needed to locate /boot/grub/ where even more modules can be arbitrarily loaded, as well as grub.cfg. At this point the kernel and initramfs could be anywhere, located, and booted.


Chris Murphy
Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40771 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaDWWDM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:03:12 -0400
Date: Wed, 23 Apr 2014 15:03:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Message-ID: <20140423220312.GK26949@merlins.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info> <20140423205819.GH26949@merlins.org> <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 12:54:57AM +0300, Пламен Петров wrote:
> > It may help to look up what error -38 translates into for that mount error.
> 
> My searches so far failed to return anything useful to solving this problem.
 
Yeah, I searched before you :) this would require reading the kernel source
to track down -38.
(not hard, I just didn't do it)(

> The initrd way will require some reading up on my part - so will have to wait for tomorrow.

On debian, I just have to run this:
update-initramfs -v -c -k `grep linux-source debian/changelog  | awk '{ print $1 }' | sed "s/linux-source-//"`

Then see /etc/initramfs-tools/initramfs.conf
but the defaults should work

Running update-grub2 should give you something like this:
                echo    'Loading Linux 3.12.7-amd64-i915-preempt-20131107 ...'
                linux   /vmlinuz-3.12.7-amd64-i915-preempt-20131107 root=/dev/mapper/cryptroot ro rootflags=subvol=root cryptopts=source=/dev/sda4,keyscript=/sbin/cryptgetpw,discard usbcore.autosuspend=1 pcie_aspm=force i915.i915_enable_rc6 =7 i915.i915_enable_fbc=1 i915.semaphores=1 i915.lvds_downclock=1 acpi_osi=Linux acpi_backlight=vendor 
                echo    'Loading initial ramdisk ...'
                initrd  /initrd.img-3.12.7-amd64-i915-preempt-20131107

> > You don't have to build a
> > new kernel or make btrfs a module, just mounting a working initrd and then
> > trying this again with userland tools will help debug.
> > (alternatively, rescue boot media with your kernel would work too, but that's
> > likely more work to build than an initrd)
> 
> Not more work - just replaced the kernel on the setup/rescue media with mine and the result is the same - see attached image file.
 
That's not what I meant, I meant a rescue media that boots another
filesystem than you root filesystem.
Then from there, you can use normal userland tools to manually mount your
root filesystem and/or see errors.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

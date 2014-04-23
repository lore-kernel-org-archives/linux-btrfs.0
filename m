Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:34939 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751743AbaDWWUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:20:15 -0400
From: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info> <20140423205819.GH26949@merlins.org> <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info> <20140423220312.GK26949@merlins.org>
In-Reply-To: <20140423220312.GK26949@merlins.org>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Thu, 24 Apr 2014 01:20:01 +0300
Message-ID: <000a01cf5f42$2b180b30$81482190$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Marc MERLIN [mailto:marc@merlins.org]
> Sent: Thursday, April 24, 2014 1:03 AM
> To: Пламен Петров
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
> newer?
> 
> On Thu, Apr 24, 2014 at 12:54:57AM +0300, Пламен Петров wrote:
> > > It may help to look up what error -38 translates into for that mount error.
> >
> > My searches so far failed to return anything useful to solving this problem.
> 
> Yeah, I searched before you :) this would require reading the kernel source
> to track down -38.
> (not hard, I just didn't do it)(
> 
> > The initrd way will require some reading up on my part - so will have to wait
> for tomorrow.
> 
> On debian, I just have to run this:
> update-initramfs -v -c -k `grep linux-source debian/changelog  | awk '{ print
> $1 }' | sed "s/linux-source-//"`
> 

Well, I'm using a source based distro - ever heard of CRUX - http://crux.nu/ ?

> Then see /etc/initramfs-tools/initramfs.conf
> but the defaults should work
> 
> Running update-grub2 should give you something like this:
>                 echo    'Loading Linux 3.12.7-amd64-i915-preempt-20131107 ...'
>                 linux   /vmlinuz-3.12.7-amd64-i915-preempt-20131107
> root=/dev/mapper/cryptroot ro rootflags=subvol=root
> cryptopts=source=/dev/sda4,keyscript=/sbin/cryptgetpw,discard
> usbcore.autosuspend=1 pcie_aspm=force i915.i915_enable_rc6 =7
> i915.i915_enable_fbc=1 i915.semaphores=1 i915.lvds_downclock=1
> acpi_osi=Linux acpi_backlight=vendor
>                 echo    'Loading initial ramdisk ...'
>                 initrd  /initrd.img-3.12.7-amd64-i915-preempt-20131107
> 

Never got to understand GRUB2 inner workings... so I keep to what works for me - GRUB Legacy here!

> > > You don't have to build a
> > > new kernel or make btrfs a module, just mounting a working initrd
> > > and then trying this again with userland tools will help debug.
> > > (alternatively, rescue boot media with your kernel would work too,
> > > but that's likely more work to build than an initrd)
> >
> > Not more work - just replaced the kernel on the setup/rescue media with
> mine and the result is the same - see attached image file.
> 
> That's not what I meant, I meant a rescue media that boots another
> filesystem than you root filesystem.
> Then from there, you can use normal userland tools to manually mount your
> root filesystem and/or see errors.
> 
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking Home page:
> http://marc.merlins.org/

I'm trying to boot into the rescue media's environment with my own kernel, but it fails now that my monolithic kernel has no support for initrd whatsoever (or something else missing)!
I guess I’ll leave this testing for tomorrow - getting tired and sleepy now...
Thanks!
---------------------------------
Plamen Petrov


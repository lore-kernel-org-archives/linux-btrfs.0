Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:39718 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305Ab2FTRla (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 13:41:30 -0400
Message-ID: <4FE20B3D.5060704@zytor.com>
Date: Wed, 20 Jun 2012 10:41:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@libero.it>, cwillu <cwillu@cwillu.com>,
        helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com> <4FE1FB9B.1090203@libero.it>
In-Reply-To: <4FE1FB9B.1090203@libero.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 09:34 AM, Goffredo Baroncelli wrote:
> 
> At the first I tough that having the /boot separate could be a good
> thing. Unfortunately /boot contains both the bootloader code and the
> kernel image. The kernel image should be in sync with the contents of
> /lib/modules/....
> 
> This is the tricky point. If I handle /boot inside the filesystem
> submodule a de-sync between the bootloader code and the boot sector
> could happens. In I handle /boot as separate subvolume/filesystem a
> de-sync between the kernel image and the modules could happens.
> 
> Anyway, from a bootloader POV I think that /boot should be handle
> separately (or as filesystem or as subvolume identified by specific ID).
> The best could be move the kernel in the same subvolume as /lib/modules,
> so a switch of the subvolume as root filesystem would be coherent.
> 

You're not really answering the question.   "The best could be move the
kernel in the same subvolume as /lib/modules" isn't really going to
happen... the whole *point* of /boot is that /boot contains everything
needed to get to the point of kernel initialization.

So, sorry, you're out to sea here...

	-hpa


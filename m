Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39088 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaDWSyP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 14:54:15 -0400
Date: Wed, 23 Apr 2014 11:54:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Message-ID: <20140423185413.GF26949@merlins.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2014 at 08:30:08PM +0300, Пламен Петров wrote:
> Can anyone boot a system using btrfs root with linux 3.14 or newer?
> 
> Because I can't.

It works fine for me.

> I'm trying to move some 3.13.x based systems to 3.14.x and the kernel panics
> during boot. It says to append a correct root=sdaX partition, but the one
> provided is correct, because if use 3.13.x with the same kernel command line
> - the system boots fine.
 
My guess is that you have btrfs compiled as a module, it then needs to be in
an initrd, and you either haven't built it and put it in the right place, or
grub isn't setup to load that initrd.

> #menuentry 0
> title Linux
>     root (hd0,0)
>     kernel /vmlinuz rw root=/dev/sda2 vga=6 raid=noautodetect

That's missing an initrd. Are you absolutely certain then that btrfs is
compiled in the kernel and not as a module?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

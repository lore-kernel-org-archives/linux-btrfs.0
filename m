Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60476 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaHDEOU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 00:14:20 -0400
From: Russell Coker <russell@coker.com.au>
To: george@chinilu.com
Reply-To: russell@coker.com.au
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scan not being performed properly on boot
Date: Mon, 04 Aug 2014 14:14:16 +1000
Message-ID: <30613326.hzdtJptJHK@xev>
In-Reply-To: <53DF0553.1010404@chinilu.com>
References: <53DEF7DD.5070002@peter-r.co.uk> <1704788.vV3kpDkpOK@xev> <53DF0553.1010404@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 3 Aug 2014 21:00:19 George Mitchell wrote:
> > But just changing your boot configuration to use /dev/sdx is probably the
> > best option.
> 
> Assuming you are booting with grub2, you will need to use /dev/sdx in 
> the grub2 configuration file.  This is known issue with grub2. Example 
> from my script:

That's not a GRUB issue it's an initrd issue.  GRUB just passes text to the 
kernel.  "cat /proc/cmdline" will show you what GRUB sent to the kernel, the 
programs in the initrd read /proc/cmdline and then do what they think is 
appropriate.

> ----------------------------------------------------------------------------
> ---------- echo    'Loading Linux desktop ...'
> linux   /vmlinuz-desktop root=/dev/sda7 ro splash quiet
> echo    'Loading initial ramdisk ...'
> initrd  /initrd-desktop.img

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/


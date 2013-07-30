Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42611 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab3G3UkE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 16:40:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C9D0B9A06A2
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jul 2013 14:40:03 -0600 (MDT)
Date: Tue, 30 Jul 2013 16:40:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Thorsten Glaser <tg@mirbsd.de>
CC: Josef Bacik <jbacik@fusionio.com>, Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
Message-ID: <20130730204001.GG24583@localhost.localdomain>
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
 <20130730171329.GF24583@localhost.localdomain>
 <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 30, 2013 at 07:02:29PM +0000, Thorsten Glaser wrote:
> Josef Bacik dixit:
> 
> >Can you gdb btrfs.ko and do
> >
> >list *(__btrfs_map_block+0x11c)
> 
> Not easily (the kernel image is from a .deb package),
> and even in a compile tree gdb just says:
> No symbol table is loaded.  Use the "file" command.
> 
> With a bit of cheating and a cross-compiler, this is:
> 
> (gdb) list *0x0000106e
> 0x106e is in __btrfs_map_block (/var/lib/gforge/chroot/home/users/tg/Xl/linux-3.10.1/fs/btrfs/volumes.c:4447).
> 4442            stripe_nr = offset;
> 4443            /*
> 4444             * stripe_nr counts the total number of stripes we have to stride
> 4445             * to get to this block
> 4446             */
> 4447            do_div(stripe_nr, stripe_len);
> 4448
> 4449            stripe_offset = stripe_nr * stripe_len;
> 4450            BUG_ON(offset < stripe_offset);
> 4451
> 

So stripe_len shouldn't be 0, if it is you have bigger problems :).  Is this a
corrupt fs or something?  If there was some sort of corruption that occured then
I suppose stripe_len could be 0 and we'd need to catch that somewhere higher up
the stack and error out.  Is there a way you could check and see if that's the
case?  Thanks,

Josef

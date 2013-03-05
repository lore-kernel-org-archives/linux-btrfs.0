Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab3CEOgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Mar 2013 09:36:35 -0500
Date: Tue, 5 Mar 2013 15:36:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] during balance operation, WARNING: at
 fs/btrfs/relocation.c:1624 replace_file_extents+0x74b/0x7e0 [btrfs]()
Message-ID: <20130305143633.GB21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5134D8D7.9000501@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5134D8D7.9000501@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 04, 2013 at 06:24:39PM +0100, Stefan Behrens wrote:
> Just ran the following command sequence and got lots of WARNINGs.
> The issue is reproducible.
> The box was running the cmason/for-linus that made it into Linux 3.9 RC1.
> 
> #!/bin/sh
> mkfs.btrfs -f /dev/sdl /dev/sdk -m raid1 -d raid1 -l 16384
> mount /dev/sdl /mnt
> dd if=/dev/urandom of=/mnt/urandom.1GB bs=10M count=100 &
> dd if=/dev/zero of=/mnt/zero.4GB bs=10M count=400 &
> (cd ~/kernel-src; tar cf - fs) | (cd /mnt && tar xf -)
> wait
> 
> ((cd ~/kernel-src; tar cf - drivers) | (cd /mnt && tar xf -)) &
> sleep 5
> btrfs fi balance start /mnt

Does the balance finish, report progress or is cancellable?

What I see here is 0% after many minutes. I've filled the fs with a few
4GB files as above, otherwise there are kernel sources compiled (ie.
files < 256M) and balance used to run fine there.

thanks,
david

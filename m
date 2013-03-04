Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36933 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3CDTbk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 14:31:40 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E2CDE7C041F
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Mar 2013 12:31:39 -0700 (MST)
Date: Mon, 4 Mar 2013 14:31:37 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] during balance operation, WARNING: at
 fs/btrfs/relocation.c:1624 replace_file_extents+0x74b/0x7e0 [btrfs]()
Message-ID: <20130304193137.GA30680@shiny.masoncoding.com>
References: <5134D8D7.9000501@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5134D8D7.9000501@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 04, 2013 at 10:24:39AM -0700, Stefan Behrens wrote:
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

This doesn't look new, are you able to trigger it with an older kernel?

-chris

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44514 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3CEPLY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Mar 2013 10:11:24 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C5CC17C0415
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2013 08:11:23 -0700 (MST)
Date: Tue, 5 Mar 2013 10:11:21 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Chris Mason <clmason@fusionio.com>,
        Linux Btrfs List <linux-btrfs@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>
Subject: Re: [BUG] during balance operation, WARNING: at
 fs/btrfs/relocation.c:1624 replace_file_extents+0x74b/0x7e0 [btrfs]()
Message-ID: <20130305151121.GE30680@shiny.masoncoding.com>
References: <5134D8D7.9000501@giantdisaster.de>
 <20130304193137.GA30680@shiny.masoncoding.com>
 <5135DE09.4080605@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5135DE09.4080605@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 05, 2013 at 04:59:05AM -0700, Stefan Behrens wrote:
> On Mon, 4 Mar 2013 14:31:37 -0500, Chris Mason wrote:
> > On Mon, Mar 04, 2013 at 10:24:39AM -0700, Stefan Behrens wrote:
> >> Just ran the following command sequence and got lots of WARNINGs.
> >> The issue is reproducible.
> >> The box was running the cmason/for-linus that made it into Linux 3.9 RC1.
> >>
> >> #!/bin/sh
> >> mkfs.btrfs -f /dev/sdl /dev/sdk -m raid1 -d raid1 -l 16384
> >> mount /dev/sdl /mnt
> >> dd if=/dev/urandom of=/mnt/urandom.1GB bs=10M count=100 &
> >> dd if=/dev/zero of=/mnt/zero.4GB bs=10M count=400 &
> >> (cd ~/kernel-src; tar cf - fs) | (cd /mnt && tar xf -)
> >> wait
> >>
> >> ((cd ~/kernel-src; tar cf - drivers) | (cd /mnt && tar xf -)) &
> >> sleep 5
> >> btrfs fi balance start /mnt
> > 
> > This doesn't look new, are you able to trigger it with an older kernel?
> > 
> 
> git bisect identifies the following post v3.8 commit to be the one:

Is your dd running fallocate?  Trying to figure out how this is related.

-chris

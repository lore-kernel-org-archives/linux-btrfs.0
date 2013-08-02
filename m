Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:49396 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab3HBVZz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 17:25:55 -0400
Received: from mailout-us.gmx.com ([172.19.198.45]) by mrigmx.server.lan
 (mrigmxus001) with ESMTP (Nemesis) id 0MUZKZ-1UfpDO3s2d-00REoX for
 <linux-btrfs@vger.kernel.org>; Fri, 02 Aug 2013 23:25:53 +0200
Cc: sbehrens@giantdisaster.de, zab@redhat.com,
        "David Sterba" <dsterba@suse.cz>
Content-Type: text/plain; charset="utf-8"
Date: Fri, 02 Aug 2013 17:25:52 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130802212552.119430@gmx.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
To: "Mike Audia" <mikey_a@gmx.com>, "David Sterba" <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> ----- Original Message -----
> From: Mike Audia
> Sent: 08/02/13 05:12 PM
> To: David Sterba, linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
>
> > v2:
> > * Stefan pointed out a missing break and that /proc/mounts does not show
> >  the option.
> > * fixed missing goto and extra printk parameter after failed match_int

Another newbie question is which version of the kernel do I need to have in order to cleanly apply this patch?  I am finding that it fails to apply to the current stable kernel code (as of now it is v3.10.4) which makes me think your patch has to be applied to a newer one?  Are you patching against the linux git tree meaning I have to use the 3.11 series to try your code?

Is this the correct git repo: git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Here is the error in patching observed patching against 3.10.4 as described:

patching file fs/btrfs/ctree.h
Hunk #1 succeeded at 1338 (offset -12 lines).
Hunk #2 succeeded at 1929 (offset -40 lines).
patching file fs/btrfs/disk-io.c
Hunk #1 succeeded at 1713 (offset -24 lines).
Hunk #2 FAILED at 1749.
Hunk #3 succeeded at 2172 with fuzz 1 (offset -17 lines).
1 out of 3 hunks FAILED -- saving rejects to file fs/btrfs/disk-io.c.rej
patching file fs/btrfs/super.c
Hunk #1 succeeded at 319 (offset -2 lines).
Hunk #2 succeeded at 360 (offset -2 lines).
Hunk #3 succeeded at 626 (offset -2 lines).
Hunk #4 succeeded at 968 (offset 1 line).

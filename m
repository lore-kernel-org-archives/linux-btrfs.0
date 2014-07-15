Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53588 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbaGOJvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 05:51:47 -0400
From: Russell Coker <russell@coker.com.au>
To: constantine <costas.magnuse@gmail.com>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs and LBA errors
Date: Tue, 15 Jul 2014 19:51:43 +1000
Message-ID: <1462970.GnvBtDSB5Z@xev>
In-Reply-To: <CANcfdL0E+gFkVQWkzy+MJ5PZhB2y51_k3OQF+Ygekhbw=_ZrKg@mail.gmail.com>
References: <CANcfdL3ZUwOGPf2YQpyXYSd8ZoNntyaX8rdQXdciSADGCsb-Sg@mail.gmail.com> <3431118.WpiWX9X6ip@xev> <CANcfdL0E+gFkVQWkzy+MJ5PZhB2y51_k3OQF+Ygekhbw=_ZrKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 15 Jul 2014 11:42:05 constantine wrote:
> Thank you very much for your advice. It worked!

Great!

> I verified that the superblocks 1 and 2 had similar information with
> btrfs-show-super -i 1 /dev/sdc1 (and -i 2) and then with crossed
> fingers:
> btrfs-select-super  -s 2 /dev/sdc1
> which restored my btrfs filesystem.
> 
> Then I runned scrub. For future reference, scrub was "stuck":
> "
> # btrfs scrub status partition/
> scrub status for c1eb1aaf-665a-4337-9d04-3c3921aa67e0
> scrub started at Thu Jul 10 21:30:41 2014, running for 2743 seconds
>    total bytes scrubbed: 193.47GiB with 0 errors
> "
> and could not cancel it:
> "
> btrfs scrub cancel partition/
> ERROR: scrub cancel failed on Downloads/: not running
> "
> After deleting
> /var/lib/btrfs/scrub.status.c1eb1aaf-665a-4337-9d04-3c3921aa67e0 it was
> completed successfully.

That's a known bug.

Now I hope you have made a good backup, the next problem you encounter may not 
be as easy to solve.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/


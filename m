Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56291 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaCWQZN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 12:25:13 -0400
Date: Sun, 23 Mar 2014 09:25:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <20140323162506.GL12833@merlins.org>
References: <20140323152516.GJ12833@merlins.org>
 <20140323161843.GD25400@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140323161843.GD25400@carfax.org.uk>
Subject: Re: btrfs-tools missing "btrfs device delete devid=x path" ?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 23, 2014 at 04:18:43PM +0000, Hugo Mills wrote:
> On Sun, Mar 23, 2014 at 08:25:17AM -0700, Marc MERLIN wrote:
> > I'm still doing some testing so that I can write some howto.
> > 
> > I got that far after a rebalance (mmmh, that took 2 days with little
> > data, and unfortunately 5 deadlocks and reboots.
> > 
> > polgara:/mnt/btrfs_backupcopy# btrfs fi show
> > Label: backupcopy  uuid: eed9b55c-1d5a-40bf-a032-1be6980648e1
> >         Total devices 11 FS bytes used 114.35GiB
> >         devid    1 size 465.76GiB used 32.14GiB path /dev/dm-0
> >         devid    2 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdd1
> >         devid    3 size 465.75GiB used 0.00 path  <----  drive is freed up now.
> >         devid    4 size 465.76GiB used 32.14GiB path /dev/dm-2
> >         devid    5 size 465.76GiB used 32.14GiB path /dev/dm-3
> >         devid    6 size 465.76GiB used 32.14GiB path /dev/dm-4
> >         devid    7 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdi1
> >         devid    8 size 465.76GiB used 32.14GiB path /dev/dm-6
> >         devid    9 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdk1
> >         devid    10 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdl1
> >         devid    11 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sde1
> > Btrfs v3.12
> > 
> > What's the syntax for removing a drive that isn't there?
> 
>    btrfs dev del missing /path
> 
>    Removes all the missing devices.

Aaah, this worked, thank you.
This isn't documented in the 3.12 man page, but I'm guessing it'll be in
the upcoming 3.14.

I'll document this in the raid5 page I'm currently writing.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

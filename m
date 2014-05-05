Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42989 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaEEFun (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 01:50:43 -0400
Date: Sun, 4 May 2014 22:50:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How does "btrfs fi show" show full?
Message-ID: <20140505055029.GM10159@merlins.org>
References: <20140505005412.GS9061@merlins.org>
 <53670F70.1010509@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53670F70.1010509@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 06:11:28AM +0200, Brendan Hide wrote:
> The "per-device" used amount refers to the amount of space that has
> been allocated to chunks. That first one probably needs a balance.
> Btrfs doesn't behave very well when available diskspace is so low
> due to the fact that it cannot allocate any new chunks. An attempt
> to allocate a new chunk will result in ENOSPC errors.
> 
> The "Total" bytes used refers to the total actual data that is stored.

Right. So 'Total used' is what I'm really using, whereas 'devid used' is
actually what is being used due to the way btrfs doesn't seem to reclaim
chunks after they're not used anymore, or some similar problem.

In the second FS:
> >Label: btrfs_pool1  uuid: 4850ee22-bf32-4131-a841-02abdb4a5ba6
> >	Total devices 1 FS bytes used 442.17GiB
> >	devid    1 size 865.01GiB used 751.04GiB path /dev/mapper/cryptroot

The difference is huge between 'Total used' and 'devid used'.

Is btrfs going to fix this on its own, or likely not and I'm stuck doing
a full balance (without filters since I'm balancing data and not
metadata)?

If that helps.
legolas:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=734.01GiB, used=435.29GiB
System, DUP: total=8.00MiB, used=96.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=8.50GiB, used=6.74GiB
Metadata, single: total=8.00MiB, used=0.00

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

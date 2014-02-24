Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55529 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaBXGmb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 01:42:31 -0500
Date: Sun, 23 Feb 2014 22:42:31 -0800
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
Message-ID: <20140224064231.GD15937@merlins.org>
References: <20140224061426.GB15937@merlins.org> <20140224061714.GC15937@merlins.org> <530AE662.5090303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530AE662.5090303@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 02:27:46PM +0800, Wang Shilong wrote:
> >Note that it says running for 5 seconds, but it started 4H ago.
> >
> >Any idea what's going on here?
> What is dmesg output?
> 
> Did it output something like "Skip abort transaction"? Also
> what is your mount option? did you enable nodatasum etc?

sh-4.1# btrfs scrub cancel /mnt/btrfs_pool2
ERROR: scrub cancel failed on /mnt/btrfs_pool2: not running
sh-4.1# 

And no, I get nothing in dmesg.

Now, what's very interesting is that I rebooted the machine, and even after
rebooting, scrub is still being shown as active on 3 of my devices.

sh-4.1# btrfs-scrub-status 
/mnt/btrfs_bigbackup
scrub status for 024ba4d0-dacb-438d-9f1b-eeb34083fe49
scrub device /dev/mapper/crypt_sdl1 (id 1) history
        scrub started at Sun Feb 23 21:32:32 2014 and finished after 262 seconds
        total bytes scrubbed: 2.76GiB with 0 errors
scrub device /dev/dm-6 (id 2) history
        scrub started at Sun Feb 23 21:32:32 2014 and finished after 249 seconds
        total bytes scrubbed: 2.82GiB with 0 errors
scrub device /dev/dm-5 (id 3) history
        scrub started at Sun Feb 23 21:32:32 2014 and finished after 246 seconds
        total bytes scrubbed: 2.82GiB with 0 errors
scrub device /dev/dm-7 (id 4) history
        scrub started at Sun Feb 23 21:32:32 2014 and finished after 260 seconds
        total bytes scrubbed: 2.75GiB with 0 errors
scrub device /dev/dm-8 (id 5) history
        scrub started at Sun Feb 23 21:32:32 2014 and finished after 257 seconds
        total bytes scrubbed: 2.75GiB with 0 errors
/mnt/btrfs_boot
scrub status for e4c1daa8-9c39-4a59-b0a9-86297d397f3b
scrub device /dev/mapper/cryptroot (id 1) history
        scrub started at Sun Feb 23 22:14:36 2014 and was aborted after 18 seconds
        total bytes scrubbed: 992.79MiB with 0 errors
/mnt/btrfs_pool1
scrub status for 6358304a-2234-4243-b02d-4944c9af47d7
scrub device /dev/mapper/dshelf1 (id 1) status
        scrub started at Sun Feb 23 06:50:46 2014, running for 11193 seconds
        total bytes scrubbed: 612.31GiB with 0 errors
/mnt/btrfs_pool2
scrub status for cb9df6d3-a528-4afc-9a45-4fed5ec358d6
scrub device /dev/mapper/dshelf2 (id 1) status
        scrub started at Sun Feb 23 18:29:39 2014, running for 5 seconds
        total bytes scrubbed: 0.00 with 0 errors
/mnt/btrfs_raid0
scrub status for 9f46dbe2-1344-44c3-b0fb-af2888c34f18
scrub device /dev/mapper/cryptraid0 (id 1) status
        scrub started at Sun Feb 23 09:56:57 2014, running for 25 seconds
        total bytes scrubbed: 964.86MiB with 0 errors
sh-4.1# 


sh-4.1# btrfs fi show
Label: btrfs_boot  uuid: e4c1daa8-9c39-4a59-b0a9-86297d397f3b
        Total devices 1 FS bytes used 60.83GiB
        devid    1 size 79.93GiB used 65.04GiB path /dev/mapper/cryptroot

Label: varlocalspace  uuid: 9f46dbe2-1344-44c3-b0fb-af2888c34f18
        Total devices 1 FS bytes used 772.80GiB
        devid    1 size 1.63TiB used 780.04GiB path /dev/mapper/cryptraid0

Label: btrfs_pool1  uuid: 6358304a-2234-4243-b02d-4944c9af47d7
        Total devices 1 FS bytes used 7.13TiB
        devid    1 size 14.55TiB used 7.50TiB path /dev/mapper/dshelf1

Label: btrfs_pool2  uuid: cb9df6d3-a528-4afc-9a45-4fed5ec358d6
        Total devices 1 FS bytes used 2.89TiB
        devid    1 size 7.28TiB used 2.96TiB path /dev/mapper/dshelf2

Label: bigbackup  uuid: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
        Total devices 5 FS bytes used 30.01GiB
        devid    1 size 1.82TiB used 6.02GiB path /dev/mapper/crypt_sdl1
        devid    2 size 1.82TiB used 7.00GiB path /dev/dm-6
        devid    3 size 1.82TiB used 7.00GiB path /dev/dm-5
        devid    4 size 1.82TiB used 6.01GiB path /dev/dm-7
        devid    5 size 1.82TiB used 6.01GiB path /dev/dm-8

Btrfs v3.12
sh-4.1# 

Any other ideas?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

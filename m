Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbcDOLUk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 07:20:40 -0400
Date: Fri, 15 Apr 2016 13:20:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Check if the FSID was seen by comparing
 full UUID
Message-ID: <20160415112036.GE28775@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460672471-12433-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460672471-12433-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 03:21:11PM -0700, Yauhen Kharuzhy wrote:
> is_seen_fsid() uses simple hash to check if FS was seen before at
> walking on FS list in 'filesystem show' command: hash key is first byte
> of the UUID. This function doesn't check full UUID then, so, if there
> are two FS with same first byte in UUIDs exist, only one will be shown:
> 
> root@test:~# btrfs fi show
> Label: 'System'  uuid: 688cb918-7bac-4c8e-9b11-8d047eb14cf4
>         Total devices 2 FS bytes used 1.76GiB
>         devid    1 size 3.46TiB used 4.01GiB path /dev/sda2
>         devid    2 size 6.91TiB used 4.01GiB path /dev/sdb2
> 
> Global spare
> 
> root@test:~# grep btrfs /proc/mounts
> /dev/sda2 / btrfs rw,relatime,space_cache,subvolid=256,subvol=/root 0 0
> /dev/sdc /media/688cb918-7bac-4c8e-9b11-8d047eb14cf4 btrfs rw,relatime,space_cache,subvolid=5,subvol=/ 0 0
> 
> root@test:~# btrfs fi show --all-devices
> Label: 'System'  uuid: 688cb918-7bac-4c8e-9b11-8d047eb14cf4
>         Total devices 2 FS bytes used 1.76GiB
>         devid    1 size 3.46TiB used 4.03GiB path /dev/sda2
>         devid    2 size 6.91TiB used 4.01GiB path /dev/sdb2
> 
> Label: 'test'  uuid: 683b1a80-ca7f-4c4d-b87b-7155401a4d18
>         Total devices 7 FS bytes used 2.06MiB
>         devid    1 size 7.28TiB used 1.57GiB path /dev/sdc
>         devid    2 size 7.28TiB used 1.57GiB path /dev/sdd
>         devid    3 size 7.28TiB used 1.57GiB path /dev/sde
>         devid    4 size 7.28TiB used 1.57GiB path /dev/sdf
>         devid    5 size 7.28TiB used 1.57GiB path /dev/sdg
>         devid    6 size 7.28TiB used 1.57GiB path /dev/sdh
>         devid    7 size 7.28TiB used 1.57GiB path /dev/sdi
> 
> To resolve this collision, search for full FSID in the list of seen
> filesystems.
> 
> Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>

Applied, thanks.

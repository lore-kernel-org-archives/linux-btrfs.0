Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42183 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaJ1RrF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 13:47:05 -0400
Date: Tue, 28 Oct 2014 18:47:03 +0100
From: Petr Janecek <janecek@ucw.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race that makes btrfs_lookup_extent_info miss
 skinny extent items
Message-ID: <20141028174703.GA17026@atrey.karlin.mff.cuni.cz>
References: <20141028130839.GC24064@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141028130839.GC24064@atrey.karlin.mff.cuni.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

[...]
>   This patch seems to fix https://bugzilla.kernel.org/show_bug.cgi?id=64961
> for me: I've been testing it together with
> [PATCH] Btrfs: fix invalid leaf slot access in btrfs_lookup_extent()
> on top of 3.18-rc2 since yesterday, and so far no crashes during balance
> or device remove.

  with a little more data on the fs, btrfs balance aborted with

ERROR: error during balancing '/mnt/b3' - No space left on device
There may be more info in syslog - try dmesg | tail

[104437.841446] BTRFS info (device sdh): 8 enospc errors during balance

There is still plenty of free space on the fs:

root@fs0:~# df /mnt/b3
Filesystem      1K-blocks      Used  Available Use% Mounted on
/dev/sde       7814042460 989236936 5127850672  17% /mnt/b3
root@fs0:~# btrfs fi df /mnt/b3
Data, RAID10: total=974.00GiB, used=967.21GiB
System, RAID1: total=32.00MiB, used=128.00KiB
Metadata, RAID1: total=24.00GiB, used=20.79GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
root@fs0:~# btrfs fi sh /mnt/b3
Label: 'BTR3'  uuid: 9de82766-9f9a-4605-9be7-7b6da9de720c
	Total devices 5 FS bytes used 985.69GiB
	devid    1 size 2.73TiB used 371.03GiB path /dev/sde
	devid    2 size 2.73TiB used 371.00GiB path /dev/sdf
	devid    3 size 2.73TiB used 371.00GiB path /dev/sdg
	devid    4 size 2.73TiB used 371.00GiB path /dev/sdh
	devid    5 size 3.64TiB used 500.03GiB path /dev/sdp

Btrfs v3.17

There was some activity (copying) on that fs during the balance.


Thanks,

Petr

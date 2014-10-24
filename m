Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub004-omc1s3.hotmail.com ([157.55.0.202]:56212 "EHLO
	DUB004-OMC1S3.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432AbaJXNcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 09:32:12 -0400
Message-ID: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>
From: Jasper Verberk <jverberk@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Problem converting data raid0 to raid1: enospc errors during balance
Date: Fri, 24 Oct 2014 13:32:09 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying to change my 4 disk btrfs data from raid0 to raid1. The metadata is allready in raid1 and now I'm trying to also make the data raid1.

I'm getting the following errors and I got told on irc to go report this as a bug.

Hoping there is anybody that can give me a hand here in solving it.


-------------------------------
Command I issued was:

  btrfs balance start -dconvert=raid1,soft /data
-------------------------------

-------------------------------
Error I got:

  ERROR: error during balancing '/data' - No space left on device
  There may be more info in syslog - try dmesg | tail
-------------------------------

-------------------------------
Last lines of dmesg:

[60098.584459] BTRFS info (device sdc): relocating block group 18282971136 flags 9
[60102.422310] BTRFS info (device sdc): relocating block group 5398069248 flags 9
[60102.776406] BTRFS info (device sdc): relocating block group 1103101952 flags 9
[60103.168554] BTRFS info (device sdc): relocating block group 4194304 flags 4
[60103.619552] BTRFS info (device sdc): relocating block group 0 flags 2
[60104.040776] BTRFS info (device sdc): 1046 enospc errors during balance
-------------------------------

-------------------------------
Further info:

root@BlackMesa:/mnt# btrfs fi show
Label: 'data'  uuid: a1e36575-0843-45ab-850e-618a5d8a4b7e
        Total devices 4 FS bytes used 2.75TiB
        devid    1 size 2.73TiB used 1.94TiB path /dev/sdb
        devid    2 size 2.73TiB used 1.94TiB path /dev/sdd
        devid    3 size 2.73TiB used 1.94TiB path /dev/sdc
        devid    4 size 2.73TiB used 1.94TiB path /dev/sde


root@BlackMesa:/mnt# btrfs fi df /data
Data, RAID1: total=2.85TiB, used=790.46GiB
Data, RAID0: total=2.04TiB, used=1.97TiB
System, RAID1: total=8.00MiB, used=612.00KiB
Metadata, RAID1: total=5.00GiB, used=3.39GiB
unknown, single: total=512.00MiB, used=0.00

root@BlackMesa:/mnt# uname -a
Linux BlackMesa 3.17-1-amd64 #1 SMP Debian 3.17-1~exp1 (2014-10-14) x86_64 GNU/Linux

root@BlackMesa:/mnt# btrfs --version
Btrfs v3.14.1
-------------------------------

-------------------------------
And this is what happens when I try to make an image:

root@BlackMesa:/mnt# btrfs-image -c9 -t4 /dev/sdb /home/jasper/dump.image
btrfs-image: disk-io.c:155: readahead_tree_block: Assertion `!(ret)' failed.
Aborted
------------------------------- 		 	   		  
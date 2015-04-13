Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from columbia.partiallystapled.com ([199.38.182.105]:53086 "EHLO
	columbia.partiallystapled.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108AbbDMOAS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:00:18 -0400
Received: from ganymede.homeslice (unknown [IPv6:2602:306:c413:8680:a189:b186:867f:5188])
	(Authenticated sender: gxti)
	by columbia.partiallystapled.com (Postfix) with ESMTPSA id CCA8155F48
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 09:51:11 -0400 (EDT)
Message-ID: <552BC9CD.6090406@partiallystapled.com>
Date: Mon, 13 Apr 2015 09:51:09 -0400
From: Michael Tharp <gxti@partiallystapled.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Degraded volume silently fails to mount
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I've got a 4 disk raid1 volume that has one failed disk. I have so far 
been unable to mount it in degraded mode, but the failure is that 
"mount" silently does nothing.

  # btrfs fi sh
warning devid 2 not found already
Label: 'seneca'  uuid: b9da07f5-c0fd-45ad-861b-d1bcad6cbf4c
	Total devices 4 FS bytes used 581.71GiB
	devid    1 size 931.51GiB used 334.02GiB path /dev/mapper/luks-seneca-1
	devid    3 size 931.51GiB used 334.01GiB path /dev/mapper/luks-seneca-3
	devid    4 size 931.51GiB used 334.01GiB path /dev/mapper/luks-seneca-4
	*** Some devices missing

Btrfs v3.18.1
  # mount -t btrfs -o degraded /dev/mapper/luks-seneca-1 /seneca
  # echo $?
0
  # ls /seneca/
  # grep seneca /proc/mounts
  # dmesg |tail
[   84.955467] BTRFS: device label seneca devid 1 transid 1753 /dev/dm-4
[   87.926347] BTRFS: device label seneca devid 4 transid 1753 /dev/dm-5
[  107.069109] BTRFS: device label seneca devid 3 transid 1753 /dev/dm-6
[  195.267046] BTRFS info (device dm-6): allowing degraded mounts
[  195.267094] BTRFS info (device dm-6): disk space caching is enabled
[  195.267133] BTRFS: has skinny extents
[  195.277615] BTRFS warning (device dm-6): devid 2 missing
[  781.160250] BTRFS info (device dm-6): allowing degraded mounts
[  781.160270] BTRFS info (device dm-6): disk space caching is enabled
[  781.160286] BTRFS: has skinny extents
  # uname -a
Linux ambrosia.homeslice 3.19.3-200.fc21.x86_64 #1 SMP Thu Mar 26 
21:39:42 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
  # btrfs --version
Btrfs v3.18.1


Any ideas?

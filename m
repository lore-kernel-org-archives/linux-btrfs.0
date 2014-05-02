Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-db3lp0081.outbound.protection.outlook.com ([213.199.154.81]:41613
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751015AbaEBKP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 May 2014 06:15:26 -0400
From: George Pochiscan <george.pochiscan@sphs.ro>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Unable to boot
Date: Fri, 2 May 2014 10:00:05 +0000
Message-ID: <1399024804436.53859@sphs.ro>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a problem with a server with Fedora 20 and BTRFS. This server had frequent hard restarts before the filesystem got corrupt and we are unable to boot it.

We have a HP Proliant server with 4 disks @1TB each and Software RAID 5.
It had Debian installed (i don't know the version) and right now i'm using fedora 20 live to try to rescue the  system.

When we try btrfsck /dev/md127 i have a lot of checksum errors, and the output is: 

Checking filesystem on /dev/md127
UUID: e068faf0-2c16-4566-9093-e6d1e21a5e3c
checking extents
checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
checksum verify failed on 1006686208 found 457560AC wanted 6B3ECE11
Csum didn't match
checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
checksum verify failed on 1001492480 found 74CC3F5D wanted C222A2C9
Csum didn't match
-----------------------------------------------------------------

extent buffer leak: start 1006686208 len 4096
found 32039247396 bytes used err is -22
total csum bytes: 41608612
total tree bytes: 388857856
total fs tree bytes: 310124544
total extent tree bytes: 22016000
btree space waste bytes: 126431234
file data blocks allocated: 47227326464
 referenced 42595635200
Btrfs v3.12



When i attempt to repair i have the following error:
-----------------------------------------
Backref 1005817856 parent 5 root 5 not found in extent tree
backpointer mismatch on [1005817856 4096]
owner ref check failed [1006686208 4096]
repaired damaged extent references
Failed to find [1000525824, 168, 4096]
btrfs unable to find ref byte nr 1000525824 parent 0 root 1  owner 1 offset 0
btrfsck: extent-tree.c:1752: write_one_cache_group: Assertion `!(ret)' failed.
Aborted
------------------------------------




I have installed btrfs version 3.12

Linux localhost 3.11.10-301.fc20.x86_64 #1 SMP Thu Dec 5 14:01:17 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

[root@localhost liveuser]# btrfs fi show
Label: none  uuid: e068faf0-2c16-4566-9093-e6d1e21a5e3c
	Total devices 1 FS bytes used 40.04GiB
	devid    1 size 1.82TiB used 43.04GiB path /dev/md127
Btrfs v3.12


Please advice.

Thank you,
George Pochiscan

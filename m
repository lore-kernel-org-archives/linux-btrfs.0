Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46685 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaCJIbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 04:31:08 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel BUG: btrfs send - Incremental backup
Date: Mon, 10 Mar 2014 09:30:12 +0100
Message-ID: <1550249.xHHhKzo2qK@tethys>
In-Reply-To: <531D6B3B.6030804@cn.fujitsu.com>
References: <2853810.EcqZt5vpol@tethys> <1975990.QvfbKRKJvK@tethys> <531D6B3B.6030804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le lundi 10 mars 2014 07:34:18 quwenruo@cn.fujitsu.com a écrit :
> 
> Better check it offline, since online check may not comprehensive than 
> offline check.

Here you are. Tested from an Ubuntu 13.10 live USB, kernel 3.11 and btrfs-
utils 0.20 - this machine usually runs Arch with kernel 3.13 and btrfs-utils 
3.12...

# btrfsck /dev/VG1/TETHYS
Checking filesystem on /dev/VG1/TETHYS
UUID: 9a1ca6f4-1c1b-4a62-a84b-b388066084dc
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 226049665697 bytes used err is 0
total csum bytes: 528376452
total tree bytes: 1692942336
total fs tree bytes: 997363712
total extent tree bytes: 100626432
btree space waste bytes: 287750314
file data blocks allocated: 704903720960
 referenced 691788443648
Btrfs v0.20-rc1

(Exited normally with return code = 0)


Other info you might find relevant (from running system)

# btrfs fi sh
Label: TETHYS  uuid: 9a1ca6f4-1c1b-4a62-a84b-b388066084dc
        Total devices 1 FS bytes used 546.38GiB
        devid    1 size 845.00GiB used 755.04GiB path /dev/dm-3

Label: BOOT  uuid: 6a16d133-4b99-47b2-876f-148a8266f58f
        Total devices 1 FS bytes used 68.03MiB
        devid    1 size 1.00GiB used 236.00MiB path /dev/dm-0

Btrfs v3.12


# btrfs fi df /
Data, single: total=744.01GiB, used=544.80GiB
System, DUP: total=8.00MiB, used=88.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=5.50GiB, used=1.57GiB
Metadata, single: total=8.00MiB, used=0.00


Kind regards.


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E


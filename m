Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.commandict.com.au ([203.190.234.55]:49585 "EHLO
	mascot.commandict.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbJQEVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Oct 2015 00:21:04 -0400
Received: from mascot.commandict.com.au (localhost [IPv6:::1])
	by mascot.commandict.com.au (Postfix) with ESMTP id EE5CF6996D1
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Oct 2015 15:21:00 +1100 (AEDT)
Subject: Re: btrfs replace status >100%
From: =?utf-8?Q?Brett_King?= <brett.king@commandict.com.au>
To: =?utf-8?Q?linux-btrfs=40vger=2Ekernel=2Eorg?=
	<linux-btrfs@vger.kernel.org>
Date: Sat, 17 Oct 2015 15:21:00 +1100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.5621ccac.20e7.00b252f0489a137c@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Henk,
That's encouraging and what I suspected - everything looks fine (even some bitrot picked up through read error corrections on checksum failures, hurray!) and yes I'll resize the new device once it completes.

[root@array ~]# btrfs replace status -1 /export/archive/
547.9% done, 0 write errs, 0 uncorr. read errs

'btrfs filesystem usage' is nifty however also doesn't provide any hints as to progress; the replace operation is from /dev/sdb to /dev/sdj and if the Data value for /dev/sdb was gradually reducing it would make more sense, however it appears the entire operation needs to complete before the source device shows as <device size> unallocated and the destination device shows the same amount of moved chunks. Maybe that's intended due to RAID1 layout (i.e. per subvolume and not per file).

[root@array ~]# btrfs fi usage /export/archive/
Overall:
    Device size:                  46.39TiB
    Device allocated:             41.84TiB
    Device unallocated:            4.55TiB
    Device missing:                  0.00B
    Used:                         41.30TiB
    Free (estimated):              2.55TiB      (min: 2.55TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:20.90TiB, Used:20.63TiB
   /dev/sdb        4.55TiB
   /dev/sdc        5.45TiB
   /dev/sdd        5.46TiB
   /dev/sde        5.46TiB
   /dev/sdf        5.45TiB
   /dev/sdg        5.45TiB
   /dev/sdh        4.55TiB
   /dev/sdi        5.45TiB

Metadata,single: Size:8.00MiB, Used:0.00B
   /dev/sdc        8.00MiB

Metadata,RAID1: Size:23.00GiB, Used:22.14GiB
   /dev/sdb        1.00GiB
   /dev/sdc       10.00GiB
   /dev/sdd        1.00GiB
   /dev/sdf       11.00GiB
   /dev/sdg       11.00GiB
   /dev/sdh        1.00GiB
   /dev/sdi       11.00GiB

System,single: Size:4.00MiB, Used:0.00B
   /dev/sdc        4.00MiB

System,RAID1: Size:8.00MiB, Used:2.91MiB
   /dev/sdf        8.00MiB
   /dev/sdg        8.00MiB

Unallocated:
   /dev/sdb        1.02MiB
   /dev/sdc        5.02MiB
   /dev/sdd        1.02MiB
   /dev/sde        1.02MiB
   /dev/sdf        1.02MiB
   /dev/sdg        1.02MiB
   /dev/sdh        1.02MiB
   /dev/sdi        1.02MiB
   /dev/sdj        4.55TiB
[root@array ~]#

Here's hoping a dev can make the necessary adjustments to improve the status output .. thanks again !

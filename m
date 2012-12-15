Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:47030 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2LOXbZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Dec 2012 18:31:25 -0500
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 8D290EC8BF
	for <linux-btrfs@vger.kernel.org>; Sun, 16 Dec 2012 10:24:37 +1100 (EST)
From: Russell Coker <russell+btrfs@coker.com.au>
Reply-To: russell+btrfs@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Intel 120G SSD write performance with 3.2.0-4-amd64
Date: Sun, 16 Dec 2012 10:23:59 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201212161023.59380.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a system running Debian kernel 3.2.0-4-amd64 with root on a SSD that 
identifies itself as "INTEL SSDSC2CT12 300i" (it's an Intel 120G device).

Here is the /proc/mounts entry which shows that ssd and discard options are 
enabled.

/dev/disk/by-uuid/7939c405-c656-4e85-a6a0-29f17be09585 / btrfs 
rw,seclabel,nodev,noatime,ssd,discard,space_cache 0 0

Here is the "expert mode" output of fdisk which shows that /dev/sda3 (the root 
filesystem) is aligned to a multiple of 4096 sectors (surely 2MB is larger than 
the erase block size although a quick Google search didn't turn up the number 
for that device).

Disk /dev/sda: 255 heads, 63 sectors, 14593 cylinders

Nr AF  Hd Sec  Cyl  Hd Sec  Cyl     Start      Size ID
 1 80  32  33    0  53  55   62       2048     997376 83
 2 00  53  56   62 211  28  183     999424    1953792 82
 3 00 211  29  183 254  63 1023    2953216  231487488 83
 4 00   0   0    0   0   0    0          0          0 00

But I'm seeing very poor write performance, the system will block on disk IO 
when iostat is reporting a few hundred KB/s in writes.  Below is some output 
of "iostat -x 10":

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00  100.00     0.00    50.00     1.00     
1.00   10.00    0.00   10.00  10.00 100.00

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          27.04    0.00    3.10    0.00    0.00   69.86

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.80    0.00  107.70     0.00   116.75     2.17     
1.04    9.66    0.00    9.66   9.28  99.96

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          18.31    0.00    1.82    0.00    0.00   79.87

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00  100.80     0.00    55.60     1.10     
1.00    9.95    0.00    9.95   9.92 100.00


Any suggestions for how to debug or improve things?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

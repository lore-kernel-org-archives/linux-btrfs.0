Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([37.247.55.143]:57699 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbbC2TU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Mar 2015 15:20:59 -0400
Received: from mx1.miceliux.com (unknown [188.164.129.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: relay)
	by mx2.miceliux.com (Postfix) with ESMTPSA id DF932181AFC
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 21:15:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mx1.miceliux.com (Postfix) with ESMTP id ECAC364DDA
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 21:15:29 +0200 (CEST)
Received: from mx1.miceliux.com ([127.0.0.1])
	by localhost (mx1.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id bsDrc7sLhbog for <linux-btrfs@vger.kernel.org>;
	Sun, 29 Mar 2015 21:15:28 +0200 (CEST)
Received: from xenon.lan (unknown [IPv6:2001:470:7950:10:f66d:4ff:fe61:abb4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx1.miceliux.com (Postfix) with ESMTPSA id B0FC564DD8
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 21:15:28 +0200 (CEST)
Message-ID: <1427656526.2251.8.camel@miceliux.com>
Subject: Cannot convert to raid1
From: Juan Orti Alcaine <juan.orti@miceliux.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sun, 29 Mar 2015 21:15:26 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, I'm experiencing problems while balancing a filesystem to 
raid1. The versions I'm using are: 
kernel-4.0.0-0.rc5.git1.3.fc22.x86_64
btrfs-progs-3.19.1-1.fc22.x86_64

The filesystem was created with one device, and I have added two more 
devices afterwards. To convert it to raid1, I have used:

# btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/btrfs_raid1

The balance process has finished, but if I check my filesystem, it 
shows up as single

# btrfs fi show /mnt/btrfs_raid1
Label: 'btrfs_raid1'  uuid: cd7d4b6d-fa6b-4e2e-8b53-116d25ccdf4e
        Total devices 3 FS bytes used 1.19TiB
        devid    1 size 1.81TiB used 410.06GiB path /dev/sdb2
        devid    2 size 1.81TiB used 410.00GiB path /dev/sdc2
        devid    3 size 1.81TiB used 410.00GiB path /dev/sdd2

btrfs-progs v3.19.1

# btrfs fi df /mnt/btrfs_raid1
Data, single: total=1.19TiB, used=1.19TiB
System, DUP: total=32.00MiB, used=176.00KiB
Metadata, DUP: total=5.00GiB, used=3.73GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs fi usage /mnt/btrfs_raid1
Overall:
    Device size:                   5.44TiB
    Device allocated:              1.20TiB
    Device unallocated:            4.24TiB
    Device missing:                  0.00B
    Used:                          1.20TiB
    Free (estimated):              4.24TiB      (min: 2.12TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:1.19TiB, Used:1.19TiB
   /dev/sdb2     406.00GiB
   /dev/sdc2     405.00GiB
   /dev/sdd2     409.00GiB

Metadata,DUP: Size:5.00GiB, Used:3.73GiB
   /dev/sdb2       4.00GiB
   /dev/sdc2       5.00GiB
   /dev/sdd2       1.00GiB

System,DUP: Size:32.00MiB, Used:176.00KiB
   /dev/sdb2      64.00MiB

Unallocated:
   /dev/sdb2       1.41TiB
   /dev/sdc2       1.41TiB
   /dev/sdd2       1.41TiB


-- 
Juan Orti
https://miceliux.com

GPG key: https://miceliux.com/pub/pubkey.asc
GPG fingerprint: 61F0 8272 6882 BCA6 3A35  88F6 B630 4B72 DEEB D08B


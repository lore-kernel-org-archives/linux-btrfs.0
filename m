Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fmxout03.freemail.hu ([195.228.245.73]:23325 "EHLO
	fmxout03.freemail.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbbDYCyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 22:54:09 -0400
Received: from fmxmldata06.freemail.hu (fmlb00.freemail.hu [195.228.245.211])
	by fmxout03.freemail.hu (Postfix) with ESMTP id 0E4FC3414
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2015 04:47:32 +0200 (CEST)
Date: Sat, 25 Apr 2015 04:47:31 +0200 (CEST)
From: None None <whocares0101@freemail.hu>
Subject: btrfs balance start -dconvert=raid5 on raid1 not converting to raid5
To: linux-btrfs@vger.kernel.org
Message-ID: <freemail.20150425044731.99087.1@fmxmldata06.freemail.hu>
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried to convert my btrfs from raid1 to raid5 but after the balance command it's still raid1.
Also for raid56 the wiki says "Parity may be inconsistent after a crash (the "write hole")"
does that mean if I convert metadata to raid5/6 and the parity becomes inconsistent my btrfs will be lost?

Kernel is v4.0 on debian/sid
The filesystem was created with nodesize 8k if I remember correctly
Mount options for /srv/ noatime,nodev,space_cache,subvol=@
No snapshots and only a few subvolumes
Free space is ~450GiB

To convert the data profile to raid5 (with btrfs-progs v3.17) I did
btrfs balance start -v -dconvert=raid5 /srv/
but after the the command was done (after 10 days)
btrfs fi sho /srv/
still shows data as raid1, free space is also what would be expected for raid1
no errors, no problems, no raid5


So I compiled the newer btrfs-progs v3.19.1 and did (I also tried raid6, same result still raid1)
btrfs balance start -v -dconvert=raid5 -dlimit=1 /srv/
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x120): converting, target=128, soft is off, limit=1
Done, had to relocate 1 out of 12071 chunks

dmesg shows only this, no errors
[170427.207107] BTRFS info (device sdj): relocating block group 65294058848256 flags 17
[170461.591056] BTRFS info (device sdj): found 129 extents
[170476.270765] BTRFS info (device sdj): found 129 extents

btrfs fi sho /srv/
shows all data as raid1


btrfs fi sho
Label: none  uuid: xxxxxxxx-xxxx-xxxx-xxxxxxxxxxxxxxxxx
        Total devices 9 FS bytes used 11.78TiB
        devid    1 size 2.73TiB used 2.62TiB path /dev/sdh
        devid    2 size 2.73TiB used 2.62TiB path /dev/sdj
        devid    3 size 2.73TiB used 2.62TiB path /dev/sdg
        devid    4 size 2.73TiB used 2.62TiB path /dev/sdi
        devid    5 size 2.73TiB used 2.62TiB path /dev/sdf
        devid    6 size 2.73TiB used 2.62TiB path /dev/sde
        devid    7 size 2.73TiB used 2.62TiB path /dev/sdc
        devid    9 size 2.73TiB used 2.62TiB path /dev/sdd
        devid   10 size 2.73TiB used 2.62TiB path /dev/sda

btrfs-progs v3.19.1


btrfs fi df /srv/
Data, RAID1: total=11.76TiB, used=11.76TiB
System, RAID1: total=32.00MiB, used=1.62MiB
Metadata, RAID1: total=17.06GiB, used=14.85GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

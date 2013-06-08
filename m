Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1167.vcdns.de ([88.80.200.92]:56740 "EHLO delorus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3FHMrE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Jun 2013 08:47:04 -0400
Received: from [192.168.1.101] (ip-88-153-52-10.unitymediagroup.de [88.153.52.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by delorus.de (Postfix) with ESMTPSA id 101F35048026
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Jun 2013 14:47:01 +0200 (CEST)
Message-ID: <51B327C4.3000304@delorus.de>
Date: Sat, 08 Jun 2013 14:47:00 +0200
From: =?ISO-8859-1?Q?Andr=E9_Schlichting?= <andre@delorus.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Moved partition via dd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I did the following experiment and tried to move a dm-cryped btrfs 
partition to the left on an external 3TB drive.

The old partition had the sector boundaries: 245547520 - 732566527

I deleted this one and created a new one with boundaries: 33024 - 732566640

Now I moved the data
   > sudo dd conv=notrunc bs=4096 iflag=fullblock if=/dev/sdc2 
skip=$((245547520-33024)) seek=0 of=/dev/sdc2

Afterwards I could succesfully open the dm-crypt container
   > cryptsetup luksOpen /dev/sdc2 data-ext

The idea was now to mount the btrfs filesystem and resize it to fill up 
the whole new partition. But the mounting of the btrfs filesystem failed 
with following errors
   > mount /dev/mapper/data-ext /mnt/data-ext/
mount: wrong fs type, bad option, bad superblock on /dev/mapper/data-ext,
          missing codepage or helper program, or other error

          In some cases useful info is found in syslog - try
          dmesg | tail or so.

   > dmesg | tail
[51666.228722] device label data-ext devid 1 transid 2088 
/dev/mapper/data-ext
[51666.230327] btrfs: disk space caching is enabled
[51666.256347] btrfs bad tree block start 13587293097915834379 959572647936
[51666.256854] btrfs bad tree block start 15898041577671574353 959572647936
[51666.256863] Failed to read block groups: -5
[51666.262707] btrfs: open_ctree failed

   > btrfs --version
Btrfs v0.20-rc1-253-g7854c8b

   > btrfsck /dev/mapper/data-ext
Check tree block failed, want=959572647936, have=13587293097915834379
Check tree block failed, want=959572647936, have=13587293097915834379
Check tree block failed, want=959572647936, have=15898041577671574353
Check tree block failed, want=959572647936, have=13587293097915834379
Check tree block failed, want=959572647936, have=13587293097915834379
read block failed check_tree_block
Check tree block failed, want=615210135552, have=9470612182821228052
Check tree block failed, want=615210135552, have=9470612182821228052
Check tree block failed, want=615210135552, have=11515627140616528497
Check tree block failed, want=615210135552, have=11515627140616528497
Check tree block failed, want=615210135552, have=11515627140616528497
read block failed check_tree_block
Checking filesystem on /dev/mapper/data-ext
UUID: eba8eac6-836f-4664-b8b7-e2a405772e5a
checking extents

   > dmesg | tail

[51738.639126] btrfsck[15851]: segfault at 1d3 ip 0000000000413ed0 sp 
00007fff52494e40 error 4 in btrfsck[400000+4d000]

   > btrfs-debug-tree /dev/mapper/data-ext > debug-tree.log 2> 
debug-tree.err

I ran also from the Problem-FAQ
   > btrfs-zero-log /dev/mapper/data-ext
Check tree block failed, want=959572647936, have=13587293097915834379
Check tree block failed, want=959572647936, have=13587293097915834379
Check tree block failed, want=959572647936, have=15898041577671574353
Check tree block failed, want=959572647936, have=13587293097915834379
Check tree block failed, want=959572647936, have=13587293097915834379
read block failed check_tree_block
Check tree block failed, want=615210135552, have=9470612182821228052
Check tree block failed, want=615210135552, have=9470612182821228052
Check tree block failed, want=615210135552, have=11515627140616528497
Check tree block failed, want=615210135552, have=11515627140616528497
Check tree block failed, want=615210135552, have=11515627140616528497
read block failed check_tree_block

   > dmesg | tail
[52362.222122] btrfs-zero-log[16113]: segfault at 1d3 ip 
0000000000401e11 sp 00007fff2f214060 error 4 in btrfs-zero-log[400000+2b000]
[52362.367331] device label data-ext devid 1 transid 2088 /dev/dm-4






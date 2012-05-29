Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55231 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2E2HSv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 03:18:51 -0400
Received: by bkcji2 with SMTP id ji2so2713641bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 00:18:50 -0700 (PDT)
Message-ID: <1338275871.2271.13.camel@ierdnac-hp>
Subject: [btrfs-progs] btrfs fi df output
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: linux-btrfs@vger.kernel.org
Date: Tue, 29 May 2012 10:17:51 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a question regarding "btrfs filesystem df"output.
# btrfs fi df /mnt/test
Data: total=3.01GB, used=512.19MB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00                             <= What this
means? For what is used? I've never seen this incremented
Metadata, DUP: total=2.50GB, used=676.00KB
Metadata: total=8.00MB, used=0.00                        <= the same
question

I have kernel 3.3.6 and btrfs-tools from git.
#mkfs.btrfs /dev/mapper/vg-lvtest
#mount /dev/mapper/vg-lvtest /mnt/test
#dd if=/dev/zero of=/mnt/test/test.file bs=1M count=512 conv=fdatasync
# btrfs fi df /mnt/test
Data: total=3.01GB, used=512.19MB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=2.50GB, used=676.00KB
Metadata: total=8.00MB, used=0.00
ierdnac-hp ~ # 
#umount /mnt/test

These two chunks are the ones that appear below in btrfs-debug-tree ?
Which ones ? In the three there is one 4MB andthree 8MB, one with 2
stripes.

#btrfs-debug-tree /dev/mapper/vg-lvtest 
chunk tree
leaf 20979712 items 12 free space 2557 generation 5 owner 3
fs uuid 6accfaf3-c88a-462e-85fc-35513d0b43d6
chunk uuid 65f22206-a9dd-4053-a660-61bc4ee0be12
	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 3897 itemsize 98
		dev item devid 1 total_bytes 116912029696 bytes used 8627683328
	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 0) itemoff 3817 itemsize 80
		chunk length 4194304 owner 2 type 2 num_stripes 1
			stripe 0 devid 1 offset 0
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 4194304) itemoff 3737 itemsize
80
		chunk length 8388608 owner 2 type 4 num_stripes 1
			stripe 0 devid 1 offset 4194304
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12582912) itemoff 3657 itemsize
80
		chunk length 8388608 owner 2 type 1 num_stripes 1
			stripe 0 devid 1 offset 12582912
	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 20971520) itemoff 3545 itemsize
112
		chunk length 8388608 owner 2 type 34 num_stripes 2
			stripe 0 devid 1 offset 20971520
			stripe 1 devid 1 offset 29360128

Thanks


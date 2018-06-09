Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scc-mailout-kit-01.scc.kit.edu ([129.13.231.81]:52657 "EHLO
        scc-mailout-kit-01.scc.kit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753422AbeFIMhm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Jun 2018 08:37:42 -0400
Received: from kit-msx-32.kit.edu ([2a00:1398:9:f612::32])
        by scc-mailout-kit-01.scc.kit.edu with esmtps (TLS1.2:ECDHE_RSA_AES_256_CBC_SHA384:256)
        (envelope-from <simon.kaiser@kit.edu>)
        id 1fRcsk-0007WU-RN
        for linux-btrfs@vger.kernel.org; Sat, 09 Jun 2018 14:22:12 +0200
From: Simon Kaiser <simon.kaiser@kit.edu>
To: <linux-btrfs@vger.kernel.org>
Subject: corrupt leaf; unaligned key offset for csum item 
Date: Sat, 9 Jun 2018 14:22:20 +0200
Message-ID: <87lgboxi83.fsf@int-nb-181.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm having trouble with my btrfs volume on a Samsung SSD 840 pro.  On
startup I immediately get the error

BTRFS critical (device sda5): corrupt leaf: root=1 block=73263579136
slot=105, unaligned key offset for csum item, have 1271496708 should be
aligned to 4096

I used to make regular backups, but slacked off recently.  Fixing the
filesystem isn't essential in any way, but would save me quite some time
on config tinkering and weeding out vacation photos.  The second of
which I don't enjoy at all...

On similar issues faulty RAM seemed to be the most prominent cause.  I
added a third memory module quite recently which could have caused this,
but I couldn't run memtest long enough yet to verify.

Here's the trimmed dmesg output (full output at
https://pastebin.com/7XF9i09K)

[    4.062748] BTRFS critical (device sda5): corrupt leaf: root=1 block=73263579136 slot=105, unaligned key offset for csum item, have 1271496708 should be aligned to 4096
[    4.063806] BTRFS info (device sda5): no csum found for inode 7810710 start 0
[    4.064260] BTRFS warning (device sda5): csum failed root 257 ino 7810710 off 109201939968 csum 0x5307fa6f expected csum 0x00000000 mirror 1
[    4.075834] BTRFS info (device sdb3): use lzo compression, level 0
[    4.075836] BTRFS info (device sdb3): enabling auto defrag
[    4.075837] BTRFS info (device sdb3): disk space caching is enabled

`brfs inspect-internal dump-tree -b 73263579136 /dev/sda5` (trimmed,
full output at https://pastebin.com/dqBJ3b6D)

btrfs-progs v4.16.1
leaf 73263579136 items 194 free space 4089 generation 530006 owner CSUM_TREE
leaf 73263579136 flags 0x1(WRITTEN) backref revision 1
fs uuid 95b4974b-a798-44b3-99aa-a4eef990aeeb
chunk uuid 9c8f46c3-ba51-4175-857c-8041543fa813
	item 0 key (EXTENT_CSUM EXTENT_CSUM 1268850688) itemoff 16263 itemsize 20
		range start 1268850688 end 1268871168 length 20480
	item 1 key (EXTENT_CSUM EXTENT_CSUM 1268871168) itemoff 16259 itemsize 4
		range start 1268871168 end 1268875264 length 4096
	item 2 key (EXTENT_CSUM EXTENT_CSUM 1268875264) itemoff 16255 itemsize 4
		range start 1268875264 end 1268879360 length 4096
	item 3 key (EXTENT_CSUM EXTENT_CSUM 1268879360) itemoff 16239 itemsize 16
		range start 1268879360 end 1268895744 length 16384
	item 4 key (EXTENT_CSUM EXTENT_CSUM 1268895744) itemoff 16235 itemsize 4
		range start 1268895744 end 1268899840 length 4096
	item 5 key (EXTENT_CSUM EXTENT_CSUM 1268899840) itemoff 16223 itemsize 12
		range start 1268899840 end 1268912128 length 12288
[...]
	item 100 key (EXTENT_CSUM EXTENT_CSUM 1271410688) itemoff 13827 itemsize 8
		range start 1271410688 end 1271418880 length 8192
	item 101 key (EXTENT_CSUM EXTENT_CSUM 1271418880) itemoff 13811 itemsize 16
		range start 1271418880 end 1271435264 length 16384
	item 102 key (EXTENT_CSUM EXTENT_CSUM 1271435264) itemoff 13807 itemsize 4
		range start 1271435264 end 1271439360 length 4096
	item 103 key (EXTENT_CSUM EXTENT_CSUM 1271439360) itemoff 13771 itemsize 36
		range start 1271439360 end 1271476224 length 36864
	item 104 key (EXTENT_CSUM EXTENT_CSUM 1271488512) itemoff 13763 itemsize 8
		range start 1271488512 end 1271496704 length 8192
	item 105 key (EXTENT_CSUM EXTENT_CSUM 1271496708) itemoff 13403 itemsize 360
		range start 1271496708 end 1271865348 length 368640
	item 106 key (EXTENT_CSUM EXTENT_CSUM 1271873536) itemoff 13399 itemsize 4
		range start 1271873536 end 1271877632 length 4096
	item 107 key (EXTENT_CSUM EXTENT_CSUM 1271877632) itemoff 13379 itemsize 20
		range start 1271877632 end 1271898112 length 20480
	item 108 key (EXTENT_CSUM EXTENT_CSUM 1271898112) itemoff 13375 itemsize 4
		range start 1271898112 end 1271902208 length 4096
	item 109 key (EXTENT_CSUM EXTENT_CSUM 1271918592) itemoff 13363 itemsize 12
		range start 1271918592 end 1271930880 length 12288
	item 110 key (EXTENT_CSUM EXTENT_CSUM 1271930880) itemoff 13351 itemsize 12
		range start 1271930880 end 1271943168 length 12288
[...]

`uname -a`

Linux hostname 4.16.12-1-ARCH #1 SMP PREEMPT Fri May 25 23:30:31 UTC 2018 x86_64 GNU/Linux

`btrfs fi show`

Label: 'arch'  uuid: 95b4974b-a798-44b3-99aa-a4eef990aeeb
	Total devices 1 FS bytes used 78.10GiB
	devid    1 size 100.00GiB used 94.05GiB path /dev/sda5

`btrfs fi df`

Data, single: total=90.01GiB, used=76.32GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=4.01GiB, used=1.78GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Is there any chance this can be fixed?  Your help would be greatly
apperciated!

Yours,
Simon

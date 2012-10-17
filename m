Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab2JQMH0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Oct 2012 08:07:26 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9HC7PVD007611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 08:07:26 -0400
Received: from [127.0.0.1] (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q9HC7O5T019996
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2012 08:07:25 -0400
Message-ID: <1350475643.26001.18.camel@fatty>
Subject: Weird checksum error with VM images
From: Alexander Larsson <alexl@redhat.com>
To: linux-btrfs@vger.kernel.org
Date: Wed, 17 Oct 2012 14:07:23 +0200
Content-Type: multipart/mixed; boundary="=-XtvuatIewhfu6IuheDWn"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-XtvuatIewhfu6IuheDWn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

I recently got some checksum errors on my btrfs filesystem that seem
"interesting". This is on a F18 kernel (3.6.0-3.fc18.x86_64) with the
filesystem on a single INTEL SSDSA2CW16 disk (ssd). Its my workstation,
so i do normal development on it, i.e. its not a server. Recently I have
been doing some virt work, so I've been running qemu a lot. I also for
some time had a near full filesystem (98% full, which caused some long
100% cpu use stalls in flush-btrfs-4) but have now freed up some space.

Today when i was copying a VM image i got an I/O error. Turns out that
two of my VM images had checksum errors in them. A full scrub run showed
that these were the only errors on the entire disk. Logs attached.

I was able to copy the win7 image from the log with dd_rescue, but it
had (as can be seen from the log) 8 checksum failures of 4k blocks at
different places in the file.

I've now got a working system again as no other files were affected.
However, this doesn't seem like a hardware error to me, so I'm worried
that there is some underlying issue in btrfs that caused these checksum
errors.

--=-XtvuatIewhfu6IuheDWn
Content-Disposition: attachment; filename="btrfs-logs"
Content-Type: text/plain; name="btrfs-logs"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Copy image files gives me I/O error:

[673070.768001] btrfs csum failed ino 15379268 off 3159482368 csum 1286030660 private 1719954193
[673070.774354] btrfs csum failed ino 15379268 off 3160571904 csum 3480905005 private 69536457
[673070.897491] btrfs csum failed ino 15379268 off 3165626368 csum 1961753175 private 1657165790
[673070.919400] btrfs csum failed ino 15379268 off 3166662656 csum 4206057786 private 1587774525
[673070.922452] btrfs csum failed ino 15379268 off 3167363072 csum 511798528 private 1788313104
[673070.971314] btrfs csum failed ino 15379268 off 3159482368 csum 1286030660 private 1719954193
[673070.971665] btrfs csum failed ino 15379268 off 3159482368 csum 1286030660 private 1719954193
[673486.590277] btrfs csum failed ino 16102441 off 11099144192 csum 544899664 private 2561040867
[673486.741525] btrfs csum failed ino 16102441 off 11099144192 csum 544899664 private 2561040867
[673486.744991] btrfs csum failed ino 16102441 off 11099144192 csum 544899664 private 2561040867

scrub results:

[675630.170827] btrfs: checksum error at logical 14817001472 on dev /dev/sda3, sector 40228032, root 5, inode 16102441, offset 12728803328, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[675630.170833] btrfs: checksum error at logical 14817001472 on dev /dev/sda3, sector 40228032, root 5, inode 16102441, offset 12728803328, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[675630.170838] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[675630.170841] btrfs: unable to fixup (regular) error at logical 14817001472 on dev /dev/sda3
[675695.573571] btrfs: checksum error at logical 26672648192 on dev /dev/sda3, sector 67577896, root 5, inode 16102441, offset 12183031808, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[675695.573574] btrfs: checksum error at logical 26722541568 on dev /dev/sda3, sector 67675344, root 5, inode 16102441, offset 12183052288, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[675695.573576] btrfs: checksum error at logical 26658189312 on dev /dev/sda3, sector 67549656, root 5, inode 16102441, offset 12183011328, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[675695.573577] btrfs: checksum error at logical 26722541568 on dev /dev/sda3, sector 67675344, root 5, inode 16102441, offset 12183052288, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[675695.573579] btrfs: checksum error at logical 26658189312 on dev /dev/sda3, sector 67549656, root 5, inode 16102441, offset 12183011328, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[675695.573581] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[675695.573582] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
[675695.573583] btrfs: unable to fixup (regular) error at logical 26722541568 on dev /dev/sda3
[675695.573583] btrfs: unable to fixup (regular) error at logical 26658189312 on dev /dev/sda3
[675695.573587] btrfs: checksum error at logical 26672648192 on dev /dev/sda3, sector 67577896, root 5, inode 16102441, offset 12183031808, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[675695.573589] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
[675695.573590] btrfs: unable to fixup (regular) error at logical 26672648192 on dev /dev/sda3
[675736.002225] btrfs: checksum error at logical 35882266624 on dev /dev/sda3, sector 85565432, root 5, inode 16102441, offset 12186034176, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[675736.002232] btrfs: checksum error at logical 35882266624 on dev /dev/sda3, sector 85565432, root 5, inode 16102441, offset 12186034176, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[675736.002238] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
[675736.002240] btrfs: unable to fixup (regular) error at logical 35882266624 on dev /dev/sda3
[676096.525832] btrfs: checksum error at logical 116225216512 on dev /dev/sda3, sector 242485256, root 5, inode 16102441, offset 11099144192, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[676096.525838] btrfs: checksum error at logical 116225216512 on dev /dev/sda3, sector 242485256, root 5, inode 16102441, offset 11099144192, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[676096.525844] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
[676096.525846] btrfs: unable to fixup (regular) error at logical 116225216512 on dev /dev/sda3
[676110.241329] btrfs: checksum error at logical 119200296960 on dev /dev/sda3, sector 248295960, root 5, inode 16102441, offset 13004058624, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[676110.241335] btrfs: checksum error at logical 119200296960 on dev /dev/sda3, sector 248295960, root 5, inode 16102441, offset 13004058624, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[676110.241340] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[676110.241343] btrfs: unable to fixup (regular) error at logical 119200296960 on dev /dev/sda3
[676181.366235] btrfs: checksum error at logical 134855159808 on dev /dev/sda3, sector 278871864, root 5, inode 15379268, offset 3159482368, length 4096, links 1 (path: home/alex/.local/share/gnome-boxes/images/ubuntu12.04-2)
[676181.366238] btrfs: checksum error at logical 134856925184 on dev /dev/sda3, sector 278875312, root 5, inode 15379268, offset 3160571904, length 4096, links 1 (path: home/alex/.local/share/gnome-boxes/images/ubuntu12.04-2)
[676181.366240] btrfs: checksum error at logical 134836838400 on dev /dev/sda3, sector 278836080, root 5, inode 15379268, offset 3165626368, length 4096, links 1 (path: home/alex/.local/share/gnome-boxes/images/ubuntu12.04-2)
[676181.366242] btrfs: checksum error at logical 134863417344 on dev /dev/sda3, sector 278887992, root 5, inode 15379268, offset 3166662656, length 4096, links 1 (path: home/alex/.local/share/gnome-boxes/images/ubuntu12.04-2)
[676181.366243] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 8, gen 0
[676181.366244] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 9, gen 0
[676181.366246] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 10, gen 0
[676181.366246] btrfs: unable to fixup (regular) error at logical 134856925184 on dev /dev/sda3
[676181.366247] btrfs: unable to fixup (regular) error at logical 134836838400 on dev /dev/sda3
[676181.366248] btrfs: unable to fixup (regular) error at logical 134863417344 on dev /dev/sda3
[676181.366252] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 11, gen 0
[676181.366254] btrfs: unable to fixup (regular) error at logical 134855159808 on dev /dev/sda3
[676181.484240] btrfs: checksum error at logical 134864138240 on dev /dev/sda3, sector 278889400, root 5, inode 15379268, offset 3167363072, length 4096, links 1 (path: home/alex/.local/share/gnome-boxes/images/ubuntu12.04-2)
[676181.484248] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 12, gen 0
[676181.484251] btrfs: unable to fixup (regular) error at logical 134864138240 on dev /dev/sda3
[676226.584506] btrfs: checksum error at logical 144913842176 on dev /dev/sda3, sector 298517728, root 5, inode 15379268, offset 3173015552, length 4096, links 1 (path: home/alex/.local/share/gnome-boxes/images/ubuntu12.04-2)
[676226.584513] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 13, gen 0
[676226.584516] btrfs: unable to fixup (regular) error at logical 144913842176 on dev /dev/sda3
[676228.257297] btrfs: checksum error at logical 145299263488 on dev /dev/sda3, sector 299270504, root 5, inode 16102441, offset 11259777024, length 4096, links 2 (path: home/alex/.local/share/gnome-boxes/images/Windows 7 Ultimate.iso)
[676228.257304] btrfs: checksum error at logical 145299263488 on dev /dev/sda3, sector 299270504, root 5, inode 16102441, offset 11259777024, length 4096, links 2 (path: var/www/html/x/Windows 7 Ultimate.iso)
[676228.257309] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0, corrupt 14, gen 0
[676228.257312] btrfs: unable to fixup (regular) error at logical 145299263488 on dev /dev/sda3

--=-XtvuatIewhfu6IuheDWn--


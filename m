Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47581 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbbEDQzK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 May 2015 12:55:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YpJe4-0000zg-QB
	for linux-btrfs@vger.kernel.org; Mon, 04 May 2015 18:55:05 +0200
Received: from c-24-5-205-109.hsd1.ca.comcast.net ([24.5.205.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 18:55:04 +0200
Received: from obiwantje by c-24-5-205-109.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 18:55:04 +0200
To: linux-btrfs@vger.kernel.org
From: TheJay <obiwantje@gmail.com>
Subject: [REQ] Help to gain access to btrfsraid6 pool that won't mount
Date: Mon, 4 May 2015 15:44:35 +0000 (UTC)
Message-ID: <mi8452$i00$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ uname -a
Linux thejay-srv03 4.0.0-040000-generic #201504121935 SMP Sun Apr 12 
23:36:33 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v3.19.1

$ sudo btrfs fi show
Label: 'roms03'  uuid: b0025417-4045-4c63-a432-0625b7cc41ea
	Total devices 4 FS bytes used 2.67TiB
	devid    1 size 1.36TiB used 1.36TiB path /dev/sdz
	devid    3 size 1.36TiB used 1.36TiB path /dev/sdaa
	devid    4 size 1.36TiB used 1.36TiB path /dev/sdab
	*** Some devices missing

This pool is a btrfsraid6 pool

when trying to mount I get:

$ sudo mount -t btrfs -o recovery,ro /dev/sdaa /mnt/roms03
mount: wrong fs type, bad option, bad superblock on /dev/sdaa,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

$ dmesg -T|tail
[Mon May  4 08:35:08 2015] BTRFS info (device sdz): enabling auto recovery
[Mon May  4 08:35:08 2015] BTRFS info (device sdz): disk space caching is 
enabled
[Mon May  4 08:35:08 2015] BTRFS: has skinny extents
[Mon May  4 08:35:08 2015] BTRFS: failed to read chunk tree on sdz
[Mon May  4 08:35:08 2015] BTRFS: open_ctree failed

What could I try to see if I can mount this pool and gain access to the 
data?

While I have a backup of the data, next time I may not, and I am trying 
to learn how to go about. 



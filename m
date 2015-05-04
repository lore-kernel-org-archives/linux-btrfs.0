Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36609 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbbEDVgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 May 2015 17:36:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YpO2b-0000a9-7g
	for linux-btrfs@vger.kernel.org; Mon, 04 May 2015 23:36:41 +0200
Received: from c-24-5-205-109.hsd1.ca.comcast.net ([24.5.205.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 23:36:41 +0200
Received: from obiwantje by c-24-5-205-109.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 23:36:41 +0200
To: linux-btrfs@vger.kernel.org
From: TheJay <obiwantje@gmail.com>
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
Date: Mon, 4 May 2015 21:36:35 +0000 (UTC)
Message-ID: <mi8op3$ri6$1@ger.gmane.org>
References: <mi8452$i00$1@ger.gmane.org> <5547E3BF.4090901@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 04 May 2015 23:25:19 +0200, Goffredo Baroncelli wrote:


> A disk is missing, in this case you should use the "degraded" mount option:
> 
> mount -o degraded /dev/sdaa /mnt/roms03


Goffredo - Thanks for responding - I tried that, but to no avail:

$ sudo mount -o degraded /dev/sdaa /mnt/roms03
mount: wrong fs type, bad option, bad superblock on /dev/sdaa,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so


$ dmesg -T|tail
[Mon May  4 14:33:17 2015] BTRFS info (device sdaa): allowing degraded mounts
[Mon May  4 14:33:17 2015] BTRFS info (device sdaa): disk space caching is enabled
[Mon May  4 14:33:17 2015] BTRFS: has skinny extents
[Mon May  4 14:33:17 2015] BTRFS: bdev (null) errs: wr 3, rd 28773, flush 2, corrupt 0, gen 0
[Mon May  4 14:33:22 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Mon May  4 14:33:22 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Mon May  4 14:33:22 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Mon May  4 14:33:22 2015] BTRFS (device sdaa): bad tree block start 8714499618262386624 1585233920
[Mon May  4 14:33:22 2015] BTRFS: Failed to read block groups: -5
[Mon May  4 14:33:22 2015] BTRFS: open_ctree failed


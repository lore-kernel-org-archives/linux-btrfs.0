Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub004-omc1s27.hotmail.com ([157.55.0.226]:53582 "EHLO
	DUB004-OMC1S27.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751879AbbH1PPK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 11:15:10 -0400
Message-ID: <DUB126-W37868A0DCD702A054C464CB46E0@phx.gbl>
From: J - <mailinglists@hotmail.nl>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: BTRFS errors on fresh filesystem
Date: Fri, 28 Aug 2015 17:10:06 +0200
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have noticed a BTRFS error mentioned in two consecutive identical entries  in my kernel log:
"BTRFS error (device sda2): bad extent! em: [0 0] passed [0 4096]"

sda2 contains a btrfs with skinny extents has been created a few days ago and contains a few subvolumes (mounted as root and home) and subsubvolumes a few gigabites of data in smallish files. It is mounted with 'rw,relatime,compress-force=lzo,ssd,space_cache',

Shortly after noticing the errors, which cannot have been long after their occurrence, I rebooted and ran 'btrfs check' on the filesystem, with output as follows:

'Checking filesystem on /dev/sda2
UUID: c2c63f52-a322-413f-84f6-b4106fdff8c1
found 16882602001 bytes used err is 0
total csum bytes: 15775044
total tree bytes: 610959360
total fs tree bytes: 563019776
total extent tree bytes: 28459008
btree space waste bytes: 85192798
file data blocks allocated: 19913826304
 referenced 24478576640
btrfs-progs v4.1.2'

After this I ran 'btrfs scrub' which reported no errors.

The filesystem has been created (and also checked) with Arch Linux, kernel 4.1.6, btrfs-progs 4.1.2.
The computer has a AMD FX-8350CPU, 32GB ECC ram, a 990fx chipset and the drive is a OCZ Vector 180 (GPT, 2 partition, ESP from 2048s to 1050623s, .linux partition from 1050624s to 468860175s)
 		 	   		  
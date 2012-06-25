Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40205 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab2FYUzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 16:55:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SjGJL-0007Dt-Rx
	for linux-btrfs@vger.kernel.org; Mon, 25 Jun 2012 22:55:03 +0200
Received: from 213.33.228.174 ([213.33.228.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 22:55:03 +0200
Received: from miksir by 213.33.228.174 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2012 22:55:03 +0200
To: linux-btrfs@vger.kernel.org
From: Dmitry MiksIr <miksir@maker.ru>
Subject: how to cleanup old superblock
Date: Mon, 25 Jun 2012 23:54:50 +0400
Message-ID: <jsafma$896$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!
Long time ago I created btrfs on /dev/sda
After some changes btrfs moved to /dev/sda1 (well, to md, and sda1 is 
part of md).

As result, <btrfs fi show> show me 2 filesystems: new one and old one.
Probably I need to do some cleaning. Can someone tell me what to do.

fdisk -u -c -l /dev/sda

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
81 heads, 63 sectors/track, 765633 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0xde07ba46

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048  3907029167  1953513560   fd  Linux raid


btrfs fi show
Label: 'storage'  uuid: ea3824ec-2fd5-4813-88da-d96c319029f4
         Total devices 1 FS bytes used 50.87GB
         devid    1 size 1.82TB used 138.04GB path /dev/md127

Label: 'mainst'  uuid: 1bd2b9be-5464-4926-88da-af8e12c21f94
         Total devices 3 FS bytes used 45.94GB
         devid    1 size 1.82TB used 123.04GB path /dev/sda
         *** Some devices missing

Last one is wrong.



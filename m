Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:58564 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbbALNvH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 08:51:07 -0500
Received: by mail-yh0-f49.google.com with SMTP id f10so9571592yha.8
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Jan 2015 05:51:06 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 12 Jan 2015 14:51:06 +0100
Message-ID: <CABdHLQ4P4=rNCHpAuL7azGMA4xTgoHqyFNZ25sw4X2bsHQWwcg@mail.gmail.com>
Subject: btrfs performance - ssd array
From: "P. Remek" <p.remek1@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

we are currently investigating possiblities and performance limits of
the Btrfs filesystem. Now it seems we are getting pretty poor
performance for the writes and I would like to ask, if our results
makes sense and if it is a result of some well known performance
bottleneck.

Our setup:

Server:
   CPU: dual socket: E5-2630 v2
   RAM: 32 GB ram
   OS: Ubuntu server 14.10
   Kernel: 3.19.0-031900rc2-generic
   btrfs tools: Btrfs v3.14.1
   2x LSI 9300 HBAs - SAS3 12/Gbs
   8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs

Both HBAs see all 8 disks and we have set up multipathing using
multipath command and device mapper. Then we using this command to
create the filesystem:

mkfs.btrfs -f -d raid10 /dev/mapper/prm-0 /dev/mapper/prm-1
/dev/mapper/prm-2 /dev/mapper/prm-3 /dev/mapper/prm-4
/dev/mapper/prm-5 /dev/mapper/prm-6 /dev/mapper/prm-7


We run performance test using following command:

fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1
--name=test1 --filename=test1 --bs=4k --iodepth=32 --size=12G
--numjobs=24 --readwrite=randwrite


The results for the random read are more or less comparable with the
performance of EXT4 filesystem, we get approximately 300 000 IOPs for
random read.

For random write however, we are getting only about 15 000 IOPs, which
is much lower than for ESX4 (~200 000 IOPs for RAID10).


Regards,
Premek

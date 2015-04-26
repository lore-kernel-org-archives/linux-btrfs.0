Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-afa67.mailout.artfiles.de ([212.72.176.67]:42692 "EHLO
	mailout-afa67.mailout.artfiles.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbbDZSji (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 14:39:38 -0400
Received: from [47.70.125.116] (helo=discus.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80.1)
	id 1YmRSp-000389-UV
	for linux-btrfs@vger.kernel.org; Sun, 26 Apr 2015 20:39:36 +0200
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: linux-btrfs@vger.kernel.org
Subject: How to get the devid of a missing device
Date: Sun, 26 Apr 2015 20:39:34 +0200
Message-ID: <1704142.6uN5bYeLWo@discus>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a raid10 with one device missing. I would like to use btrfs replace to 
replace it. However, I am unsure on how to obtain the devid of the missing 
device. Having the filesystem mounted in degraded mode under mnt, btrfs fs 
show /mnt returns

sudo btrfs filesystem show /mnt
Label: 'dataPool'  uuid: b5f082e2-2ce0-4f91-b54b-c2d26185a635
        Total devices 4 FS bytes used 665.88GiB
        devid    2 size 931.51GiB used 336.03GiB path /dev/sdb
        devid    4 size 931.51GiB used 336.03GiB path /dev/sdd
        devid    5 size 931.51GiB used 336.03GiB path /dev/sde
        *** Some devices missing

but does not mention the devid of the missing device. The device stat is

sudo btrfs device stats /mnt 
[/dev/sdb].write_io_errs   0 
[/dev/sdb].read_io_errs    0 
[/dev/sdb].flush_io_errs   0 
[/dev/sdb].corruption_errs 0 
[/dev/sdb].generation_errs 0 
[(null)].write_io_errs   1448 
[(null)].read_io_errs    0 
[(null)].flush_io_errs   0 
[(null)].corruption_errs 0 
[(null)].generation_errs 0 
[/dev/sdd].write_io_errs   0 
[/dev/sdd].read_io_errs    0 
[/dev/sdd].flush_io_errs   0 
[/dev/sdd].corruption_errs 0 
[/dev/sdd].generation_errs 0 
[/dev/sde].write_io_errs   0 
[/dev/sde].read_io_errs    0 
[/dev/sde].flush_io_errs   0 
[/dev/sde].corruption_errs 0 
[/dev/sde].generation_errs 0


Btw, the file system is too old for skinny metadata and extended inode refs. 
If I do a btrfs replace or a btrfs device add, must I myself ensure that the 
new features are not enables for the new device which is to be added?

Thank!
Wolfgang



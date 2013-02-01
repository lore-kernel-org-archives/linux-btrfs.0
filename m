Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:40196 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3BAWSg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Feb 2013 17:18:36 -0500
Received: from luuna.daevel.fr ([82.67.37.138] helo=[192.168.1.50])
	by licorne.daevel.fr with esmtpsa (SSL3.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1U1OpL-00072X-Ge
	for linux-btrfs@vger.kernel.org; Fri, 01 Feb 2013 23:11:19 +0100
Message-ID: <1359756678.6019.30.camel@boolette.noo>
Subject: System unmountable RW
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: linux-btrfs@vger.kernel.org
Date: Fri, 01 Feb 2013 23:11:18 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs volume that I can't mount RW (but I can mount and use it
RO).

So, at boot time, the partition is mounted RO
(defaults,noatime,compress-force=zlib,nossd,ro) :
 
Feb  1 22:30:12 frozen kernel: [    8.646350] Btrfs loaded
Feb  1 22:30:12 frozen kernel: [    8.650878] device fsid cf2c98bd-147b-400e-bca5-79765650b1a7 devid 1 transid 376249 /dev/mapper/vg--frozen-backup
Feb  1 22:30:12 frozen kernel: [    8.652740] btrfs: force zlib compression
Feb  1 22:30:12 frozen kernel: [    8.652750] btrfs: not using ssd allocation scheme
Feb  1 22:30:12 frozen kernel: [    8.652756] btrfs: disk space caching is enabled


then I do : mount -o rw,remount /backup/

Feb  1 22:32:38 frozen kernel: [   65.780686] btrfs: force zlib compression
Feb  1 22:32:38 frozen kernel: [   65.780700] btrfs: not using ssd allocation scheme
Feb  1 22:32:38 frozen kernel: [   65.780706] btrfs: disk space caching is enabled


I let that mount run days, without any success. It stay running, and I can't interrupt it (CTRL+C or kill).


There is nothing about btrfs in kern.log, and when I run btrfsck it
throw OOM because it use the 10GB of RAM of the system.


It's a 2TB volume, running a 3.7.1 kernel :

# btrfs fi df /backup/
Data: total=1.72TB, used=1.65TB
System, DUP: total=64.00MB, used=208.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=39.20GB, used=35.38GB



If it's a btrfs bug, can I give you any information to help fix that ?

Thanks,
Olivier


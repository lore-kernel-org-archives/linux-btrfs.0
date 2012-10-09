Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:59207 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2JIHoF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 03:44:05 -0400
Received: from local.plusdinfo.com ([82.232.160.30] helo=[192.168.0.10])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1TLUNw-00021W-Sk
	for linux-btrfs@vger.kernel.org; Tue, 09 Oct 2012 09:37:48 +0200
Message-ID: <5073D44C.7000601@daevel.fr>
Date: Tue, 09 Oct 2012 09:37:48 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Frozen transaction
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

on one system I have a "frozen transaction" since more than 24 hours, 
without any IO.
I can't umount the partition, delete a snapshot or write anything.
I try to reboot the system, but the problem is still present.

Here the "frozen transaction" :
$ ps auxw | grep btrfs | grep D
root      1835  0.0  0.0      0     0 ?        D    Oct08   0:13 
[btrfs-cleaner]
root      1836  0.0  0.0      0     0 ?        D    Oct08   0:01 
[btrfs-transacti]
root      2633  0.0  0.0      0     0 ?        D    Oct08   0:00 
[flush-btrfs-1]


The partition is mounted with this options :
# mount | grep btrfs
/dev/mapper/vg--sofia-backup on /backup type btrfs 
(rw,noatime,compress-force=zlib,nossd)


The disk is near full :
# btrfs fi df /backup/
Data: total=482.68GB, used=480.89GB
System, DUP: total=32.00MB, used=72.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=10.12GB, used=8.82GB

But one of the last actions was the removing of some big subvolumes 
(near 50GB).

There is no error in logs, the frozen transaction was started from a 
3.5* kernel (from GIT), and the system is now running on a 3.6.1 kernel 
(vanilla).

Is there something I can do to solve that problem ?

Thanks,
Olivier

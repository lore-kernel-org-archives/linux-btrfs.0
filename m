Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34762 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbcGYHZp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 03:25:45 -0400
Received: by mail-qt0-f194.google.com with SMTP id c52so8197983qte.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jul 2016 00:25:44 -0700 (PDT)
MIME-Version: 1.0
From: Kurt Seo <tiger.anam.manager@gmail.com>
Date: Mon, 25 Jul 2016 16:25:43 +0900
Message-ID: <CAAcuexAaxha03vnwAC1bW6hcjEpH4GoQr2YBps=vWAu3RS8FJg@mail.gmail.com>
Subject: Any suggestions for thousands of disk image snapshots ?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Hi all


 I am currently running a project for building servers with btrfs.
Purposes of servers are exporting disk images through iscsi targets
and disk images are generated from btrfs subvolume snapshot.
Maximum number of clients is 500 and each client uses two snapshots of
disk images. the first disk image's size is about 50GB and second one
is about 1.5TB.
Important thing is that the original 1.5TB disk image is mounted with
loop device and modified real time - eg. continuously downloading
torrents in it.
snapshots are made when clients boot up and deleted when they turned off.

So server has two original disk images and about a thousand of
snapshots in total.
I made a list of factors affect server's performance and stability.

1. Raid Configuration - Mdadm raid vs btrfs raid, configuration and
options for them.
2. How to format btrfs - nodesize, features
3. Mount options - nodatacow and compression things.
4. Kernel parameter tuning.
5. Hardware specification.


My current setups are

1. mdadm raid10 with 1024k chunk and 12 disks of 512GB ssd.
2. nodesize 32k and nothing else.
3. nodatacow, noatime, nodiratime, nospace_cache, ssd, compress=lzo
4. Ubuntu with 4.1.27 kernel without additional configurations.
5.
CPU : Xeon E3- 1225v2 Quad Core 3.2Ghz
RAM : 2 x DDR3 8GB ECC  ( total 16GB)
NIC : 2 x 10Gbe


 The result of test so far is

1. btrfs-transaction and btrfs-cleaner assume cpu regularly.
2. When cpu is busy for those processes, creating snapshots takes long.
3. The performance is getting slow as time goes by.


So if there are any wrong and missing configurations , can you suggest some?
like i need to increase physical memory.

Any idea would help me a lot.

Thank you


Seo

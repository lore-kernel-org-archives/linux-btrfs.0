Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 7.mo68.mail-out.ovh.net ([46.105.63.230]:55632 "EHLO
        7.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbeGTW0t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 18:26:49 -0400
Received: from player728.ha.ovh.net (unknown [10.109.160.143])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 716CFE9F63
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 23:28:54 +0200 (CEST)
Received: from awhome.eu (p4FF91582.dip0.t-ipconnect.de [79.249.21.130])
        (Authenticated sender: postmaster@awhome.eu)
        by player728.ha.ovh.net (Postfix) with ESMTPSA id 5286A54008F
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2018 23:28:54 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Alexander Wetzel <alexander.wetzel@web.de>
Subject: btrfs filesystem corruptions with 4.18. git kernels
Message-ID: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
Date: Fri, 20 Jul 2018 23:28:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm running my normal workstation with git kernels from 
git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git 
and just got the second file system corruption in three weeks. I do not 
have issues with stable kernels, and just want to give you a heads up 
that there might be something seriously broken in current development 
kernels.

The first corruption was with a kernel based on 4.18.0-rc1 
(wt-2018-06-20) and the second one today based on 4.18.0-rc4 
(wt-2018-07-09).
The first corruption definitely destroyed data, the second one has not 
been looked at all, yet.

After the reinstall I did run some scrubs, the last working one one week 
ago.

Of course this could be unrelated to the development kernels or even 
btrfs, but two corruptions within weeks after years without problems is 
very suspect.
And since btrfs also allowed to read corrupted data (with a stable 
ubuntu kernel, see below for more details) it looks like this is indeed 
an issue in btrfs, correct?

A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO mSATA 
1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard is 
enabled as mount option and there were roughly 5 other subvolumes.

I'm currently backing up the full btrfs partition after the second 
corruption which announced itself with the following log entries:

[  979.223767] BTRFS critical (device sdc2): corrupt leaf: root=2 
block=1029783552 slot=1, unexpected item end, have 16161 expect 16250
[  979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1080: 
errno=-5 IO failure
[  979.223810] BTRFS info (device sdc2): forced readonly
[  979.224599] BTRFS warning (device sdc2): Skipping commit of aborted 
transaction.
[  979.224603] BTRFS: error (device sdc2) in cleanup_transaction:1847: 
errno=-5 IO failure

I'll restore the system from a backup - and stick to stable kernels for 
now - after that, but if needed I can of course also restore the 
partition backup to another disk for testing.

Here what I can say from the first crash:

On Jul 4th I discovered severe file system corruptions and when booting 
with init=/bin/bash even tools like parted failed with some report about 
invalid ELF headers for some library. I started an Ubuntu 17.10 install 
on another physical disk and copied some data from the damaged btrfs 
volume to the Ubuntu disk. And while I COULD copy the files quite many 
of the interesting ones were broken:
e.g. the git tree I rescued from the broken btrfs disk is unusable. The 
broken files I found all look about the correct size but contain only 0x01:
$ hexdump -C .git/objects/9d/732f6506e4cecd6d2b50c5008f9d1255198c1e
00000000  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01 
|................|
*
00000e26

After copying the files I tried a "btrfs check --repair" which was 
finding countless errors and I aborted after I got more than 3 million 
lines output. After the abort the complete home dir and everything 
beneath it was simple gone. I gave up on the install and set the system 
up from scratch, starting with formating the damaged partition new.
And exported the root subvolume with btrfs send to a fil.

The full output from the repair attempt can be downloaded here: 
https://www.awhome.eu/index.php/s/6jXtBTEeyA2ns3d

Kind regards,

Alexander



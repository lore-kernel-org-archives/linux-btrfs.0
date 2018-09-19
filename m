Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:56360 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbeISO1j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 10:27:39 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 3DA64310FD70
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 08:43:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 08:43:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 19 Sep 2018 10:43:18 +0200
From: Tomasz Chmielewski <tch@virtall.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: very poor performance / a lot of writes to disk with space_cache (but
 not with space_cache=v2)
Message-ID: <e0f21dace16885d1bd615dd723235d57@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a mysql slave which writes to a RAID-1 btrfs filesystem (with 
4.17.14 kernel) on 3 x ~1.9 TB SSD disks; filesystem is around 40% full.

The slave receives around 0.5-1 MB/s of data from the master over the 
network, which is then saved to MySQL's relay log and executed. In ideal 
conditions (i.e. no filesystem overhead) we should expect some 1-3 MB/s 
of data written to disk.

MySQL directory and files in it are chattr +C (since the directory was 
created, so all files are really +C); there are no snapshots.


Now, an interesting thing.

When the filesystem is mounted with these options in fstab:

defaults,noatime,discard


We can see a *constant* write of 25-100 MB/s to each disk. The system is 
generally unresponsive and it sometimes takes long seconds for a simple 
command executed in bash to return.


However, as soon as we remount the filesystem with space_cache=v2 - 
writes drop to just around 3-10 MB/s to each disk. If we remount to 
space_cache - lots of writes, system unresponsive. Again remount to 
space_cache=v2 - low writes, system responsive.


That's a huuge, 10x overhead! Is it expected? Especially that 
space_cache=v1 is still the default mount option?


Tomasz Chmielewski
https://lxadm.com

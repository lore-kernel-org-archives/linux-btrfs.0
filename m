Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from campbell-lange.net ([178.79.140.51]:44678 "EHLO
        campbell-lange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbeIPQ5h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Sep 2018 12:57:37 -0400
Received: from 242.164.198.146.dyn.plus.net ([146.198.164.242] helo=rory-t450s)
        by campbell-lange.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <rory@campbell-lange.net>)
        id 1g1V0n-0001Qo-IH
        for linux-btrfs@vger.kernel.org; Sun, 16 Sep 2018 11:14:45 +0000
Received: from rory by rory-t450s with local (Exim 4.89)
        (envelope-from <rory@rory-t450s>)
        id 1g1V0n-0008Uc-9B
        for linux-btrfs@vger.kernel.org; Sun, 16 Sep 2018 12:14:45 +0100
Date: Sun, 16 Sep 2018 12:14:45 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: linux-btrfs@vger.kernel.org
Subject: Move data and mount point to subvolume
Message-ID: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

We have a backup machine that has been happily running its backup
partitions on btrfs (on top of a luks encrypted disks) for a few years.

Our backup partition is on /bkp which is a top level subvolume. 
    Data, RAID1: total=2.52TiB, used=1.36TiB
There are no other subvolumes.

We have /bkp with /bkp/backup in it. We would like to mount /bkp/backup
at /bkp instead. Note that /bkp/backup has a lot of hardlinked files.

I guess I could do 

    cd /bkp/backup
    mv * ../
    rmdir backup

But would it also be possible to do something like

    cd /bkp
    btrfs subvol create backup-subvol
    mv /bkp/backup/* /bkp/backup-subvol
    ... then mount /bkp/backup-subvol at /bkp

Would this second approach work, and preserve hardlinks?

The machine is btrfs-progs v4.7.3 Linux 4.9.0-8-amd64 on Debian. The
coreutils version is 8.26-3.

Thanks for any comments
Rory

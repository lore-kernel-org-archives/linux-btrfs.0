Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:47866 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752085AbdJDLNG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 07:13:06 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 0D1D2CE270B
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Oct 2017 11:13:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Oct 2017 11:13:03 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 04 Oct 2017 20:13:01 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: yet another "out of space" on a filesystem with >100 GB free space,
 and strange files which exist but don't exist
Message-ID: <7c6a0bb4ff9b4f09c7ea6f6c7173a994@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel: 4.13.4, btrfs RAID-1.

Disk usage more or less like below (yes, I know about btrfs fi df / show 
/ usage):

Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       424G  262G  161G  62% /var/lib/lxd


Balance would exit immediately with "out of space", but continues to run 
after I've removed a few gigabytes from the filesystem.


Now, I'm seeing some files which exist, but don't. Strange, I know.


root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
# ls *set
ls: cannot access 'WiredTiger.turtle.set': No such file or directory

root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
# ls -l|grep set
ls: cannot access 'WiredTiger.turtle.set': No such file or directory
-????????? ? ?      ?                ?            ? 
WiredTiger.turtle.set

root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
# mv WiredTiger.turtle.set WiredTiger.turtle.set.Ghost.File
mv: cannot stat 'WiredTiger.turtle.set': No such file or directory

root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
# rm -v WiredTiger.turtle.set
rm: cannot remove 'WiredTiger.turtle.set': No such file or directory



What is this file, and why does it exist if it doesn't? How do I remove 
it?


Tomasz Chmielewski
https://lxadm.com

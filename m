Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:56031 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdJDLUY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Oct 2017 07:20:24 -0400
Received: by mail-it0-f43.google.com with SMTP id p185so4650361itc.4
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Oct 2017 04:20:24 -0700 (PDT)
Subject: Re: yet another "out of space" on a filesystem with >100 GB free
 space, and strange files which exist but don't exist
To: Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7c6a0bb4ff9b4f09c7ea6f6c7173a994@wpkg.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e2b27980-dabf-540b-c4c1-8628cc1d47c1@gmail.com>
Date: Wed, 4 Oct 2017 07:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <7c6a0bb4ff9b4f09c7ea6f6c7173a994@wpkg.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-04 07:13, Tomasz Chmielewski wrote:
> Kernel: 4.13.4, btrfs RAID-1.
> 
> Disk usage more or less like below (yes, I know about btrfs fi df / show 
> / usage):
> 
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda3       424G  262G  161G  62% /var/lib/lxd
> 
> 
> Balance would exit immediately with "out of space", but continues to run 
> after I've removed a few gigabytes from the filesystem.
> 
> 
> Now, I'm seeing some files which exist, but don't. Strange, I know.
> 
> 
> root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
> # ls *set
> ls: cannot access 'WiredTiger.turtle.set': No such file or directory
> 
> root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
> # ls -l|grep set
> ls: cannot access 'WiredTiger.turtle.set': No such file or directory
> -????????? ? ?      ?                ?            ? WiredTiger.turtle.set
> 
> root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
> # mv WiredTiger.turtle.set WiredTiger.turtle.set.Ghost.File
> mv: cannot stat 'WiredTiger.turtle.set': No such file or directory
> 
> root@lxd02 /var/lib/lxd/containers/mongo-repl04b/rootfs/var/lib/mongodb 
> # rm -v WiredTiger.turtle.set
> rm: cannot remove 'WiredTiger.turtle.set': No such file or directory
> 
> 
> 
> What is this file, and why does it exist if it doesn't? How do I remove it?
It's got corrupted metadata, probably the inode itself (IIRC, the dentry 
in BTRFS just matches the inode to the file name, and all the other data 
reported by ls -l is stored in the inode).  If you're running with a 
replicated metadata profile (dup, raid1, or raid10), run a scrub, and it 
may fix things.  If not, you will likely have to run a check in repair 
mode (though I would suggest waiting to hear from one of the developers 
before doing so).  Alternatively, if that's in a subvolume, and you can 
afford to just nuke the subvolume and recreate it, deleting the 
subvolume should get rid of it (though you should still run a check).

Either way, this is likely related to the balance issues you're seeing.

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388426AbeGXP3q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 11:29:46 -0400
Date: Tue, 24 Jul 2018 16:22:51 +0200
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix send failure when root has deleted files
 still open
Message-ID: <20180724142250.GW26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180723080948.4824-1-fdmanana@kernel.org>
 <20180724105404.2950-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180724105404.2950-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2018 at 11:54:04AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The more common use case of send involves creating a RO snapshot and then
> use it for a send operation. In this case it's not possible to have inodes
> in the snapshot that have a link count of zero (inode with an orphan item)
> since during snapshot creation we do the orphan cleanup. However, other
> less common use cases for send can end up seeing inodes with a link count
> of zero and in this case the send operation fails with a ENOENT error
> because any attempt to generate a path for the inode, with the purpose
> of creating it or updating it at the receiver, fails since there are no
> inode reference items. One use case it to use a regular subvolume for
> a send operation after turning it to RO mode or turning a RW snapshot
> into RO mode and then using it for a send operation. In both cases, if a
> file gets all its hard links deleted while there is an open file
> descriptor before turning the subvolume/snapshot into RO mode, the send
> operation will encounter an inode with a link count of zero and then
> fail with errno ENOENT.
> 
> Example using a full send with a subvolume:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ btrfs subvolume create /mnt/sv1
>   $ touch /mnt/sv1/foo
>   $ touch /mnt/sv1/bar
> 
>   # keep an open file descriptor on file bar
>   $ exec 73</mnt/sv1/bar
>   $ unlink /mnt/sv1/bar
> 
>   # Turn the subvolume to RO mode and use it for a full send, while
>   # holding the open file descriptor.
>   $ btrfs property set /mnt/sv1 ro true
> 
>   $ btrfs send -f /tmp/full.send /mnt/sv1
>   At subvol /mnt/sv1
>   ERROR: send ioctl failed with -2: No such file or directory
> 
> Example using an incremental send with snapshots:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ btrfs subvolume create /mnt/sv1
>   $ touch /mnt/sv1/foo
>   $ touch /mnt/sv1/bar
> 
>   $ btrfs subvolume snapshot -r /mnt/sv1 /mnt/snap1
> 
>   $ echo "hello world" >> /mnt/sv1/bar
> 
>   $ btrfs subvolume snapshot -r /mnt/sv1 /mnt/snap2
> 
>   # Turn the second snapshot to RW mode and delete file foo while
>   # holding an open file descriptor on it.
>   $ btrfs property set /mnt/snap2 ro false
>   $ exec 73</mnt/snap2/foo
>   $ unlink /mnt/snap2/foo
> 
>   # Set the second snapshot back to RO mode and do an incremental send.
>   $ btrfs property set /mnt/snap2 ro true
> 
>   $ btrfs send -f /tmp/inc.send -p /mnt/snap1 /mnt/snap2
>   At subvol /mnt/snap2
>   ERROR: send ioctl failed with -2: No such file or directory
> 
> So fix this by ignoring inodes with a link count of zero if we are either
> doing a full send or if they do not exist in the parent snapshot (they
> are new in the send snapshot), and unlink all paths found in the parent
> snapshot when doing an incremental send (and ignoring all other inode
> items, such as xattrs and extents).
> 
> A test case for fstests follows soon.
> 
> Reported-by: Martin Wilck <martin.wilck@suse.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Added to misc-next, thanks. I did a light review of the overall logic
how the ignore_cur_inode is passed around, skipping the orphans and
replacing with send_unlink sounds ok to me.

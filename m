Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbbDBQVb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 12:21:31 -0400
Date: Thu, 2 Apr 2015 18:21:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, robbieko@synology.com
Subject: Re: [PATCH] Btrfs: incremental send, clear name from cache after
 orphanization
Message-ID: <20150402162129.GP6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1425836905-26109-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425836905-26109-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 08, 2015 at 05:48:25PM +0000, Filipe Manana wrote:
> If a directory's reference ends up being orphanized, because the inode
> currently being processed has a new path that matches that directory's
> path, make sure we evict the name of the directory from the name cache.
> This is because there might be descendent inodes (either directories or
> regular files) that will be orphanized later too, and therefore the
> orphan name of the ancestor must be used, otherwise we send issue rename
> operations with a wrong path in the send stream.
> 
> Reproducer:
> 
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount /dev/sdb /mnt
> 
>   $ mkdir -p /mnt/data/n1/n2/p1/p2
>   $ mkdir /mnt/data/n4
>   $ mkdir -p /mnt/data/p1/p2
> 
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap1
> 
>   $ mv /mnt/data/p1/p2 /mnt/data
>   $ mv /mnt/data/n1/n2/p1/p2 /mnt/data/p1
>   $ mv /mnt/data/p2 /mnt/data/n1/n2/p1
>   $ mv /mnt/data/n1/n2 /mnt/data/p1
>   $ mv /mnt/data/p1 /mnt/data/n4
>   $ mv /mnt/data/n4/p1/n2/p1 /mnt/data
> 
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap2
> 
>   $ btrfs send /mnt/snap1 -f /tmp/1.send
>   $ btrfs send -p /mnt/snap1 /mnt/snap2 -f /tmp/2.send
> 
>   $ mkfs.btrfs -f /dev/sdc
>   $ mount /dev/sdc /mnt2
>   $ btrfs receive /mnt2 -f /tmp/1.send
>   $ btrfs receive /mnt2 -f /tmp/2.send
>   ERROR: rename data/p1/p2 -> data/n4/p1/p2 failed. no such file or directory
> 
> Directories data/p1 (inode 263) and data/p1/p2 (inode 264) in the parent
> snapshot are both orphanized during the incremental send, and as soon as
> data/p1 is orphanized, we must make sure that when orphanizing data/p1/p2
> we use a source path of o263-6-o/p2 for the rename operation instead of
> the old path data/p1/p2 (the one before the orphanization of inode 263).
> 
> A test case for xfstests follows soon.
> 
> Reported-by: Robbie Ko <robbieko@synology.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Tested-by: David Sterba <dsterba@suse.cz>

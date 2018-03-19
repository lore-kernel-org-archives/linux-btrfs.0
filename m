Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753151AbeCSMuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 08:50:25 -0400
Date: Mon, 19 Mar 2018 13:47:59 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] Btrfs-progs: add fsck test for filesystem with
 shared prealloc extents
Message-ID: <20180319124759.GC6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180313184713.30223-1-fdmanana@kernel.org>
 <20180314201118.12451-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180314201118.12451-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2018 at 08:11:18PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Verify that a filesystem check operation (fsck) does not report the
> following scenario as an error:
> 
> An extent is shared between two inodes, as a result of clone/reflink
> operation, and for one of the inodes, lets call it inode A, the extent is
> referenced through a file extent item as a prealloc extent, while for the
> other inode, call it inode B, the extent is referenced through a regular
> file extent item, that is, it was written to. The goal of this test is to
> make sure a filesystem check operation will not report "odd csum items"
> errors for the prealloc extent at inode A, because this scenario is valid
> since the extent was written through inode B and therefore it is expected
> to have checksum items in the filesystem's checksum btree for that shared
> extent.
> 
> Such scenario can be created with the following steps for example:
> 
>  mkfs.btrfs -f /dev/sdb
>  mount /dev/sdb /mnt
> 
>  touch /mnt/foo
>  xfs_io -c "falloc 0 256K" /mnt/foo
>  sync
> 
>  xfs_io -c "pwrite -S 0xab 0 256K" /mnt/foo
>  touch /mnt/bar
>  xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
>  xfs_io -c "fsync" /mnt/bar
> 
>  <power fail>
>  mount /dev/sdb /mnt
>  umount /mnt
> 
> This scenario is fixed by the following patch for the filesystem checker:
> 
>  "Btrfs-progs: check, fix false error reports for shared prealloc extents"
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Applied, thanks.

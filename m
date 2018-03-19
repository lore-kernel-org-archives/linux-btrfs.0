Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52759 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753151AbeCSMsY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 08:48:24 -0400
Date: Mon, 19 Mar 2018 13:45:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] Btrfs-progs: check, fix false error reports for
 shared prealloc extents
Message-ID: <20180319124559.GB6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180313184700.30173-1-fdmanana@kernel.org>
 <20180314201109.9678-1-fdmanana@kernel.org>
 <5a66561e-3625-7d28-30da-54fbdcaa83aa@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5a66561e-3625-7d28-30da-54fbdcaa83aa@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 02:35:36PM +0200, Nikolay Borisov wrote:
> On 14.03.2018 22:11, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > Under some cases the filesystem checker reports an error when it finds
> > checksum items for an extent that is referenced by an inode as a prealloc
> > extent. Such cases are not an error when the extent is actually shared
> > (was cloned/reflinked) with other inodes and was written through one of
> > those other inodes.
> > 
> > Example:
> > 
> >   $ mkfs.btrfs -f /dev/sdb
> >   $ mount /dev/sdb /mnt
> > 
> >   $ touch /mnt/foo
> >   $ xfs_io -c "falloc 0 256K" /mnt/foo
> >   $ sync
> > 
> >   $ xfs_io -c "pwrite -S 0xab 0 256K" /mnt/foo
> >   $ touch /mnt/bar
> >   $ xfs_io -c "reflink /mnt/foo 0 0 256K" /mnt/bar
> >   $ xfs_io -c "fsync" /mnt/bar
> > 
> >   <power fail>
> >   $ mount /dev/sdb /mnt
> >   $ umount /mnt
> > 
> >   $ btrfs check /dev/sdc
> >   Checking filesystem on /dev/sdb
> >   UUID: 52d3006e-ee3b-40eb-aa21-e56253a03d39
> >   checking extents
> >   checking free space cache
> >   checking fs roots
> >   root 5 inode 257 errors 800, odd csum item
> >   ERROR: errors found in fs roots
> >   found 688128 bytes used, error(s) found
> >   total csum bytes: 256
> >   total tree bytes: 163840
> >   total fs tree bytes: 65536
> >   total extent tree bytes: 16384
> >   btree space waste bytes: 138819
> >   file data blocks allocated: 10747904
> >    referenced 10747904
> >   $ echo $?
> >   1
> > 
> > So teach check to not report such cases as errors by checking if the
> > extent is shared with other inodes and if so, consider it an error the
> > existence of checksum items only if all those other inodes are referencing
> > the extent as a prealloc extent.
> > This case can be hit often when running the generic/475 testcase from
> > fstests.
> > 
> > A test case will follow in a separate patch.
> > 
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Applied, thanks.

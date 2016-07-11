Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172AbcGKOlI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 10:41:08 -0400
Date: Mon, 11 Jul 2016 16:41:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Pavel Raiskup <praiskup@redhat.com>
Cc: linux-btrfs@vger.kernel.org, bug-tar <bug-tar@gnu.org>
Subject: Re: stat() on btrfs reports the st_blocks with delay (data loss in
 archivers)
Message-ID: <20160711144119.GY13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 02, 2016 at 09:18:07AM +0200, Pavel Raiskup wrote:
> There are optimizations in archivers (tar, rsync, ...) that rely on up2date
> st_blocks info.  For example, in GNU tar there is optimization check [1]
> whether the 'st_size' reports more data than the 'st_blocks' can hold --> then
> tar considers that file is sparse (and does additional steps).
> 
> It looks like btrfs doesn't show correct value in 'st_blocks' until the data
> are synced.  ATM, there happens that:
> 
>     a) some "tool" creates sparse file
>     b) that tool does not sync explicitly and exits ..
>     c) tar is called immediately after that to archive the sparse file
>     d) tar considers [2] the file is completely sparse (because st_blocks is
>        zero) and archives no data.  Here comes data loss.
> 
> Because we fixed 'btrfs' to report non-zero 'st_blocks' when the file data is
> small and is in-lined (no real data blocks) -- I consider this is too bug in
> btrfs worth fixing.
> 
> [1] http://git.savannah.gnu.org/cgit/paxutils.git/tree/lib/system.h?id=ec72abd9dd63bbff4534ec77e97b1a6cadfc3cf8#n392
> [2] http://git.savannah.gnu.org/cgit/tar.git/tree/src/sparse.c?id=ac065c57fdc1788a2769fb119ed0c8146e1b9dd6#n273
> 
> Tested on kernel:
> kernel-4.5.7-300.fc24.x86_64
> 
> Originally reported here, reproducer available there:
> https://bugzilla.redhat.com/show_bug.cgi?id=1352061

The reproducer works for me here. So far I found:

* the btrfs implementation of stat.st_blocks (btrfs_getattr) includes
  the 'delayed allocated' bytes, so there is not a problem in principle
  (http://lxr.free-electrons.com/source/fs/btrfs/inode.c#L9372)

* calling fsync on the sparsefile will produce the expected result

* a short delay between ./binary and 'stat' will also produce correct
  result, 0.5 seconds worked for me -- so it IMO proves it's a race
  between writing and reporting the data

* I'm not yet sure where the delay between write and synced
  'inode->delalloc_bytes' comes from

* I think that st_blocks accounting can be wrong anyway, if the file is
  mmap-ed and not msync-ed, I'm writing a reproducer for this case

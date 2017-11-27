Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40221 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753005AbdK0QnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 11:43:14 -0500
Date: Mon, 27 Nov 2017 17:41:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix list_add corruption and soft lockups in
 fsync
Message-ID: <20171127164117.GC3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171113175724.7302-1-bo.li.liu@oracle.com>
 <20171121213540.20656-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171121213540.20656-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 02:35:40PM -0700, Liu Bo wrote:
> Xfstests btrfs/146 revealed this corruption,
> 
> [   58.138831] Buffer I/O error on dev dm-0, logical block 2621424, async page read
> [   58.151233] BTRFS error (device sdf): bdev /dev/mapper/error-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> [   58.152403] list_add corruption. prev->next should be next (ffff88005e6775d8), but was ffffc9000189be88. (prev=ffffc9000189be88).
> [   58.153518] ------------[ cut here ]------------
> [   58.153892] WARNING: CPU: 1 PID: 1287 at lib/list_debug.c:31 __list_add_valid+0x169/0x1f0
> ...
> [   58.157379] RIP: 0010:__list_add_valid+0x169/0x1f0
> ...
> [   58.161956] Call Trace:
> [   58.162264]  btrfs_log_inode_parent+0x5bd/0xfb0 [btrfs]
> [   58.163583]  btrfs_log_dentry_safe+0x60/0x80 [btrfs]
> [   58.164003]  btrfs_sync_file+0x4c2/0x6f0 [btrfs]
> [   58.164393]  vfs_fsync_range+0x5f/0xd0
> [   58.164898]  do_fsync+0x5a/0x90
> [   58.165170]  SyS_fsync+0x10/0x20
> [   58.165395]  entry_SYSCALL_64_fastpath+0x1f/0xbe
> ...
> 
> It turns out that we could record btrfs_log_ctx:io_err in
> log_one_extents when IO fails, but make log_one_extents() return '0'
> instead of -EIO, so the IO error is not acknowledged by the callers,
> i.e.  btrfs_log_inode_parent(), which would remove btrfs_log_ctx:list
> from list head 'root->log_ctxs'.  Since btrfs_log_ctx is allocated
> from stack memory, it'd get freed with a object alive on the
> list. then a future list_add will throw the above warning.
> 
> This returns the correct error in the above case.
> 
> Jeff also reported this while testing against his fsync error
> patch set[1].
> 
> [1]: https://www.spinics.net/lists/linux-btrfs/msg65308.html
> "btrfs list corruption and soft lockups while testing writeback error handling"
> 
> Fixes: 8407f553268a4611f254 ("Btrfs: fix data corruption after fast fsync and writeback error")
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

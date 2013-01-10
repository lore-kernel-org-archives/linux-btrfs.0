Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29205 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3AJCUr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 21:20:47 -0500
Date: Thu, 10 Jan 2013 10:17:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130110021747.GB4456@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
 <20130108083053.GD3763@twin.jikos.cz>
 <20130108172627.GP20089@twin.jikos.cz>
 <20130109043443.GA4527@liubo>
 <20130109115025.GQ20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130109115025.GQ20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 09, 2013 at 12:50:25PM +0100, David Sterba wrote:
> On Wed, Jan 09, 2013 at 12:34:45PM +0800, Liu Bo wrote:
> > > [20191.948060] D: __set_extent_bit isize = 0 odd range [774144,7384799041917984768)
> > > [20191.956581] D: clear_extent_bit isize = 0 odd range [774144,7384799041917984768)
> > > 
> > > so I'm not sending it as a separate patch yet until the check covers all cases.
> > 
> > Thanks for coding this up, I've checked the code, these messages can
> > be fixed by the following, please check if it works on your side :)
> 
> Thanks, no more of these warnings. There was one new to me, during test
> 013:
> 
> [  348.433006] ------------[ cut here ]------------
> [  348.438926] WARNING: at fs/btrfs/disk-io.c:3210 free_fs_root+0x8b/0x90 [btrfs]()
> [  348.447596] Hardware name: Santa Rosa platform
> [  348.447602] Modules linked in: aoe dm_crypt loop btrfs
> [  348.447605] Pid: 9091, comm: umount Not tainted 3.8.0-rc2-default+ #229
> [  348.447607] Call Trace:
> [  348.447615]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
> [  348.447619]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
> [  348.447635]  [<ffffffffa002af3b>] free_fs_root+0x8b/0x90 [btrfs]
> [  348.447652]  [<ffffffffa002e75e>] btrfs_free_fs_root+0x7e/0x90 [btrfs]
> [  348.447668]  [<ffffffffa002e84b>] del_fs_roots+0xdb/0x120 [btrfs]
> [  348.447683]  [<ffffffffa002292e>] ? btrfs_free_block_groups+0x29e/0x370 [btrfs]
> [  348.447699]  [<ffffffffa0030182>] close_ctree+0x1d2/0x340 [btrfs]
> [  348.447705]  [<ffffffff81178c6f>] ? dispose_list+0x4f/0x60
> [  348.447711]  [<ffffffff811799d4>] ? evict_inodes+0x114/0x130
> [  348.447722]  [<ffffffffa0003c69>] btrfs_put_super+0x19/0x20 [btrfs]
> [  348.447727]  [<ffffffff811608f2>] generic_shutdown_super+0x62/0xf0
> [  348.447730]  [<ffffffff81160a16>] kill_anon_super+0x16/0x30
> [  348.447741]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
> [  348.447744]  [<ffffffff811618e2>] ? deactivate_super+0x42/0x70
> [  348.447748]  [<ffffffff81160c6d>] deactivate_locked_super+0x3d/0x90
> [  348.447751]  [<ffffffff811618ea>] deactivate_super+0x4a/0x70
> [  348.447755]  [<ffffffff8117dc70>] mntput_no_expire+0x100/0x160
> [  348.447759]  [<ffffffff8117ecb1>] sys_umount+0x71/0x3c0
> [  348.447763]  [<ffffffff81960919>] system_call_fastpath+0x16/0x1b
> [  348.447765] ---[ end trace 25a08f78869c0553 ]---
> [  348.614158] VFS: Busy inodes after unmount of sda8. Self-destruct in 5 seconds.  Have a nice day...
> 
> looks like a leaked inode. The line number does not match a WARN in the
> sources, this one is better:
> 
> (gdb) l *(free_fs_root+0x8b)
> 0x2ab5b is in free_fs_root (fs/btrfs/disk-io.c:3206).
> 3201    }
> 3202
> 3203    static void free_fs_root(struct btrfs_root *root)
> 3204    {
> 3205            iput(root->cache_inode);
> 3206            WARN_ON(!RB_EMPTY_ROOT(&root->inode_tree));
> 3207            if (root->anon_dev)
> 3208                    free_anon_bdev(root->anon_dev);
> 3209            free_extent_buffer(root->node);
> 3210            free_extent_buffer(root->commit_root);
> 
> I've added only the 2 fixes from you, no other change. I'll do another test
> based on current btrfs-next.

Thanks for the report, could you please show me what options you're
using?

thanks,
liubo

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:32605 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdCCCIe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 21:08:34 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v230dEdE022058
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 3 Mar 2017 00:39:14 GMT
Date: Thu, 2 Mar 2017 16:36:43 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix file corruption after cloning inline extents
Message-ID: <20170303003642.GB26698@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1436888088-8631-1-git-send-email-fdmanana@kernel.org>
 <20170302221821.GA26698@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170302221821.GA26698@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 02, 2017 at 02:18:21PM -0800, Liu Bo wrote:
> On Tue, Jul 14, 2015 at 04:34:48PM +0100, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > Using the clone ioctl (or extent_same ioctl, which calls the same extent
> > cloning function as well) we end up allowing copy an inline extent from
> > the source file into a non-zero offset of the destination file. This is
> > something not expected and that the btrfs code is not prepared to deal
> > with - all inline extents must be at a file offset equals to 0.
> >
> 
> Somehow I failed to reproduce the BUG_ON with this case.
> 
> > For example, the following excerpt of a test case for fstests triggers
> > a crash/BUG_ON() on a write operation after an inline extent is cloned
> > into a non-zero offset:
> > 
> >   _scratch_mkfs >>$seqres.full 2>&1
> >   _scratch_mount
> > 
> >   # Create our test files. File foo has the same 2K of data at offset 4K
> >   # as file bar has at its offset 0.
> >   $XFS_IO_PROG -f -s -c "pwrite -S 0xaa 0 4K" \
> >       -c "pwrite -S 0xbb 4k 2K" \
> >       -c "pwrite -S 0xcc 8K 4K" \
> >       $SCRATCH_MNT/foo | _filter_xfs_io
> > 
> >   # File bar consists of a single inline extent (2K size).
> >   $XFS_IO_PROG -f -s -c "pwrite -S 0xbb 0 2K" \
> >      $SCRATCH_MNT/bar | _filter_xfs_io
> > 
> >   # Now call the clone ioctl to clone the extent of file bar into file
> >   # foo at its offset 4K. This made file foo have an inline extent at
> >   # offset 4K, something which the btrfs code can not deal with in future
> >   # IO operations because all inline extents are supposed to start at an
> >   # offset of 0, resulting in all sorts of chaos.
> >   # So here we validate that clone ioctl returns an EOPNOTSUPP, which is
> >   # what it returns for other cases dealing with inlined extents.
> >   $CLONER_PROG -s 0 -d $((4 * 1024)) -l $((2 * 1024)) \
> >       $SCRATCH_MNT/bar $SCRATCH_MNT/foo
> > 
> >   # Because of the inline extent at offset 4K, the following write made
> >   # the kernel crash with a BUG_ON().
> >   $XFS_IO_PROG -c "pwrite -S 0xdd 6K 2K" $SCRATCH_MNT/foo | _filter_xfs_io
> >
> 
> On 4.10, after allowing to clone an inline extent to dst file's offset greater
> than zero, I followed the test case manually and got these
> 
> [root@localhost trinity]# /home/btrfs-progs/btrfs-debugfs -f /mnt/btrfs/foo 
> (257 0): ram 4096 disk 12648448 disk_size 4096
> (257 4096): ram 2048 disk 0 disk_size 2048 -- inline
> (257 8192): ram 4096 disk 12656640 disk_size 4096
> file: /mnt/btrfs/foo extents 3 disk size 10240 logical size 12288 ratio 1.20
> 
> [root@localhost trinity]# xfs_io -f -c "pwrite 6k 2k" /mnt/btrfs/foo 
> wrote 2048/2048 bytes at offset 6144
> 2 KiB, 1 ops; 0.0000 sec (12.520 MiB/sec and 6410.2564 ops/sec)
> 
> [root@localhost trinity]# sync
> [root@localhost trinity]# /home/btrfs-progs/btrfs-debugfs -f /mnt/btrfs/foo 
> (257 0): ram 4096 disk 12648448 disk_size 4096
> (257 4096): ram 4096 disk 12582912 disk_size 4096
> (257 8192): ram 4096 disk 12656640 disk_size 4096
> file: /mnt/btrfs/foo extents 3 disk size 12288 logical size 12288 ratio 1.00
> 
> 
> Looks like we now are able to cope with these inline extents?

I went back to test against v4.1 and v4.5, it turns out that we got the below
BUG_ON() in MM and -EIO when writing to the inline extent, because of the fact
that, when writing to the page that covers the inline extent, firstly it reads
page to get an uptodate page for writing, in readpage(), for inline extent,
btrfs_get_extent() always goes to search fs tree to read inline data out to page
and then tries to insert a em, -EEXIST would be returned if there is an existing
one.

However, after commit 8dff9c853410 ("Btrfs: deal with duplciates during
extent_map insertion in btrfs_get_extent"), we have that fixed, so now we can
read/write inline extent even they've been mixed with other regular extents.

But...I'm not 100% sure whether such files (with mixing inline with regular)
would have any other problems rather than read/write.  Let me know if you could
think of a corruption due to that.

Thanks,

-liubo
> 
> 
> Thanks,
> 
> -liubo
> 
> 
> >   status=0
> >   exit
> > 
> > The stack trace of the BUG_ON() triggered by the last write is:
> > 
> >   [152154.035903] ------------[ cut here ]------------
> >   [152154.036424] kernel BUG at mm/page-writeback.c:2286!
> >   [152154.036424] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> >   [152154.036424] Modules linked in: btrfs dm_flakey dm_mod crc32c_generic xor raid6_pq nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc loop fuse parport_pc acpi_cpu$
> >   [152154.036424] CPU: 2 PID: 17873 Comm: xfs_io Tainted: G        W       4.1.0-rc6-btrfs-next-11+ #2
> >   [152154.036424] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.1-0-g4adadbd-20150316_085822-nilsson.home.kraxel.org 04/01/2014
> >   [152154.036424] task: ffff880429f70990 ti: ffff880429efc000 task.ti: ffff880429efc000
> >   [152154.036424] RIP: 0010:[<ffffffff8111a9d5>]  [<ffffffff8111a9d5>] clear_page_dirty_for_io+0x1e/0x90
> >   [152154.036424] RSP: 0018:ffff880429effc68  EFLAGS: 00010246
> >   [152154.036424] RAX: 0200000000000806 RBX: ffffea0006a6d8f0 RCX: 0000000000000001
> >   [152154.036424] RDX: 0000000000000000 RSI: ffffffff81155d1b RDI: ffffea0006a6d8f0
> >   [152154.036424] RBP: ffff880429effc78 R08: ffff8801ce389fe0 R09: 0000000000000001
> >   [152154.036424] R10: 0000000000002000 R11: ffffffffffffffff R12: ffff8800200dce68
> >   [152154.036424] R13: 0000000000000000 R14: ffff8800200dcc88 R15: ffff8803d5736d80
> >   [152154.036424] FS:  00007fbf119f6700(0000) GS:ffff88043d280000(0000) knlGS:0000000000000000
> >   [152154.036424] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   [152154.036424] CR2: 0000000001bdc000 CR3: 00000003aa555000 CR4: 00000000000006e0
> >   [152154.036424] Stack:
> >   [152154.036424]  ffff8803d5736d80 0000000000000001 ffff880429effcd8 ffffffffa04e97c1
> >   [152154.036424]  ffff880429effd68 ffff880429effd60 0000000000000001 ffff8800200dc9c8
> >   [152154.036424]  0000000000000001 ffff8800200dcc88 0000000000000000 0000000000001000
> >   [152154.036424] Call Trace:
> >   [152154.036424]  [<ffffffffa04e97c1>] lock_and_cleanup_extent_if_need+0x147/0x18d [btrfs]
> >   [152154.036424]  [<ffffffffa04ea82c>] __btrfs_buffered_write+0x245/0x4c8 [btrfs]
> >   [152154.036424]  [<ffffffffa04ed14b>] ? btrfs_file_write_iter+0x150/0x3e0 [btrfs]
> >   [152154.036424]  [<ffffffffa04ed15a>] ? btrfs_file_write_iter+0x15f/0x3e0 [btrfs]
> >   [152154.036424]  [<ffffffffa04ed2c7>] btrfs_file_write_iter+0x2cc/0x3e0 [btrfs]
> >   [152154.036424]  [<ffffffff81165a4a>] __vfs_write+0x7c/0xa5
> >   [152154.036424]  [<ffffffff81165f89>] vfs_write+0xa0/0xe4
> >   [152154.036424]  [<ffffffff81166855>] SyS_pwrite64+0x64/0x82
> >   [152154.036424]  [<ffffffff81465197>] system_call_fastpath+0x12/0x6f
> >   [152154.036424] Code: 48 89 c7 e8 0f ff ff ff 5b 41 5c 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 53 48 89 fb e8 ae ef 00 00 49 89 c4 48 8b 03 a8 01 75 02 <0f> 0b 4d 85 e4 74 59 49 8b 3c 2$
> >   [152154.036424] RIP  [<ffffffff8111a9d5>] clear_page_dirty_for_io+0x1e/0x90
> >   [152154.036424]  RSP <ffff880429effc68>
> >   [152154.242621] ---[ end trace e3d3376b23a57041 ]---
> > 
> > Fix this by returning the error EOPNOTSUPP if an attempt to copy an
> > inline extent into a non-zero offset happens, just like what is done for
> > other scenarios that would require copying/splitting inline extents,
> > which were introduced by the following commits:
> > 
> >    00fdf13a2e9f ("Btrfs: fix a crash of clone with inline extents's split")
> >    3f9e3df8da3c ("btrfs: replace error code from btrfs_drop_extents")
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  fs/btrfs/ioctl.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index d389815..0770c91 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -3588,6 +3588,20 @@ process_slot:
> >  				u64 trim = 0;
> >  				u64 aligned_end = 0;
> >  
> > +				/*
> > +				 * Don't copy an inline extent into an offset
> > +				 * greater than zero. Having an inline extent
> > +				 * at such an offset results in chaos as btrfs
> > +				 * isn't prepared for such cases. Just skip
> > +				 * this case for the same reasons as commented
> > +				 * at btrfs_ioctl_clone().
> > +				 */
> > +				if (last_dest_end > 0) {
> > +					ret = -EOPNOTSUPP;
> > +					btrfs_end_transaction(trans, root);
> > +					goto out;
> > +				}
> > +
> >  				if (off > key.offset) {
> >  					skip = off - key.offset;
> >  					new_key.offset += skip;
> > -- 
> > 2.1.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

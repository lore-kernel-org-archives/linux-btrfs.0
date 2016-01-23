Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34516 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbcAWREB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 12:04:01 -0500
Date: Sat, 23 Jan 2016 09:03:54 -0800
From: Marc MERLIN <marc@merlins.org>
To: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
Message-ID: <20160123170354.GA10113@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160121045239.GQ17679@merlins.org>
 <20160118233943.GF17679@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+David, +Qu
about 
1) kernel crash on BUG_ON
2) check --repair not giving good clue that
"type mismatch with chunk" is unfixable, and whether it can be kind of
ignored or whether your FS really needs to be recreated from scratch
(many hours of work for me, and probably 2 days of clock time to rebuild
and restore from backup)
3) say more about "root 45948 inode 204452 errors 1000, some csum missing",
that they aren't being fixed, and whether they're a big deal or not.

More generally I'm curious to know if check --repair will sometimes fix
more things on a 2nd (or 3rd...) run than on the first one.

Thanks,
Marc

On Mon, Jan 18, 2016 at 03:39:43PM -0800, Marc MERLIN wrote:
> On Mon, Jan 18, 2016 at 03:21:53AM +0000, Duncan wrote:
> > No.  Those are monotonically increasing counts that are never 
> > automatically reset over the life of the filesystem.  Use ...
> > 
> > btrfs dev stats
> > 
> > ... to display them on the commandline (vs. the kernel log at filesystem 
> > mount), with the -z option to reset them after display, if desired.
> 
> It's a bit counter intuitive that check --repair doesn't reset error counts if it fixed
> underlying errors, but maybe there is a good reason :)
> 
> btrfs dev stats -z /dev/mapper/dshelf1
> put everything back to 0 as you hinted, I can now watch what's going on
> from here on, thanks.
> 
> On Mon, Jan 18, 2016 at 12:45:33PM +0000, Hugo Mills wrote:
> > > bad extent [8697338122240, 8697338126336), type mismatch with chunk
> > > bad extent [8697338126336, 8697338130432), type mismatch with chunk
> > > bad extent [8697338130432, 8697338134528), type mismatch with chunk
> > 
> >    This is, I think, a symptom of an FS created with a broken
> > mkfs.btrfs, and it needs to be re-created. Take a look for that error
> > message in the mailing list archives -- there's been a few posts about
> > it in the last couple of months.
>  
> Thanks for that other hint.
> It was created quite a while ago (1y+), and ran ok until I had an
> unexpected crash.
> If I have to rebuild it, I will, but that will take 2 days+ due to the 
> size and getting the backup back (well also, I'm not home for a week, so
> restoring backups remotely isn't going to be fun).
> 
> But sure enough, while it ran perfectly fine for a long time, after check --repair,
> my machine is now crashing every hour or so, with the crash below.
> 
> I had to have an older kernel due to a separate problem where PMP (sata
> port multiplier) support was broken in more recent kernels.
> I've just put 4.3.3 on it to see if crashes still, but either way, I thought
> btrfs had gotten rid of its last BUG_ON(xxx). System should never crash
> due to unexpected filesystem state on a non system partition.
> 
> Mmmh, scratch this, here's the BUG_ON, it's a memory problem :(
> fs/btrfs/ctree.c:5200
> 		/* save our key for returning back */
> 		btrfs_node_key_to_cpu(cur, &found_key, slot);
> 		path->slots[level] = slot;
> 		if (level == path->lowest_level) {
> 			ret = 0;
> 			goto out;
> 		}
> 		btrfs_set_path_blocking(path);
> 		cur = read_node_slot(root, cur, slot);
> 		BUG_ON(!cur); /* -ENOMEM */
> 
> Did check --repair potentially change my FS in a way that is now making the
> kernel take a lot of RAM and crash?
> 
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/ctree.c:5200!
> invalid opcode: 0000 [#1] SMP
> CPU: 3 PID: 29041 Comm: btrfs Tainted: G        W       4.2.5-amd64-i915-volpreempt-20150421 #4
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
> task: ffff88002f8482c0 ti: ffff8800c9058000 task.ti: ffff8800c9058000
> RIP: 0010:[<ffffffff81234001>]  [<ffffffff81234001>] btrfs_search_forward+0x1a6/0x24b
> RSP: 0018:ffff8800c905bbc8  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8801494409b0 RCX: 000000000003c6c8
> RDX: 0000000000000000 RSI: 000000000aa60000 RDI: fffffffffffffffb
> RBP: ffff8800c905bc38 R08: 0000000001c00000 R09: 0000000000000000
> R10: 0000000000aaaaaa R11: ffffffff818799e0 R12: 0000000000000000
> R13: 0000000000000001 R14: 0000000000000000 R15: ffff8801494409b4
> FS:  00007fa9d46848c0(0000) GS:ffff88021e2c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000f77cd000 CR3: 0000000143780000 CR4: 00000000001406e0
> Stack:
>  ffff8800c9bb6050 0001880149440a18 ffff8800c905bc87 ffff8800c939a800
>  0000000000000003 1a0000000000002e 84000000000000b3 000000000003c59e
>  000000000000002c ffff8801494409b0 0000000000000000 ffff8800c905bce0
> Call Trace:
>  [<ffffffff81278ca5>] search_ioctl+0xfc/0x167
>  [<ffffffff81278d6b>] btrfs_ioctl_tree_search+0x5b/0x8e
>  [<ffffffff8127c6af>] btrfs_ioctl+0x396/0x232f
>  [<ffffffff81123a2d>] ? get_page+0xe/0x28
>  [<ffffffff81123e68>] ? __lru_cache_add+0x23/0x44
>  [<ffffffff81124139>] ? lru_cache_add_active_or_unevictable+0x2d/0x6b
>  [<ffffffff8113a2df>] ? set_pte_at+0x9/0xd
>  [<ffffffff8113e21d>] ? handle_mm_fault+0x90e/0xe9b
>  [<ffffffff8100d02b>] ? paravirt_write_msr+0xf/0x13
>  [<ffffffff811814af>] do_vfs_ioctl+0x39b/0x412
>  [<ffffffff810ace61>] ? current_kernel_time+0xe/0x32
>  [<ffffffff810d4d5c>] ? __audit_syscall_entry+0xbe/0xe0
>  [<ffffffff81181580>] SyS_ioctl+0x5a/0x7f
>  [<ffffffff816b0032>] entry_SYSCALL_64_fastpath+0x16/0x75
> Code: 89 47 40 44 3b ab 84 00 00 00 74 69 48 89 df e8 f7 a3 ff ff 8b 55 b8 48 8b 7d a8 4c 89 e6 e8 d8 86 ff ff 48 85 c0 
> <0f> 0b 48 89 c7 e8 23 a7 04 00 41 8d 45 ff 41 c7 47 5c 02 00 00
> RIP  [<ffffffff81234001>] btrfs_search_forward+0x1a6/0x24b
>  RSP <ffff8800c905bbc8>
> ---[ end trace e3c37adcaa703f63 ]---
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: disabled
> drm_kms_helper: panic occurred, switching back to text console
> 
> 
> 
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

On Wed, Jan 20, 2016 at 08:52:39PM -0800, Marc MERLIN wrote:
> On Mon, Jan 18, 2016 at 03:39:43PM -0800, Marc MERLIN wrote:
> > Thanks for that other hint.
> > It was created quite a while ago (1y+), and ran ok until I had an
> > unexpected crash.
> > If I have to rebuild it, I will, but that will take 2 days+ due to the 
> > size and getting the backup back (well also, I'm not home for a week, so
> > restoring backups remotely isn't going to be fun).
> > 
> > But sure enough, while it ran perfectly fine for a long time, after check --repair,
> > my machine is now crashing every hour or so, with the crash below.
> 
> I ran check --repair a few more times on it but it does not seem to converge.
> The bad extent stuff, I understand cannot be fixed (although it's not obvious from check
> --repair that they are not getting fixed).
> 
> But how about 
> root 45940 inode 204450 errors 1000, some csum missing
> Are those getting fixed by check --repair or are they unfixable too?
>  
> (...)
> bad extent [8697338126336, 8697338130432), type mismatch with chunk
> bad extent [8697338130432, 8697338134528), type mismatch with chunk
> repaired damaged extent references
> 
> Fixed 0 roots.
> cache and super generation don't match, space cache will be invalidated
> rootk262 inodeo204450 errors 1000, some csum missing
> root 262 inode 204452 errors 1000, some csum missing
> (...)
> root 45940 inode 204450 errors 1000, some csum missing
> root 45940 inode 204452 errors 1000, some csum missing
> root 45944 inode 204450 errors 1000, some csum missing
> root 45944 inode 204452 errors 1000, some csum missing
> root 45948 inode 204450 errors 1000, some csum missing
> root 45948 inode 204452 errors 1000, some csum missing
> checking fs roots [o]
> checking csums
> checking root refs
> found 9826295305149 bytes used err is 0
> total csum bytes: 9584154948
> total tree bytes: 12201304064
> total fs tree bytes: 330776576
> total extent tree bytes: 498921472
> btree space waste bytes: 1373183541
> file data blocks allocated: 9953275256832
>  referenced 9964596801536
> btrfs-progs v4.3
> 
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

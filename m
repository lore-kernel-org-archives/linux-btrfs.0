Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34202 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933429AbeF2GHE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 02:07:04 -0400
Date: Thu, 28 Jun 2018 23:06:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20180629060657.qrtcxfcy22zkstfw@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 01:48:17PM +0800, Qu Wenruo wrote:
> Just normal btrfs check, and post the output.
> If normal check eats up all your memory, btrfs check --mode=lowmem.
 
Does check without --repair eat less RAM?

> --repair should be considered as the last method.

If --repair doesn't work, check is useless to me sadly. I know that for
FS analysis and bug reporting, you want to have the FS without changing
it to something maybe worse, but for my use, if it can't be mounted and
can't be fixed, then it gets deleted which is even worse than check
doing the wrong thing.

> > The last two ERROR lines took over a day to get generated, so I'm not sure if it's still working, but just slowly.
> 
> OK, that explains something.
> 
> One extent is referred hundreds times, no wonder it will take a long time.
> 
> Just one tip here, there are really too many snapshots/reflinked files.
> It's highly recommended to keep the number of snapshots to a reasonable
> number (lower two digits).
> Although btrfs snapshot is super fast, it puts a lot of pressure on its
> extent tree, so there is no free lunch here.
 
Agreed, I doubt I have over or much over 100 snapshots though (but I
can't check right now).
Sadly I'm not allowed to mount even read only while check is running:
gargamel:~# mount -o ro /dev/mapper/dshelf2 /mnt/mnt2
mount: /dev/mapper/dshelf2 already mounted or /mnt/mnt2 busy

> > I see. Is there any reasonably easy way to check on this running process?
> 
> GDB attach would be good.
> Interrupt and check the inode number if it's checking fs tree.
> Check the extent bytenr number if it's checking extent tree.
> 
> But considering how many snapshots there are, it's really hard to determine.
> 
> In this case, the super large extent tree is causing a lot of problem,
> maybe it's a good idea to allow btrfs check to skip extent tree check?

I only see --init-extent-tree in the man page, which option did you have
in mind?

> > Then again, maybe it already fixed enough that I can mount my filesystem again.
> 
> This needs the initial btrfs check report and the kernel messages how it
> fails to mount.

mount command hangs, kernel does not show anything special outside of disk access hanging.

Jun 23 17:23:26 gargamel kernel: [  341.802696] BTRFS warning (device dm-2): 'recovery' is deprecated, use 'useback
uproot' instead
Jun 23 17:23:26 gargamel kernel: [  341.828743] BTRFS info (device dm-2): trying to use backup root at mount time
Jun 23 17:23:26 gargamel kernel: [  341.850180] BTRFS info (device dm-2): disk space caching is enabled
Jun 23 17:23:26 gargamel kernel: [  341.869014] BTRFS info (device dm-2): has skinny extents
Jun 23 17:23:26 gargamel kernel: [  342.206289] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0 , flush 0, corrupt 2, gen 0
Jun 23 17:26:26 gargamel kernel: [  521.571392] BTRFS info (device dm-2): enabling ssd optimizations
Jun 23 17:55:58 gargamel kernel: [ 2293.914867] perf: interrupt took too long (2507 > 2500), lowering kernel.perf_event_max_sample_rate to 79750
Jun 23 17:56:22 gargamel kernel: [ 2317.718406] BTRFS info (device dm-2): disk space caching is enabled
Jun 23 17:56:22 gargamel kernel: [ 2317.737277] BTRFS info (device dm-2): has skinny extents
Jun 23 17:56:22 gargamel kernel: [ 2318.069461] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0 , flush 0, corrupt 2, gen 0
Jun 23 17:59:22 gargamel kernel: [ 2498.256167] BTRFS info (device dm-2): enabling ssd optimizations
Jun 23 18:05:23 gargamel kernel: [ 2859.107057] BTRFS info (device dm-2): disk space caching is enabled
Jun 23 18:05:23 gargamel kernel: [ 2859.125883] BTRFS info (device dm-2): has skinny extents
Jun 23 18:05:24 gargamel kernel: [ 2859.448018] BTRFS info (device dm-2): bdev /dev/mapper/dshelf2 errs: wr 0, rd 0 , flush 0, corrupt 2, gen 0
Jun 23 18:08:23 gargamel kernel: [ 3039.023305] BTRFS info (device dm-2): enabling ssd optimizations
Jun 23 18:13:41 gargamel kernel: [ 3356.626037] perf: interrupt took too long (3143 > 3133), lowering kernel.perf_event_max_sample_rate to 63500
Jun 23 18:17:23 gargamel kernel: [ 3578.937225] Process accounting resumed
Jun 23 18:33:47 gargamel kernel: [ 4563.356252] JFS: nTxBlock = 8192, nTxLock = 65536
Jun 23 18:33:48 gargamel kernel: [ 4563.446715] ntfs: driver 2.1.32 [Flags: R/W MODULE].
Jun 23 18:42:20 gargamel kernel: [ 5075.995254] INFO: task sync:20253 blocked for more than 120 seconds.
Jun 23 18:42:20 gargamel kernel: [ 5076.015729]       Not tainted 4.17.2-amd64-preempt-sysrq-20180817 #1
Jun 23 18:42:20 gargamel kernel: [ 5076.036141] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 23 18:42:20 gargamel kernel: [ 5076.060637] sync            D    0 20253  15327 0x20020080
Jun 23 18:42:20 gargamel kernel: [ 5076.078032] Call Trace:
Jun 23 18:42:20 gargamel kernel: [ 5076.086366]  ? __schedule+0x53e/0x59b
Jun 23 18:42:20 gargamel kernel: [ 5076.098311]  schedule+0x7f/0x98
Jun 23 18:42:20 gargamel kernel: [ 5076.108665]  __rwsem_down_read_failed_common+0x127/0x1a8
Jun 23 18:42:20 gargamel kernel: [ 5076.125565]  ? sync_fs_one_sb+0x20/0x20
Jun 23 18:42:20 gargamel kernel: [ 5076.137982]  ? call_rwsem_down_read_failed+0x14/0x30
Jun 23 18:42:20 gargamel kernel: [ 5076.154081]  call_rwsem_down_read_failed+0x14/0x30
Jun 23 18:42:20 gargamel kernel: [ 5076.169429]  down_read+0x13/0x25
Jun 23 18:42:20 gargamel kernel: [ 5076.180444]  iterate_supers+0x57/0xbe
Jun 23 18:42:20 gargamel kernel: [ 5076.192619]  ksys_sync+0x40/0xa4
Jun 23 18:42:20 gargamel kernel: [ 5076.203192]  __ia32_sys_sync+0xa/0xd
Jun 23 18:42:20 gargamel kernel: [ 5076.214774]  do_fast_syscall_32+0xaf/0xf3
Jun 23 18:42:20 gargamel kernel: [ 5076.227740]  entry_SYSENTER_compat+0x7f/0x91
Jun 23 18:44:21 gargamel kernel: [ 5196.828764] INFO: task sync:20253 blocked for more than 120 seconds.
Jun 23 18:44:21 gargamel kernel: [ 5196.848724]       Not tainted 4.17.2-amd64-preempt-sysrq-20180817 #1
Jun 23 18:44:21 gargamel kernel: [ 5196.868789] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 23 18:44:21 gargamel kernel: [ 5196.893615] sync            D    0 20253  15327 0x20020080

> > But back to the main point, it's sad that after so many years, the
> > repair situation is still so suboptimal, especially when it's apparently
> > pretty easy for btrfs to get damaged (through its own fault or not, hard
> > to say).
> 
> Unfortunately, yes.
> Especially the extent tree is pretty fragile and hard to repair.

So, I don't know the code, but if I may make a suggestion (which maybe
is totally wrong, if so forgive me):
I would love for a repair mode that gives me a back a fixed
filesystem. I don't really care how much data is lost (although ideally
it would give me a list of files lost), but I want a working filesystem
at the end. I can then decide if there is enough data left on it to
restore what's missing or if I'm better off starting from scratch.

Is that possible at all?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08

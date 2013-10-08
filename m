Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43226 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3JHHMq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 03:12:46 -0400
Date: Tue, 8 Oct 2013 15:12:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Zach Brown <zab@zabbo.net>
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
Message-ID: <20131008071232.GA1402@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com>
 <CAOMFOmX95ebV=myVO1yDf5yPs7DfmvHDKDFwNNfT0CajDQ=W4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOMFOmX95ebV=myVO1yDf5yPs7DfmvHDKDFwNNfT0CajDQ=W4Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 11:36:30PM -0700, Anatol Pomozov wrote:
> Hi, Btrfs developers
> 
> 
> On Fri, Oct 4, 2013 at 9:03 PM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:
> > Hi,
> >
> > I have a home server on Linux Arch (kernel 3.11.2) that uses
> > multi-device btrfs on root filesystem.
> >
> > Until recently it worked completely fine. And yesterday I rebooted it
> > and the machine did not wake up.
> >
> > I booted from a USB (kernel 3.10) and tried to mount the filesystem.
> > Here is OOPs I see
> >
> > [   41.676217] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 8 transid 164237 /dev/sda
> > [   41.684161] btrfs: disk space caching is enabled
> > [   67.266742] BTRFS error (device sdd3): block group 1141416919040
> > has wrong amount of free space
> > [   67.266796] BTRFS error (device sdd3): failed to load free space
> > cache for block group 1141416919040
> > [   68.126102] ------------[ cut here ]------------
> > [   68.126138] kernel BUG at fs/btrfs/inode.c:873!
> > [   68.126164] invalid opcode: 0000 [#1] PREEMPT SMP
> > [   68.126203] Modules linked in: intel_powerclamp coretemp kvm_intel
> > kvm crc32_pclmul ghash_clmulni_intel cryptd iTCO_wdt
> > iTCO_vendor_support ppdev microcode snd_hda_codec_hdmi psmouse
> > snd_hda_codec_realtek serio_raw i2c_i801 snd_hda_intel pcspkr
> > snd_hda_codec lpc_ich snd_hwdep parport_pc parport snd_pcm mperf
> > snd_page_alloc snd_timer snd mei_me soundcore evdev mei processor nfs
> > lockd sunrpc fscache ext4 crc16 mbcache jbd2 dm_snapshot dm_mod
> > squashfs loop isofs btrfs raid6_pq libcrc32c zlib_deflate xor
> > hid_generic usbhid hid usb_storage sd_mod i915 intel_agp intel_gtt
> > ahci libahci crc32c_intel i2c_algo_bit xhci_hcd libata ehci_pci
> > ehci_hcd scsi_mod atl1c drm_kms_helper usbcore usb_common drm i2c_core
> > button video
> > [   68.126754] CPU: 1 PID: 386 Comm: mount Not tainted 3.10.10-1-ARCH #1
> > [   68.126787] Hardware name: To Be Filled By O.E.M. To Be Filled By
> > O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
> > [   68.126834] task: ffff880118869950 ti: ffff88011377e000 task.ti:
> > ffff88011377e000
> > [   68.126871] RIP: 0010:[<ffffffffa0471223>]  [<ffffffffa0471223>]
> > __cow_file_range+0x3e3/0x460 [btrfs]
> > [   68.126933] RSP: 0018:ffff88011377f328  EFLAGS: 00010206
> > [   68.126961] RAX: 00000000000004d2 RBX: 0000000000000000 RCX: 0000000000001000
> > [   68.126996] RDX: 00000000000004d2 RSI: ffff88001f438608 RDI: ffff880115eb3000
> > [   68.127032] RBP: ffff88011377f3c8 R08: 0000000000000000 R09: 000000000003ffff
> > [   68.127068] R10: 0000000000040000 R11: 0000000000000000 R12: 0000000000000000
> > [   68.127103] R13: ffff880115f88630 R14: ffff88001f438608 R15: 0000000000000000
> > [   68.127140] FS:  00007fac17768780(0000) GS:ffff88011f300000(0000)
> > knlGS:0000000000000000
> > [   68.127180] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   68.127209] CR2: 00007f518d994000 CR3: 0000000117ab4000 CR4: 00000000000407e0
> > [   68.127246] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   68.127281] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [   68.127317] Stack:
> > [   68.127331]  00000109ffe26000 ffff880115f88c60 ffff88001f438428
> > 000000000003ffff
> > [   68.127381]  ffff88011700c010 ffffea0003231b40 ffff880115eb3000
> > f600000109ffd870
> > [   68.127430]  ffffffffa0482f29 ffff880118a31000 ffff880115f88638
> > ffff88001f438448
> > [   68.127480] Call Trace:
> > [   68.127508]  [<ffffffffa0482f29>] ? release_extent_buffer+0xa9/0xd0 [btrfs]
> > [   68.127553]  [<ffffffffa048862f>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
> > [   68.127598]  [<ffffffffa04716d6>] run_delalloc_nocow+0x436/0xaf0 [btrfs]
> > [   68.127641]  [<ffffffffa0472180>] run_delalloc_range+0x320/0x390 [btrfs]
> > [   68.127685]  [<ffffffffa04854c1>] ?
> > find_lock_delalloc_range.constprop.44+0x1d1/0x1f0 [btrfs]
> > [   68.127735]  [<ffffffffa0487044>] __extent_writepage+0x354/0x7b0 [btrfs]
> > [   68.127772]  [<ffffffff81122645>] ? find_get_pages_tag+0x105/0x180
> > [   68.127813]  [<ffffffffa0487722>]
> > extent_write_cache_pages.isra.32.constprop.48+0x282/0x3e0 [btrfs]
> > [   68.127867]  [<ffffffffa0487b7d>] extent_writepages+0x4d/0x70 [btrfs]
> > [   68.127909]  [<ffffffffa046e080>] ? can_nocow_odirect+0x2f0/0x2f0 [btrfs]
> > [   68.127951]  [<ffffffffa046cf28>] btrfs_writepages+0x28/0x30 [btrfs]
> > [   68.127985]  [<ffffffff8112e28e>] do_writepages+0x1e/0x40
> > [   68.128014]  [<ffffffff81123669>] __filemap_fdatawrite_range+0x59/0x60
> > [   68.128048]  [<ffffffff81123733>] filemap_fdatawrite_range+0x13/0x20
> > [   68.128090]  [<ffffffffa0481c99>] btrfs_wait_ordered_range+0x49/0x110 [btrfs]
> > [   68.128135]  [<ffffffffa04a64c0>] __btrfs_write_out_cache+0x6d0/0x8f0 [btrfs]
> > [   68.128180]  [<ffffffffa04a774d>] btrfs_write_out_cache+0x8d/0xe0 [btrfs]
> > [   68.128224]  [<ffffffffa0459983>]
> > btrfs_write_dirty_block_groups+0x533/0x620 [btrfs]
> > [   68.128271]  [<ffffffffa04676e2>] commit_cowonly_roots+0x172/0x260 [btrfs]
> > [   68.128314]  [<ffffffffa04695ad>]
> > btrfs_commit_transaction+0x5bd/0xaf0 [btrfs]
> > [   68.128353]  [<ffffffff8107b460>] ? wake_up_bit+0x30/0x30
> > [   68.128391]  [<ffffffffa04a4edd>] btrfs_recover_log_trees+0x3bd/0x490 [btrfs]
> > [   68.128434]  [<ffffffffa04a3270>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
> > [   68.128477]  [<ffffffffa0466689>] open_ctree+0x17b9/0x1e80 [btrfs]
> > [   68.128513]  [<ffffffff813555d3>] ? proc_comm_connector+0x33/0x120
> > [   68.128551]  [<ffffffffa043f456>] btrfs_mount+0x636/0x830 [btrfs]
> > [   68.128584]  [<ffffffff81141cd2>] ? pcpu_alloc+0x7d2/0x9e0
> > [   68.128616]  [<ffffffff8118f5d9>] mount_fs+0x39/0x1b0
> > [   68.128643]  [<ffffffff81141ef0>] ? __alloc_percpu+0x10/0x20
> > [   68.128676]  [<ffffffff811a8c27>] vfs_kern_mount+0x67/0x100
> > [   68.128706]  [<ffffffff811ab24e>] do_mount+0x23e/0xa20
> > [   68.128737]  [<ffffffff8113d73b>] ? strndup_user+0x4b/0xf0
> > [   68.128766]  [<ffffffff811abab3>] SyS_mount+0x83/0xc0
> > [   68.128795]  [<ffffffff814cfe1d>] system_call_fastpath+0x1a/0x1f
> > [   68.128826] Code: 8b 7d 90 4c 89 f6 e8 ad 9e 00 00 e9 dc fc ff ff
> > 48 85 d2 74 40 80 be 30 fe ff ff 84 48 89 d0 74 34 48 83 f8 01 0f 84
> > 87 fc ff ff <0f> 0b 48 8b 75 a8 48 8b 7d 90 41 89 c0 b9 9b 03 00 00 48
> > c7 c2
> > [   68.129145] RIP  [<ffffffffa0471223>] __cow_file_range+0x3e3/0x460 [btrfs]
> > [   68.129192]  RSP <ffff88011377f328>
> > [   68.129230] ---[ end trace 7992880786c40076 ]---
> >
> >
> >
> > Hm.... it looks like it crashed when it tries to restore logs. Ok, I
> > ran 'btrfschk /dev/sda' and here is its output:
> >
> > [  181.281546] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 8 transid 164237 /dev/sda
> > [  181.318148] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 3 transid 164237 /dev/sdb
> > [  181.408490] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 2 transid 164237 /dev/sdc1
> > [  181.763300] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 9 transid 164237 /dev/sdd3
> > [  181.782414] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 8 transid 164237 /dev/sda
> > [  181.784634] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 3 transid 164237 /dev/sdb
> > [  181.788715] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 2 transid 164237 /dev/sdc1
> > [  181.803161] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
> > 9 transid 164237 /dev/sdd3
> > [  337.445525] systemd-journald[160]: Failed to write entry, ignoring:
> > Argument list too long
> >
> >
> > Then I tried to mount the filesystem again and it stuck. I see several
> > processes in UNINTERRUPTIBLE state:
> >
> > [  828.034908] SysRq : Show Blocked State
> > [  828.036150]   task                        PC stack   pid father
> > [  828.037418] btrfs-transacti D ffff880118a311e8     0   407      2 0x00000000
> > [  828.038709]  ffff880115051dc8 0000000000000046 0000000000014340
> > ffff880115051fd8
> > [  828.040030]  ffff880115051fd8 0000000000014340 ffff88011886f620
> > ffff88011886f620
> > [  828.041364]  000000000000082f ffff880115051d30 ffffffff8109d141
> > ffff880118868048
> > [  828.042724] Call Trace:
> > [  828.044071]  [<ffffffff8109d141>] ? cpuacct_charge+0x61/0x70
> > [  828.045445]  [<ffffffff8108dd88>] ? __enqueue_entity+0x78/0x80
> > [  828.046829]  [<ffffffff810920f6>] ? enqueue_entity+0x286/0xa20
> > [  828.048227]  [<ffffffff81065bbb>] ? lock_timer_base.isra.35+0x2b/0x50
> > [  828.049648]  [<ffffffff814c6f09>] schedule+0x29/0x70
> > [  828.051076]  [<ffffffffa0468695>]
> > wait_current_trans.isra.14+0xa5/0xf0 [btrfs]
> > [  828.052515]  [<ffffffff8107b460>] ? wake_up_bit+0x30/0x30
> > [  828.053970]  [<ffffffffa0469e18>] start_transaction+0x338/0x530 [btrfs]
> > [  828.055453]  [<ffffffffa046a0c7>] btrfs_attach_transaction+0x17/0x20 [btrfs]
> > [  828.056943]  [<ffffffffa0460ca1>] transaction_kthread+0x141/0x230 [btrfs]
> > [  828.058455]  [<ffffffffa0460b60>] ? free_fs_root+0x90/0x90 [btrfs]
> > [  828.059989]  [<ffffffff8107a670>] kthread+0xc0/0xd0
> > [  828.061508]  [<ffffffff8107a5b0>] ? kthread_create_on_node+0x120/0x120
> > [  828.063036]  [<ffffffff814cfd6c>] ret_from_fork+0x7c/0xb0
> > [  828.064568]  [<ffffffff8107a5b0>] ? kthread_create_on_node+0x120/0x120
> > [  828.066109] mount           D ffff880118a31878     0   427    343 0x00000000
> > [  828.067680]  ffff880117bdbc18 0000000000000086 0000000000014340
> > ffff880117bdbfd8
> > [  828.069278]  ffff880117bdbfd8 0000000000014340 ffff880118facbf0
> > ffff8801169cb800
> > [  828.070869]  ffff88011f214340 ffffffff81085aa9 ffff8801169cb800
> > ffff88011f214340
> > [  828.072430] Call Trace:
> > [  828.073966]  [<ffffffff81085aa9>] ? finish_task_switch+0x49/0xe0
> > [  828.075524]  [<ffffffff814c6996>] ? __schedule+0x3f6/0x940
> > [  828.077093]  [<ffffffff81071194>] ? wake_up_worker+0x24/0x30
> > [  828.078671]  [<ffffffff814c5a34>] ? __mutex_lock_slowpath+0x284/0x3b0
> > [  828.080275]  [<ffffffff814c6f09>] schedule+0x29/0x70
> > [  828.081867]  [<ffffffff814c7d95>] rwsem_down_write_failed+0xf5/0x1c3
> > [  828.083473]  [<ffffffffa043a000>] ? 0xffffffffa0439fff
> > [  828.085083]  [<ffffffff81279e33>] call_rwsem_down_write_failed+0x13/0x20
> > [  828.086717]  [<ffffffff814c5ec4>] ? down_write+0x24/0x26
> > [  828.088366]  [<ffffffff8118dffe>] grab_super+0x2e/0xa0
> > [  828.090021]  [<ffffffff8118e6f0>] sget+0x320/0x580
> > [  828.091677]  [<ffffffffa043e130>] ?
> > btrfs_parse_early_options+0x190/0x190 [btrfs]
> > [  828.093368]  [<ffffffff814c57ae>] ? mutex_unlock+0xe/0x10
> > [  828.095068]  [<ffffffffa043f228>] btrfs_mount+0x408/0x830 [btrfs]
> > [  828.096786]  [<ffffffff81141cd2>] ? pcpu_alloc+0x7d2/0x9e0
> > [  828.098516]  [<ffffffff8118f5d9>] mount_fs+0x39/0x1b0
> > [  828.100267]  [<ffffffff81141ef0>] ? __alloc_percpu+0x10/0x20
> > [  828.102017]  [<ffffffff811a8c27>] vfs_kern_mount+0x67/0x100
> > [  828.103775]  [<ffffffff811ab24e>] do_mount+0x23e/0xa20
> > [  828.105547]  [<ffffffff8113d73b>] ? strndup_user+0x4b/0xf0
> > [  828.107312]  [<ffffffff811abab3>] SyS_mount+0x83/0xc0
> > [  828.109096]  [<ffffffff814cfe1d>] system_call_fastpath+0x1a/0x1f
> >
> > The only thing that I did recently is defrag /var/log/journal files
> > (journalctl is very slow because of btrfs COW). Something like this
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24878.html
> >
> > How to fix this problem? And restore the data...
> 
> 
> Dear btrfs developers, I still have my server in broken state. Is
> there anything I can do to restore it? I tried to mount the filesystem
> with different flags (e.g. notreelog) but all of them cause deadlock
> like above. Have you see such issue before? Any ideas what the problem
> can be?
> 
> I do not mind to spend some time on debugging this kernel issue it but
> I really need some pointers from people who know this code very well
> (I am mostly familiar with block layer).

Getting Stuck while sget() doesn't seem to be a problem caused by zeroing the
log.

Is it possible to boot it with a USB(recent 3.12-rc3) and mount it again?

-liubo

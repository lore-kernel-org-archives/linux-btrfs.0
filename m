Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from library-of-babel.snurgle.org ([72.93.243.60]:43746 "EHLO
	library-of-babel.snurgle.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760062Ab2JLSKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 14:10:03 -0400
Date: Fri, 12 Oct 2012 14:01:53 -0400
From: Chris Chiappa <chris@chiappa.net>
To: linux-btrfs@vger.kernel.org
Subject: Crash / assertion failure in btrfsck
Message-ID: <20121012180152.GA3937@library-of-babel.snurgle.org>
Reply-To: chris@chiappa.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For kicks, I started doing a "btrfs balance" on filesystem A
yesterday.  At some point, a process (a backup script which uses
rsync) ran which did a lot of I/O on A and then proceeded to a lot of
I/O on filesystem B (also btrfs) as well.  At some point, I got a BUG
in __btrfs_inc_extent_ref:

Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420031] kernel BUG at
/build/buildd-linux_3.5.2-1~experimental.1-amd64-bLqIZ_/linux-3.5.2/f
s/btrfs/extent-tree.c:1769!
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420089] invalid opcode:
0000 [#1] SMP 
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420117] CPU 0 
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420130] Modules linked
in: nls_utf8 nls_cp437 vfat fat sr_mod cdrom cpufreq_powersave cpufr
eq_userspace ppdev cpufreq_stats lp cpufreq_conservative autofs4
pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc n
fsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc tun loop fuse
dm_crypt dm_mod uvcvideo videobuf2_vmalloc videobuf2_memops ses
enclosure 
videobuf2_core videodev media snd_usb_audio snd_usbmidi_lib snd_hwdep
snd_seq_midi snd_seq_midi_event snd_rawmidi snd_pcm snd_page_alloc 
snd_seq snd_seq_device snd_timer joydev snd hid_generic soundcore
usbhid hid radeon ttm parport_pc coretemp drm_kms_helper drm kvm acpi_c
pufreq mperf i2c_i801 parport evdev psmouse processor i2c_algo_bit
lpc_ich pcspkr dcdbas button serio_raw i2c_core microcode mfd_core the
rmal_sys ext4 crc16 jbd2 mbcache btrfs crc32c libcrc32c zlib_deflate
usb_storage uas sg sd_mod crc_t10dif ata_generic uhci_hcd ahci libah
ci ehci_hcd libata scsi_mod e1000e usbcore usb_common [last unloaded:
scsi
Oct 12 05:46:40 cchiappa-lnx kernel: _wait_scan]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420799] 
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420803] Pid: 22392, comm: btrfs Tainted: G           O 3.5-trunk-amd64 #1 Dell Inc. OptiPlex 755                 /0DR845
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420867] RIP: 0010:[<ffffffffa0135e9b>]  [<ffffffffa0135e9b>] insert_inline_extent_backref+0x6a/0xee [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420941] RSP: 0018:ffff88009ea33818  EFLAGS: 00010297
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.420970] RAX: 0000000000000000 RBX: ffff880105244d00 RCX: ffff8800933ca000
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421008] RDX: ffff88009ea33860 RSI: 0000000000000000 RDI: 0000000000000000
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421045] RBP: ffff8801ae341c00 R08: 0000000000000000 R09: ffff88009ea33728
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421082] R10: 0000000000000008 R11: 0000000000000000 R12: ffff88010703fd20
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421120] R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421158] FS: 00007fedcf2a7760(0000) GS:ffff8801b7c00000(0000) knlGS:0000000000000000
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421200] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421232] CR2: 0000000002c680c8 CR3: 000000015d2ac000 CR4: 00000000000007f0
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421269] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421307] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421345] Process btrfs (pid: 22392, threadinfo ffff88009ea32000, task ffff88014fca88b0)
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421387] Stack:
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421400] 0000000000000000 0000000000000005 0000000000000002 0000000000000000
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421447] ffff880100000001 ffff88017a721c40 ffff8801addf6500 0000000000008050
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421495] 0000000000008050 0000000000000fb2 0000000000000246 ffff880105244d00
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421542] Call Trace:
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421570]  [<ffffffffa0135fc0>] ? __btrfs_inc_extent_ref+0xa1/0x1e5 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421620]  [<ffffffffa01380e3>] ? do_chunk_alloc.isra.69+0x77/0x368 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421670]  [<ffffffffa013a751>] ? run_clustered_refs+0x6a6/0x77d [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421719]  [<ffffffffa013aa32>] ? btrfs_run_delayed_refs+0x20a/0x302 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421773]  [<ffffffffa0182e1e>] ? relocate_tree_blocks+0x453/0x46b [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421826]  [<ffffffffa0148b39>] ? __btrfs_end_transaction+0xa2/0x209 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421878]  [<ffffffffa0183a26>] ? relocate_block_group+0x2ad/0x4e6 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421920]  [<ffffffff8105982f>] ? should_resched+0x5/0x23
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.421965]  [<ffffffffa0183d9e>] ? btrfs_relocate_block_group+0x13f/0x267 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422020]  [<ffffffffa01684b4>] ? btrfs_relocate_chunk.isra.51+0x52/0x589 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422075]  [<ffffffffa0173eb2>] ? btrfs_set_lock_blocking_rw+0xd0/0xe6 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422116]  [<ffffffff8105a4cb>] ? __wake_up+0x35/0x46
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422159]  [<ffffffffa0165780>] ? release_extent_buffer.isra.30+0x27/0x86 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422214]  [<ffffffffa016b97c>] ? btrfs_balance+0x83f/0x9bb [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422263]  [<ffffffffa017038b>] ? btrfs_ioctl_balance+0xad/0x20d [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422315]  [<ffffffffa017041b>] ? btrfs_ioctl_balance+0x13d/0x20d [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422354]  [<ffffffff8105982f>] ? should_resched+0x5/0x23
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422398]  [<ffffffffa017048c>] ? btrfs_ioctl_balance+0x1ae/0x20d [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422449]  [<ffffffffa017352a>] ? btrfs_ioctl+0xe97/0x1081 [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422486]  [<ffffffff813637e6>] ? do_page_fault+0x2fc/0x337
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422519]  [<ffffffff8110d7a1>] ? do_vfs_ioctl+0x453/0x494
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422552]  [<ffffffff810dd71c>] ? do_brk+0x20e/0x261
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422582]  [<ffffffff8110d82d>] ? sys_ioctl+0x4b/0x72
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422612]  [<ffffffff813657f9>] ? system_call_fastpath+0x16/0x1b
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422645] Code: 24 48 c7
44 24 20 01 00 00 00 4c 89 7c 24 18 4c 89 6c 24 10 48 89 44 24 08 e8 fd f2 ff ff 85 c0 75 38 49 81 fd ff 00 00 00 77 02 <0f> 0b 4c 8b 8c 24
b0 00 00 00 44 8b 84 24 a8 00 00 00 48 89 da 
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422879] RIP  [<ffffffffa0135e9b>] insert_inline_extent_backref+0x6a/0xee [btrfs]
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.422933]  RSP <ffff88009ea33818>
Oct 12 05:46:40 cchiappa-lnx kernel: [1197028.431418] ---[ end trace cd153028752daa11 ]---

There are more stack traces in the log, but the top 5 or so calls all
look alike at a quick glance.  The full kernel log from when I started
the balance on A until I rebooted it with SYSREQ-B is at
http://www.chiappa.net/~chris/kern_btrfscrash_short.log.bz2
I'm not sure why the kernel is saying it's tainted, I don't see
anything in any of my logs indicating it.

Upon reboot, filesystem B (note, NOT the one the balance was running
on) is unmountable, with the kernel logging:

[Fri Oct 12 09:13:31 2012] device label cdc-backups devid 1 transid 5994 /dev/sdc1
[Fri Oct 12 09:13:31 2012] btrfs: use lzo compression
[Fri Oct 12 09:13:31 2012] btrfs: disk space caching is enabled
[Fri Oct 12 09:13:31 2012] btrfs: bdev /dev/sdc1 errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
[Fri Oct 12 09:13:32 2012] btrfs bad tree block start 6220398530238967197 144669868032
[Fri Oct 12 09:13:32 2012] btrfs: bdev /dev/sdc1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[Fri Oct 12 09:13:32 2012] Failed to read block groups: -5
[Fri Oct 12 09:13:32 2012] btrfs: open_ctree failed

I found some references to balance bugs fixed in a later version at
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18141.html
so I was just going to ignore this, but I thought it was worth
noting that btrfsck is unable to repair this filesystem.  It starts
out with many megabytes of:

Check tree block failed, want=144669868032, have=6220398530238967197
Check tree block failed, want=144669868032, have=6220398530238967197
Check tree block failed, want=144669868032, have=6220398530238967197
read block failed check_tree_block
checking extents
Check tree block failed, want=167840686080, have=30401732608
Check tree block failed, want=167840686080, have=30401732608
...

and finishes with:

...
backpointer mismatch on [741746167808 4194304]
owner ref check failed [741746167808 4194304]
ref mismatch on [741750366208 2469888] extent item 1, found 0
Incorrect local backref count on 741750366208 root 5 owner 45228300
offset 29409280 found 0 wanted 1 back 0x3a22b600
backpointer mismatch on [741750366208 2469888]
owner ref check failed [741750366208 2469888]
Errors found in extent allocation tree
checking fs roots
Check tree block failed, want=167889866752, have=30450913280
Check tree block failed, want=167889866752, have=30450913280
Check tree block failed, want=167889866752, have=30450913280
read block failed check_tree_block
btrfsck: btrfsck.c:936: count_csum_range: Assertion !(ret < 0)' failed.

Full log at http://www.chiappa.net/~chris/btrfsck.log.bz2 (produced by
btrfs-progs from git as of this morning).  The
contents of this filesystem are not particularly valuable, so there's
no great loss for me to recreate it, but I thought I would report here
first to see if it was interesting to anyone.

Filesystem A was a conversion from ext4 and I believe B is as well.

# btrfs filesystem show /dev/sdc1
Label: 'cdc-backups'  uuid: f0ffaf11-6f42-486d-a633-638603b7bd65
Total devices 1 FS bytes used 442.90GB
devid    1 size 698.63GB used 698.63GB path /dev/sdc1

Btrfs Btrfs v0.19

-- 

..ooOO chris@chiappa.net              | My opinions are my own  OOoo..
..ooOO chris.chiappa@oracle.com       | and certainly not those OOoo..
..ooOO http://www.chiappa.net/~chris/ | of my employer          OOoo..

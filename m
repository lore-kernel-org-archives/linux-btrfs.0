From: "Mitch Harder (aka DontPanic)" <mmharder@gmail.com>
Subject: Re: [DEBUG PATCH] for anybody who gets a panic due to ENOSPC
Date: Mon, 17 Nov 2008 23:08:51 -0600
Message-ID: <89ed0c690811172108h1685657cl1d1cb1336beb63b4@mail.gmail.com>
References: <4922214A.5090904@cs.drexel.edu>
	 <89ed0c690811172008g555de35fnaf7270dcb7e5afcc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <89ed0c690811172008g555de35fnaf7270dcb7e5afcc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Some Follow-Up:

Just to ease my mind, I ran 7 iterations of a destructive badblocks
test on the partition I've been using without error ('badblocks -sw -t
random -p 7 /dev/sdc2').

On Mon, Nov 17, 2008 at 10:08 PM, Mitch Harder (aka DontPanic)
<mmharder@gmail.com> wrote:
> I've generated another allocation error with the debugging patch installed.
>
> In order to get a better idea of disk usage around the period of the
> allocation errors, I made up a bash script to dump 'df -T
> /var/tmp/portage' every 3 seconds to the terminal (where my btrfs
> drive is mounted at /var/tmp/portage) until 20 polls after dmesg goes
> over 20 lines in length.
>
> For this error, max usage was shown as:
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sdc2    btrfs     3510200    890424   2619776  26% /var/tmp/portage
>
> The dmesg output did show '[ 4171.126131] space_info has 0 free, is
> full', but this did not agree with the 'df -T' output.  Let me know if
> you can think of something else I should be looking at here.
>
> My test partition is ~3.3-3.4 GB (3,510,200 1K blocks).  I am mounting
> btrfs with compression turned on.
>
> The drive is 10 GB total, so I can increase size, but I'm trying to
> select a size to highlight problems.  Let me know if you'd like to
> test some other sizes.
>
> Here's a summary of usage for this drive:
> (1)  Create drive 'mkfs.btrfs'
> (2)  Fill Drive to ~66% by uncompressing the FlightGear source package
> multiple times.
> (3)  Delete all files using 'rm -rf' (I was wondering if there was a
> repeatable problem with this kind of operation, but it worked fine.
> No errors to this point, and the drive indicated near-empty after this
> (~300k still allocated)).
> (4)  Beginning compiling Open Office with Gentoo Portage build manager
> (portage uses /var/tmp/portage as a build directory).
>
> During the OpenOffice build process, the build crashed in conjunction
> with the following dmesg output:
>
> [ 4171.126120] we were searching for 4096 bytes, num_bytes 4096, loop
> 2, allowed_alloc 1
> [ 4171.126129] allocation failed flags 36, wanted 4096
> [ 4171.126131] space_info has 0 free, is full
> [ 4171.126523] block group 29360128 has 179699712 bytes, 167817216
> used 11882496 pinned 0 reserved
> [ 4171.126528] 0 blocks of free space at or bigger than bytes is
> [ 4171.126582] ------------[ cut here ]------------
> [ 4171.126585] kernel BUG at
> /var/tmp/portage/sys-fs/btrfs-9998/work/btrfs-9998/extent-tree.c:3088!
> [ 4171.126587] invalid opcode: 0000 [#1]
> [ 4171.126589] Modules linked in: btrfs snd_pcm_oss snd_mixer_oss
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> ipv6 ppdev pcspkr nvidia(P) snd_intel8x0 snd_ac97_codec ac97_bus
> snd_pcm snd_timer snd snd_page_alloc forcedeth ohci_hcd i2c_nforce2
> ssb pcmcia i2c_core parport_pc parport nvidia_agp sr_mod
> scsi_wait_scan sl811_hcd uhci_hcd ehci_hcd
> [ 4171.126606]
> [ 4171.126610] Pid: 1227, comm: find Tainted: P          (2.6.27-sabayon-r10 #1)
> [ 4171.126613] EIP: 0060:[<f8e2f23e>] EFLAGS: 00210257 CPU: 0
> [ 4171.126650] EIP is at __btrfs_reserve_extent+0x2be/0x430 [btrfs]
> [ 4171.126653] EAX: ed75c940 EBX: f1e1b180 ECX: f4ea28a0 EDX: 00000001
> [ 4171.126656] ESI: ed75c938 EDI: ed75c938 EBP: ed75c940 ESP: e4447c48
> [ 4171.126658]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [ 4171.126661] Process find (pid: 1227, ti=e4446000 task=f4ea28a0
> task.ti=e4446000)
> [ 4171.126663] Stack: f8e6d944 01c00000 00000000 0ab60000 00000000
> 0a00b000 00000000 00b55000
> [ 4171.126668]        00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000024
> [ 4171.126672]        0c75dfff 00000000 ed684e00 f20f9078 ed618000
> 00000005 00000000 ed684e00
> [ 4171.126677] Call Trace:
> [ 4171.126680]  [<f8e2f89f>] btrfs_alloc_extent+0x9f/0x140 [btrfs]
> [ 4171.126700]  [<f8e2fa0e>] btrfs_alloc_free_block+0xce/0x110 [btrfs]
> [ 4171.126718]  [<f8e242e9>] __btrfs_cow_block+0x219/0x870 [btrfs]
> [ 4171.126737]  [<f8e392c2>] verify_parent_transid+0x62/0x1a0 [btrfs]
> [ 4171.126755]  [<f8e24fec>] btrfs_cow_block+0x13c/0x1e0 [btrfs]
> [ 4171.126773]  [<f8e28190>] btrfs_search_slot+0x1c0/0x7f0 [btrfs]
> [ 4171.126791]  [<f8e5690c>] map_private_extent_buffer+0x8c/0x140 [btrfs]
> [ 4171.126814]  [<c0195aa0>] path_walk+0x50/0x90
> [ 4171.126822]  [<f8e38aac>] btrfs_lookup_inode+0x3c/0xc0 [btrfs]
> [ 4171.126841]  [<f8e42906>] btrfs_update_inode+0x46/0xc0 [btrfs]
> [ 4171.126861]  [<f8e43a7f>] btrfs_dirty_inode+0x3f/0x60 [btrfs]
> [ 4171.126881]  [<c01a8c90>] __mark_inode_dirty+0x30/0x160
> [ 4171.126887]  [<c0197f90>] filldir64+0x0/0xe0
> [ 4171.126890]  [<c019f837>] touch_atime+0xc7/0xf0
> [ 4171.126896]  [<c01981f6>] vfs_readdir+0xa6/0xb0
> [ 4171.126898]  [<c019826f>] sys_getdents64+0x6f/0xc0
> [ 4171.126901]  [<c010303d>] sysenter_do_call+0x12/0x21
> [ 4171.126906]  =======================
> [ 4171.126908] Code: 89 44 24 04 e8 f4 e8 2e c7 89 d8 8b 54 24 68 8b
> 4c 24 6c e8 c5 bf 03 00 8b 36 8b 06 0f 18 00 90 39 fe 75 90 89 e8 e8
> 82 29 30 c7 <0f> 0b eb fe 8b 5c 24 48 8b 74 24 50 8b 83 f4 00 00 00 8b
> 50 20
> [ 4171.126927] EIP: [<f8e2f23e>] __btrfs_reserve_extent+0x2be/0x430
> [btrfs] SS:ESP 0068:e4447c48
> [ 4171.126947] ---[ end trace 91e641b298e7b0de ]---
> [ 4171.129768] we were searching for 4096 bytes, num_bytes 4096, loop
> 2, allowed_alloc 1
> [ 4171.129774] allocation failed flags 36, wanted 4096
> [ 4171.129777] space_info has 0 free, is full
> [ 4171.129779] block group 29360128 has 179699712 bytes, 167817216
> used 11882496 pinned 0 reserved
> [ 4171.129782] 0 blocks of free space at or bigger than bytes is
> [ 4171.129817] ------------[ cut here ]------------
> [ 4171.129819] kernel BUG at
> /var/tmp/portage/sys-fs/btrfs-9998/work/btrfs-9998/extent-tree.c:3088!
> [ 4171.129822] invalid opcode: 0000 [#2]
> [ 4171.129824] Modules linked in: btrfs snd_pcm_oss snd_mixer_oss
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> ipv6 ppdev pcspkr nvidia(P) snd_intel8x0 snd_ac97_codec ac97_bus
> snd_pcm snd_timer snd snd_page_alloc forcedeth ohci_hcd i2c_nforce2
> ssb pcmcia i2c_core parport_pc parport nvidia_agp sr_mod
> scsi_wait_scan sl811_hcd uhci_hcd ehci_hcd
> [ 4171.129840]
> [ 4171.129843] Pid: 30919, comm: localize-ooo Tainted: P      D
> (2.6.27-sabayon-r10 #1)
> [ 4171.129846] EIP: 0060:[<f8e2f23e>] EFLAGS: 00210257 CPU: 0
> [ 4171.129874] EIP is at __btrfs_reserve_extent+0x2be/0x430 [btrfs]
> [ 4171.129876] EAX: ed75c940 EBX: f1e1b180 ECX: f4ea2080 EDX: 00000001
> [ 4171.129879] ESI: ed75c938 EDI: ed75c938 EBP: ed75c940 ESP: e93c7b2c
> [ 4171.129881]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [ 4171.129884] Process localize-ooo (pid: 30919, ti=e93c6000
> task=f4ea2080 task.ti=e93c6000)
> [ 4171.129886] Stack: f8e6d944 01c00000 00000000 0ab60000 00000000
> 0a00b000 00000000 00b55000
> [ 4171.129891]        00000000 00000000 00000000 00000000 00000000
> 00000000 00000000 00000024
> [ 4171.129895]        c0133b7e 00000000 ed684e00 f20f9028 ed618000
> 00000005 00000000 ed684e00
> [ 4171.129900] Call Trace:
> [ 4171.129902]  [<c0133b7e>] update_wall_time+0x25e/0x7f0
> [ 4171.129911]  [<f8e2f89f>] btrfs_alloc_extent+0x9f/0x140 [btrfs]
> [ 4171.129930]  [<f8e2fa0e>] btrfs_alloc_free_block+0xce/0x110 [btrfs]
> [ 4171.129949]  [<f8e242e9>] __btrfs_cow_block+0x219/0x870 [btrfs]
> [ 4171.129967]  [<f8e392c2>] verify_parent_transid+0x62/0x1a0 [btrfs]
> [ 4171.129985]  [<f8e24fec>] btrfs_cow_block+0x13c/0x1e0 [btrfs]
> [ 4171.130003]  [<f8e28190>] btrfs_search_slot+0x1c0/0x7f0 [btrfs]
> [ 4171.130010]  [<c0172735>] do_wp_page+0x315/0x4e0
> [ 4171.130010]  [<f8e38aac>] btrfs_lookup_inode+0x3c/0xc0 [btrfs]
> [ 4171.130010]  [<c011a819>] check_preempt_wakeup+0xe9/0x140
> [ 4171.130010]  [<f8e42906>] btrfs_update_inode+0x46/0xc0 [btrfs]
> [ 4171.130010]  [<f8e43a7f>] btrfs_dirty_inode+0x3f/0x60 [btrfs]
> [ 4171.130010]  [<c01a8c90>] __mark_inode_dirty+0x30/0x160
> [ 4171.130010]  [<c019f837>] touch_atime+0xc7/0xf0
> [ 4171.130010]  [<c0165e9f>] generic_file_aio_read+0x56f/0x5f0
> [ 4171.130010]  [<c018c275>] do_sync_read+0xd5/0x120
> [ 4171.130010]  [<c010264a>] do_notify_resume+0x37a/0x750
> [ 4171.130010]  [<c012e610>] autoremove_wake_function+0x0/0x40
> [ 4171.130010]  [<c041c64c>] security_file_permission+0xc/0x10
> [ 4171.130010]  [<c018c31e>] rw_verify_area+0x5e/0xd0
> [ 4171.130010]  [<c018c1a0>] do_sync_read+0x0/0x120
> [ 4171.130010]  [<c018cbad>] vfs_read+0x9d/0x160
> [ 4171.130010]  [<c018cf01>] sys_read+0x41/0x70
> [ 4171.130010]  [<c010303d>] sysenter_do_call+0x12/0x21
> [ 4171.130010]  =======================
> [ 4171.130010] Code: 89 44 24 04 e8 f4 e8 2e c7 89 d8 8b 54 24 68 8b
> 4c 24 6c e8 c5 bf 03 00 8b 36 8b 06 0f 18 00 90 39 fe 75 90 89 e8 e8
> 82 29 30 c7 <0f> 0b eb fe 8b 5c 24 48 8b 74 24 50 8b 83 f4 00 00 00 8b
> 50 20
> [ 4171.130010] EIP: [<f8e2f23e>] __btrfs_reserve_extent+0x2be/0x430
> [btrfs] SS:ESP 0068:e93c7b2c
> [ 4171.130201] ---[ end trace 91e641b298e7b0de ]---
>

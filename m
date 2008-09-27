From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [BUG] kernel BUG at btrfs/extent-tree.c:2462
Date: Sat, 27 Sep 2008 08:21:31 -0400
Message-ID: <20080927122131.GB23335@unused.rdu.redhat.com>
References: <1327be9e0809262246o131e20c2vd6a93607e8349084@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Diego Rosario Brogna <dierbro@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1327be9e0809262246o131e20c2vd6a93607e8349084@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 27, 2008 at 07:46:22AM +0200, Diego Rosario Brogna wrote:
> hi
> doing a defragmentation on a full disk ( fs_mark -d test -s 20480 -D
> 64 -t 8 -F ) btrfsctl return with segmentation fault, the filesystem
> becomes unresponsive and dmesg show this kernel BUG:
> 
> [16790.147270] space info full 1
> [39828.979719] space info full 4
> [39828.979725] allocation failed flags 4, wanted 4096
> [39828.979728] space_info has 525475840 free, is full
> [39828.979730] block group 2176843776 has 1073741824 bytes, 532398080
> used 21934080 pinned
> [39828.983715] 42987 blocks of free space at or bigger than bytes is
> [39828.983718] block group 4194304 has 8388608 bytes, 2322432 used 0
> pinned
> [39828.983737] 168 blocks of free space at or bigger than bytes is
> [39828.983782] ------------[ cut here ]------------
> [39828.983786] kernel BUG at
> /usr/src/kernel-development/btrfs-unstable/fs/btrfs/extent-tree.c:2462!
> [39828.983790] invalid opcode: 0000 [1] SMP
> [39828.983794] CPU 0
> [39828.983797] Modules linked in: btrfs libcrc32c af_packet radeon drm
> binfmt_misc rfcomm l2cap bluetooth ppdev ipv6 cpufreq_ondemand
> cpufreq_conservative cpufreq_userspace cpufreq_powersave cpufreq_stats
> freq_table sbs sbshc video output wmi container pci_slot battery
> iptable_filter ip_tables x_tables dm_crypt crypto_blkcipher dm_mod ac
> sbp2 lp snd_via82xxgameport snd_via82xx_modem snd_pcm_oss
> snd_mixer_oss snd_ac97_codec ac97_bus snd_mpu401_uart snd_pcm
> snd_seq_dummy psmouse serio_raw snd_seq_oss snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq snd_timer snd_seq_device k8temp snd
> snd_page_alloc soundcore i2c_viapro i2c_core parport_pc parport shpchp
> pci_hotplug button evdev usbhid hid ext3 jbd mbcache sr_mod cdrom sg
> sd_mod crc_t10dif pata_via pata_acpi ata_generic sata_via uhci_hcd
> ehci_hcd libata usbcore ohci1394 scsi_mod dock ieee1394 sky2 thermal
> processor fan fbcon tileblit font bitblit softcursor uvesafb cn fuse
> [39828.983863] Pid: 12303, comm: btrfsctl Not tainted 2.6.27-4-generic #1
> [39828.983865] RIP: 0010:[<ffffffffa04a971d>]  [<ffffffffa04a971d>]
> __btrfs_reserve_extent+0x30d/0x3b0 [btrfs]
> [39828.983893] RSP: 0000:ffff88000a5cda18  EFLAGS: 00010206
> [39828.983895] RAX: ffff88003d97aec0 RBX: ffff8800175d3480 RCX: 0000000000000000
> [39828.983897] RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffff880032f27e28
> [39828.983899] RBP: ffff88000a5cda88 R08: 0000000000000000 R09: 0000000000000006
> [39828.983902] R10: ffff88000a5cd788 R11: ffff88008a5cd897 R12: ffff8800175d34ac
> [39828.983904] R13: 0000000000001000 R14: ffff880032f27e18 R15: ffff880032f27e28
> [39828.983907] FS:  00007fa4665e7730(0000) GS:ffffffff806ffa80(0000)
> knlGS:00000000f731e920
> [39828.983909] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [39828.983911] CR2: 00007f03759d7000 CR3: 000000003cd74000 CR4: 00000000000006e0
> [39828.983914] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [39828.983916] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [39828.983919] Process btrfsctl (pid: 12303, threadinfo
> ffff88000a5cc000, task ffff88001db10000)
> [39828.983920] Stack:  00000000c1bef000 ffff88000a5cdb38
> 0000000000000000 0000000000000000
> [39828.983928]  ffffe20000000004 00000000c1bef000 0000000000010000
> ffff88000c72e000
> [39828.983932]  ffff880032f27e18 0000000000001000 ffff88000a5cdb38
> ffff880020701400
> [39828.983936] Call Trace:
> [39828.983958]  [<ffffffffa04a9826>] btrfs_alloc_extent+0x66/0xd0 [btrfs]
> [39828.983974]  [<ffffffffa04a98fa>] btrfs_alloc_free_block+0x6a/0xa0 [btrfs]
> [39828.983990]  [<ffffffffa04cfd9a>] ?
> read_extent_buffer_pages+0x35a/0x400 [btrfs]
> [39828.984005]  [<ffffffffa049e553>] __btrfs_cow_block+0x4d3/0x6c0 [btrfs]
> [39828.984007]  [<ffffffffa04b21c4>] ?
> btree_read_extent_buffer_pages+0x74/0xd0 [btrfs]
> [39828.984007]  [<ffffffffa04a028d>] btrfs_realloc_node+0x40d/0x660 [btrfs]
> [39828.984007]  [<ffffffffa04cc6c9>] ? read_extent_buffer+0xd9/0x190 [btrfs]
> [39828.984007]  [<ffffffffa04bf2ed>] btrfs_defrag_leaves+0x2fd/0x3c0 [btrfs]
> [39828.984007]  [<ffffffff8051b236>] ? _spin_lock_irq+0x16/0x20
> [39828.984007]  [<ffffffffa04ca47b>] ? count_range_bits+0xfb/0x170 [btrfs]
> [39828.984007]  [<ffffffffa04b4bdf>] btrfs_defrag_root+0x7f/0x100 [btrfs]
> [39828.984007]  [<ffffffffa04d5fba>] btrfs_ioctl+0x2fa/0x450 [btrfs]
> [39828.984007]  [<ffffffff802c7d05>] ? vma_link+0x85/0x140
> [39828.984007]  [<ffffffff802f9e76>] vfs_ioctl+0x36/0xb0
> [39828.984007]  [<ffffffff802fa173>] do_vfs_ioctl+0x283/0x2f0
> [39828.984007]  [<ffffffff802fa281>] sys_ioctl+0xa1/0xb0
> [39828.984007]  [<ffffffff8021288a>] system_call_fastpath+0x16/0x1b
> [39828.984007]
> [39828.984007]
> [39828.984007] Code: e0 4c 89 ff e8 35 1c 07 e0 4d 8b 74 24 38 49 83
> c4 38 4c 89 65 d0 4c 3b 75 d0 49 8b 06 0f 18 08 75 60 4c 89 ff e8 c4
> 3d d8 df 90 <0f> 0b eb fe 0f 1f 80 00 00 00 00 48 8b 98 20 1a 00 00 48
> 23 98
> [39828.984007] RIP  [<ffffffffa04a971d>]
> __btrfs_reserve_extent+0x30d/0x3b0 [btrfs]
> [39828.984007]  RSP <ffff88000a5cda18>
> [39828.984215] ---[ end trace 9ded69dedbc7fc63 ]---

Arrgh I thought I had gotten this to go away.  I'll run your command and see if
I can reproduce, this thing has been bugging me for a few weeks now.  Thanks,

Josef

From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Sat, 17 Sep 2011 20:13:34 +0100
Message-ID: <20110917191334.GB10108@yahoo.fr>
References: <201106061220.05696.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Marek Otahal <markotahal@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106061220.05696.markotahal@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-06-06 12:19:56 +0200, Marek Otahal:
> Hello, 
> the issue happens every time when i have to hard power-off my notebook (suspend problems). 
> With kernel 2.6.39 the partition is unmountable, solution is to boot 2.6.38 kernel which 
> 1/ is able to mount the partition, 
> 2/ by doing that fixes the problem so later .39 (after clean shutdown) can mount it also. 
[...]

I've just been hit by this (3.0). I dug up a 2.6.38 kernel and got
it back running just the same. Has any progress made on this?

[39564.802905] device fsid 01b919f7-32cd-4d09-be1c-1810249001b2 devid 1 transid 21097 /dev/mapper/VG_USB_debian-root
[39565.555655] ------------[ cut here ]------------
[39565.555662] kernel BUG at /build/buildd-linux-2.6_3.0.0-3-amd64-9ClimQ/linux-2.6-3.0.0/debian/build/source_amd64_none/fs/btrfs/inode.c:4586!
[39565.555668] invalid opcode: 0000 [#1] SMP
[39565.555672] CPU 1
[39565.555674] Modules linked in: ext2 hfsplus nls_utf8 nls_cp437 vfat fat ip6table_filter ip6_tables ebtable_nat ebtables vboxnetadp(O) vboxnetflt(O) ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT vboxdrv(O) xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp parport_pc ppdev lp parport rfcomm bnep bluetooth rfkill xt_multiport iptable_filter ip_tables x_tables snd_hrtimer acpi_cpufreq mperf cpufreq_conservative cpufreq_powersave cpufreq_userspace cpufreq_stats binfmt_misc fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext3 jbd loop dm_crypt kvm_intel kvm uvcvideo videodev media v4l2_compat_ioctl32 nvidia(P) snd_hda_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq snd_timer snd_seq_device evdev i7core_edac snd i2c_i80
 1 edac_core pcspkr soundcore i2c_core asus_atk0110 snd_page_alloc button processor thermal_sys ext4 mbcache jbd2 crc16 btrfs zlib_deflate crc32c libcrc32c dm_mod raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear md_mod nbd sg sd_mod sr_mod crc_t10dif cdrom ata_generic usb_storage usbhid hid uas pata_jmicron firewire_ohci firewire_core crc_itu_t ahci libahci ehci_hcd libata scsi_mod r8169 mii usbcore [last unloaded: scsi_wait_scan]
[39565.555806]
[39565.555810] Pid: 18729, comm: mount Tainted: P          IO 3.0.0-1-amd64 #1 System manufacturer System Product Name/P7P55D
[39565.555817] RIP: 0010:[<ffffffffa01fe008>]  [<ffffffffa01fe008>] btrfs_add_link+0x120/0x178 [btrfs]
[39565.555850] RSP: 0018:ffff8801c5273858  EFLAGS: 00010282
[39565.555854] RAX: 00000000ffffffef RBX: ffff8801caf96d90 RCX: ffff8802124d01d8
[39565.555858] RDX: 000000000000000e RSI: ffff8801948da880 RDI: 0000000000000292
[39565.555862] RBP: ffff880162b12800 R08: 0000000000000050 R09: 000000000000000d
[39565.555866] R10: 000000000000000c R11: 0000000000015670 R12: ffff8801caf7d1d8
[39565.555870] R13: 000000000000000b R14: ffff88017b3c0600 R15: ffff8801cecfb540
[39565.555875] FS:  00007f1062f7b7e0(0000) GS:ffff88023fc20000(0000) knlGS:0000000000000000
[39565.555879] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[39565.555883] CR2: 00007f84b7689000 CR3: 000000017b112000 CR4: 00000000000006e0
[39565.555887] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[39565.555891] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[39565.555896] Process mount (pid: 18729, threadinfo ffff8801c5272000, task ffff880236e947f0)
[39565.555899] Stack:
[39565.555901]  0000000000000001 00000000000001c9 ffff880100000000 00000000000592ad
[39565.555908]  00000000000592ad 0000000000000001 ffff880203d96e00 0000000c00000000
[39565.555915]  0000000000001000 ffff8801cec8b7f0 ffff8801c52739e8 ffff8801caf7d1d8
[39565.555922] Call Trace:
[39565.555948]  [<ffffffffa021ddf5>] ? add_inode_ref+0x2f3/0x385 [btrfs]
[39565.555974]  [<ffffffffa0220063>] ? replay_one_buffer+0x181/0x1fb [btrfs]
[39565.556000]  [<ffffffffa0210c4e>] ? alloc_extent_buffer+0x6f/0x295 [btrfs]
[39565.556025]  [<ffffffffa021f7e8>] ? walk_down_log_tree+0x153/0x29c [btrfs]
[39565.556050]  [<ffffffffa021f9b2>] ? walk_log_tree+0x81/0x196 [btrfs]
[39565.556074]  [<ffffffffa01f0b4e>] ? btrfs_read_fs_root_no_radix+0x166/0x1a5 [btrfs]
[39565.556099]  [<ffffffffa0221177>] ? btrfs_recover_log_trees+0x192/0x297 [btrfs]
[39565.556125]  [<ffffffffa021fee2>] ? replay_one_dir_item+0xb3/0xb3 [btrfs]
[39565.556148]  [<ffffffffa01ef722>] ? btree_read_extent_buffer_pages.clone.63+0x6f/0xb2 [btrfs]
[39565.556173]  [<ffffffffa01f2f47>] ? open_ctree+0x10f5/0x140e [btrfs]
[39565.556180]  [<ffffffff811aa488>] ? string.clone.2+0x39/0x9f
[39565.556187]  [<ffffffff810fdc92>] ? sget+0x363/0x381
[39565.556207]  [<ffffffffa01d9743>] ? btrfs_mount+0x228/0x470 [btrfs]
[39565.556213]  [<ffffffff810cdcd6>] ? pcpu_next_pop+0x37/0x45
[39565.556219]  [<ffffffff810cda22>] ? cpumask_next+0x18/0x1d
[39565.556224]  [<ffffffff810ceb4c>] ? pcpu_alloc+0x7b4/0x7cc
[39565.556232]  [<ffffffff810fe52b>] ? mount_fs+0x67/0x150
[39565.556241]  [<ffffffff81111c4c>] ? vfs_kern_mount+0x58/0x97
[39565.556249]  [<ffffffff81111f10>] ? do_kern_mount+0x49/0xd8
[39565.556255]  [<ffffffff81113645>] ? do_mount+0x690/0x6f6
[39565.556262]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[39565.556269]  [<ffffffff813358d7>] ? _cond_resched+0x9/0x20
[39565.556275]  [<ffffffff810caf25>] ? memdup_user+0x36/0x5b
[39565.556280]  [<ffffffff81113939>] ? sys_mount+0x88/0xc3
[39565.556287]  [<ffffffff8133bd12>] ? system_call_fastpath+0x16/0x1b
[39565.556291] Code: 89 f2 48 89 ee 4c 89 ff 48 89 44 24 08 41 8b 04 24 66 c1 e8 0c 83 e0 0f 0f b6 80 70 6c 23 a0 89 04 24 e8 f4 da fe ff 85 c0 74 02 <0f> 0b 45 01 ed 4d 63 ed 4c 03 ab d0 00 00 00 4c 89 ab d0 00 00
[39565.556334] RIP  [<ffffffffa01fe008>] btrfs_add_link+0x120/0x178 [btrfs]
[39565.556360]  RSP <ffff8801c5273858>
[39565.556434] ---[ end trace a7919e7f17c0a727 ]---

-- 
Stephane

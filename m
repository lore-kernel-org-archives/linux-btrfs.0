From: Andy Lutomirski <luto@MIT.EDU>
Subject: Re: kernel BUG at fs/btrfs/inode.c:4676!
Date: Thu, 09 Jun 2011 21:57:01 -0400
Message-ID: <4DF179ED.1080001@mit.edu>
References: <201106061220.05696.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Marek Otahal <markotahal@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201106061220.05696.markotahal@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/06/2011 06:19 AM, Marek Otahal wrote:
> Hello,
> the issue happens every time when i have to hard power-off my notebook (suspend problems).
> With kernel 2.6.39 the partition is unmountable, solution is to boot 2.6.38 kernel which
> 1/ is able to mount the partition,
> 2/ by doing that fixes the problem so later .39 (after clean shutdown) can mount it also.

Same problem here.  Mounting with 2.6.38 says:

[   41.906259] Btrfs loaded
[   41.906747] device fsid e040a9d60da49596-66c0275e348878bf devid 1 
transid 69217 /dev/mapper/vg_midnight_ssd-home
[   41.908767] btrfs: disk space caching is enabled
[   42.232185] btrfs: unlinked 17 orphans
[   42.232189] btrfs: truncated 2 orphans

dmesg in 2.6.39.1 says:

[   14.956469] Btrfs loaded
[   14.963227] device fsid e040a9d60da49596-66c0275e348878bf devid 1 
transid 69217 /dev/mapper/vg_midnight_ssd-home
[   14.963680] btrfs: enabling disk space caching
[   14.963686] btrfs: use lzo compression
[   15.004196] ------------[ cut here ]------------
[   15.004255] kernel BUG at fs/btrfs/inode.c:4676!
[   15.004300] invalid opcode: 0000 [#1] SMP
[   15.004339] last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
[   15.004389] CPU 4
[   15.004408] Modules linked in: btrfs zlib_deflate lzo_compress 
libcrc32c snd_hda_codec_hdmi snd_hda_codec_realtek usb_storage uas vfat 
fat snd_hda_intel snd_hda_codec snd_hwdep snd_seq joydev snd_seq_device 
snd_pcm microcode snd_timer serio_raw iTCO_wdt pcspkr e1000e i2c_i801 
snd iTCO_vendor_support xhci_hcd soundcore snd_page_alloc virtio_net 
virtio virtio_ring kvm_intel kvm ipv6 xts gf128mul firewire_ohci 
firewire_core pata_acpi dm_crypt crc_itu_t ata_generic i915 
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: 
scsi_wait_scan]
[   15.004947]
[   15.004964] Pid: 859, comm: mount Not tainted 2.6.39.1+ #65 
         /DQ67SW
[   15.005031] RIP: 0010:[<ffffffffa03b0584>]  [<ffffffffa03b0584>] 
btrfs_add_link+0x109/0x162 [btrfs]
[   15.005122] RSP: 0018:ffff880230b79858  EFLAGS: 00010282
[   15.005165] RAX: 00000000ffffffef RBX: ffff88022fe41968 RCX: 
0000000000000057
[   15.005223] RDX: 0000000000000056 RSI: 000000000001af90 RDI: 
ffffea0007a79a10
[   15.005299] RBP: ffff880230b798c8 R08: ffffffffa038e301 R09: 
ffff880230b79760
[   15.005367] R10: 0000000000000aa3 R11: 0000000000000008 R12: 
ffff8802300ad800
[   15.005422] R13: ffff88022fe41d60 R14: 0000000000000009 R15: 
ffff880230ba7d50
[   15.005477] FS:  00007ff29d1b6820(0000) GS:ffff88023e300000(0000) 
knlGS:0000000000000000
[   15.005539] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   15.005594] CR2: 00007f2fd5f5d00f CR3: 0000000230ed8000 CR4: 
00000000000406e0
[   15.005656] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   15.005711] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[   15.005766] Process mount (pid: 859, threadinfo ffff880230b78000, 
task ffff88022c803260)
[   15.005827] Stack:
[   15.005846]  ffff880200000001 0000000000009153 ffff880230b79898 
ffff88022fe48080
[   15.005925]  0000000000000000 96ff88022f51a000 010000000000847e 
0000000000000000
[   15.005998]  0000000000001000 ffff88022fe2e120 ffff88022fe41d60 
ffff880230b799e7
[   15.006065] Call Trace:
[   15.006104]  [<ffffffffa03d14cd>] add_inode_ref+0x2bc/0x354 [btrfs]
[   15.006169]  [<ffffffffa03c4a53>] ? read_extent_buffer+0xc3/0xe3 [btrfs]
[   15.006253]  [<ffffffffa03d1e7e>] replay_one_buffer+0x197/0x212 [btrfs]
[   15.006338]  [<ffffffffa03a0f47>] ? 
btree_read_extent_buffer_pages+0xbc/0xbc [btrfs]
[   15.006411]  [<ffffffffa03cfcd8>] walk_up_log_tree+0xe4/0x1aa [btrfs]
[   15.006474]  [<ffffffffa03d1ce7>] ? replay_one_dir_item+0xbd/0xbd [btrfs]
[   15.006538]  [<ffffffffa03d00fd>] walk_log_tree+0x9e/0x19e [btrfs]
[   15.006589]  [<ffffffff8143ec48>] ? _cond_resched+0xe/0x22
[   15.006665]  [<ffffffffa03d306d>] btrfs_recover_log_trees+0x174/0x286 
[btrfs]
[   15.006733]  [<ffffffffa03d1ce7>] ? replay_one_dir_item+0xbd/0xbd [btrfs]
[   15.006798]  [<ffffffffa03a561f>] open_ctree+0xfb7/0x12a4 [btrfs]
[   15.006853]  [<ffffffffa038c7d3>] btrfs_mount+0x225/0x473 [btrfs]
[   15.006923]  [<ffffffff810c087d>] ? __free_pages+0x20/0x29
[   15.006975]  [<ffffffff8110626c>] mount_fs+0x69/0x155
[   15.007018]  [<ffffffff810d2d85>] ? __alloc_percpu+0x10/0x12
[   15.007066]  [<ffffffff8111a00d>] vfs_kern_mount+0x63/0x9d
[   15.007112]  [<ffffffff8111a996>] do_kern_mount+0x4d/0xdf
[   15.007157]  [<ffffffff8111c0a2>] do_mount+0x63c/0x69f
[   15.007198]  [<ffffffff8111c39a>] sys_mount+0x88/0xc2
[   15.007242]  [<ffffffff8144666b>] system_call_fastpath+0x16/0x1b
[   15.007308] Code: fa 4c 89 e6 48 8b 7d a8 48 89 44 24 08 41 8b 45 00 
66 c1 e8 0c 83 e0 0f 0f b6 80 48 5d 3e a0 89 04 24 e8 01 e7 fe ff 85 c0 
74 02 <0f> 0b 45 01 f6 4d 63 f6 4c 03 b3 c8 00 00 00 4c 89 b3 c8 00 00
[   15.007600] RIP  [<ffffffffa03b0584>] btrfs_add_link+0x109/0x162 [btrfs]
[   15.007686]  RSP <ffff880230b79858>
[   15.179663] ---[ end trace 614a0d527d4b2a82 ]---

--Andy

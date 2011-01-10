From: Andy Isaacson <adi@hexapodia.org>
Subject: 2.6.37 BUG at inode.c:1616 (was Re: 2.6.37: Bug on btrfs while
	umount)
Date: Mon, 10 Jan 2011 00:08:15 -0800
Message-ID: <20110110080815.GA7508@hexapodia.org>
References: <AANLkTikb2UhU3XwFWjon=BRiFgcAni54ZN7PVCBZDaVf@mail.gmail.com> <1294363682-sup-7971@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Drunkard Zhang <gongfan193@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294363682-sup-7971@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 06, 2011 at 08:29:12PM -0500, Chris Mason wrote:
> > [50010.838804] ------------[ cut here ]------------
> > [50010.838931] kernel BUG at fs/btrfs/inode.c:1616!
> > [50010.839053] invalid opcode: 0000 [#1] PREEMPT SMP
[snip]
> > [50010.839653] Pid: 1681, comm: btrfs-endio-wri Not tainted 2.6.37 #1
> 
> Could you please pull from the master branch of the btrfs unstable tree.
> We had a late fix that is related to this.

I saw BUG at inode.c:1616 while running 2.6.37-rc6-11882-g55ec86f, I saw
your message and upgraded to Linus tip (0c21e3a) + btrfs-unstable tip
(65e5341), and I just saw it again.  Including both BUG traces below.

The machine is a Core i7 with 12GB, with btrfs spanning three volumes:

Label: btr  uuid: 1271de53-b3d2-4d68-9d48-b19487e1c982
        Total devices 3 FS bytes used 735.97GB
        devid    1 size 18.65GB used 18.64GB path /dev/sda2
        devid    2 size 512.00GB used 511.88GB path /dev/sdb1
        devid    3 size 512.00GB used 225.26GB path /dev/sdc1

The primary writer to the filesystem is rtorrent; normally I have ffmpeg
writing to the filesystem at about 100 kbyte/sec as well, but it wasn't
running in this latest crash.

[ 9275.240027] ------------[ cut here ]------------
[ 9275.249991] kernel BUG at fs/btrfs/inode.c:1616!
[ 9275.259914] invalid opcode: 0000 [#1] SMP 
[ 9275.269794] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4:1.0/host8/target8:0:0/8:0:0:0/block/sdd/stat
[ 9275.280066] CPU 0 
[ 9275.280127] Modules linked in: tun ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc kvm_intel kvm xfs exportfs loop snd_hda_codec_hdmi snd_hda_codec_realtek radeon ttm drm_kms_helper drm snd_hda_intel snd_hda_codec i2c_algo_bit snd_usb_audio uvcvideo snd_hwdep i2c_i801 snd_usbmidi_lib snd_pcm snd_rawmidi snd_timer videodev snd_seq_device snd v4l2_compat_ioctl32 pcspkr i2c_core serio_raw soundcore snd_page_alloc processor tpm_tis tpm tpm_bios evdev shpchp button thermal_sys ext3 jbd mbcache dm_mod btrfs zlib_deflate crc32c libcrc32c usb_storage uas sd_mod crc_t10dif ehci_hcd usbcore ahci libahci libata r8169 scsi_mod mii nls_base [last unloaded: scsi_wait_sca
 n]
[ 9275.358450] 
[ 9275.369821] Pid: 3654, comm: btrfs-endio-wri Not tainted 2.6.37-03739-gccda756 #73 MSI X58 Pro-E (MS-7522)/MS-7522
[ 9275.381570] RIP: 0010:[<ffffffffa0152824>]  [<ffffffffa0152824>] T.1234+0x76/0x201 [btrfs]
[ 9275.393380] RSP: 0018:ffff88025f275c30  EFLAGS: 00010286
[ 9275.405100] RAX: 00000000ffffffe4 RBX: ffff88032b596b40 RCX: ffff88032b596c60
[ 9275.416865] RDX: 0000000000000000 RSI: ffffea000b17b8d0 RDI: 00000000fffffff4
[ 9275.428666] RBP: ffff88025f275cc0 R08: 0000000000000005 R09: ffff88025f2759a0
[ 9275.440522] R10: ffff88025f275970 R11: dead000000100100 R12: ffff880083a7e888
[ 9275.452374] R13: 0000000006e0c000 R14: ffff880331d7c800 R15: ffff8800bb38d880
[ 9275.464146] FS:  0000000000000000(0000) GS:ffff8800bf400000(0000) knlGS:0000000000000000
[ 9275.475923] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 9275.487673] CR2: 00007f3eada57000 CR3: 0000000001603000 CR4: 00000000000026e0
[ 9275.499547] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 9275.511395] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 9275.523192] Process btrfs-endio-wri (pid: 3654, threadinfo ffff88025f274000, task ffff88032554b020)
[ 9275.535168] Stack:
[ 9275.546852]  0000000006e0c000 0000000000001000 000000b8c1376000 0000000000001000
[ 9275.558616]  ffff880331d7c800 0000000000000001 ffff8800bb38d880 ffff880331d7c800
[ 9275.570416]  ffff88025f275cb0 ffffffffa014b53f ffff88025f275ce0 ffff8802e21ad7f0
[ 9275.582149] Call Trace:
[ 9275.593731]  [<ffffffffa014b53f>] ? start_transaction+0x1a9/0x1d8 [btrfs]
[ 9275.605513]  [<ffffffffa0152e1e>] btrfs_finish_ordered_io+0x1e6/0x2c2 [btrfs]
[ 9275.617426]  [<ffffffffa0152f14>] btrfs_writepage_end_io_hook+0x1a/0x1c [btrfs]
[ 9275.629403]  [<ffffffffa0166871>] end_bio_extent_writepage+0xae/0x159 [btrfs]
[ 9275.641463]  [<ffffffff81125947>] bio_endio+0x2d/0x2f
[ 9275.653462]  [<ffffffffa01470a0>] end_workqueue_fn+0x111/0x120 [btrfs]
[ 9275.665484]  [<ffffffffa016ecc2>] worker_loop+0x195/0x4c4 [btrfs]
[ 9275.677451]  [<ffffffffa016eb2d>] ? worker_loop+0x0/0x4c4 [btrfs]
[ 9275.689317]  [<ffffffffa016eb2d>] ? worker_loop+0x0/0x4c4 [btrfs]
[ 9275.701079]  [<ffffffff81061a8b>] kthread+0x82/0x8a
[ 9275.712839]  [<ffffffff8100aaa4>] kernel_thread_helper+0x4/0x10
[ 9275.724455]  [<ffffffff81061a09>] ? kthread+0x0/0x8a
[ 9275.735873]  [<ffffffff8100aaa0>] ? kernel_thread_helper+0x0/0x10
[ 9275.747329] Code: 0f 0b eb fe 80 88 88 00 00 00 08 45 31 c9 48 8b 4d 88 4c 8d 45 c0 4c 01 e9 4c 89 ea 4c 89 e6 4c 89 ff e8 7c 4c 00 00 85 c0 74 04 <0f> 0b eb fe 49 8b 84 24 a8 00 00 00 4c 89 6d a9 48 89 45 a0 c6 
[ 9275.771177] RIP  [<ffffffffa0152824>] T.1234+0x76/0x201 [btrfs]
[ 9275.782973]  RSP <ffff88025f275c30>
[ 9276.049117] ---[ end trace 39a68c45b2f4ff68 ]---

The previous BUG also happened at runtime (not umount or anything), with
rtorrent running and ffmpeg writing a video stream from /dev/video0 to
btrfs.

[1719001.040399] ------------[ cut here ]------------
[1719001.041581] kernel BUG at fs/btrfs/inode.c:1616!
[1719001.042826] invalid opcode: 0000 [#1] SMP
[1719001.044174] last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4/1-4:1.0/host8/target8:0:0/8:0:0:0/block/sdd/stat
[1719001.046024] CPU 4
[1719001.046090] Modules linked in: ntfs vfat msdos fat jfs ext4 jbd2 crc16 oprofile xfs exportfs tun ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat nf_conntr
ack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc kvm_intel kvm loop snd_hda_codec_hdmi snd_hda_codec_realtek radeon ttm snd_hda_intel snd_hda_codec drm_kms_helper snd_usb_audio drm uvcvideo snd_hwdep snd_usbmidi_lib i2c_algo_bit snd_rawmidi snd_seq_device videodev snd_pcm v4l1_compat psmouse v4l2_compat_ioctl32 i2c_i801 evdev pcspkr snd_timer snd snd_page_alloc button processor tpm_tis i2c_core tpm soundcore tpm_bios serio_raw shpchp thermal_sys ext3 jbd mbcache dm_mod btrfs zlib_deflate crc32c libcrc32c usb_storage sd_mod uas crc_t10dif ehci_hcd usbcore ahci r8169 libahci libata mii scsi_mod nls_base [last unloaded: scsi_wait_scan] 
[1719001.071852] 
[1719001.076138] Pid: 876, comm: btrfs-endio-wri Tainted: G        W   2.6.37-rc6-11882-g55ec86f #72 MSI X58 Pro-E (MS-7522)/MS-7522
[1719001.085812] RIP: 0010:[<ffffffffa0165732>]  [<ffffffffa0165732>] T.1226+0x76/0x1fb [btrfs]
[1719001.091295] RSP: 0018:ffff880331519c30  EFLAGS: 00010286
[1719001.096685] RAX: 00000000ffffffe4 RBX: ffff880330d515a0 RCX: ffff880330d51900
[1719001.102302] RDX: 0000000000000000 RSI: ffffea000b2ae9b8 RDI: 00000000fffffff4
[1719001.107998] RBP: ffff880331519cc0 R08: 0000000000000005 R09: ffff8803315199a0
[1719001.113840] R10: ffff880331519970 R11: ffff88033238a260 R12: ffff880235800198
[1719001.119831] R13: 00000000155b2000 R14: ffff88032eff8800 R15: ffff88032db3d4c0
[1719001.125962] FS:  0000000000000000(0000) GS:ffff8800bf480000(0000) knlGS:0000000000000000
[1719001.132257] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1719001.138724] CR2: 00007f0131dad000 CR3: 0000000001603000 CR4: 00000000000026e0
[1719001.145347] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[1719001.152023] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[1719001.158700] Process btrfs-endio-wri (pid: 876, threadinfo ffff880331518000, task ffff88033238a260)
[1719001.165664] Stack:
[1719001.172662]  00000000155b2000 0000000000001000 000000b8ceedb000 0000000000001000
[1719001.179992]  ffff88032eff8800 0000000000000001 ffff88032db3d4c0 ffff88032eff8800
[1719001.187426]  ffff880331519cb0 ffffffffa015e543 ffff880331519ce0 ffff88025d033ff0
[1719001.187430] Call Trace:
[1719001.187492]  [<ffffffffa015e543>] ? start_transaction+0x1a9/0x1d8 [btrfs]
[1719001.187537]  [<ffffffffa0165d26>] btrfs_finish_ordered_io+0x1e6/0x2c2 [btrfs]
[1719001.187570]  [<ffffffffa0165e1c>] btrfs_writepage_end_io_hook+0x1a/0x1c [btrfs]
[1719001.187605]  [<ffffffffa017970b>] end_bio_extent_writepage+0xae/0x159 [btrfs]
[1719001.187636]  [<ffffffff811246cf>] bio_endio+0x2d/0x2f
[1719001.187667]  [<ffffffffa015a09d>] end_workqueue_fn+0x111/0x120 [btrfs]
[1719001.187701]  [<ffffffffa0181b4a>] worker_loop+0x195/0x4c4 [btrfs]
[1719001.187760]  [<ffffffffa01819b5>] ? worker_loop+0x0/0x4c4 [btrfs]
[1719001.187812]  [<ffffffffa01819b5>] ? worker_loop+0x0/0x4c4 [btrfs] 
[1719001.187839]  [<ffffffff8106207a>] kthread+0x82/0x8a
[1719001.187851]  [<ffffffff8100aa64>] kernel_thread_helper+0x4/0x10
[1719001.187862]  [<ffffffff81061ff8>] ? kthread+0x0/0x8a
[1719001.187869]  [<ffffffff8100aa60>] ? kernel_thread_helper+0x0/0x10
[1719001.187873] Code: 0f 0b eb fe 80 88 88 00 00 00 08 45 31 c9 48 8b 4d 88 4c 8d 45 c0 4c 01 e9 4c 89 ea 4c 89 e6 4c 89 ff e8 0e 4c 00 00 85 c0 74 04 <0f> 0b eb fe 49 8b 44 24 50 4c 89 6d a9 48 89 45 a0 c6 45 a8 6c  
[1719001.187893] RIP  [<ffffffffa0165732>] T.1226+0x76/0x1fb [btrfs]
[1719001.187924]  RSP <ffff880331519c30>
[1719001.250922] uvcvideo: Failed to resubmit video URB (-27).
[1719001.250926] uvcvideo: Failed to resubmit video URB (-27).
[1719001.250929] uvcvideo: Failed to resubmit video URB (-27).
[1719001.250932] uvcvideo: Failed to resubmit video URB (-27).
[1719001.250935] uvcvideo: Failed to resubmit video URB (-27).
[1719001.621253] ---[ end trace d2fa9249fb1bd731 ]---

Happy to provide any further info and run test patches.

Thanks,
-andy

From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: Errors in rebalancing RAID1 array after disk failure.
Date: Mon, 30 Apr 2012 15:01:04 +0200
Message-ID: <CADy=jfULQNamqJFqE_=KPGvdU8WqgQ0p1gk2_12Et9wUVmDn=A@mail.gmail.com>
References: <CADy=jfVRz5UuKcFkDXC9hwZnP8Z=E9NuF9p3hE6b0ZC06k7DWg@mail.gmail.com>
 <CADy=jfWC1vJs_TWt-EmvAN2Ybqw8kjN2tFV_vgAb-OKeGMpotg@mail.gmail.com>
 <CADy=jfV9pKJurcormuMK7KW54-DKSvYns-Ow-T_FEELGmFQ18Q@mail.gmail.com>
 <20120416134643.GA20982@twin.jikos.cz> <CADy=jfVh8ZvyyJTdBBFTVRSnBHka8sNrVUQcEx_ciROdB=pYhQ@mail.gmail.com>
 <CADy=jfW6rrSwPV6WvKVhcRYd67GMvB57ynSZOjPuDUnnssgZYg@mail.gmail.com> <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "Marco L. Crociani" <marco.crociani@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfV93jMa7DpN_tmQLQ9gOCjqOLgyDxv8=5tCMxr-b-m1QA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
today another episode... I have compiled and tried kernel 3.4-rc5

./btrfs fi sh
Label: 'RootFS'  uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
	Total devices 3 FS bytes used 1006.67GB
	devid    3 size 1.75TB used 357.00GB path /dev/sdb3
	devid    1 size 1.75TB used 1.34TB path /dev/sda3
	*** Some devices missing

Btrfs Btrfs v0.19


./btrfs device delete missing /mnt/sda3
ERROR: error removing the device 'missing' - Input/output error


Apr 30 13:17:51 evo kernel: [  103.074835] device label RootFS devid 1
transid 47082 /dev/sda3
Apr 30 13:17:52 evo kernel: [  103.281796] device label RootFS devid 3
transid 47082 /dev/sdb3
Apr 30 13:17:57 evo kernel: [  108.865001] device label RootFS devid 1
transid 47082 /dev/sda3
Apr 30 13:17:57 evo kernel: [  108.866205] btrfs: allowing degraded mounts
Apr 30 13:17:57 evo kernel: [  108.866214] btrfs: disk space caching is enabled
Apr 30 13:18:32 evo kernel: [  143.274899] btrfs: relocating block
group 1401002393600 flags 17
Apr 30 13:19:25 evo kernel: [  196.888248] btrfs csum failed ino 257
off 910946304 csum 432355644 private 175165154
Apr 30 13:19:25 evo kernel: [  196.889900] btrfs csum failed ino 257
off 910946304 csum 432355644 private 175165154
Apr 30 13:19:25 evo kernel: [  196.890429] btrfs csum failed ino 257
off 910946304 csum 432355644 private 175165154
Apr 30 13:19:25 evo kernel: [  197.087419] btrfs csum failed ino 257
off 910946304 csum 432355644 private 175165154
Apr 30 13:19:25 evo kernel: [  197.087681] btrfs csum failed ino 257
off 910946304 csum 432355644 private 175165154

./btrfs inspect-internal inode-resolve -v 257 /mnt/sda3/
ioctl ret=-1, error: No such file or directory




./btrfs scrub status /mnt/sda3/
scrub status for c87975a0-a575-405e-9890-d3f7f25bbd96
	scrub started at Mon Apr 30 13:26:26 2012 and was aborted after 4367 seconds
	total bytes scrubbed: 406.64GB with 2 errors
	error details: csum=2
	corrected errors: 0, uncorrectable errors: 0, unverified errors: 0




Apr 30 14:37:24 evo kernel: [ 4875.275776] btrfs: checksum error at
logical 752871157760 on dev /dev/sda3, sector 873795352, root 259,
inode 1580389, offset 612610048, length 4096, links 1 (path:
.ecryptfs/[ .... ]
Apr 30 14:37:24 evo kernel: [ 4875.275838] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000090
Apr 30 14:37:24 evo kernel: [ 4875.275848] IP: [<ffffffff811ae841>]
bio_add_page+0x11/0x60
Apr 30 14:37:24 evo kernel: [ 4875.275862] PGD 0
Apr 30 14:37:24 evo kernel: [ 4875.275868] Oops: 0000 [#1] SMP
Apr 30 14:37:24 evo kernel: [ 4875.275875] CPU 2
Apr 30 14:37:24 evo kernel: [ 4875.275878] Modules linked in:
ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables
bridge stp kvm_amd kvm rfcomm bnep dm_crypt parport_pc bluetooth ppdev
snd_hda_codec_realtek snd_hda_codec_hdmi uvcvideo videobuf2_core
snd_hda_intel snd_hda_codec videodev videobuf2_vmalloc snd_usb_audio
videobuf2_memops snd_hwdep snd_pcm snd_usbmidi_lib snd_seq_midi
snd_rawmidi eeepc_wmi asus_wmi snd_seq_midi_event snd_seq snd_timer
snd_seq_device mac_hid sparse_keymap snd binfmt_misc soundcore
snd_page_alloc dm_multipath k10temp i2c_piix4 microcode lp parport
raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov
raid6_pq async_tx raid0 multipath linear btrfs zlib_deflate libcrc32c
raid1 usbhid hid wmi r8169
Apr 30 14:37:24 evo kernel: [ 4875.276004]
Apr 30 14:37:24 evo kernel: [ 4875.276010] Pid: 3401, comm:
btrfs-scrub-1 Not tainted 3.4.0-rc5-mio01 #1 System manufacturer
System Product Name/F1A75-V EVO
Apr 30 14:37:24 evo kernel: [ 4875.276022] RIP:
0010:[<ffffffff811ae841>]  [<ffffffff811ae841>] bio_add_page+0x11/0x60
Apr 30 14:37:24 evo kernel: [ 4875.276033] RSP: 0018:ffff88017135bba0
EFLAGS: 00010246
Apr 30 14:37:24 evo kernel: [ 4875.276038] RAX: 0000000000000000 RBX:
ffff8801710ac000 RCX: 0000000000000000
Apr 30 14:37:24 evo kernel: [ 4875.276044] RDX: 0000000000001000 RSI:
ffffea0004c2b8c0 RDI: ffff88017775b900
Apr 30 14:37:24 evo kernel: [ 4875.276050] RBP: ffff88017135bba0 R08:
ffff8801bed16590 R09: 0000000000000001
Apr 30 14:37:24 evo kernel: [ 4875.276056] R10: 00000000710d1001 R11:
0000000000000007 R12: ffff88017775b900
Apr 30 14:37:24 evo kernel: [ 4875.276061] R13: ffff8801710ac000 R14:
0000000000000000 R15: ffff88017135bbf8
Apr 30 14:37:24 evo kernel: [ 4875.276068] FS:  00007f33e7e239c0(0000)
GS:ffff8801bed00000(0000) knlGS:00000000f66a2b70
Apr 30 14:37:24 evo kernel: [ 4875.276074] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Apr 30 14:37:24 evo kernel: [ 4875.276080] CR2: 0000000000000090 CR3:
000000017b6e4000 CR4: 00000000000007e0
Apr 30 14:37:24 evo kernel: [ 4875.276086] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 30 14:37:24 evo kernel: [ 4875.276092] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 30 14:37:24 evo kernel: [ 4875.276098] Process btrfs-scrub-1 (pid:
3401, threadinfo ffff88017135a000, task ffff88016de916e0)
Apr 30 14:37:24 evo kernel: [ 4875.276103] Stack:
Apr 30 14:37:24 evo kernel: [ 4875.276107]  ffff88017135bc60
ffffffffa00dbc4a ffff8801beffcd00 0000000000006090
Apr 30 14:37:24 evo kernel: [ 4875.276118]  000000010f953000
ffff8801b1084000 ffff88017825a83c 000000000004e96c
Apr 30 14:37:24 evo kernel: [ 4875.276129]  0000000034150f18
000000af00000000 ffff880100000000 ffff88017135bbf8
Apr 30 14:37:24 evo kernel: [ 4875.276138] Call Trace:
Apr 30 14:37:24 evo kernel: [ 4875.276193]  [<ffffffffa00dbc4a>]
scrub_recheck_block+0xea/0x410 [btrfs]
Apr 30 14:37:24 evo kernel: [ 4875.276238]  [<ffffffffa00de24f>]
scrub_handle_errored_block+0x33f/0x990 [btrfs]
Apr 30 14:37:24 evo kernel: [ 4875.276279]  [<ffffffffa00defa9>]
scrub_bio_end_io_worker+0x709/0x770 [btrfs]
Apr 30 14:37:24 evo kernel: [ 4875.276291]  [<ffffffff8105f360>] ?
usleep_range+0x50/0x50
Apr 30 14:37:24 evo kernel: [ 4875.276332]  [<ffffffffa00bc30f>]
worker_loop+0x16f/0x5d0 [btrfs]
Apr 30 14:37:24 evo kernel: [ 4875.276374]  [<ffffffffa00bc1a0>] ?
btrfs_queue_worker+0x310/0x310 [btrfs]
Apr 30 14:37:24 evo kernel: [ 4875.276383]  [<ffffffff81072d83>]
kthread+0x93/0xa0
Apr 30 14:37:24 evo kernel: [ 4875.276393]  [<ffffffff81661fa4>]
kernel_thread_helper+0x4/0x10
Apr 30 14:37:24 evo kernel: [ 4875.276401]  [<ffffffff81072cf0>] ?
kthread_freezable_should_stop+0x70/0x70
Apr 30 14:37:24 evo kernel: [ 4875.276410]  [<ffffffff81661fa0>] ?
gs_change+0x13/0x13
Apr 30 14:37:24 evo kernel: [ 4875.276414] Code: e8 f5 65 20 00 84 c0
0f b7 43 28 0f 85 47 ff ff ff e9 d8 fe ff ff 0f 1f 40 00 55 48 89 e5
66 66 66 66 90 48 8b 47 10 f6 47 18 10 <48> 8b 80 90 00 00 00 4c 8b 88
50 03 00 00 41 8b 81 0c 05 00 00
Apr 30 14:37:24 evo kernel: [ 4875.276492] RIP  [<ffffffff811ae841>]
bio_add_page+0x11/0x60
Apr 30 14:37:24 evo kernel: [ 4875.276500]  RSP <ffff88017135bba0>
Apr 30 14:37:24 evo kernel: [ 4875.276504] CR2: 0000000000000090
Apr 30 14:37:24 evo kernel: [ 4875.276510] ---[ end trace 3ddfc561d71fac95 ]---
Apr 30 14:37:30 evo kernel: [ 4881.497569] btrfs: checksum error at
logical 753578258432 on dev /dev/sda3, sector 875176408, root 259,
inode 1580396, offset 586055680, length 4096, links 1 (path:
.ecryptfs/[ ... ]
Apr 30 14:37:30 evo kernel: [ 4881.497636] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000090
Apr 30 14:37:30 evo kernel: [ 4881.497645] IP: [<ffffffff811ae841>]
bio_add_page+0x11/0x60
Apr 30 14:37:30 evo kernel: [ 4881.497660] PGD 17b6d8067 PUD 171101067 PMD 0
Apr 30 14:37:30 evo kernel: [ 4881.497670] Oops: 0000 [#2] SMP
Apr 30 14:37:30 evo kernel: [ 4881.497677] CPU 2
Apr 30 14:37:30 evo kernel: [ 4881.497680] Modules linked in:
ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables
bridge stp kvm_amd kvm rfcomm bnep dm_crypt parport_pc bluetooth ppdev
snd_hda_codec_realtek snd_hda_codec_hdmi uvcvideo videobuf2_core
snd_hda_intel snd_hda_codec videodev videobuf2_vmalloc snd_usb_audio
videobuf2_memops snd_hwdep snd_pcm snd_usbmidi_lib snd_seq_midi
snd_rawmidi eeepc_wmi asus_wmi snd_seq_midi_event snd_seq snd_timer
snd_seq_device mac_hid sparse_keymap snd binfmt_misc soundcore
snd_page_alloc dm_multipath k10temp i2c_piix4 microcode lp parport
raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov
raid6_pq async_tx raid0 multipath linear btrfs zlib_deflate libcrc32c
raid1 usbhid hid wmi r8169
Apr 30 14:37:30 evo kernel: [ 4881.497806]
Apr 30 14:37:30 evo kernel: [ 4881.497813] Pid: 3412, comm:
btrfs-scrub-2 Tainted: G      D      3.4.0-rc5-mio01 #1 System
manufacturer System Product Name/F1A75-V EVO
Apr 30 14:37:30 evo kernel: [ 4881.497826] RIP:
0010:[<ffffffff811ae841>]  [<ffffffff811ae841>] bio_add_page+0x11/0x60
Apr 30 14:37:30 evo kernel: [ 4881.497837] RSP: 0018:ffff8801776adba0
EFLAGS: 00010246
Apr 30 14:37:30 evo kernel: [ 4881.497842] RAX: 0000000000000000 RBX:
ffff8801710ae000 RCX: 0000000000000000
Apr 30 14:37:30 evo kernel: [ 4881.497848] RDX: 0000000000001000 RSI:
ffffea0004c4be40 RDI: ffff88017775bc00
Apr 30 14:37:30 evo kernel: [ 4881.497854] RBP: ffff8801776adba0 R08:
ffff8801bed16590 R09: 0000000000000001
Apr 30 14:37:30 evo kernel: [ 4881.497859] R10: ffffffffa00db723 R11:
0000000000000000 R12: ffff88017775bc00
Apr 30 14:37:30 evo kernel: [ 4881.497865] R13: ffff8801710ae000 R14:
0000000000000000 R15: ffff8801776adbf8
Apr 30 14:37:30 evo kernel: [ 4881.497872] FS:  00007fcf45503700(0000)
GS:ffff8801bed00000(0000) knlGS:00000000f66a2b70
Apr 30 14:37:30 evo kernel: [ 4881.497878] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Apr 30 14:37:30 evo kernel: [ 4881.497884] CR2: 0000000000000090 CR3:
000000018174c000 CR4: 00000000000007e0
Apr 30 14:37:30 evo kernel: [ 4881.497890] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 30 14:37:30 evo kernel: [ 4881.497896] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 30 14:37:30 evo kernel: [ 4881.497902] Process btrfs-scrub-2 (pid:
3412, threadinfo ffff8801776ac000, task ffff88016de92dc0)
Apr 30 14:37:30 evo kernel: [ 4881.497907] Stack:
Apr 30 14:37:30 evo kernel: [ 4881.497911]  ffff8801776adc60
ffffffffa00dbc4a ffff8801beffcd00 0000000000006090
Apr 30 14:37:30 evo kernel: [ 4881.497923]  000000010a000000
ffff8801b1084000 ffff88017132d03c 000000000004e96c
Apr 30 14:37:30 evo kernel: [ 4881.497933]  00000000342a21d8
000000af00000000 ffff880100000000 ffff8801776adbf8
Apr 30 14:37:30 evo kernel: [ 4881.497943] Call Trace:
Apr 30 14:37:30 evo kernel: [ 4881.497998]  [<ffffffffa00dbc4a>]
scrub_recheck_block+0xea/0x410 [btrfs]
Apr 30 14:37:30 evo kernel: [ 4881.498044]  [<ffffffffa00de24f>]
scrub_handle_errored_block+0x33f/0x990 [btrfs]
Apr 30 14:37:30 evo kernel: [ 4881.498085]  [<ffffffffa00defa9>]
scrub_bio_end_io_worker+0x709/0x770 [btrfs]
Apr 30 14:37:30 evo kernel: [ 4881.498128]  [<ffffffffa00bc30f>]
worker_loop+0x16f/0x5d0 [btrfs]
Apr 30 14:37:30 evo kernel: [ 4881.498171]  [<ffffffffa00bc1a0>] ?
btrfs_queue_worker+0x310/0x310 [btrfs]
Apr 30 14:37:30 evo kernel: [ 4881.498180]  [<ffffffff81072d83>]
kthread+0x93/0xa0
Apr 30 14:37:30 evo kernel: [ 4881.498190]  [<ffffffff81661fa4>]
kernel_thread_helper+0x4/0x10
Apr 30 14:37:30 evo kernel: [ 4881.498199]  [<ffffffff81072cf0>] ?
kthread_freezable_should_stop+0x70/0x70
Apr 30 14:37:30 evo kernel: [ 4881.498208]  [<ffffffff81661fa0>] ?
gs_change+0x13/0x13
Apr 30 14:37:30 evo kernel: [ 4881.498212] Code: e8 f5 65 20 00 84 c0
0f b7 43 28 0f 85 47 ff ff ff e9 d8 fe ff ff 0f 1f 40 00 55 48 89 e5
66 66 66 66 90 48 8b 47 10 f6 47 18 10 <48> 8b 80 90 00 00 00 4c 8b 88
50 03 00 00 41 8b 81 0c 05 00 00
Apr 30 14:37:30 evo kernel: [ 4881.498290] RIP  [<ffffffff811ae841>]
bio_add_page+0x11/0x60
Apr 30 14:37:30 evo kernel: [ 4881.498298]  RSP <ffff8801776adba0>
Apr 30 14:37:30 evo kernel: [ 4881.498302] CR2: 0000000000000090
Apr 30 14:37:30 evo kernel: [ 4881.498308] ---[ end trace 3ddfc561d71fac96 ]---



--
Marco Lorenzo Crociani,
marco.crociani@gmail.com

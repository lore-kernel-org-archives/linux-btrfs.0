From: cwillu <cwillu@cwillu.com>
Subject: Re: warning in btrfs_free_block_groups
Date: Wed, 9 Feb 2011 11:55:12 -0600
Message-ID: <AANLkTi=3_G5JwZpiSeCysGqmq2XLna72HkyhDznRM3PC@mail.gmail.com>
References: <20110209173903.GA23239@python.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Neil Schemenauer <nas@arctrix.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110209173903.GA23239@python.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Posted for posterity (pastebins aren't forever)

2.6.36-rc8

Oct 27 05:13:01 klonk kernel: device fsid
a040b1bd002364c8-548ed98bdbee91b4 devid 1 transid 1450 /dev/sdb2
Oct 27 05:13:08 klonk kernel: btrfs allocation failed flags 1, wanted 4096
Oct 27 05:13:08 klonk kernel: space_info has 0 free, is full
Oct 27 05:13:08 klonk kernel: space_info total=439336960000,
used=439336882176, pinned=0, reserved=12288, may_use=49152,
readonly=65536
Oct 27 05:13:08 klonk kernel: block group 12582912 has 8388608 bytes,
8388608 used 0 pinned 0 reserved
Oct 27 05:13:08 klonk kernel: block group has cluster?: no
Oct 27 05:13:08 klonk kernel: 0 blocks of free space at or bigger than bytes is
Oct 27 05:13:08 klonk kernel: block group 1103101952 has 1073741824
bytes, 1073741824 used 0 pinned 0 reserved
Oct 27 05:13:08 klonk kernel: block group has cluster?: no
Oct 27 05:13:08 klonk kernel: 0 blocks of free space at or bigger than bytes is
Oct 27 05:13:08 klonk kernel: block group 2176843776 has 1073741824
bytes, 1073741824 used 0 pinned 0 reserved
Oct 27 05:13:08 klonk kernel: block group has cluster?: no
Oct 27 05:13:08 klonk kernel: 0 blocks of free space at or bigger than bytes is
Oct 27 05:13:08 klonk kernel: block group 3250585600 has 1073741824
bytes, 1073741824 used 0 pinned 0 reserved
Oct 27 05:13:08 klonk kernel: block group has cluster?: no

[... many similar lines removed ...]

Oct 27 05:13:09 klonk kernel: 0 blocks of free space at or bigger than bytes is
Oct 27 05:13:09 klonk kernel: block group 443484733440 has 1073741824
bytes, 1073741824 used 0 pinned 0 reserved
Oct 27 05:13:09 klonk kernel: block group has cluster?: no
Oct 27 05:13:09 klonk kernel: 0 blocks of free space at or bigger than bytes is
Oct 27 05:13:09 klonk kernel: block group 444558475264 has 168165376
bytes, 168165376 used 0 pinned 0 reserved
Oct 27 05:13:09 klonk kernel: block group has cluster?: no
Oct 27 05:13:09 klonk kernel: 0 blocks of free space at or bigger than bytes is
Oct 27 05:13:09 klonk kernel: ------------[ cut here ]------------
Oct 27 05:13:09 klonk kernel: kernel BUG at fs/btrfs/inode.c:815!
Oct 27 05:13:09 klonk kernel: invalid opcode: 0000 [#1] SMP
Oct 27 05:13:09 klonk kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:11.0/host1/target1:0:0/1:0:0:0/model
Oct 27 05:13:09 klonk kernel: CPU 0
Oct 27 05:13:09 klonk kernel: Modules linked in: nls_cp437 vfat fat
nls_iso8859_1 isofs udf crc_itu_t vboxnetadp vboxnetflt vboxdrv
kvm_amd kvm ipv6 fuse f71882fg snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
r8169 i2c_piix4 usblp soundcore snd_page_alloc
Oct 27 05:13:09 klonk kernel:
Oct 27 05:13:09 klonk kernel: Pid: 9164, comm: flush-btrfs-1 Not
tainted 2.6.36-rc8 #46 790XT-G45 (MS-7388)/MS-7388
Oct 27 05:13:09 klonk kernel: RIP: 0010:[<ffffffff81161ba3>]
[<ffffffff81161ba3>] cow_file_range+0x1ab/0x2f4
Oct 27 05:13:09 klonk kernel: RSP: 0018:ffff88005d3fd890  EFLAGS: 00010286
Oct 27 05:13:09 klonk kernel: RAX: 00000000ffffffe4 RBX:
ffff88007f65e800 RCX: 00000000ffffffe4
Oct 27 05:13:09 klonk kernel: RDX: 0000000000000001 RSI:
000000005d3fd7a0 RDI: ffff880135d90f30
Oct 27 05:13:09 klonk kernel: RBP: ffff88005d3fd940 R08:
0000000000000031 R09: 0000ffffffffff0a
Oct 27 05:13:09 klonk kernel: R10: 00000000ffffffff R11:
0000000000000000 R12: 0000000000003000
Oct 27 05:13:09 klonk kernel: R13: ffff880081314cf8 R14:
0000000000001000 R15: 0000000000001000
Oct 27 05:13:09 klonk kernel: FS:  00007f8ebb25c710(0000)
GS:ffff880001a00000(0000) knlGS:0000000000000000
Oct 27 05:13:09 klonk kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct 27 05:13:09 klonk kernel: CR2: 00007f0d8f414000 CR3:
0000000129bdc000 CR4: 00000000000006f0
Oct 27 05:13:09 klonk kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Oct 27 05:13:09 klonk kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Oct 27 05:13:09 klonk kernel: Process flush-btrfs-1 (pid: 9164,
threadinfo ffff88005d3fc000, task ffff880007e2ceb0)
Oct 27 05:13:09 klonk kernel: Stack:
Oct 27 05:13:09 klonk kernel: ffffffffffffffff ffff88005d3fd8f0
0000000000000001 ffff88005d3fd948
Oct 27 05:13:09 klonk kernel: <0> 000000542d416000 ffffea000297fb40
ffff880081314b90 0000000000002fff
Oct 27 05:13:09 klonk kernel: <0> ffff880081314ba0 ffff8800c44e38a0
ffff880081314b98 0000000000009000
Oct 27 05:13:09 klonk kernel: Call Trace:
Oct 27 05:13:09 klonk kernel: [<ffffffff81162372>] run_delalloc_range+0xaf/0x31f
Oct 27 05:13:09 klonk kernel: [<ffffffff81134204>] ?
do_get_write_access+0x3b9/0x400
Oct 27 05:13:09 klonk kernel: [<ffffffff8117a82d>]
__extent_writepage+0x1ba/0x5b3
Oct 27 05:13:09 klonk kernel: [<ffffffff811beff7>] ?
radix_tree_gang_lookup_tag_slot+0x84/0xa9
Oct 27 05:13:09 klonk kernel: [<ffffffff8117aead>] T.847+0x15f/0x2a8
Oct 27 05:13:09 klonk kernel: [<ffffffff8117b0e4>] extent_writepages+0x3e/0x56
Oct 27 05:13:09 klonk kernel: [<ffffffff81163600>] ? btrfs_get_extent+0x0/0x7e9
Oct 27 05:13:09 klonk kernel: [<ffffffff8104ef08>] ? bit_waitqueue+0x14/0x92
Oct 27 05:13:09 klonk kernel: [<ffffffff811634a9>] btrfs_writepages+0x22/0x24
Oct 27 05:13:09 klonk kernel: [<ffffffff81080f85>] do_writepages+0x1c/0x25
Oct 27 05:13:09 klonk kernel: [<ffffffff810be284>]
writeback_single_inode+0x9b/0x1fd
Oct 27 05:13:09 klonk kernel: [<ffffffff810be6b2>]
writeback_sb_inodes+0xae/0x120
Oct 27 05:13:09 klonk kernel: [<ffffffff810bf043>] wb_writeback+0x185/0x219
Oct 27 05:13:09 klonk kernel: [<ffffffff810bf127>] wb_do_writeback+0x50/0x153
Oct 27 05:13:09 klonk kernel: [<ffffffff81043533>] ? lock_timer_base+0x27/0x4d
Oct 27 05:13:09 klonk kernel: [<ffffffff810bf2b3>]
bdi_writeback_thread+0x89/0x14a
Oct 27 05:13:09 klonk kernel: [<ffffffff810bf22a>] ?
bdi_writeback_thread+0x0/0x14a
Oct 27 05:13:09 klonk kernel: [<ffffffff810bf22a>] ?
bdi_writeback_thread+0x0/0x14a
Oct 27 05:13:09 klonk kernel: [<ffffffff8104ec0b>] kthread+0x7d/0x85
Oct 27 05:13:09 klonk kernel: [<ffffffff81003654>] kernel_thread_helper+0x4/0x10
Oct 27 05:13:09 klonk kernel: [<ffffffff8104eb8e>] ? kthread+0x0/0x85
Oct 27 05:13:09 klonk kernel: [<ffffffff81003650>] ?
kernel_thread_helper+0x0/0x10
Oct 27 05:13:09 klonk kernel: Code: 45 b0 48 8b 7d 98 45 31 c0 48 89
de 48 c7 44 24 10 01 00 00 00 48 89 44 24 08 48 c7 04 24 ff ff ff ff
e8 b8 d9 fe ff 85 c0 74 04 <0f> 0b eb fe bf 50 00 00 00 e8 c1 98 00 00
4c 89 60 18 4c 89 60
Oct 27 05:13:09 klonk kernel: RIP  [<ffffffff81161ba3>]
cow_file_range+0x1ab/0x2f4
Oct 27 05:13:09 klonk kernel: RSP <ffff88005d3fd890>
Oct 27 05:13:09 klonk kernel: ---[ end trace a8ea40fe0a3930b5 ]---
Oct 27 10:05:51 klonk kernel: device fsid
a040b1bd002364c8-548ed98bdbee91b4 devid 1 transid 1450 /dev/sdb2

--sm4nu43k4a2Rpi4c--

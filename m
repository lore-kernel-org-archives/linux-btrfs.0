Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:60716 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3BYTVa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 14:21:30 -0500
Received: by mail-oa0-f50.google.com with SMTP id l20so3539990oag.37
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 11:21:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130225191236.GA19641@localhost.localdomain>
References: <CAMfhy91avz+euv1vtomHMv87o-f57paUDAgegEXtn9gQ==W3Fg@mail.gmail.com>
	<20130222165302.GE2062@localhost.localdomain>
	<CAMfhy91KbFSdCyNdQo1a4whWtqg2TbXKLuJdCiRTfj9E3oOePw@mail.gmail.com>
	<20130222174401.GF2062@localhost.localdomain>
	<CAMfhy92G2yGh4HeQGq1VYVZ=pr2VkH+6yT86ZwfnLvxrUY=Wyg@mail.gmail.com>
	<20130222181017.GG2062@localhost.localdomain>
	<CAMfhy924GJHkxTmy2bDZc=TaYD9ivyg6Q8LBN=+9_m6Xo=tnag@mail.gmail.com>
	<CAMfhy90toxsRFFQVB-3kotm4zyoCJDOFknq-AUegaCsia2pazg@mail.gmail.com>
	<20130222194021.GH2062@localhost.localdomain>
	<CAMfhy91HiiJwy8iQKLJzjGj=oqbAqisNxb67JQMRkcpKJTwvug@mail.gmail.com>
	<20130225191236.GA19641@localhost.localdomain>
Date: Mon, 25 Feb 2013 14:21:30 -0500
Message-ID: <CAMfhy930iLRwh07gcPwptoxqXE8mg_HoLtzZgibn4GMnhnVzPw@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:4718 map_private_extent_buffer+0xd4/0xe0
 [btrfs]()
From: Mace Moneta <moneta.mace@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 2:12 PM, Josef Bacik <jbacik@fusionio.com> wrote:

>
> Is there any chance you got the line above [ cut here ]?  (I hate that stupid [
> cut here ], it makes us miss all the usefull info.)  Thanks,
>
> Josef

There was really nothing significant above the 'cut here'.  Here it is
with over an hour of earlier context:

[ 3865.424536] input: 00:1A:7D:E2:31:DF as /devices/virtual/input/input12
[ 4010.607797] Bluetooth: Unexpected continuation frame (len 0)
[ 4010.676798] Bluetooth: Unexpected continuation frame (len 0)
[ 4141.727328] Bluetooth: Unexpected continuation frame (len 0)
[ 4141.765326] Bluetooth: Unexpected continuation frame (len 0)
[ 4141.780317] Bluetooth: Unexpected continuation frame (len 0)
[ 4141.788322] Bluetooth: Unexpected continuation frame (len 0)
[ 6419.421032] usb 1-3: reset high-speed USB device number 4 using ehci-pci
[ 7038.654383] input: 00:1A:7D:E2:31:DF as /devices/virtual/input/input13
[ 7651.682988] Bluetooth: Unexpected continuation frame (len 0)
[ 7651.690988] Bluetooth: Unexpected continuation frame (len 0)
[ 7651.695982] Bluetooth: Unexpected continuation frame (len 0)
[ 7651.707000] Bluetooth: Unexpected continuation frame (len 0)
[ 7651.708997] Bluetooth: Unexpected continuation frame (len 0)
[ 7651.711983] Bluetooth: Unexpected continuation frame (len 0)
[ 7920.156060] Bluetooth: Unexpected continuation frame (len 0)
[ 7920.194065] Bluetooth: Unexpected continuation frame (len 0)
[ 7920.213057] Bluetooth: Unexpected continuation frame (len 0)
[ 7920.218085] Bluetooth: Unexpected continuation frame (len 0)
[ 7936.197021] Bluetooth: Unexpected continuation frame (len 0)
[ 7936.240012] Bluetooth: Unexpected continuation frame (len 0)
[ 7936.245002] Bluetooth: Unexpected continuation frame (len 0)
[ 7936.257008] Bluetooth: Unexpected continuation frame (len 0)
[ 8084.642497] Bluetooth: Unexpected continuation frame (len 0)
[ 8084.707482] Bluetooth: Unexpected continuation frame (len 0)
[ 8791.731844] ------------[ cut here ]------------
[ 8791.731877] WARNING: at fs/btrfs/extent_io.c:4720
map_private_extent_buffer+0xd4/0xe0 [btrfs]()
[ 8791.731879] Hardware name: C2SEA
[ 8791.731881] btrfs bad mapping eb start 536137728 len 4096, wanted 4096 8
[ 8791.731884] Modules linked in: vfat fat usb_storage fuse rfcomm
bnep nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables
w83627ehf hwmon_vid snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep btusb coretemp uvcvideo bluetooth snd_seq videobuf2_vmalloc
videobuf2_memops rfkill snd_seq_device videobuf2_core videodev
iTCO_wdt snd_pcm media i2c_i801 snd_page_alloc iTCO_vendor_support
lpc_ich microcode snd_timer snd r8169 mfd_core mii soundcore vhost_net
tun macvtap macvlan kvm_intel kvm i2c_dev binfmt_misc uinput btrfs
zlib_deflate raid6_pq libcrc32c xor ata_generic pata_acpi i915 video
i2c_algo_bit firewire_ohci drm_kms_helper firewire_core pata_it8213
crc_itu_t drm i2c_core
[ 8791.731931] Pid: 1984, comm: encfs Not tainted
3.8.0-1.BtrfsNext.fc18.x86_64 #1
[ 8791.731933] Call Trace:
[ 8791.731940]  [<ffffffff8105e61f>] warn_slowpath_common+0x7f/0xc0
[ 8791.731943]  [<ffffffff8105e716>] warn_slowpath_fmt+0x46/0x50
[ 8791.731962]  [<ffffffffa01b7144>] map_private_extent_buffer+0xd4/0xe0 [btrfs]
[ 8791.731980]  [<ffffffffa01ad2eb>] btrfs_set_token_64+0x6b/0x100 [btrfs]
[ 8791.732052]  [<ffffffffa01d0601>] log_one_extent.isra.26+0x241/0x730 [btrfs]
[ 8791.732080]  [<ffffffffa01d138a>] btrfs_log_inode+0x89a/0x990 [btrfs]
[ 8791.732085]  [<ffffffff81185700>] ? kmem_cache_alloc+0x10/0x200
[ 8791.732103]  [<ffffffffa01d21ac>] btrfs_log_inode_parent+0x17c/0x430 [btrfs]
[ 8791.732122]  [<ffffffffa01d24a7>] btrfs_log_dentry_safe+0x47/0x70 [btrfs]
[ 8791.732141]  [<ffffffffa01a7bc5>] btrfs_sync_file+0x175/0x290 [btrfs]
[ 8791.732147]  [<ffffffff811cc4ed>] do_fsync+0x5d/0x90
[ 8791.732150]  [<ffffffff811cc760>] sys_fsync+0x10/0x20
[ 8791.732154]  [<ffffffff81658d19>] system_call_fastpath+0x16/0x1b
[ 8791.732157] ---[ end trace 941faf2a391e738a ]---
[ 8791.732174] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[ 8791.732239] IP: [<ffffffffa01b7353>] write_extent_buffer+0xd3/0x150 [btrfs]
[ 8791.732296] PGD 1ec354067 PUD 1f3d5a067 PMD 0
[ 8791.732334] Oops: 0000 [#1] SMP
[ 8791.732361] Modules linked in: vfat fat usb_storage fuse rfcomm
bnep nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables
w83627ehf hwmon_vid snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep btusb coretemp uvcvideo bluetooth snd_seq videobuf2_vmalloc
videobuf2_memops rfkill snd_seq_device videobuf2_core videodev
iTCO_wdt snd_pcm media i2c_i801 snd_page_alloc iTCO_vendor_support
lpc_ich microcode snd_timer snd r8169 mfd_core mii soundcore vhost_net
tun macvtap macvlan kvm_intel kvm i2c_dev binfmt_misc uinput btrfs
zlib_deflate raid6_pq libcrc32c xor ata_generic pata_acpi i915 video
i2c_algo_bit firewire_ohci drm_kms_helper firewire_core pata_it8213
crc_itu_t drm i2c_core
[ 8791.732913] CPU 1
[ 8791.732929] Pid: 1984, comm: encfs Tainted: G        W
3.8.0-1.BtrfsNext.fc18.x86_64 #1 Supermicro C2SEA/C2SEA
[ 8791.732983] RIP: 0010:[<ffffffffa01b7353>]  [<ffffffffa01b7353>]
write_extent_buffer+0xd3/0x150 [btrfs]
[ 8791.733011] RSP: 0018:ffff8801ec389b48  EFLAGS: 00010202
[ 8791.733011] RAX: 0000000000000000 RBX: ffff8801ec389bc0 RCX: 0000000000000008
[ 8791.733011] RDX: 0000000000001008 RSI: ffff8801ec389bc0 RDI: 0000000000001000
[ 8791.733011] RBP: ffff8801ec389b88 R08: 000000000000000a R09: 00000000000003c9
[ 8791.733011] R10: 0000000000000000 R11: 00000000000003c8 R12: 0000000000000008
[ 8791.733011] R13: ffff8800403cac18 R14: 0000000000000000 R15: 0000000000000008
[ 8791.733011] FS:  00007ff4e8a77800(0000) GS:ffff880237c80000(0000)
knlGS:0000000000000000
[ 8791.733011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8791.733011] CR2: 0000000000000000 CR3: 00000001ec1cb000 CR4: 00000000000007e0
[ 8791.733011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8791.733011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8791.733011] Process encfs (pid: 1984, threadinfo ffff8801ec388000,
task ffff8801fcaa9760)
[ 8791.733011] Stack:
[ 8791.733011]  0000000000001000 0000000000001000 ffff8801ec389b88
ffff8801ec389c98
[ 8791.733011]  ffff8800403cac18 0000000000001000 0000000000000025
0000000000000fdb
[ 8791.733011]  ffff8801ec389bf8 ffffffffa01ad370 ffff8801ec389bf8
0000000000000000
[ 8791.733011] Call Trace:
[ 8791.733011]  [<ffffffffa01ad370>] btrfs_set_token_64+0xf0/0x100 [btrfs]
[ 8791.733011]  [<ffffffffa01d0601>] log_one_extent.isra.26+0x241/0x730 [btrfs]
[ 8791.733011]  [<ffffffffa01d138a>] btrfs_log_inode+0x89a/0x990 [btrfs]
[ 8791.733011]  [<ffffffff81185700>] ? kmem_cache_alloc+0x10/0x200
[ 8791.733011]  [<ffffffffa01d21ac>] btrfs_log_inode_parent+0x17c/0x430 [btrfs]
[ 8791.733011]  [<ffffffffa01d24a7>] btrfs_log_dentry_safe+0x47/0x70 [btrfs]
[ 8791.733011]  [<ffffffffa01a7bc5>] btrfs_sync_file+0x175/0x290 [btrfs]
[ 8791.733011]  [<ffffffff811cc4ed>] do_fsync+0x5d/0x90
[ 8791.733011]  [<ffffffff811cc760>] sys_fsync+0x10/0x20
[ 8791.733011]  [<ffffffff81658d19>] system_call_fastpath+0x16/0x1b
[ 8791.733011] Code: e0 0c 48 01 d0 4c 89 c2 4a 8d 3c 30 45 31 f6 e8
54 cd 14 e1 4c 8b 45 c8 4c 01 c3 4d 29 c7 74 38 49 8b 85 50 01 00 00
4a 8b 04 20 <48> 8b 30 83 e6 08 75 95 be b1 12 00 00 48 c7 c7 45 7c 20
a0 48
[ 8791.733011] RIP  [<ffffffffa01b7353>] write_extent_buffer+0xd3/0x150 [btrfs]
[ 8791.733011]  RSP <ffff8801ec389b48>
[ 8791.733011] CR2: 0000000000000000
[ 8791.755502] ---[ end trace 941faf2a391e738b ]---

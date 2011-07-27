From: Franck Martyn <franckmartyn@yahoo.com>
Subject: Re: kernel BUG at fs/btrfs/tree-log.c:1669!
Date: Wed, 27 Jul 2011 20:42:17 +0200
Message-ID: <4E305C09.1020204@yahoo.com>
References: <4E304221.5050004@yahoo.com> <20110727171339.GA23320@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110727171339.GA23320@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 27, 2011 at 06:51:45PM +0200, Franck Martyn wrote:
>> Do to a hard reboot, I was unable to mount my home partition.
>> I've try kernel 3.0, 3.0-git7 with same result
>> Is there any issue to recover my datas?
>     You could try using btrfs-zero-log, which is available from the
> btrfs-progs-unstable git repository. You will need to make it
> explicitly with "make btrfs-zero-log" once you have the sources. (A
> plain "make" won't build it by default).
>
>     Hugo.
>
>> Thanx
>> Franck
>>
>> [  106.683688] ------------[ cut here ]------------
>> [  106.683691] kernel BUG at fs/btrfs/tree-log.c:1669!
>> [  106.683692] invalid opcode: 0000 [#2] PREEMPT SMP
>> [  106.683695] CPU 2
>> [  106.683696] Modules linked in: coretemp nf_conntrack_ipv4
>> nf_defrag_ipv4 xt_state iptable_filter xt_mark xt_conntrack
>> nf_conntrack ip_tables snd_seq_dummy snd_seq_oss snd_seq_midi_event
>> snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tm6000_alsa(C)
>> tm6000_dvb(C) dvb_core tuner_xc2028 xc5000 zl10353 ir_lirc_codec
>> lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
>> ir_rc5_decoder tm6000(C) videobuf_vmalloc videobuf_core
>> ir_nec_decoder rc_core v4l2_common snd_hda_codec_realtek
>> snd_hda_intel(+) snd_hda_codec snd_hwdep snd_pcm snd_timer snd
>> uvcvideo videodev v4l2_compat_ioctl32 snd_page_alloc i2c_i801
>> i7core_edac ath9k ath9k_common ath9k_hw atl1c ath asus_laptop
>> xhci_hcd sparse_keymap [last unloaded: microcode]
>> [  106.683726]
>> [  106.683728] Pid: 2723, comm: mount Tainted: G      D  C
>> 3.0.0-git7 #1 ASUSTeK Computer Inc.         N61Jq/N61Jq
>> [  106.683731] RIP: 0010:[<ffffffff812110c1>]  [<ffffffff812110c1>]
>> replay_one_buffer+0x2e1/0x3a0
>> [  106.683738] RSP: 0018:ffff880122e47968  EFLAGS: 00010282
>> [  106.683739] RAX: 00000000fffffffb RBX: 0000000000000002 RCX:
>> 00000000fffd0c74
>> [  106.683741] RDX: ffffffff8168d140 RSI: ffffffff811da380 RDI:
>> ffff88011349af90
>> [  106.683743] RBP: 0000000000000097 R08: ffffffff811e9160 R09:
>> 0000000000000001
>> [  106.683744] R10: 0000000000000002 R11: 0000000000000000 R12:
>> ffff880122e47b38
>> [  106.683746] R13: ffff88011342cc80 R14: 0000000000000009 R15:
>> ffff880122e47998
>> [  106.683747] FS:  00007f099f8b2740(0000) GS:ffff88013fc80000(0000)
>> knlGS:0000000000000000
>> [  106.683749] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [  106.683751] CR2: 00007fff00c4bf5c CR3: 000000011d309000 CR4:
>> 00000000000006e0
>> [  106.683752] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [  106.683754] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [  106.683756] Process mount (pid: 2723, threadinfo
>> ffff880122e46000, task ffff8801269b4740)
>> [  106.683757] Stack:
>> [  106.683758]  ffff880122e479b8 ffff88011342c980 0000000000000086
>> ffff88013acd9000
>> [  106.683761]  ffff88011340b120 ffff88013acd9400 0000000000000005
>> 000000000000060c
>> [  106.683763]  ffffffff8120ca00 0000000000000000 0000000000000005
>> 000000000000060c
>> [  106.683766] Call Trace:
>> [  106.683769]  [<ffffffff8120ca00>] ? btrfs_ioctl+0xdd0/0xde0
>> [  106.683772]  [<ffffffff8120ffbd>] ? walk_down_log_tree+0x37d/0x530
>> [  106.683774]  [<ffffffff81210273>] ? walk_log_tree+0x103/0x280
>> [  106.683777]  [<ffffffff811b4ff5>] ? btrfs_root_node+0x15/0x20
>> [  106.683780]  [<ffffffff81212fde>] ? btrfs_recover_log_trees+0x23e/0x320
>> [  106.683783]  [<ffffffff81210de0>] ? fixup_inode_link_counts+0x170/0x170
>> [  106.683786]  [<ffffffff811d7560>] ? open_ctree+0x1400/0x17c0
>> [  106.683789]  [<ffffffff811b212a>] ? btrfs_mount+0x3ca/0x500
>> [  106.683792]  [<ffffffff810e40d8>] ? kmem_cache_alloc+0x98/0xb0
>> [  106.683795]  [<ffffffff810ec19a>] ? mount_fs+0x1a/0xd0
>> [  106.683798]  [<ffffffff81104abf>] ? vfs_kern_mount+0x5f/0xd0
>> [  106.683800]  [<ffffffff81103dce>] ? get_fs_type+0x3e/0xd0
>> [  106.683803]  [<ffffffff81105b93>] ? do_kern_mount+0x53/0x120
>> [  106.683805]  [<ffffffff81107610>] ? do_mount+0x460/0x7d0
>> [  106.683808]  [<ffffffff810c1b7f>] ? memdup_user+0x3f/0x80
>> [  106.683810]  [<ffffffff81107d6a>] ? sys_mount+0x9a/0xf0
>> [  106.683814]  [<ffffffff814db23b>] ? system_call_fastpath+0x16/0x1b
>> [  106.683815] Code: 41 89 d9 4d 89 e8 48 8b 4c 24 20 48 8b 54 24 28
>> 48 8b 74 24 18 e8 30 db ff ff 83 f8 fe 0f 84 8e fe ff ff 85 c0 0f 84
>> 86 fe ff ff<0f>  0b 0f 1f 44 00 00 49 8b 7c 24 20 4c 8d 4c 24 50 41
>> 89 d8 4c
>> [  106.683835] RIP  [<ffffffff812110c1>] replay_one_buffer+0x2e1/0x3a0
>> [  106.683838]  RSP<ffff880122e47968>
>> [  106.683840] ---[ end trace 68037d908f130913 ]---
I've try it without succes
Here are the log

btrfsck /dev/sdb1
couldn't open because of unsupported option features (8).
btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
Abandon

btrfs-zero-log /dev/sdb1
couldn't open because of unsupported option features (8).
btrfs-zero-log: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
Abandon

Franck

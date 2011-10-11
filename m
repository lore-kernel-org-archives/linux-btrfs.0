From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: allow us to overcommit our enospc reservations
 TEST THIS PLEASE!!!
Date: Tue, 11 Oct 2011 12:33:48 -0500
Message-ID: <CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
References: <1317072155-26792-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1317072155-26792-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 26, 2011 at 4:22 PM, Josef Bacik <josef@redhat.com> wrote:
>
> go from taking around 45 minutes to 10 seconds on my freshly formatte=
d 3 TiB
> file system. =A0This doesn't seem to break my other enospc tests, but=
 could really
> use some more testing as this is a super scary change. =A0Thanks,
>

I've been testing Josef's git.kernel.org testing tree, and I've
bisected an error down to this commit.

I'm triggering the error using a removedirs benchmark in filebench
with the following profile:
load removedirs
set $dir=3D/mnt/benchmark/filebench
set $ndirs=3D400000
run

Here's the dmesg dump:
[   89.972715] device fsid 48b0ed3c-0b57-44ee-9554-37c707dc03c7 devid
1 transid 7 /dev/sdb6
[   89.975565] btrfs: disk space caching is enabled
[  389.240070] btrfs failed to delete reference to 00000076, inode
2175208 parent 2024324
[  389.240095] btrfs failed to delete reference to 00000077, inode
2215544 parent 2024324
[  389.240485] btrfs failed to delete reference to 00000080, inode
2158464 parent 2024324
[  389.240521] btrfs failed to delete reference to 00000081, inode
2187285 parent 2024324
[  389.240693] btrfs failed to delete reference to 00000085, inode
2349157 parent 2024324
[  389.240802] btrfs failed to delete reference to 00000087, inode
2139156 parent 2024324
[  389.241006] btrfs failed to delete reference to 00000090, inode
2353094 parent 2024324
[  389.241041] btrfs failed to delete reference to 00000091, inode
2355786 parent 2024324
[  389.241085] btrfs failed to delete reference to 00000092, inode
2357463 parent 2024324
[  389.241119] btrfs failed to delete reference to 00000093, inode
2361163 parent 2024324
[  389.241300] btrfs failed to delete reference to 00000095, inode
2366103 parent 2024324
[  389.241637] btrfs failed to delete reference to 00000096, inode
2229779 parent 2024324
[  389.241661] btrfs failed to delete reference to 00000097, inode
2349423 parent 2024324
[  389.241741] btrfs failed to delete reference to 00000099, inode
2240025 parent 2024324
[  389.241870] btrfs failed to delete reference to 00000101, inode
2347096 parent 2024324
[  389.241969] btrfs failed to delete reference to 00000103, inode
2198337 parent 2024324
[  389.242239] btrfs failed to delete reference to 00000104, inode
2206224 parent 2024324
[  389.242332] btrfs failed to delete reference to 00000106, inode
2364824 parent 2024324
[  389.242353] btrfs failed to delete reference to 00000107, inode
2276826 parent 2024324
[  389.242374] btrfs failed to delete reference to 00000108, inode
2368177 parent 2024324
[  389.242552] btrfs failed to delete reference to 00000111, inode
2375233 parent 2024324
[  389.243183] btrfs failed to delete reference to 00000118, inode
2165951 parent 2024324
[  389.243221] btrfs failed to delete reference to 00000119, inode
2387229 parent 2024324
[  389.243351] btrfs failed to delete reference to 00000121, inode
2236403 parent 2024324
[  389.243385] btrfs failed to delete reference to 00000120, inode
2392838 parent 2024324
[  389.243456] btrfs failed to delete reference to 00000123, inode
2396706 parent 2024324
[  389.243478] btrfs failed to delete reference to 00000124, inode
2400988 parent 2024324
[  389.243496] btrfs failed to delete reference to 00000125, inode
2363919 parent 2024324
[  389.243889] btrfs failed to delete reference to 00000128, inode
2136496 parent 2024324
[  389.243951] btrfs failed to delete reference to 00000129, inode
2149209 parent 2024324
[  389.244045] btrfs failed to delete reference to 00000132, inode
2151500 parent 2024324
[  389.244114] btrfs failed to delete reference to 00000133, inode
2180704 parent 2024324
[  389.244179] btrfs failed to delete reference to 00000134, inode
2197300 parent 2024324
[  389.244413] btrfs failed to delete reference to 00000131, inode
2126799 parent 2024324
[  389.244434] btrfs failed to delete reference to 00000137, inode
2208205 parent 2024324
[  389.244470] btrfs failed to delete reference to 00000138, inode
2220635 parent 2024324
[  389.244700] btrfs failed to delete reference to 00000143, inode
2182109 parent 2024324
[  389.244914] btrfs failed to delete reference to 00000144, inode
2342857 parent 2024324
[  389.244935] btrfs failed to delete reference to 00000145, inode
2350382 parent 2024324
[  389.245219] btrfs failed to delete reference to 00000146, inode
2357237 parent 2024324
[  389.245437] btrfs failed to delete reference to 00000149, inode
2193875 parent 2024324
[  389.245476] btrfs failed to delete reference to 00000150, inode
2371468 parent 2024324
[  389.245523] btrfs failed to delete reference to 00000151, inode
2379733 parent 2024324
[  389.245684] btrfs failed to delete reference to 00000153, inode
2245651 parent 2024324
[  389.246028] btrfs failed to delete reference to 00000158, inode
2157477 parent 2024324
[  389.246223] btrfs failed to delete reference to 00000159, inode
2165824 parent 2024324
[  389.246970] ------------[ cut here ]------------
[  389.246972] kernel BUG at fs/btrfs/inode.c:2176!
[  389.246974] invalid opcode: 0000 [#1] SMP
[  389.246976] CPU 1
[  389.246978] Modules linked in: ipv6 snd_seq_midi snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss
lgdt330x cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core rc_hauppauge
tuner_simple tuner_types tda9887 tda8290 ir_lirc_codec tuner lirc_dev
nvidia(P) ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder cx8800 cx8802 cx88_alsa
snd_ens1371 cx88xx gameport rc_core i2c_algo_bit tveeprom v4l2_common
videodev media videobuf_dma_sg v4l2_compat_ioctl32 tpm_tis tpm ppdev
btcx_risc parport_pc parport videobuf_core tpm_bios sr_mod iTCO_wdt
i2c_i801 r8169 pcspkr i2c_core iTCO_vendor_support snd_rawmidi
intel_agp snd_seq_device intel_gtt snd_ac97_codec ac97_bus snd_pcm
snd_timer snd snd_page_alloc iscsi_tcp libiscsi_tcp libiscsi fuse nfs
nfs_acl auth_rpcgss lockd sunrpc sl811_hcd ohci_hcd uhci_hcd ehci_hcd
[  389.247024]
[  389.247026] Pid: 3629, comm: go_filebench Tainted: P
3.1.0-rc9+ #14 Gigabyte Technology Co., Ltd. P35-DS3L/P35-DS3L
[  389.247030] RIP: 0010:[<ffffffff812b5857>]  [<ffffffff812b5857>]
btrfs_orphan_add+0x11b/0x133
[  389.247037] RSP: 0018:ffff880024f47dd8  EFLAGS: 00010286
[  389.247039] RAX: 0000000000000000 RBX: ffff880073f47800 RCX: 0000000=
00162525c
[  389.247041] RDX: 00000000ffffffe4 RSI: ffff880024f47d98 RDI: ffffea0=
001e938c0
[  389.247043] RBP: ffff880024f47e08 R08: ffffffff81295e05 R09: 0000000=
009550000
[  389.247045] R10: 0000000000000001 R11: ffff880024f47d98 R12: ffff880=
07a7e14c8
[  389.247047] R13: ffff8800556a9870 R14: 0000000000000000 R15: 0000000=
000000000
[  389.247049] FS:  00007fffe824f700(0000) GS:ffff88007fd00000(0000)
knlGS:0000000000000000
[  389.247051] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  389.247053] CR2: 00007ffff7ff4000 CR3: 0000000031009000 CR4: 0000000=
0000006e0
[  389.247055] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  389.247057] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  389.247060] Process go_filebench (pid: 3629, threadinfo
ffff880024f46000, task ffff88007bd8a170)
[  389.247061] Stack:
[  389.247063]  0000000000000003 ffff8800556a9870 ffff88007a7e14c8
ffff88006729cd00
[  389.247066]  ffff880073f47800 ffff8800525fa900 ffff880024f47e58
ffffffff812b844a
[  389.247069]  ffff8800751e4c00 ffff8800525fa9a0 ffff880024f47e58
ffff8800525fa900
[  389.247073] Call Trace:
[  389.247076]  [<ffffffff812b844a>] btrfs_rmdir+0xc2/0x124
[  389.247079]  [<ffffffff81104cbd>] vfs_rmdir+0x93/0xeb
[  389.247082]  [<ffffffff81106a63>] do_rmdir+0xdb/0x12f
[  389.247086]  [<ffffffff813335b3>] ? rwsem_wake+0x39/0x42
[  389.247089]  [<ffffffff81337557>] ? call_rwsem_wake+0x17/0x30
[  389.247092]  [<ffffffff810cfc35>] ? remove_vma+0x77/0x7f
[  389.247095]  [<ffffffff81107a8b>] sys_rmdir+0x16/0x18
[  389.247099]  [<ffffffff8162316b>] system_call_fastpath+0x16/0x1b
[  389.247101] Code: 95 78 fe ff ff 48 85 d2 74 0a 41 80 bd 80 fe ff
ff 84 75 04 49 8b 55 40 48 89 de 4c 89 e7 e8 59 19 02 00 89 c2 31 c0
85 d2 74 0b <0f> 0b b8 f4 ff ff ff eb 02 31 c0 41 5a 5b 41 5c 41 5d 41
5e 41
[  389.247124] RIP  [<ffffffff812b5857>] btrfs_orphan_add+0x11b/0x133
[  389.247127]  RSP <ffff880024f47dd8>
[  389.247141] ---[ end trace 5f145d9895a8631c ]---
[  402.382211] ------------[ cut here ]------------
[  402.382214] kernel BUG at fs/btrfs/extent-tree.c:5565!
[  402.382216] invalid opcode: 0000 [#2] SMP
[  402.382219] CPU 0
[  402.382220] Modules linked in: ipv6 snd_seq_midi snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss
lgdt330x cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core rc_hauppauge
tuner_simple tuner_types tda9887 tda8290 ir_lirc_codec tuner lirc_dev
nvidia(P) ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder cx8800 cx8802 cx88_alsa
snd_ens1371 cx88xx gameport rc_core i2c_algo_bit tveeprom v4l2_common
videodev media videobuf_dma_sg v4l2_compat_ioctl32 tpm_tis tpm ppdev
btcx_risc parport_pc parport videobuf_core tpm_bios sr_mod iTCO_wdt
i2c_i801 r8169 pcspkr i2c_core iTCO_vendor_support snd_rawmidi
intel_agp snd_seq_device intel_gtt snd_ac97_codec ac97_bus snd_pcm
snd_timer snd snd_page_alloc iscsi_tcp libiscsi_tcp libiscsi fuse nfs
nfs_acl auth_rpcgss lockd sunrpc sl811_hcd ohci_hcd uhci_hcd ehci_hcd
[  402.382266]
[  402.382269] Pid: 3491, comm: btrfs-transacti Tainted: P      D
3.1.0-rc9+ #14 Gigabyte Technology Co., Ltd. P35-DS3L/P35-DS3L
[  402.382273] RIP: 0010:[<ffffffff812a2c05>]  [<ffffffff812a2c05>]
run_clustered_refs+0x38f/0x6e0
[  402.382281] RSP: 0018:ffff880075a67c50  EFLAGS: 00010286
[  402.382283] RAX: 00000000ffffffe4 RBX: ffff88007603b0c0 RCX: 0000000=
000000000
[  402.382285] RDX: ffff880059f99b18 RSI: 0000000000000282 RDI: 0000000=
000000000
[  402.382287] RBP: ffff880075a67d30 R08: 0000000000000000 R09: 0000000=
000000000
[  402.382289] R10: 0000000000000001 R11: ffff880075a67ce0 R12: ffff880=
07524a480
[  402.382291] R13: ffff8800336b4280 R14: ffff8800751e4800 R15: ffff880=
074e974b0
[  402.382293] FS:  0000000000000000(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[  402.382295] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  402.382297] CR2: 00007ffff7ff5000 CR3: 0000000039ba9000 CR4: 0000000=
0000006f0
[  402.382299] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  402.382301] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  402.382304] Process btrfs-transacti (pid: 3491, threadinfo
ffff880075a66000, task ffff8800760abc30)
[  402.382305] Stack:
[  402.382307]  0000000000000000 0000000000000000 ffff880000000001
0000000000000000
[  402.382310]  ffff88007599c000 ffff880074e97568 000000006d84f440
ffff880075a67d60
[  402.382314]  0000000000000000 ffff8800751e4920 0000000000000cd1
0000000000000005
[  402.382317] Call Trace:
[  402.382322]  [<ffffffff812e2401>] ? btrfs_find_ref_cluster+0x7a/0x12=
d
[  402.382325]  [<ffffffff812a3027>] btrfs_run_delayed_refs+0xd1/0x1c5
[  402.382329]  [<ffffffff812b0668>] btrfs_commit_transaction+0x8a/0x6f=
d
[  402.382332]  [<ffffffff812aff2f>] ? join_transaction.clone.24+0x20/0=
x1f0
[  402.382336]  [<ffffffff810543cf>] ? wake_up_bit+0x2a/0x2a
[  402.382339]  [<ffffffff812ab299>] transaction_kthread+0x172/0x227
[  402.382342]  [<ffffffff812ab127>] ? btrfs_congested_fn+0x86/0x86
[  402.382345]  [<ffffffff812ab127>] ? btrfs_congested_fn+0x86/0x86
[  402.382347]  [<ffffffff81053f12>] kthread+0x82/0x8a
[  402.382351]  [<ffffffff81624294>] kernel_thread_helper+0x4/0x10
[  402.382354]  [<ffffffff81053e90>] ? kthread_worker_fn+0x13a/0x13a
[  402.382356]  [<ffffffff81624290>] ? gs_change+0xb/0xb
[  402.382358] Code: 00 08 41 b9 01 00 00 00 48 8b 72 20 c7 45 cc 33
00 00 00 4c 8d 45 cc 48 8d 4d b0 48 89 c2 48 8b 7d a0 e8 ad 82 ff ff
85 c0 74 02 <0f> 0b 48 8b 55 98 48 8b 45 98 48 8b 12 48 63 70 40 48 89
d7 48
[  402.382381] RIP  [<ffffffff812a2c05>] run_clustered_refs+0x38f/0x6e0
[  402.382384]  RSP <ffff880075a67c50>
[  402.382386] ---[ end trace 5f145d9895a8631d ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

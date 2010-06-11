From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Regression in 2.6.35 RC1 (Ubuntu 2.6.35-1-generic)
Date: Fri, 11 Jun 2010 14:33:47 +0800
Message-ID: <AANLkTimWIqGJYzMDooPCV2pnNpGP-7TjuG40kprWo8_V@mail.gmail.com>
References: <4C11C16B.7030302@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Brad Figg <brad.figg@canonical.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C11C16B.7030302@canonical.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 11, 2010 at 12:54 PM, Brad Figg <brad.figg@canonical.com> w=
rote:
> I'm seeing the following in /var/log/messages. The system is not unde=
r
> any particular load. The system has my /home as a btrfs partition. Th=
e
> system has GDM up and I've logged in via ssh.
>
>
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.563934] CPU 1
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.563937] Modules linked in=
: cryptd
> aes_x86_64 aes_generic rfcomm binfmt_misc sco ppdev bridge stp bnep l=
2cap
> dm_crypt snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep
> snd_pcm thinkpad_acpi snd_seq_midi snd_rawmidi snd_seq_midi_event arc=
4
> snd_seq snd_timer snd_seq_device uvcvideo lp iwlagn videodev parport =
iwlcore
> btusb mac80211 v4l1_compat snd cfg80211 bluetooth joydev soundcore
> v4l2_compat_ioctl32 psmouse tpm_tis tpm serio_raw tpm_bios led_class =
nvram
> snd_page_alloc btrfs zlib_deflate crc32c libcrc32c vga16fb vgastate u=
sbhid
> hid i915 drm_kms_helper drm ahci i2c_algo_bit video e1000e output lib=
ahci
> intel_agp
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564051]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564059] Pid: 936, comm:
> btrfs-endio-wri Tainted: G =A0 =A0 =A0 =A0W =A0 2.6.35-1-generic #1-U=
buntu
> 2777MSU/2777MSU
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564066] RIP:
> 0010:[<ffffffffa015916b>] =A0[<ffffffffa015916b>]
> btrfs_free_tree_block+0x3bb/0x3e0 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564102] RSP: 0018:ffff880=
1282638f0
> =A0EFLAGS: 00010287
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564108] RAX: ffff8801326c=
5b00 RBX:
> ffff88013279e800 RCX: ffff8801326c5300
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564114] RDX: 0000000181ff=
ffff RSI:
> 0000000140000000 RDI: ffff8801304dc070
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564121] RBP: ffff88012826=
3940 R08:
> 0000000000000000 R09: 0000000000000007
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564126] R10: 000000000000=
0001 R11:
> 0000000000000000 R12: ffff880123dba7e0
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564132] R13: ffff8801304d=
c128 R14:
> ffff880123dbd000 R15: ffff8801326c5300
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564139] FS:
> =A00000000000000000(0000) GS:ffff880001e80000(0000) knlGS:00000000000=
00000
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564146] CS: =A00010 DS: 0=
000 ES:
> 0000 CR0: 000000008005003b
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564152] CR2: 00007f1a263e=
4e40 CR3:
> 0000000001a2a000 CR4: 00000000000006e0
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564158] DR0: 000000000000=
0000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564164] DR3: 000000000000=
0000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564171] Process btrfs-end=
io-wri
> (pid: 936, threadinfo ffff880128262000, task ffff880128635b40)
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564179] =A0ffff8801000000=
02
> 0000000000000000 ffff880130b301b8 000000000000b242
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564189] <0> ffff880128263=
940
> ffff88013081c630 ffff880123dba900 ffff88013279e800
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564199] <0> ffff880123dba=
7e0
> ffff880123dbd000 ffff8801282639f0 ffffffffa014992b
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564234] =A0[<ffffffffa014=
992b>]
> __btrfs_cow_block+0x3bb/0x620 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564257] =A0[<ffffffffa014=
9c97>]
> btrfs_cow_block+0x107/0x1f0 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564280] =A0[<ffffffffa015=
086e>]
> btrfs_search_slot+0x37e/0x6b0 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564308] =A0[<ffffffffa016=
104d>]
> btrfs_lookup_csum+0x6d/0x160 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564321] =A0[<ffffffff8114=
0915>] ?
> kmem_cache_alloc+0xe5/0x140
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564347] =A0[<ffffffffa016=
1d29>]
> btrfs_csum_file_blocks+0xd9/0x850 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564380] =A0[<ffffffffa018=
6b9e>] ?
> merge_state+0x7e/0x150 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564411] =A0[<ffffffffa018=
6317>] ?
> free_extent_state+0x37/0x60 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564442] =A0[<ffffffffa016=
b4b9>]
> add_pending_csums+0x49/0x70 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564471] =A0[<ffffffffa016=
d7f3>]
> btrfs_finish_ordered_io+0x1a3/0x2a0 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564482] =A0[<ffffffff8110=
8aed>] ?
> test_clear_page_writeback+0x8d/0x150
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564512] =A0[<ffffffffa016=
d90a>]
> btrfs_writepage_end_io_hook+0x1a/0x20 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564542] =A0[<ffffffffa018=
822b>]
> end_bio_extent_writepage+0x13b/0x180 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564553] =A0[<ffffffff8158=
235d>] ?
> schedule_timeout+0x19d/0x310
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564564] =A0[<ffffffff8106=
e1d0>] ?
> process_timeout+0x0/0x10
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564573] =A0[<ffffffff8117=
da1d>]
> bio_endio+0x1d/0x40
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564601] =A0[<ffffffffa016=
41ec>]
> end_workqueue_fn+0xfc/0x130 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564629] =A0[<ffffffffa019=
42cc>]
> worker_loop+0x15c/0x4c0 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564657] =A0[<ffffffffa019=
4170>] ?
> worker_loop+0x0/0x4c0 [btrfs]
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564668] =A0[<ffffffff8107=
d0b6>]
> kthread+0x96/0xa0
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564677] =A0[<ffffffff8100=
aee4>]
> kernel_thread_helper+0x4/0x10
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564686] =A0[<ffffffff8107=
d020>] ?
> kthread+0x0/0xa0
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564693] =A0[<ffffffff8100=
aee0>] ?
> kernel_thread_helper+0x0/0x10
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564809] =A0RSP <ffff88012=
82638f0>
> Jun 10 21:22:43 bradf-x301 kernel: [ =A0175.564816] ---[ end trace
> 32d3e1002acaefc4 ]---
>
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857602] CPU 1
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857605] Modules linked in=
: cryptd
> aes_x86_64 aes_generic rfcomm binfmt_misc sco ppdev bridge stp bnep l=
2cap
> dm_crypt snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep
> snd_pcm thinkpad_acpi snd_seq_midi snd_rawmidi snd_seq_midi_event arc=
4
> snd_seq snd_timer snd_seq_device uvcvideo lp iwlagn videodev parport =
iwlcore
> btusb mac80211 v4l1_compat snd cfg80211 bluetooth joydev soundcore
> v4l2_compat_ioctl32 psmouse tpm_tis tpm serio_raw tpm_bios led_class =
nvram
> snd_page_alloc btrfs zlib_deflate crc32c libcrc32c vga16fb vgastate u=
sbhid
> hid i915 drm_kms_helper drm ahci i2c_algo_bit video e1000e output lib=
ahci
> intel_agp
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857719]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857726] Pid: 946, comm:
> btrfs-transacti Tainted: G =A0 =A0 =A0D W =A0 2.6.35-1-generic #1-Ubu=
ntu
> 2777MSU/2777MSU
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857733] RIP:
> 0010:[<ffffffffa015916b>] =A0[<ffffffffa015916b>]
> btrfs_free_tree_block+0x3bb/0x3e0 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857767] RSP: 0018:ffff880=
12821b820
> =A0EFLAGS: 00010287
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857772] RAX: ffff8801326c=
5b00 RBX:
> ffff88013279a000 RCX: ffff8801326c5300
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857778] RDX: 0000000181ff=
ffff RSI:
> 0000000140000000 RDI: ffff8801304dc070
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857784] RBP: ffff88012821=
b870 R08:
> 0000000000000000 R09: 0000000000000002
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857790] R10: 000000000000=
0001 R11:
> 0000000000000000 R12: ffff880130ab0510
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857796] R13: ffff8801304d=
c128 R14:
> ffff880123dbd040 R15: ffff8801326c5300
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857803] FS:
> =A00000000000000000(0000) GS:ffff880001e80000(0000) knlGS:00000000000=
00000
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857810] CS: =A00010 DS: 0=
000 ES:
> 0000 CR0: 000000008005003b
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857815] CR2: 0000000001be=
6028 CR3:
> 0000000001a2a000 CR4: 00000000000006e0
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857821] DR0: 000000000000=
0000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857827] DR3: 000000000000=
0000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857834] Process btrfs-tra=
nsacti
> (pid: 946, threadinfo ffff88012821a000, task ffff880128660000)
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857843] =A0ffff8801000000=
02
> 0000000000000000 ffff880130b301b8 000000000000b242
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857852] <0> ffff88012821b=
870
> ffff880130ab0cf0 ffff880130b6a000 ffff88013279a000
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857862] <0> ffff880130ab0=
510
> ffff880123dbd040 ffff88012821b920 ffffffffa014992b
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857898] =A0[<ffffffffa014=
992b>]
> __btrfs_cow_block+0x3bb/0x620 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857920] =A0[<ffffffffa014=
9c97>]
> btrfs_cow_block+0x107/0x1f0 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857943] =A0[<ffffffffa015=
086e>]
> btrfs_search_slot+0x37e/0x6b0 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857969] =A0[<ffffffffa015=
7cfc>]
> lookup_inline_extent_backref+0xbc/0x400 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.857982] =A0[<ffffffff8114=
0915>] ?
> kmem_cache_alloc+0xe5/0x140
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858006] =A0[<ffffffffa015=
83f6>]
> __btrfs_free_extent+0xd6/0x710 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858031] =A0[<ffffffffa015=
8b8a>]
> run_delayed_tree_ref+0x15a/0x160 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858055] =A0[<ffffffffa015=
8d8a>]
> run_one_delayed_ref+0x9a/0xc0 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858080] =A0[<ffffffffa015=
b3a0>]
> run_clustered_refs+0xc0/0x220 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858090] =A0[<ffffffff8104=
ff7a>] ?
> finish_task_switch+0x4a/0xd0
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858115] =A0[<ffffffffa015=
b5ca>]
> btrfs_run_delayed_refs+0xca/0x220 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858127] =A0[<ffffffff8158=
2a9e>] ?
> mutex_lock+0x1e/0x50
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858159] =A0[<ffffffffa018=
5a0e>] ?
> btrfs_run_ordered_operations+0x1ee/0x210 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858189] =A0[<ffffffffa016=
94e0>]
> btrfs_commit_transaction+0x80/0x710 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858198] =A0[<ffffffff8158=
2a9e>] ?
> mutex_lock+0x1e/0x50
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858227] =A0[<ffffffffa016=
9f8b>] ?
> start_transaction+0x1ab/0x230 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858238] =A0[<ffffffff8107=
d610>] ?
> autoremove_wake_function+0x0/0x40
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858265] =A0[<ffffffffa016=
3d53>]
> transaction_kthread+0x283/0x290 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858293] =A0[<ffffffffa016=
3ad0>] ?
> transaction_kthread+0x0/0x290 [btrfs]
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858302] =A0[<ffffffff8107=
d0b6>]
> kthread+0x96/0xa0
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858311] =A0[<ffffffff8100=
aee4>]
> kernel_thread_helper+0x4/0x10
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858320] =A0[<ffffffff8107=
d020>] ?
> kthread+0x0/0xa0
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858327] =A0[<ffffffff8100=
aee0>] ?
> kernel_thread_helper+0x0/0x10
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858441] =A0RSP <ffff88012=
821b820>
> Jun 10 21:23:17 bradf-x301 kernel: [ =A0209.858448] ---[ end trace
> 32d3e1002acaefc5 ]---
>

I have already sent a patch for this.
http://www.spinics.net/lists/linux-btrfs/msg05150.html

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: allow us to overcommit our enospc reservations
 TEST THIS PLEASE!!!
Date: Wed, 12 Oct 2011 15:45:04 -0500
Message-ID: <CAKcLGm_MMzv0rK169pZJyHu4r2=6xXBE0OjxcoLZVzLMkf3evg@mail.gmail.com>
References: <1317072155-26792-1-git-send-email-josef@redhat.com>
	<CAKcLGm_oFQOCCeFs69ohGfskkCj1FSbdxL18653ANoTX75n4SQ@mail.gmail.com>
	<20111011190049.GG2293@localhost.localdomain>
	<CAKcLGm-JU1e4ssv9FQTieX-OmHgbc6hef8Rnsy_R7Jy3RwsznA@mail.gmail.com>
	<20111011200131.GH2293@localhost.localdomain>
	<CAKcLGm-y5on_dWjaNdSARd5_K5nri0G9zuMZAsV19ecuYmXH9g@mail.gmail.com>
	<20111012175047.GA14280@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111012175047.GA14280@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2011 at 12:50 PM, Josef Bacik <josef@redhat.com> wrote:
> On Tue, Oct 11, 2011 at 03:45:45PM -0500, Mitch Harder wrote:
>> On Tue, Oct 11, 2011 at 3:01 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > On Tue, Oct 11, 2011 at 02:44:09PM -0500, Mitch Harder wrote:
>> >> On Tue, Oct 11, 2011 at 2:00 PM, Josef Bacik <josef@redhat.com> w=
rote:
>> >> > On Tue, Oct 11, 2011 at 12:33:48PM -0500, Mitch Harder wrote:
>> >> >> On Mon, Sep 26, 2011 at 4:22 PM, Josef Bacik <josef@redhat.com=
> wrote:
>> >> >> >
>> >> >> > go from taking around 45 minutes to 10 seconds on my freshly=
 formatted 3 TiB
>> >> >> > file system. =A0This doesn't seem to break my other enospc t=
ests, but could really
>> >> >> > use some more testing as this is a super scary change. =A0Th=
anks,
>> >> >> >
>> >> >>
>> >> >> I've been testing Josef's git.kernel.org testing tree, and I'v=
e
>> >> >> bisected an error down to this commit.
>> >> >>
>> >> >> I'm triggering the error using a removedirs benchmark in fileb=
ench
>> >> >> with the following profile:
>> >> >> load removedirs
>> >> >> set $dir=3D/mnt/benchmark/filebench
>> >> >> set $ndirs=3D400000
>> >> >> run
>> >> >>
>> >> >
>> >> > Ok try this one, it will write out more and harder, see if that=
 helps. =A0Thanks,
>> >> >
>> >>
>> >> Still running into BUG at fs/btrfs/inode.c:2176!
>> >
>> > How about this one?
>> >
>>
>> Sorry, still getting the same bug.
>>
>> [ =A0175.956273] kernel BUG at fs/btrfs/inode.c:2176!
>
> Ok I think I see what's happening, this patch replaces the previous o=
ne, let me
> know how it goes. =A0Thanks,
>

Getting a slightly different BUG this time:

[  172.889179] ------------[ cut here ]------------
[  172.889182] kernel BUG at fs/btrfs/inode.c:785!
[  172.889184] invalid opcode: 0000 [#1] SMP
[  172.889186] CPU 1
[  172.889187] Modules linked in: ipv6 snd_seq_midi snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss
lgdt330x cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core rc_hauppauge
tuner_simple tuner_types tda9887 tda8290 tuner ir_lirc_codec lirc_dev
ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder cx8800 cx8802
cx88_alsa cx88xx ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_core
i2c_algo_bit tveeprom v4l2_common videodev snd_ens1371 gameport
videobuf_dma_sg media v4l2_compat_ioctl32 videobuf_core snd_rawmidi
btcx_risc snd_seq_device sr_mod snd_ac97_codec ppdev parport_pc
parport ac97_bus tpm_tis intel_agp snd_pcm tpm i2c_i801 snd_timer
i2c_core intel_gtt tpm_bios snd iTCO_wdt iTCO_vendor_support pcspkr
r8169 snd_page_alloc iscsi_tcp libiscsi_tcp libiscsi fuse nfs nfs_acl
auth_rpcgss lockd sunrpc sl811_hcd ohci_hcd uhci_hcd ehci_hcd
[  172.889232]
[  172.889235] Pid: 1812, comm: btrfs-transacti Not tainted
3.1.0-rc9-josef+ #18 Gigabyte Technology Co., Ltd. P35-DS3L/P35-DS3L
[  172.889239] RIP: 0010:[<ffffffff812b6974>]  [<ffffffff812b6974>]
cow_file_range+0x6a/0x31e
[  172.889245] RSP: 0018:ffff88007aee1570  EFLAGS: 00010246
[  172.889247] RAX: ffff88007af28000 RBX: ffff88007aee7c00 RCX: 0000000=
00000ffff
[  172.889249] RDX: 0000000000000000 RSI: ffffea0001dcc280 RDI: ffff880=
07abb14a0
[  172.889251] RBP: ffff88007aee1620 R08: ffff88007aee18dc R09: ffff880=
07aee18c0
[  172.889253] R10: 0000000000000000 R11: dead000000200200 R12: 0000000=
000000000
[  172.889255] R13: ffff88007abb14a0 R14: 0000000000001000 R15: ffff880=
07abb1310
[  172.889257] FS:  0000000000000000(0000) GS:ffff88007fd00000(0000)
knlGS:0000000000000000
[  172.889259] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  172.889261] CR2: ffffffffff600400 CR3: 000000007acdf000 CR4: 0000000=
0000006e0
[  172.889263] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[  172.889265] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[  172.889268] Process btrfs-transacti (pid: 1812, threadinfo
ffff88007aee0000, task ffff88007bccd040)
[  172.889269] Stack:
[  172.889271]  00000002ad0dbfff ffff88005d239448 0000000000000282
0000000000010000
[  172.889274]  0000000000010000 ffffea0001dcc280 ffff88007abb1330
ffff88007aee18dc
[  172.889277]  ffff88007aee18c0 0000000000000000 ffff880000000001
000000000000ffff
[  172.889280] Call Trace:
[  172.889285]  [<ffffffff812d72ab>] ? btrfs_tree_read_unlock_blocking+=
0x51/0x59
[  172.889288]  [<ffffffff812b71ed>] run_delalloc_nocow+0x5c5/0x654
[  172.889292]  [<ffffffff810e95ee>] ? kmem_cache_free+0x20/0xcf
[  172.889295]  [<ffffffff812b72f1>] run_delalloc_range+0x75/0x34f
[  172.889298]  [<ffffffff812c9926>] __extent_writepage+0x1fb/0x5e6
[  172.889302]  [<ffffffff81332915>] ? radix_tree_gang_lookup_tag_slot+=
0x81/0xa2
[  172.889306]  [<ffffffff810ad650>] ? find_get_pages_tag+0x43/0xfb
[  172.889309]  [<ffffffff812c9e8a>]
extent_write_cache_pages.clone.10.clone.20+0x179/0x2b3
[  172.889312]  [<ffffffff812ca1cc>] extent_writepages+0x47/0x5c
[  172.889315]  [<ffffffff812c7290>] ? free_extent_state+0x48/0x4c
[  172.889318]  [<ffffffff812b45a3>] ? uncompress_inline.clone.36+0x148=
/0x148
[  172.889320]  [<ffffffff812c78ba>] ? clear_extent_bit+0x2b7/0x2f2
[  172.889323]  [<ffffffff812b3fdc>] btrfs_writepages+0x27/0x29
[  172.889326]  [<ffffffff810b6674>] do_writepages+0x21/0x2a
[  172.889328]  [<ffffffff810ae4d8>] __filemap_fdatawrite_range+0x53/0x=
55
[  172.889331]  [<ffffffff810af11d>] filemap_fdatawrite+0x1f/0x21
[  172.889334]  [<ffffffff810af13c>] filemap_write_and_wait+0x1d/0x38
[  172.889337]  [<ffffffff812de0f5>] __btrfs_write_out_cache+0x5a2/0x80=
e
[  172.889340]  [<ffffffff812e2b46>] ? btrfs_find_ref_cluster+0x113/0x1=
2d
[  172.889343]  [<ffffffff812de3f2>] btrfs_write_out_cache+0x91/0xc0
[  172.889346]  [<ffffffff812a361f>] btrfs_write_dirty_block_groups+0x3=
ff/0x473
[  172.889349]  [<ffffffff812af8a6>] commit_cowonly_roots+0xc9/0x191
[  172.889352]  [<ffffffff812b0b5b>] btrfs_commit_transaction+0x3f5/0x6=
f3
[  172.889355]  [<ffffffff812b00b7>] ? join_transaction.clone.24+0x20/0=
x1f0
[  172.889359]  [<ffffffff810543cf>] ? wake_up_bit+0x2a/0x2a
[  172.889362]  [<ffffffff812ab421>] transaction_kthread+0x172/0x227
[  172.889365]  [<ffffffff812ab2af>] ? btrfs_congested_fn+0x86/0x86
[  172.889367]  [<ffffffff812ab2af>] ? btrfs_congested_fn+0x86/0x86
[  172.889370]  [<ffffffff81053f12>] kthread+0x82/0x8a
[  172.889373]  [<ffffffff81624914>] kernel_thread_helper+0x4/0x10
[  172.889376]  [<ffffffff81053e90>] ? kthread_worker_fn+0x13a/0x13a
[  172.889378]  [<ffffffff81624910>] ? gs_change+0xb/0xb
[  172.889379] Code: 20 01 00 00 48 89 4d a8 4c 89 45 88 4c 89 4d 90
44 8b b3 f8 02 00 00 48 3b 58 28 74 0e 48 83 bf 78 fe ff ff f4 0f 85
97 02 00 00 <0f> 0b 0f 0b 45 89 f6 48 8b 83 20 01 00 00 48 8b 55 a0 48
05 38
[  172.889402] RIP  [<ffffffff812b6974>] cow_file_range+0x6a/0x31e
[  172.889405]  RSP <ffff88007aee1570>
[  172.889408] ---[ end trace bd2a7fa17108e565 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

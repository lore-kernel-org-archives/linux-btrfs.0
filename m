From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Warnings and crash
Date: Thu, 3 Nov 2011 19:39:31 -0500
Message-ID: <CAKcLGm9wJTxvNkQG2EydQkoWcdJkrZ77GOy6FisG5ry6eE-rHQ@mail.gmail.com>
References: <20111101024957.GH4468@shiny>
	<20111101125654.GF12759@twin.jikos.cz>
	<20111102230231.GM12759@twin.jikos.cz>
	<20111102234058.GH18900@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111102234058.GH18900@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 2, 2011 at 6:40 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> On Thu, Nov 03, 2011 at 12:02:31AM +0100, David Sterba wrote:
>> This one happened again, exactly same sequence of warnings and the c=
rash
>> at the end (same stack traces). It was in integration-scrub branch, =
ie.
>> with all fixes on top.
>>
>> (I have captured sysrq-w, /proc/pid/stack of all processes and have =
the
>> dmesg logs if anybody is interested.)
>
> Yes, I'd like to see the logs. =A0We need to figure out if we just fa=
iled
> with enospc in a critical spot or if there are other bigger problems.
>

I'm seeing similar warnings while testing the integration-scrub branch.

I'm testing on a 16-GB partition that is less than 20% full when I'm
seeing the warning.

Let me know if you're still working on this issue, and I'll try to
isolate the command that is running.

[ 8631.183234] device fsid aff24946-5596-4c19-a6c4-81809ae6bd94 devid
1 transid 7 /dev/sdb6
[ 8631.183483] btrfs: disk space caching is enabled
[ 8712.675332] btrfs: block rsv returned -28
[ 8712.675334] ------------[ cut here ]------------
[ 8712.675362] WARNING: at fs/btrfs/extent-tree.c:5837
btrfs_alloc_free_block+0x3e9/0x400 [btrfs]()
[ 8712.675364] Hardware name: P35-DS3L
[ 8712.675365] Modules linked in: ipv6 snd_seq_midi snd_seq_dummy
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss
lgdt330x cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core rc_hauppauge
tuner_simple tuner_types tda9887 tda8290 tuner nvidia(P) ir_lirc_codec
lirc_dev ir_mce_kbd_decoder cx88_alsa cx8800 ir_sony_decoder
ir_jvc_decoder ir_rc6_decoder cx8802 cx88xx snd_ens1371 ir_rc5_decoder
ir_nec_decoder gameport snd_rawmidi snd_seq_device rc_core
i2c_algo_bit snd_ac97_codec videobuf_dma_sg tveeprom v4l2_common
videodev media v4l2_compat_ioctl32 videobuf_core btcx_risc iTCO_wdt
iTCO_vendor_support intel_agp intel_gtt ac97_bus snd_pcm snd_timer
i2c_i801 snd i2c_core snd_page_alloc ppdev parport_pc parport tpm_tis
tpm r8169 tpm_bios sr_mod pcspkr iscsi_tcp libiscsi_tcp libiscsi fuse
nfs nfs_acl auth_rpcgss lockd sunrpc btrfs zlib_deflate sl811_hcd
ohci_hcd uhci_hcd ehci_hcd
[ 8712.675409] Pid: 7917, comm: btrfs-transacti Tainted: P
3.1.0-integration-scrub+ #1
[ 8712.675411] Call Trace:
[ 8712.675417]  [<ffffffff81046e8f>] warn_slowpath_common+0x7f/0xc0
[ 8712.675420]  [<ffffffff81046eea>] warn_slowpath_null+0x1a/0x20
[ 8712.675428]  [<ffffffffa004a2e9>] btrfs_alloc_free_block+0x3e9/0x400=
 [btrfs]
[ 8712.675435]  [<ffffffffa003b621>] ? btrfs_leaf_free_space+0x61/0xb0 =
[btrfs]
[ 8712.675442]  [<ffffffffa0039069>] __btrfs_cow_block+0x119/0x560 [btr=
fs]
[ 8712.675451]  [<ffffffffa0054070>] ? btrfs_buffer_uptodate+0x50/0x70 =
[btrfs]
[ 8712.675458]  [<ffffffffa0039669>] btrfs_cow_block+0x1b9/0x2f0 [btrfs=
]
[ 8712.675465]  [<ffffffffa003d640>] btrfs_search_slot+0x5c0/0xa90 [btr=
fs]
[ 8712.675473]  [<ffffffffa0048b49>]
btrfs_write_dirty_block_groups+0xd9/0x530 [btrfs]
[ 8712.675481]  [<ffffffffa0048952>] ? btrfs_run_delayed_refs+0xf2/0x21=
0 [btrfs]
[ 8712.675490]  [<ffffffffa0057475>] commit_cowonly_roots+0x115/0x1e0 [=
btrfs]
[ 8712.675499]  [<ffffffffa0058a74>]
btrfs_commit_transaction+0x404/0x8a0 [btrfs]
[ 8712.675508]  [<ffffffffa0057e31>] ?
join_transaction.clone.24+0x21/0x240 [btrfs]
[ 8712.675511]  [<ffffffff81068e30>] ? wake_up_bit+0x40/0x40
[ 8712.675520]  [<ffffffffa0051ee3>] transaction_kthread+0x263/0x280 [b=
trfs]
[ 8712.675528]  [<ffffffffa0051c80>] ? btrfs_congested_fn+0xb0/0xb0 [bt=
rfs]
[ 8712.675536]  [<ffffffffa0051c80>] ? btrfs_congested_fn+0xb0/0xb0 [bt=
rfs]
[ 8712.675539]  [<ffffffff810688a6>] kthread+0x96/0xa0
[ 8712.675542]  [<ffffffff816d3b54>] kernel_thread_helper+0x4/0x10
[ 8712.675545]  [<ffffffff81068810>] ? kthread_worker_fn+0x1a0/0x1a0
[ 8712.675547]  [<ffffffff816d3b50>] ? gs_change+0xb/0xb
[ 8712.675549] ---[ end trace 234618ad5fea81a4 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

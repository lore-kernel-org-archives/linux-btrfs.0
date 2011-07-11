From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [GIT PULL] Btrfs updates for 3.1
Date: Sun, 10 Jul 2011 19:20:01 -0500
Message-ID: <CAKcLGm9ukUsfp87D0PJ56uYv8DHmFzu8Z7Kq33Bi55+NO=8kTg@mail.gmail.com>
References: <4E0E3091.9060704@redhat.com>
	<4E0F8CC0.8010909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0F8CC0.8010909@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 2, 2011 at 4:25 PM, Josef Bacik <josef@redhat.com> wrote:
> On 07/01/2011 04:39 PM, Josef Bacik wrote:
>> Hey Chris,
>>
>> Since I'm going on vacation next week I wanted to get everything rea=
dy for you
>> in case you get bored with fsck and want to put together a 3.1 tree =
:). =A0If you
>> can pull
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git f=
or-chris
>>
>> It is based on your for-linus branch. =A0Here is the shortlog and di=
ffstat
>>
>
> Ugh sorry I had to update the don't panic patch because I'm an idiot.
> Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Josef:

I've been testing this series of patches in a 2.6.39.3 kernel merged
with the latest 'for-linus' branch in Chris btrfs-unstable repository.

I'm getting a kernel BUG that looks like it could be attributed to the
"Btrfs: try to only do one btrfs_search_slot in do_setxattr" patch.

[ 5959.860027] ------------[ cut here ]------------
[ 5959.860032] kernel BUG at include/linux/spinlock.h:380!
[ 5959.860035] invalid opcode: 0000 [#1] SMP
[ 5959.860038] last sysfs file: /sys/kernel/uevent_seqnum
[ 5959.860041] CPU 1
[ 5959.860042] Modules linked in: snd_seq_midi nvidia(P) lgdt330x
cx88_dvb cx88_vp3054_i2c videobuf_dvb snd_ens1371 tuner_simple
tuner_types snd_rawmidi tda9887 tda8290 tuner cx8800 cx88_alsa cx8802
snd_ac97_codec r8169 i2c_i801 cx88xx tveeprom videobuf_dma_sg
btcx_risc videobuf_core ac97_bus
[ 5959.860062]
[ 5959.860065] Pid: 13521, comm: install Tainted: P
2.6.39.3-git-local-v10+ #1 Gigabyte Technology Co., Ltd.
P35-DS3L/P35-DS3L
[ 5959.860071] RIP: 0010:[<ffffffff813a4021>]  [<ffffffff813a4021>]
btrfs_assert_tree_locked+0x21/0x30
[ 5959.860079] RSP: 0018:ffff880005dffaf8  EFLAGS: 00010246
[ 5959.860082] RAX: 0000000000003300 RBX: ffff88007be51b40 RCX: 0000000=
000000001
[ 5959.860084] RDX: 0000000000003333 RSI: ffff880005dfe000 RDI: ffff880=
025993900
[ 5959.860087] RBP: ffff880005dffaf8 R08: 0000000000000001 R09: 0000000=
000000001
[ 5959.860089] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880=
05a8c2800
[ 5959.860092] R13: 0000000000000001 R14: 000000000000000b R15: ffff880=
03e41ebd0
[ 5959.860095] FS:  00007f495b017700(0000) GS:ffff88007fd00000(0000)
knlGS:0000000000000000
[ 5959.860098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5959.860100] CR2: 00007f495afdc000 CR3: 000000003482b000 CR4: 0000000=
0000006e0
[ 5959.860103] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 5959.860106] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 5959.860109] Process install (pid: 13521, threadinfo
ffff880005dfe000, task ffff880056aaac40)
[ 5959.860111] Stack:
[ 5959.860113]  ffff880005dffb88 ffffffff813536f7 ffff88000343f000
ffffffff8138add4
[ 5959.860117]  ffff880078546700 000000000000000b 0000000000000072
0000000000000001
[ 5959.860122]  ffff880005dffb88 0000000100000001 0000000000000000
00000efb0343f000
[ 5959.860126] Call Trace:
[ 5959.860132]  [<ffffffff813536f7>] push_leaf_left+0xc7/0x190
[ 5959.860136]  [<ffffffff8138add4>] ? btrfs_item_size+0xe4/0xf0
[ 5959.860140]  [<ffffffff81356f6d>] btrfs_del_items+0x39d/0x570
[ 5959.860144]  [<ffffffff81365f49>] btrfs_delete_one_dir_name+0xf9/0x1=
00
[ 5959.860148]  [<ffffffff8138e251>] do_setxattr+0x191/0x1f0
[ 5959.860152]  [<ffffffff81370761>] ? join_transaction.clone.24+0x21/0=
x220
[ 5959.860156]  [<ffffffff8138e493>] __btrfs_setxattr+0x93/0xf0
[ 5959.860159]  [<ffffffff813aa2c3>] btrfs_set_acl+0x103/0x230
[ 5959.860163]  [<ffffffff813aab1a>] btrfs_acl_chmod+0xea/0xf0
[ 5959.860167]  [<ffffffff8113e478>] ? __mark_inode_dirty+0x68/0x200
[ 5959.860171]  [<ffffffff8137b9be>] btrfs_setattr+0x9e/0xd0
[ 5959.860175]  [<ffffffff81133809>] notify_change+0x189/0x370
[ 5959.860179]  [<ffffffff81118a5d>] sys_fchmodat+0xcd/0x100
[ 5959.860183]  [<ffffffff810f9adb>] ? do_munmap+0x2eb/0x360
[ 5959.860187]  [<ffffffff81118aa8>] sys_chmod+0x18/0x20
[ 5959.860191]  [<ffffffff81883ceb>] system_call_fastpath+0x16/0x1b
[ 5959.860193] Code: 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 1f
44 00 00 48 8b 47 38 a8 02 75 0e 8b 57 64 89 d0 c1 f8 08 31 d0 84 c0
74 02 c9 c3 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5
48 83
[ 5959.860226] RIP  [<ffffffff813a4021>] btrfs_assert_tree_locked+0x21/=
0x30
[ 5959.860230]  RSP <ffff880005dffaf8>
[ 5959.860233] ---[ end trace 56253344f3b39a7c ]---

I'll try dropping the patch to confirm the source, but it's been an
intermittent bug.  I haven't run across a simple way to reliably
reproduce it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

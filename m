Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33565 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbbBEKXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 05:23:17 -0500
Received: by mail-la0-f51.google.com with SMTP id hv19so5140011lab.10
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 02:23:15 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAJSVwFMaA9_d64TeWfL6b9Keae+Gb2d__HiTv1W_E8Rv=QFS9A@mail.gmail.com>
References: <1422864528-8625-1-git-send-email-forrestl@synology.com>
	<CAJSVwFMaA9_d64TeWfL6b9Keae+Gb2d__HiTv1W_E8Rv=QFS9A@mail.gmail.com>
Date: Thu, 5 Feb 2015 10:23:15 +0000
Message-ID: <CAL3q7H7iSCnLxU=A60RY84TMPmvsZFF+TSKBQXbNb46afG4N4w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_orphan_add() when delete
 unused block group
From: Filipe David Manana <fdmanana@gmail.com>
To: Forrest Liu <forrestl@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 4, 2015 at 12:28 PM, Forrest Liu <forrestl@synology.com> wrote:
> Kernel BUG_ON when running following script on kernel 3.19-rc7
>
> mntpath=/btrfs
> loopdev=/dev/loop0
> filepath=/volume2/100g_image
>
> umount $mntpath
> losetup -d $loopdev
> truncate --size 1000g $filepath
> losetup $loopdev $filepath
> mkfs.btrfs -f $loopdev
> mount $loopdev $mntpath
>
> for i in `seq 1 1 100`; do
>         echo "round $i"
>         for j in `seq 1 1 1000`; do
>                 fallocate -l 1g $mntpath/$j
>         done
>         rm $mntpath/*
> done
>
> [  613.093084] ------------[ cut here ]------------
> [  613.097928] kernel BUG at fs/btrfs/inode.c:3142!
> [  613.105855] invalid opcode: 0000 [#1] SMP
> [  613.112702] Modules linked in: coretemp(E) crc32_pclmul(E)
> ghash_clmulni_intel(E) aesni_intel(E) snd_ens1371(E) snd_ac97_codec(E)
> aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ppdev(E) ac97_bus(E)
> ablk_helper(E) gameport(E) cryptd(E) snd_rawmidi(E) snd_seq_device(E)
> snd_pcm(E) vmw_balloon(E) snd_timer(E) snd(E) soundcore(E)
> serio_raw(E) vmwgfx(E) ttm(E) drm_kms_helper(E) drm(E) vmw_vmci(E)
> parport_pc(E) shpchp(E) i2c_piix4(E) mac_hid(E) lp(E) parport(E)
> btrfs(E) xor(E) raid6_pq(E) hid_generic(E) usbhid(E) hid(E) psmouse(E)
> ahci(E) libahci(E) e1000(E) mptspi(E) mptscsih(E) mptbase(E) floppy(E)
> vmw_pvscsi(E) vmxnet3(E)
> [  613.144196] CPU: 0 PID: 1480 Comm: btrfs-cleaner Tainted: G
>    E  3.19.0-rc7-custom #2
> [  613.148501] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
> [  613.152694] task: ffff880035cdb1a0 ti: ffff880039cf4000 task.ti:
> ffff880039cf4000
> [  613.154969] RIP: 0010:[<ffffffffa01441c2>]  [<ffffffffa01441c2>]
> btrfs_orphan_add+0x1d2/0x1e0 [btrfs]
> [  613.157780] RSP: 0018:ffff880039cf7c48  EFLAGS: 00010286
> [  613.159560] RAX: 00000000ffffffe4 RBX: ffff88003bd981a0 RCX: ffff88003c9e4000
> [  613.161904] RDX: 0000000000002244 RSI: 0000000000040000 RDI: ffff88003c9e4138
> [  613.164264] RBP: ffff880039cf7c88 R08: 000060ffc0000850 R09: 0000000000000000
> [  613.166507] R10: ffff88003bc4b7a0 R11: ffffea0000eb6740 R12: ffff88003c9c0000
> [  613.168681] R13: ffff88003c102160 R14: ffff88003c9c0458 R15: 0000000000000001
> [  613.170932] FS:  0000000000000000(0000) GS:ffff88003f600000(0000)
> knlGS:0000000000000000
> [  613.173316] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  613.175227] CR2: 00007f6343537000 CR3: 0000000036329000 CR4: 00000000000407f0
> [  613.177554] Stack:
> [  613.178712]  ffff880039cf7c88 ffffffffa0182a54 ffff88003c9e4b04
> ffff88003c9c7800
> [  613.181297]  ffff88003bc4b7a0 ffff88003bd981a0 ffff88003c8db200
> ffff88003c2fcc60
> [  613.183782]  ffff880039cf7d18 ffffffffa012da97 ffff88003bc4b7a4
> ffff88003bc4b7a0
> [  613.186171] Call Trace:
> [  613.187493]  [<ffffffffa0182a54>] ?
> lookup_free_space_inode+0x44/0x100 [btrfs]
> [  613.189801]  [<ffffffffa012da97>]
> btrfs_remove_block_group+0x137/0x740 [btrfs]
> [  613.192126]  [<ffffffffa0166912>] btrfs_remove_chunk+0x672/0x780 [btrfs]
> [  613.194267]  [<ffffffffa012e2ff>] btrfs_delete_unused_bgs+0x25f/0x280 [btrfs]
> [  613.196567]  [<ffffffffa0135e4c>] cleaner_kthread+0x12c/0x190 [btrfs]
> [  613.198687]  [<ffffffffa0135d20>] ? check_leaf+0x350/0x350 [btrfs]
> [  613.200758]  [<ffffffff8108f232>] kthread+0xd2/0xf0
> [  613.202616]  [<ffffffff8108f160>] ? kthread_create_on_node+0x180/0x180
> [  613.204738]  [<ffffffff8175dabc>] ret_from_fork+0x7c/0xb0
> [  613.206652]  [<ffffffff8108f160>] ? kthread_create_on_node+0x180/0x180
> [  613.208741] Code: ff ff 0f 1f 80 00 00 00 00 89 45 c8 3e 80 63 80
> fd 48 89 df e8 d0 23 fe ff 8b 45 c8 e9 14 ff ff ff b8 f4 ff ff ff e9
> 12 ff ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
> 55 48
> [  613.216562] RIP  [<ffffffffa01441c2>] btrfs_orphan_add+0x1d2/0x1e0 [btrfs]
> [  613.218828]  RSP <ffff880039cf7c48>
> [  613.220382] ---[ end trace 71073106deb8a457 ]---
>
> The patch fix problem of BUG_ON

Why don't you include the reproducing steps and stack traces in the
commit message? Those are very useful information to have there.

Also, would you consider adding a regression test as generic xfstest?
Code changes over time, and it's unlikely (and unrealistic) that
someone will run these steps for every future kernel release candidate
to verify there are no regressions... xfstests serves that purpose, to
find out if there are regressions.

This comment applies to your other 2 patches as well.

Thanks Forrest.

>
> Thanks,
> Forrest
>
> 2015-02-02 16:08 GMT+08:00 Forrest Liu <forrestl@synology.com>:
>> btrfs_orphan_reserve_metadata() will grab metadata reservation from
>> transaction handle, and the transaction handle was passed from
>> btrfs_delete_unused_bgs() when delete unused block group.
>>
>> Repace btrfs_join_transaction() with btrfs_start_transaction() in
>> btrfs_delete_unused_bgs() to prevent BUG_ON() in btrfs_orphan_add()
>>
>> Signed-off-by: Forrest Liu <forrestl@synology.com>
>> ---
>>  fs/btrfs/extent-tree.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 53294da..61a3255 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -9548,7 +9548,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
>>                  * Want to do this before we do anything else so we can recover
>>                  * properly if we fail to join the transaction.
>>                  */
>> -               trans = btrfs_join_transaction(root);
>> +               /* 1 for btrfs_orphan_reserve_metadata() */
>> +               trans = btrfs_start_transaction(root, 1);
>>                 if (IS_ERR(trans)) {
>>                         btrfs_set_block_group_rw(root, block_group);
>>                         ret = PTR_ERR(trans);
>> --
>> 1.9.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

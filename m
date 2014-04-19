Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49539 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDSNC2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Apr 2014 09:02:28 -0400
Received: by mail-ob0-f181.google.com with SMTP id gq1so2715795obb.40
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Apr 2014 06:02:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcaxmU+4637dYwga-9BQmGkDgRyd0C2kuh2PnbNeAyQWkTT0A@mail.gmail.com>
References: <CAAcaxmU+4637dYwga-9BQmGkDgRyd0C2kuh2PnbNeAyQWkTT0A@mail.gmail.com>
Date: Sat, 19 Apr 2014 21:02:27 +0800
Message-ID: <CAAcaxmX_Jw=FqpsKd3Op8Jy9=0XZL4Z0Qs7n+T-GyiMGX3ze2g@mail.gmail.com>
Subject: Re: trigger BUG_ON in compress mode
From: ylet ylet <levin.front@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: jbacik <jbacik@fb.com>, clm@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTW, mount option is
mount -t btrfs -o nospace_cache -o compress-force=zlib -o enospc_debug
/dev/sdb /mnt/btrfs

2014-04-19 20:59 GMT+08:00 ylet ylet <levin.front@gmail.com>:
> I ran for-stable-3.13 branch and still ran the IOzone
>
> ./iozone -s 16g -i 0 -i 1 -i 2 -t 4 -r 4k -+w 50 -+y 20 -+C 60 -F
> /mnt/btrfs/test1 /mnt/btrfs/test2 /mnt/btrfs/test3 /mnt/btrfs/test
>
> the following bug_on is triggered. The following is CALL TRACE
>
> [  318.694805] btrfs: device fsid 1130b5e3-5e6a-4746-9ebf-4c0ecb237857
> devid 1 transid 4 /dev/sdb
> [  318.695025] btrfs: disabling disk space caching
> [  318.695028] btrfs: force zlib compression
> [  318.695029] btrfs flagging fs with big metadata feature
> [  318.696120] Btrfs detected SSD devices, enabling SSD mode
> [  318.696548] btrfs: creating UUID tree
> [ 1955.144474] ------------[ cut here ]------------
> [ 1955.144484] kernel BUG at
> /home/btrfs-linux-public/btrfs-3.13-stable/ctree.c:3166!
> [ 1955.144495] invalid opcode: 0000 [#1] SMP
> [ 1955.144512] Modules linked in: btrfs(O) raid6_pq xor libcrc32c
> dm_crypt snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel
> snd_hda_codec rfcomm bnep bluetooth snd_hwdep snd_pcm snd_seq_midi
> snd_rawmidi parport_pc snd_seq_midi_event snd_seq ppdev snd_timer
> eeepc_wmi snd_seq_device asus_wmi sparse_keymap alx(O) hid_generic snd
> psmouse mdio serio_raw compat(O) lpc_ich soundcore wmi snd_page_alloc
> mac_hid lp parport usbhid hid video [last unloaded: btrfs]
> [ 1955.144646] CPU: 2 PID: 2811 Comm: btrfs-endio-wri Tainted: G
>     O 3.13.5 #1
> [ 1955.144654] Hardware name: System manufacturer System Product
> Name/P8H77-V, BIOS 0607 04/24/2012
> [ 1955.144669] task: ffff8801f5404560 ti: ffff880002ef2000 task.ti:
> ffff880002ef2000
> [ 1955.144682] RIP: 0010:[<ffffffffa02f8921>]  [<ffffffffa02f8921>]
> btrfs_set_item_key_safe+0x141/0x150 [btrfs]
> [ 1955.144707] RSP: 0018:ffff880002ef3ae8  EFLAGS: 00010246
> [ 1955.144717] RAX: 0000000000000000 RBX: 0000000000000042 RCX: 0000000069288000
> [ 1955.144729] RDX: 0000000000000000 RSI: ffff880002ef3c27 RDI: ffff880002ef3ac7
> [ 1955.144761] RBP: ffff880002ef3b48 R08: 00000000ffffffff R09: 0000000000000000
> [ 1955.144787] R10: 0000000000000000 R11: 0000000000000003 R12: ffff8800c9ab7040
> [ 1955.144814] R13: ffff880002ef3c27 R14: ffff880002ef3b07 R15: ffff880214961630
> [ 1955.144841] FS:  0000000000000000(0000) GS:ffff88021ed00000(0000)
> knlGS:0000000000000000
> [ 1955.144882] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1955.144906] CR2: 00007f6c85221000 CR3: 0000000001c0b000 CR4: 00000000000407e0
> [ 1955.144933] Stack:
> [ 1955.144951]  ffff880002ef3b48 ffff88002cd4d000 ffff8800bb7c0000
> 0100000000003000
> [ 1955.144996]  6c00000000000001 0000000069288000 ffff880002ef3b48
> ffff880214961630
> [ 1955.145041]  ffff8800c9ab7040 0000000069287000 0000000000000001
> 0000000000000000
> [ 1955.145086] Call Trace:
> [ 1955.145114]  [<ffffffffa032fdb0>] __btrfs_drop_extents+0x5a0/0xb90 [btrfs]
> [ 1955.145145]  [<ffffffffa02fc33d>] ?
> setup_items_for_insert+0x2cd/0x3d0 [btrfs]
> [ 1955.145192]  [<ffffffffa0330ebe>] btrfs_drop_extents+0x6e/0xa0 [btrfs]
> [ 1955.145224]  [<ffffffffa032038b>]
> insert_reserved_file_extent.constprop.64+0x7b/0x2c0 [btrfs]
> [ 1955.145272]  [<ffffffffa031ded6>] ? start_transaction+0x96/0x570 [btrfs]
> [ 1955.145303]  [<ffffffffa0326255>] btrfs_finish_ordered_io+0x465/0x500 [btrfs]
> [ 1955.145335]  [<ffffffffa0326305>] finish_ordered_fn+0x15/0x20 [btrfs]
> [ 1955.145368]  [<ffffffffa0349f0a>] worker_loop+0x14a/0x530 [btrfs]
> [ 1955.145399]  [<ffffffffa0349dc0>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
> [ 1955.145428]  [<ffffffff81070f79>] kthread+0xc9/0xe0
> [ 1955.145452]  [<ffffffff81070eb0>] ? flush_kthread_worker+0xb0/0xb0
> [ 1955.145478]  [<ffffffff816a7cec>] ret_from_fork+0x7c/0xb0
> [ 1955.145503]  [<ffffffff81070eb0>] ? flush_kthread_worker+0xb0/0xb0
> [ 1955.145528] Code: 00 00 4c 89 f6 4c 89 e7 48 98 48 8d 04 80 48 8d
> 54 80 65 e8 c2 42 04 00 4c 89 ee 4c 89 f7 e8 27 f3 ff ff 85 c0 0f 8f
> 5c ff ff ff <0f> 0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66
> 90 55
> [ 1955.145694] RIP  [<ffffffffa02f8921>]
> btrfs_set_item_key_safe+0x141/0x150 [btrfs]
> [ 1955.145738]  RSP <ffff880002ef3ae8>

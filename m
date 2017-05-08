Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35735 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdEHOQq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 10:16:46 -0400
Received: by mail-pf0-f177.google.com with SMTP id v14so33898841pfd.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 07:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com>
From: Alexandru Guzu <alexguzu@gmail.com>
Date: Mon, 8 May 2017 10:16:44 -0400
Message-ID: <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Sean Greenslade <sean@seangreenslade.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Deleting the Firefox cache with the LiveCD resolved the issue where
the FS would become read-only when opening Firefox, however, the
lowmem check still reports errors. There are probably some other files
that would cause the FS to become read-only again, but I'm not sure
how to find them.
I took a snapshot of the Virtual disk before deleting the FF profile,
so I can reproduce the issue if you guys want to track down this
potential bug, otherwise I will delete the VM by the end of this week.

Sean, how would you approach the copy of the data back and forth if
the OS is on it? Would a Send-receive and then back work?

On Sun, May 7, 2017 at 1:32 PM, Sean Greenslade <sean@seangreenslade.com> wrote:
> On May 3, 2017 4:28:11 PM EDT, Alexandru Guzu <alexguzu@gmail.com> wrote:
>>Hi all,
>>
>>In a VirtualBox VM, I converted a EXT4 fs to BTRFS that is now running
>>on Ubuntu 16.04 (Kernel 4.4.0-72). I was able to use the system for
>>several weeks. I even did kernel updates, compression, deduplication
>>without issues.
>>
>>Since today, a little while after booting (usually when I start
>>opening applications), the FS becomes read-only. IMO, the only thing
>>that might have changed that could affect this is a kernel upgrade.
>>However, since the FS becomes RO, I cannot easily do a kernel update
>>(I guess I'd have to chroot and do it).
>>
>>The stack trace is the following:
>>
>>[   88.836057] ------------[ cut here ]------------
>>[   88.836082] WARNING: CPU: 0 PID: 25 at
>>/build/linux-wXdoVv/linux-4.4.0/fs/btrfs/inode.c:2931
>>btrfs_finish_ordered_io+0x63b/0x650 [btrfs]()
>>[   88.836083] BTRFS: Transaction aborted (error -95)
>>[   88.836084] Modules linked in: nvram msr zram lz4_compress
>>vboxsf(OE) joydev crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
>>aesni_intel snd_intel8x0 aes_x86_64 snd_ac97_codec lrw gf128mul
>>glue_helper ablk_helper cryptd ac97_bus snd_pcm snd_seq_midi
>>snd_seq_midi_event snd_rawmidi snd_seq vboxvideo(OE) snd_seq_device
>>snd_timer ttm input_leds drm_kms_helper serio_raw i2c_piix4 snd drm
>>fb_sys_fops syscopyarea sysfillrect sysimgblt soundcore 8250_fintek
>>vboxguest(OE) mac_hid parport_pc ppdev lp parport autofs4 btrfs xor
>>raid6_pq hid_generic usbhid hid psmouse ahci libahci fjes video
>>pata_acpi
>>[   88.836116] CPU: 0 PID: 25 Comm: kworker/u2:1 Tainted: G
>>OE   4.4.0-72-generic #93-Ubuntu
>>[   88.836117] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
>>VirtualBox 12/01/2006
>>[   88.836130] Workqueue: btrfs-endio-write btrfs_endio_write_helper
>>[btrfs]
>>[   88.836132]  0000000000000286 00000000618d3a00 ffff88007cabbc78
>>ffffffff813f82b3
>>[   88.836134]  ffff88007cabbcc0 ffffffffc01912a8 ffff88007cabbcb0
>>ffffffff81081302
>>[   88.836135]  ffff880058bf01b0 ffff8800355f2800 ffff88007b9e64e0
>>ffff88007c66f098
>>[   88.836137] Call Trace:
>>[   88.836142]  [<ffffffff813f82b3>] dump_stack+0x63/0x90
>>[   88.836145]  [<ffffffff81081302>] warn_slowpath_common+0x82/0xc0
>>[   88.836147]  [<ffffffff8108139c>] warn_slowpath_fmt+0x5c/0x80
>>[   88.836159]  [<ffffffffc012373f>] ? unpin_extent_cache+0x8f/0xe0
>>[btrfs]
>>[   88.836167]  [<ffffffffc00e0b06>] ? btrfs_free_path+0x26/0x30
>>[btrfs]
>>[   88.836178]  [<ffffffffc011554b>]
>>btrfs_finish_ordered_io+0x63b/0x650 [btrfs]
>>[   88.836188]  [<ffffffffc0115845>] finish_ordered_fn+0x15/0x20
>>[btrfs]
>>[   88.836200]  [<ffffffffc013dfda>]
>>btrfs_scrubparity_helper+0xca/0x2f0 [btrfs]
>>[   88.836202]  [<ffffffff810caee1>] ?
>>__raw_callee_save___pv_queued_spin_unlock+0x11/0x20
>>[   88.836214]  [<ffffffffc013e28e>] btrfs_endio_write_helper+0xe/0x10
>>[btrfs]
>>[   88.836217]  [<ffffffff8109a555>] process_one_work+0x165/0x480
>>[   88.836219]  [<ffffffff8109a8bb>] worker_thread+0x4b/0x4c0
>>[   88.836220]  [<ffffffff8109a870>] ? process_one_work+0x480/0x480
>>[   88.836222]  [<ffffffff8109a870>] ? process_one_work+0x480/0x480
>>[   88.836224]  [<ffffffff810a0be8>] kthread+0xd8/0xf0
>>[   88.836225]  [<ffffffff810a0b10>] ?
>>kthread_create_on_node+0x1e0/0x1e0
>>[   88.836229]  [<ffffffff8183ca0f>] ret_from_fork+0x3f/0x70
>>[   88.836230]  [<ffffffff810a0b10>] ?
>>kthread_create_on_node+0x1e0/0x1e0
>>[   88.836232] ---[ end trace f4b8dbb54f0db139 ]---
>>[   88.836234] BTRFS: error (device sda1) in
>>btrfs_finish_ordered_io:2931: errno=-95 unknown
>>[   88.836236] BTRFS info (device sda1): forced readonly
>>[   88.836392] pending csums is 118784
>>
>>If I reboot with the Live CD version, I can run `scrub` and `check`
>>without any issues. Also the FS stays read-write.
>>
>>Is this a known issue? Could it be due to the conversion, or can this
>>happen on any system on any time. This is a test VM that I can
>>re-make, but I would like to know if this can happen on a production
>>system.
>>
>>Regards,
>>Alex.
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Just FYI, I ran into basically this same issue a while back.
> My solution was to copy all the data off it,  re-run mkfs.btrfs,
> then copy all the data back. I found that none of the existing
> data was damaged, so I think the actual issue is something
> left over from the conversion that confuses the commit
> logic.
>
> --Sean

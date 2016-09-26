Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35132 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbcIZXnd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 19:43:33 -0400
Received: by mail-oi0-f43.google.com with SMTP id w11so226231081oia.2
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 16:43:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6qYijZO_4bs1vx3ic=YD3o2oazvH1ux6gW_LXMmBoW=A@mail.gmail.com>
References: <CA+Seug=j2vPr57-DX-M8x1+eQQywGO0XdVxVWnYqZqi9hqC1GA@mail.gmail.com>
 <CAL3q7H6qYijZO_4bs1vx3ic=YD3o2oazvH1ux6gW_LXMmBoW=A@mail.gmail.com>
From: Romulo <romuluspb@gmail.com>
Date: Mon, 26 Sep 2016 20:43:31 -0300
Message-ID: <CA+SeugnEb4y09vAtw6tJmZ1SgCy87b7UDdsLMAJ75C=emZEBrw@mail.gmail.com>
Subject: Re: send -p stuck with kernel bug message
To: fdmanana@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As it depends on a commit only landed in 4.8, is there something I can
do myself so I can go on with my system snapshot history? Discard all
previous Snapshots, stop using the ones I have as references? or there
exist another thing I can do about it? I have not balanced my FS
anytime as it is a single device and very new, 2 weeks.

att,
Romulo Pulcinelli Benedetti

2016-09-26 13:18 GMT-03:00 Filipe Manana <fdmanana@gmail.com>:
> On Mon, Sep 26, 2016 at 3:16 PM, Romulo <romuluspb@gmail.com> wrote:
>> Hi,
>>
>> I faced a problem with send -p command, that occur with an specif
>> snapshot and any parent before it, I isolated the problem being in
>> send as it occur even in a "send -p    > /dev/null". I've tried "-vvv"
>> with no extra information success.
>>
>>  Send  work fine for any of the two  snaps. I've deduplicated the FS
>> some times after big addition of data, before snapshotting, with "
>> ./duperemove -rdA -b 64K ".
>>
>> The sending was tried with btrfs-progs 4.4 and 4.7.3, I checked the FS
>> with 4.4, And tried to send both in Kernel version 4.4.0 and 4.7.5,
>> all in Ubuntu 16.04.
>>
>> The FS is a Luks partition, with LVM for system and swap  where system
>> is divided in 2 subvolume, "@" and "@home."
>> My FS settings > defaults,noatime,space_cache,ssd_spread,compressr.
>>
>> the result of check:
>>
>> Checking filesystem on /dev/mapper/lvmVG-root
>> UUID: 0b53c097-e5bc-40c0-a328-be4dbbce4828
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 94834094374 bytes used err is 0
>> total csum bytes: 90873036
>> total tree bytes: 1691959296
>> total fs tree bytes: 1339441152
>> total extent tree bytes: 231030784
>> btree space waste bytes: 274492566
>> file data blocks allocated: 935921709056
>> referenced 570207657984
>>
>> scrub:
>>
>> scrub done for 0b53c097-e5bc-40c0-a328-be4dbbce4828
>> scrub started at Mon Sep 26 03:31:00 2016 and finished after 00:02:55
>> total bytes scrubbed: 88.38GiB with 0 errors
>>
>> the Kernel log message:
>>
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.548208]
>> ------------[ cut here ]------------
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.549907]
>> kernel BUG at /home/kernel/COD/linux/fs/btrfs/send.c:5654!
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.551542]
>> invalid opcode: 0000 [#8] SMP
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.553265]
>> Modules linked in: nls_utf8 nls_cp437 vfat fat pci_stub vboxpci(OE)
>> vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) rfcomm fuse bnep
>> bbswitch(OE) ext4 jbd2 mbcache intel_rapl x86_pkg_temp_thermal
>> intel_powerclamp coretemp snd_hda_codec_hdmi snd_hda_codec_realtek
>> snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core
>> snd_hwdep snd_pcm arc4 snd_seq_midi snd_seq_midi_event snd_rawmidi
>> dcdbas iwldvm kvm_intel btusb mac80211 snd_seq btrtl kvm btbcm
>> uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 btintel
>> videobuf2_core snd_seq_device irqbypass bluetooth iwlwifi videodev
>> intel_cstate media intel_rapl_perf joydev crc16 serio_raw cfg80211
>> snd_timer sg rfkill snd lpc_ich mei_me mfd_core mei soundcore shpchp
>> wmi battery evdev dell_smo8800 tpm_tis ac tpm squashfs loop parport_pc
>> ppdev lp parport autofs4 btrfs xor raid6_pq algif_skcipher af_alg
>> dm_crypt dm_mod sr_mod cdrom sd_mod hid_generic usbhid hid uas
>> usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel
>> ghash_clmulni_intel jitterentropy_rng hmac i915 drbg ansi_cprng ahci
>> libahci aesni_intel libata aes_x86_64 lrw gf128mul xhci_pci
>> i2c_algo_bit glue_helper ablk_helper xhci_hcd scsi_mod ehci_pci
>> drm_kms_helper r8169 cryptd ehci_hcd psmouse drm usbcore mii
>> usb_common thermal video fjes button
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.564184]
>> CPU: 3 PID: 20573 Comm: btrfs Tainted: G      D    OE
>> 4.7.5-040705-generic #201609240533
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.566022]
>> Hardware name: Dell Inc.          Dell System XPS L502X/04X7VP, BIOS
>> A09 01/13/2012
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.567858]
>> task: ffff8802aa8db140 ti: ffff88010065c000 task.ti: ffff88010065c000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569810]
>> RIP: 0010:[<ffffffffc06c13d7>]  [<ffffffffc06c13d7>]
>> changed_cb+0x247/0xad0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569813]
>> RSP: 0018:ffff88010065fb80  EFLAGS: 00010293
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569814]
>> RAX: 00000000000147ef RBX: 0000000000000002 RCX: 0000000000000000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569815]
>> RDX: ffff88010065fc65 RSI: ffff8802ee1575b0 RDI: 0000000000000282
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569815]
>> RBP: ffff880373aecee0 R08: 0000000000000000 R09: 0000000000000000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569815]
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88010065fc65
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569816]
>> R13: ffff8802efc93000 R14: 0000000000000000 R15: ffff88040f174600
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569817]
>> FS:  00007ff666a858c0(0000) GS:ffff88043e4c0000(0000)
>> knlGS:0000000000000000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569817]
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569818]
>> CR2: 00007ff665a1be38 CR3: 00000002f3fbd000 CR4: 00000000000406e0
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569818] Stack:
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569820]
>> ffff8802ec4236d0 ffff8802ee157ee0 ffff88042709f000 ffffffffc06202cf
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569821]
>> ffff8802ee157ee0 0000000000000000 0000000000000035 0000000000000011
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569821]
>> ffffffffc0669c6c efff880429078000 ffff880429134000 ffffffffc067577f
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569822] Call Trace:
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569832]
>> [<ffffffffc06202cf>] ? read_node_slot+0x9f/0xc0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569844]
>> [<ffffffffc0669c6c>] ? btrfs_get_token_32+0x10c/0x130 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569856]
>> [<ffffffffc067577f>] ? memcmp_extent_buffer+0xbf/0x120 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569864]
>> [<ffffffffc062a8c0>] ? btrfs_compare_trees+0x560/0x690 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569875]
>> [<ffffffffc06c1190>] ? finish_inode_if_needed+0xab0/0xab0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569894]
>> [<ffffffffc06c2ba0>] ? btrfs_ioctl_send+0xf40/0x11c0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569905]
>> [<ffffffffc068ada8>] ? btrfs_ioctl+0x818/0x1fe0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569908]
>> [<ffffffff810ae318>] ? enqueue_task_fair+0x58/0x910
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569910]
>> [<ffffffff81034735>] ? sched_clock+0x5/0x10
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569912]
>> [<ffffffff8120c05e>] ? do_vfs_ioctl+0x9e/0x5e0
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569913]
>> [<ffffffff81077e4e>] ? _do_fork+0x13e/0x390
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569915]
>> [<ffffffff8120c614>] ? SyS_ioctl+0x74/0x80
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569918]
>> [<ffffffff815f1af6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569928]
>> Code: f6 0f 88 7f fe ff ff bb 02 00 00 00 e9 16 fe ff ff 48 8d 55 40
>> 4c 89 c1 48 89 ee 4c 89 ff e8 91 dd ff ff 41 89 c6 e9 5b fe ff ff <0f>
>> 0b 49 8b 87 18 01 00 00 f7 c3 fd ff ff ff 48 8b 00 41 c7 87
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569942]
>> RIP  [<ffffffffc06c13d7>] changed_cb+0x247/0xad0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569942]
>> RSP <ffff88010065fb80>
>
> The following recent patch, not yet in any kernel release, fixes the problem:
>
> https://patchwork.kernel.org/patch/9339553/
>
> And it depends on commit 951555856b88aa47bc238de6b4c6e97bfd9d36df [1]
> which landed in the 4.8 kernel.
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=951555856b88aa47bc238de6b4c6e97bfd9d36df
>
>
>>
>> Att,
>> Romulo Pulcinelli Benedetti
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "People will forget what you said,
>  people will forget what you did,
>  but people will never forget how you made them feel."

Atenciosamente,
Romulo Pulcinelli Benedetti


2016-09-26 13:18 GMT-03:00 Filipe Manana <fdmanana@gmail.com>:
> On Mon, Sep 26, 2016 at 3:16 PM, Romulo <romuluspb@gmail.com> wrote:
>> Hi,
>>
>> I faced a problem with send -p command, that occur with an specif
>> snapshot and any parent before it, I isolated the problem being in
>> send as it occur even in a "send -p    > /dev/null". I've tried "-vvv"
>> with no extra information success.
>>
>>  Send  work fine for any of the two  snaps. I've deduplicated the FS
>> some times after big addition of data, before snapshotting, with "
>> ./duperemove -rdA -b 64K ".
>>
>> The sending was tried with btrfs-progs 4.4 and 4.7.3, I checked the FS
>> with 4.4, And tried to send both in Kernel version 4.4.0 and 4.7.5,
>> all in Ubuntu 16.04.
>>
>> The FS is a Luks partition, with LVM for system and swap  where system
>> is divided in 2 subvolume, "@" and "@home."
>> My FS settings > defaults,noatime,space_cache,ssd_spread,compressr.
>>
>> the result of check:
>>
>> Checking filesystem on /dev/mapper/lvmVG-root
>> UUID: 0b53c097-e5bc-40c0-a328-be4dbbce4828
>> checking extents
>> checking free space cache
>> checking fs roots
>> checking csums
>> checking root refs
>> found 94834094374 bytes used err is 0
>> total csum bytes: 90873036
>> total tree bytes: 1691959296
>> total fs tree bytes: 1339441152
>> total extent tree bytes: 231030784
>> btree space waste bytes: 274492566
>> file data blocks allocated: 935921709056
>> referenced 570207657984
>>
>> scrub:
>>
>> scrub done for 0b53c097-e5bc-40c0-a328-be4dbbce4828
>> scrub started at Mon Sep 26 03:31:00 2016 and finished after 00:02:55
>> total bytes scrubbed: 88.38GiB with 0 errors
>>
>> the Kernel log message:
>>
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.548208]
>> ------------[ cut here ]------------
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.549907]
>> kernel BUG at /home/kernel/COD/linux/fs/btrfs/send.c:5654!
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.551542]
>> invalid opcode: 0000 [#8] SMP
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.553265]
>> Modules linked in: nls_utf8 nls_cp437 vfat fat pci_stub vboxpci(OE)
>> vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) rfcomm fuse bnep
>> bbswitch(OE) ext4 jbd2 mbcache intel_rapl x86_pkg_temp_thermal
>> intel_powerclamp coretemp snd_hda_codec_hdmi snd_hda_codec_realtek
>> snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core
>> snd_hwdep snd_pcm arc4 snd_seq_midi snd_seq_midi_event snd_rawmidi
>> dcdbas iwldvm kvm_intel btusb mac80211 snd_seq btrtl kvm btbcm
>> uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 btintel
>> videobuf2_core snd_seq_device irqbypass bluetooth iwlwifi videodev
>> intel_cstate media intel_rapl_perf joydev crc16 serio_raw cfg80211
>> snd_timer sg rfkill snd lpc_ich mei_me mfd_core mei soundcore shpchp
>> wmi battery evdev dell_smo8800 tpm_tis ac tpm squashfs loop parport_pc
>> ppdev lp parport autofs4 btrfs xor raid6_pq algif_skcipher af_alg
>> dm_crypt dm_mod sr_mod cdrom sd_mod hid_generic usbhid hid uas
>> usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel
>> ghash_clmulni_intel jitterentropy_rng hmac i915 drbg ansi_cprng ahci
>> libahci aesni_intel libata aes_x86_64 lrw gf128mul xhci_pci
>> i2c_algo_bit glue_helper ablk_helper xhci_hcd scsi_mod ehci_pci
>> drm_kms_helper r8169 cryptd ehci_hcd psmouse drm usbcore mii
>> usb_common thermal video fjes button
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.564184]
>> CPU: 3 PID: 20573 Comm: btrfs Tainted: G      D    OE
>> 4.7.5-040705-generic #201609240533
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.566022]
>> Hardware name: Dell Inc.          Dell System XPS L502X/04X7VP, BIOS
>> A09 01/13/2012
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.567858]
>> task: ffff8802aa8db140 ti: ffff88010065c000 task.ti: ffff88010065c000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569810]
>> RIP: 0010:[<ffffffffc06c13d7>]  [<ffffffffc06c13d7>]
>> changed_cb+0x247/0xad0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569813]
>> RSP: 0018:ffff88010065fb80  EFLAGS: 00010293
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569814]
>> RAX: 00000000000147ef RBX: 0000000000000002 RCX: 0000000000000000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569815]
>> RDX: ffff88010065fc65 RSI: ffff8802ee1575b0 RDI: 0000000000000282
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569815]
>> RBP: ffff880373aecee0 R08: 0000000000000000 R09: 0000000000000000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569815]
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88010065fc65
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569816]
>> R13: ffff8802efc93000 R14: 0000000000000000 R15: ffff88040f174600
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569817]
>> FS:  00007ff666a858c0(0000) GS:ffff88043e4c0000(0000)
>> knlGS:0000000000000000
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569817]
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569818]
>> CR2: 00007ff665a1be38 CR3: 00000002f3fbd000 CR4: 00000000000406e0
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569818] Stack:
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569820]
>> ffff8802ec4236d0 ffff8802ee157ee0 ffff88042709f000 ffffffffc06202cf
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569821]
>> ffff8802ee157ee0 0000000000000000 0000000000000035 0000000000000011
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569821]
>> ffffffffc0669c6c efff880429078000 ffff880429134000 ffffffffc067577f
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569822] Call Trace:
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569832]
>> [<ffffffffc06202cf>] ? read_node_slot+0x9f/0xc0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569844]
>> [<ffffffffc0669c6c>] ? btrfs_get_token_32+0x10c/0x130 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569856]
>> [<ffffffffc067577f>] ? memcmp_extent_buffer+0xbf/0x120 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569864]
>> [<ffffffffc062a8c0>] ? btrfs_compare_trees+0x560/0x690 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569875]
>> [<ffffffffc06c1190>] ? finish_inode_if_needed+0xab0/0xab0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569894]
>> [<ffffffffc06c2ba0>] ? btrfs_ioctl_send+0xf40/0x11c0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569905]
>> [<ffffffffc068ada8>] ? btrfs_ioctl+0x818/0x1fe0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569908]
>> [<ffffffff810ae318>] ? enqueue_task_fair+0x58/0x910
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569910]
>> [<ffffffff81034735>] ? sched_clock+0x5/0x10
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569912]
>> [<ffffffff8120c05e>] ? do_vfs_ioctl+0x9e/0x5e0
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569913]
>> [<ffffffff81077e4e>] ? _do_fork+0x13e/0x390
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569915]
>> [<ffffffff8120c614>] ? SyS_ioctl+0x74/0x80
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569918]
>> [<ffffffff815f1af6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569928]
>> Code: f6 0f 88 7f fe ff ff bb 02 00 00 00 e9 16 fe ff ff 48 8d 55 40
>> 4c 89 c1 48 89 ee 4c 89 ff e8 91 dd ff ff 41 89 c6 e9 5b fe ff ff <0f>
>> 0b 49 8b 87 18 01 00 00 f7 c3 fd ff ff ff 48 8b 00 41 c7 87
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569942]
>> RIP  [<ffffffffc06c13d7>] changed_cb+0x247/0xad0 [btrfs]
>> Sep 25 23:23:35 romulo-Dell-System-XPS-L502X kernel: [19740.569942]
>> RSP <ffff88010065fb80>
>
> The following recent patch, not yet in any kernel release, fixes the problem:
>
> https://patchwork.kernel.org/patch/9339553/
>
> And it depends on commit 951555856b88aa47bc238de6b4c6e97bfd9d36df [1]
> which landed in the 4.8 kernel.
>
> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=951555856b88aa47bc238de6b4c6e97bfd9d36df
>
>
>>
>> Att,
>> Romulo Pulcinelli Benedetti
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "People will forget what you said,
>  people will forget what you did,
>  but people will never forget how you made them feel."

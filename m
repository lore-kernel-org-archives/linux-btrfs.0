Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36590 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbbETNyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 09:54:54 -0400
Received: by iepj10 with SMTP id j10so39483940iep.3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2015 06:54:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMtiharLjfjEvgJaSvOru=NrxGcX754t9oLbxTMSngnF47ZQvA@mail.gmail.com>
References: <CAMtiharLjfjEvgJaSvOru=NrxGcX754t9oLbxTMSngnF47ZQvA@mail.gmail.com>
Date: Wed, 20 May 2015 15:54:53 +0200
Message-ID: <CAMtihapRHKH-+f3TChO5Feoo54AiSdJcoCXn+D9Ee+7kF4x90w@mail.gmail.com>
Subject: Re: BTRFS crash after flac tag writing
From: =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Extra information:
While I was trying to work around this issue, I found that it rarely
triggers during the whole process. If I resume the process, it seems
like it just doesn't like a few particular files it needs to tag. As I
can currently live with this state, I have no intention to dive deeper
into this on my own. However, if any of you suggest any particular
strategy to find out why this happens, I'm more than willing to help
find and squash this bug.

As I just found out:
If I do the regular mass tagging from cue files, it hits the bug
twice, so I need to start the process three times.
If I do the mass tagging but first sort the cue file list to use
alphabetically, it hits the bug only once.

To me it seems like a particular order of file alterations trigger this bug.

Daniel

2015-05-20 0:01 GMT+02:00 Daniël Sonck <dsonck92@gmail.com>:
> Hi all,
>
> My server streams music and I recently found the need to tag a lot of flac
> files automatically, this tagging process now triggers something in btrfs
> (which I only recently started to use). Below is the system information.
>
> I've looked whether my 8 concurrent writes were causing the issues or the
> sheer amount of data, even if I run only one metaflac instance at a time,
> this will still trigger.
>
> Daniel
>
> # uname -a
> Linux sakuya 4.0.2-gentoo-2-default #1 SMP Thu May 14 02:50:16 CEST 2015
> x86_64 AMD FX(tm)-8320 Eight-Core Processor AuthenticAMD GNU/Linux
>
> # btrfs --version
> btrfs-progs v4.0
>
> # btrfs fi show
> Label: none  uuid: f956cfd2-e851-42be-8943-d924c6c6e4e4
>         Total devices 1 FS bytes used 2.73TiB
>         devid    1 size 3.64TiB used 2.73TiB path /dev/sdd
>
> # btrfs fi df /storage/media-files3
> Data, single: total=2.73TiB, used=2.73TiB
> System, single: total=32.00MiB, used=320.00KiB
> Metadata, single: total=4.00GiB, used=2.97GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> # dmesg
> [372349.284091] BTRFS info (device sdd): disk space caching is enabled
> [372668.321999] ------------[ cut here ]------------
> [372668.322060] WARNING: CPU: 1 PID: 23395 at fs/btrfs/super.c:260
> __btrfs_abort_transaction+0x5f/0x130 [btrfs]()
> [372668.322147] BTRFS: Transaction aborted (error -95)
> [372668.322152] Modules linked in: btrfs xor raid6_pq binfmt_misc af_packet
> ipt_REJECT nf_reject_ipv4 xt_conntrack iptable_filter ipt_MASQUERADE
> nf_nat_masquerade_ipv4 xt_nat xt_tcpudp iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge stp llc ip_tables
> x_tables joydev hid_generic usbhid xhci_pci xhci_hcd ohci_pci
> snd_hda_codec_via snd_hda_codec_generic ehci_pci snd_hda_codec_hdmi ohci_hcd
> ehci_hcd usbcore snd_hda_intel snd_hda_controller snd_hda_codec kvm_amd kvm
> snd_hwdep crct10dif_pclmul snd_pcm crc32_pclmul crc32c_intel ppdev
> ghash_clmulni_intel aesni_intel aes_x86_64 lrw snd_timer e1000 gf128mul
> glue_helper r8169 ablk_helper snd parport_pc mii cryptd serio_raw parport
> shpchp pcspkr edac_core sp5100_tco usb_common button fam15h_power wmi
> i2c_piix4 edac_mce_amd soundcore
> [372668.322610]  k10temp asus_atk0110 acpi_cpufreq processor sch_fq_codel
> [372668.322652] CPU: 1 PID: 23395 Comm: kworker/u16:3 Tainted: G        W
> 4.0.2-gentoo-2-default #1
> [372668.322721] Hardware name: System manufacturer System Product
> Name/M5A78L-M/USB3, BIOS 2001    09/11/2014
> [372668.322803] Workqueue: btrfs-endio-write btrfs_endio_write_helper
> [btrfs]
> [372668.322840]  ffffffffa04bfe32 ffff8801e8937c08 ffffffff816edc91
> 0000000000000007
> [372668.322911]  ffff8801e8937c58 ffff8801e8937c48 ffffffff81056675
> ffff8801e8937ce8
> [372668.322986]  ffff8803ad83fd28 00000000ffffffa1 ffff880147d2a800
> ffffffffa04bea60
> [372668.323058] Call Trace:
> [372668.323097]  [<ffffffff816edc91>] dump_stack+0x45/0x57
> [372668.323134]  [<ffffffff81056675>] warn_slowpath_common+0x95/0xe0
> [372668.323171]  [<ffffffff81056706>] warn_slowpath_fmt+0x46/0x50
> [372668.323219]  [<ffffffffa0454e65>] ? try_merge_map+0x45/0x150 [btrfs]
> [372668.323261]  [<ffffffffa040f46f>] __btrfs_abort_transaction+0x5f/0x130
> [btrfs]
> [372668.323339]  [<ffffffffa0447b82>] btrfs_finish_ordered_io+0x552/0x5e0
> [btrfs]
> [372668.323418]  [<ffffffffa0447e85>] finish_ordered_fn+0x15/0x20 [btrfs]
> [372668.323466]  [<ffffffffa046f168>] normal_work_helper+0xb8/0x2a0 [btrfs]
> [372668.323515]  [<ffffffffa046f4e2>] btrfs_endio_write_helper+0x12/0x20
> [btrfs]
> [372668.323552]  [<ffffffff8106ed63>] process_one_work+0x153/0x410
> [372668.323589]  [<ffffffff8106f7bb>] worker_thread+0x6b/0x480
> [372668.323693]  [<ffffffff8106f750>] ? rescuer_thread+0x300/0x300
> [372668.323730]  [<ffffffff8107473b>] kthread+0xdb/0x100
> [372668.323767]  [<ffffffff81074660>] ? kthread_create_on_node+0x190/0x190
> [372668.323805]  [<ffffffff816f4218>] ret_from_fork+0x58/0x90
> [372668.323845]  [<ffffffff81074660>] ? kthread_create_on_node+0x190/0x190
> [372668.323885] ---[ end trace c0894b8b0ebe359e ]---
> [372668.323925] BTRFS: error (device sdd) in btrfs_finish_ordered_io:2896:
> errno=-95 unknown
>

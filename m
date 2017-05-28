Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pb-smtp2.pobox.com ([64.147.108.71]:54839 "EHLO
        sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750762AbdE1CyY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 May 2017 22:54:24 -0400
Received: from sasl.smtp.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id DC5818C889
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 22:46:03 -0400 (EDT)
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id D52808C888
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 22:46:03 -0400 (EDT)
Received: from mail-lf0-f47.google.com (unknown [209.85.215.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id D8D178C884
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 22:46:02 -0400 (EDT)
Received: by mail-lf0-f47.google.com with SMTP id 99so20884053lfu.1
        for <linux-btrfs@vger.kernel.org>; Sat, 27 May 2017 19:46:02 -0700 (PDT)
MIME-Version: 1.0
From: Bill Williamson <bill@bbqninja.com>
Date: Sun, 28 May 2017 12:46:00 +1000
Message-ID: <CAHPjZW7Af2KzRr_HTaCNGqRAM0SsV8+gJWSRis6eCjGeXNBK7Q@mail.gmail.com>
Subject: btrfs mounts RO, kernel oops on RW
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Version details:
btrfs-progs v4.9.1
Linux bigserver 4.10.0-22-generic #24-Ubuntu SMP Mon May 22 17:43:20
UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

Array Details:
root@bigserver:~# btrfs fi df /mnt/storage
Data, RAID1: total=12.48TiB, used=12.25TiB
System, RAID1: total=32.00MiB, used=2.11MiB
Metadata, RAID1: total=14.00GiB, used=13.31GiB
GlobalReserve, single: total=512.00MiB, used=0.00


root@bigserver:~# btrfs fi show /mnt/storage
Label: none  uuid: c792d033-b0a6-44a0-bd37-9825de7eeb8b
        Total devices 10 FS bytes used 12.27TiB
        devid    1 size 2.73TiB used 2.71TiB path /dev/sde
        devid    2 size 3.64TiB used 3.62TiB path /dev/sdh
        devid    5 size 1.82TiB used 1.80TiB path /dev/sdg
        devid    6 size 1.82TiB used 1.80TiB path /dev/sdc
        devid    8 size 1.36TiB used 1.35TiB path /dev/sdb
        devid    9 size 3.64TiB used 3.62TiB path /dev/sdf
        devid   12 size 1.82TiB used 1.80TiB path /dev/sdd
        devid   13 size 4.55TiB used 4.53TiB path /dev/sdk
        devid   14 size 3.64TiB used 3.62TiB path /dev/sdi
        devid   15 size 3.64TiB used 134.00GiB path /dev/sdj


Issue:
I can mount my btrfs readonly (recovery option not necessary).
Attempting to mount it readwrite results in a kernel null pointer
exception.

Background:
I have a home server with a bunch of disks running btrfs raid 1.  When
it starts to fill up I add another disk and re-balance.
I added a new 4TB disk and began the re-balance.  After a while I
needed to shut down the server, and did so gracefully with a shutdown
-h now.  Upon rebooting the array wouldn't mount, so I put "noauto"
into fstab to allow a graceful bootup and diagnose from there.

At first I got the failed to read log tree error, so I ran
btrfs-zero-log.  It walked back 3-4 transactions but now seems okay.
After that fix:
- btrfs check shows no errors.
- mounting the filesystem RO works great, I can read files.
- mounting the filesystem RW results in a huge kernel exception and a
hang, centering around can_overcommit and
btrfs_async_reclaim_metadata_space

My "you're screwed, it's dead" backup plan is to build another server
and buy 2x8TB drives, and then copy the data I care about over, but
I'd much rather save myself the trouble and $$$ and repair the array
if possible.

I'd also like to learn what happened so that I can avoid it in the future.

Thanks,

Bill Williamson


Full exception as it shows up in syslog (I've trimmed the big datetime
stamp to the left of each entry).

BTRFS info (device sdb): disk space caching is enabled
BUG: unable to handle kernel NULL pointer dereference at 00000000000001f0
IP: can_overcommit+0x28/0x110 [btrfs]
PGD 20dd42067
PUD 20abdc067
PMD 0

Oops: 0000 [#1] SMP
Modules linked in: binfmt_misc ppdev edac_mce_amd edac_core kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
aesni_intel aes_x86_64 crypto_simd glue_helper cryptd serio_raw joydev
input_leds k10temp fam15h_power i2c_piix4 snd_hda_codec_via
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hda_core snd_hwdep snd_pcm snd_timer parport_pc snd soundcore
asus_atk0110 shpchp mac_hid lp parport ip_tables x_tables autofs4
btrfs xor raid6_pq pata_acpi hid_microsoft usbhid hid amdkfd
amd_iommu_v2 radeon i2c_algo_bit ttm drm_kms_helper syscopyarea
sysfillrect psmouse sysimgblt fb_sys_fops mvsas drm pata_atiixp ahci
r8169 libsas libahci mii scsi_transport_sas wmi fjes
CPU: 7 PID: 2779 Comm: kworker/u16:3 Not tainted 4.10.0-22-generic #24-Ubuntu
Hardware name: System manufacturer System Product Name/M5A78L-M/USB3,
BIOS 1503    11/14/2012
Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
task: ffff88b6c7855a00 task.stack: ffffb66443524000
RIP: 0010:can_overcommit+0x28/0x110 [btrfs]
RSP: 0018:ffffb66443527dc0 EFLAGS: 00010286
RAX: 0000000001000000 RBX: ffff88b785f4d400 RCX: 0000000000000002
RDX: 0000000000800000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffb66443527df8 R08: 0000000000000008 R09: ffff88b785f4d4a8
R10: ffffffff8fd92d40 R11: 0000000000001ee0 R12: ffff88b785f4d4b8
R13: 0000000000800000 R14: 0000000000000000 R15: ffff88b785f4d400
FS:  0000000000000000(0000) GS:ffff88b79edc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000001f0 CR3: 0000000213c57000 CR4: 00000000000406e0
Call Trace:
? __switch_to+0x23c/0x520
btrfs_async_reclaim_metadata_space+0x378/0x440 [btrfs]
process_one_work+0x1fc/0x4b0
worker_thread+0x4b/0x500
kthread+0x109/0x140
? process_one_work+0x4b0/0x4b0
? kthread_create_on_node+0x60/0x60
ret_from_fork+0x2c/0x40
Code: 0f 1f 00 0f 1f 44 00 00 f6 46 58 01 0f 85 f0 00 00 00 55 48 89
e5 41 57 41 56 41 55 41 54 49 89 d5 53 48 89 f3 31 f6 48 83 ec 10 <4c>
8b b7 f0 01 00 00 89 4d cc 49 3b 7e 38 4d 8d be 48 01 00 00
RIP: can_overcommit+0x28/0x110 [btrfs] RSP: ffffb66443527dc0
CR2: 00000000000001f0
---[ end trace 2bcd6443af9da872 ]---

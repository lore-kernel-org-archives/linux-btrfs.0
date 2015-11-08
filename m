Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34408 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbbKHQ7n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Nov 2015 11:59:43 -0500
Received: by qgeb1 with SMTP id b1so73706682qge.1
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Nov 2015 08:59:42 -0800 (PST)
Received: from [10.0.0.3] (ool-182cf564.dyn.optonline.net. [24.44.245.100])
        by smtp.googlemail.com with ESMTPSA id h49sm251852qgh.41.2015.11.08.08.59.42
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Nov 2015 08:59:42 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Charles Wright <wrighrc@gmail.com>
Subject: soft lockup when using btrfs dev del
Message-ID: <563F7F7D.4050608@gmail.com>
Date: Sun, 8 Nov 2015 11:59:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
     I'm running Linux 4.3 and also btrfs-progs-v4.3

I'm replacing one drive with another in my system.  Both drives are 
healthy as far as I know.

I can start btrfs dev del and it will run for a while and then I get a 
cpu soft lockup.

I've restarted the process a few times and each time it runs a while, 
getting a bit further and then I get the cpu soft lockup again.  (at 
which point the I/O has stopped and I typically have to hard power the 
system)

I do this to monitor the progress.

root@x1:~# while sleep 60; do /apps/src/btrfs-progs-v4.3/btrfs fi show 
/mnt/btrfs-seagate2tbp3-root; done
Label: none  uuid: eebd1291-7ccd-49da-b3c3-93942527ead4
     Total devices 2 FS bytes used 1.48TiB
     devid    1 size 0.00B used 420.04GiB path 
/dev/mapper/seagate2tbp3_crypt
     devid    2 size 1.82TiB used 1.08TiB path /dev/mapper/sde1_crypt

btrfs-progs v4.3
Label: none  uuid: eebd1291-7ccd-49da-b3c3-93942527ead4
     Total devices 2 FS bytes used 1.48TiB
     devid    1 size 0.00B used 418.04GiB path 
/dev/mapper/seagate2tbp3_crypt
     devid    2 size 1.82TiB used 1.08TiB path /dev/mapper/sde1_crypt

Any suggestions on how to prevent this from happening?

Thanks.

Nov  8 01:02:30 x1 kernel: [22954.038620] NMI watchdog: BUG: soft lockup 
- CPU#1 stuck for 22s! [btrfs:3086]
Nov  8 01:02:30 x1 kernel: [22954.038621] Modules linked in: pci_stub 
vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) ipt_REJECT 
nf_reject_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_tcpudp 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
iptable_filter ip_tables x_tables usblp snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_codec_generic nls_utf8 nls_cp437 vfat 
intel_rapl fat iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp 
kvm_intel kvm snd_hda_intel snd_hda_codec snd_hda_core snd_pcsp 
snd_hwdep serio_raw snd_pcm snd_timer snd soundcore i2c_i801 efivars 
i915 evdev i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt 
fb_sys_fops drm mei_me shpchp mei battery wmi video button acpi_pad 
processor fuse efivarfs autofs4 algif_skcipher af_alg hid_generic usbhid 
dm_crypt dm_mod sg sr_mod cdrom sd_mod crct10dif_pclmul crc32_pclmul 
crc32c_intel jitterentropy_rng sha256_ssse3 sha256_generic hmac drbg 
ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper 
cryptd ahci libahci xhci_pci libata xhci_hcd scsi_mod usbcore usb_common 
fan thermal i2c_hid i2c_core hid
Nov  8 01:02:30 x1 kernel: [22954.038684] CPU: 1 PID: 3086 Comm: btrfs 
Tainted: G        W  O    4.3.0 #1
Nov  8 01:02:30 x1 kernel: [22954.038685] Hardware name: Gigabyte 
Technology Co., Ltd. To be filled by O.E.M./H170M-DS3H-CF, BIOS F2 
10/14/2015
Nov  8 01:02:30 x1 kernel: [22954.038686] task: ffff8803f30e91c0 ti: 
ffff8803f2e28000 task.ti: ffff8803f2e28000
Nov  8 01:02:30 x1 kernel: [22954.038687] RIP: 
0010:[<ffffffff815e5060>]  [<ffffffff815e5060>] _raw_spin_lock+0x10/0x20
Nov  8 01:02:30 x1 kernel: [22954.038702] RSP: 0018:ffff8803f2e2baf8  
EFLAGS: 00000246
Nov  8 01:02:30 x1 kernel: [22954.038703] RAX: 0000000000000000 RBX: 
ffff8803f2e2bb38 RCX: 0000000000000000
Nov  8 01:02:30 x1 kernel: [22954.038704] RDX: 0000000000000001 RSI: 
ffff880471c9cf00 RDI: ffff88028d94dd70
Nov  8 01:02:30 x1 kernel: [22954.038704] RBP: ffff880131e94800 R08: 
ffff88046108a000 R09: 00000000ffffffe2
Nov  8 01:02:30 x1 kernel: [22954.038705] R10: 000000000000002a R11: 
000000000000000b R12: ffff88028d94d800
Nov  8 01:02:30 x1 kernel: [22954.038706] R13: ffff8803f2e2bb38 R14: 
ffff8801e6a48800 R15: ffff88028d94dd78
Nov  8 01:02:30 x1 kernel: [22954.038706] FS: 00007f9ad24948c0(0000) 
GS:ffff880471c80000(0000) knlGS:0000000000000000
Nov  8 01:02:30 x1 kernel: [22954.038707] CS:  0010 DS: 0000 ES: 0000 
CR0: 0000000080050033
Nov  8 01:02:30 x1 kernel: [22954.038708] CR2: 00000000014e2d38 CR3: 
00000003d8989000 CR4: 00000000003406e0
Nov  8 01:02:30 x1 kernel: [22954.038709] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Nov  8 01:02:30 x1 kernel: [22954.038709] DR3: 0000000000000000 DR6: 
00000000fffe0ff0 DR7: 0000000000000400
Nov  8 01:02:30 x1 kernel: [22954.038710] Stack:
Nov  8 01:02:30 x1 kernel: [22954.038710]  ffffffff812f41e7 
ffff8803f2e2bb38 ffff880131e94800 ffff88028d94d800
Nov  8 01:02:30 x1 kernel: [22954.038711]  ffffffff812f42dd 
ffff880131e94bc0 ffffffff812f8b00 000000005698f3c0
Nov  8 01:02:30 x1 kernel: [22954.038713]  ffff880131e94bc0 
ffff880131e94bc0 ffff88028d94d8e8 ffff8802a77e6f50
Nov  8 01:02:30 x1 kernel: [22954.038714] Call Trace:
Nov  8 01:02:30 x1 kernel: [22954.038716] [<ffffffff812f41e7>] ? 
__del_reloc_root+0x27/0x100
Nov  8 01:02:30 x1 kernel: [22954.038718] [<ffffffff812f42dd>] ? 
free_reloc_roots+0x1d/0x30
Nov  8 01:02:30 x1 kernel: [22954.038719] [<ffffffff812f8b00>] ? 
merge_reloc_roots+0x170/0x230
Nov  8 01:02:30 x1 kernel: [22954.038720] [<ffffffff812f8ffc>] ? 
relocate_block_group+0x43c/0x670
Nov  8 01:02:30 x1 kernel: [22954.038721] [<ffffffff812f93d0>] ? 
btrfs_relocate_block_group+0x1a0/0x280
Nov  8 01:02:30 x1 kernel: [22954.038723] [<ffffffff812d1691>] ? 
btrfs_relocate_chunk.isra.36+0x41/0xc0
Nov  8 01:02:30 x1 kernel: [22954.038724] [<ffffffff812d203b>] ? 
btrfs_shrink_device+0x19b/0x520
Nov  8 01:02:30 x1 kernel: [22954.038725] [<ffffffff812d6058>] ? 
btrfs_rm_device+0x2a8/0x820
Nov  8 01:02:30 x1 kernel: [22954.038727] [<ffffffff812e1869>] ? 
btrfs_ioctl+0x19d9/0x27b0
Nov  8 01:02:30 x1 kernel: [22954.038729] [<ffffffff811b605a>] ? 
filename_lookup+0xda/0x150
Nov  8 01:02:30 x1 kernel: [22954.038731] [<ffffffff810ee1ae>] ? 
from_kgid_munged+0xe/0x20
Nov  8 01:02:30 x1 kernel: [22954.038733] [<ffffffff811ac053>] ? 
cp_new_stat+0x143/0x160
Nov  8 01:02:30 x1 kernel: [22954.038734] [<ffffffff811b9943>] ? 
do_vfs_ioctl+0x2c3/0x490
Nov  8 01:02:30 x1 kernel: [22954.038735] [<ffffffff811ac099>] ? 
SYSC_newstat+0x29/0x40
Nov  8 01:02:30 x1 kernel: [22954.038737] [<ffffffff811b9b4b>] ? 
SyS_ioctl+0x3b/0x70
Nov  8 01:02:30 x1 kernel: [22954.038738] [<ffffffff815e53b6>] ? 
entry_SYSCALL_64_fastpath+0x16/0x75
Nov  8 01:02:30 x1 kernel: [22954.038739] Code: 8b 07 85 c0 74 03 31 c0 
c3 ba 01 00 00 00 f0 0f b1 17 85 c0 75 f0 b0 01 c3 66 90 0f 1f 44 00 00 
31 c0 ba 01 00 00 00 f0 0f b1 17 <85> c0 75 01 c3 89 c6 e9 a4 34 ac ff 
0f 1f 40 00 0f 1f 44 00 00

-- 
Copyright © Charles Wright 2015 All Rights Reserved.
No part of this message may be reproduced, forwarded
or published without Charles Wright's express written consent.
Thanks for your cooperation.


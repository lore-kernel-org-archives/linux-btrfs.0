Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63777 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3JIPx2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 11:53:28 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so1241225pab.18
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2013 08:53:28 -0700 (PDT)
Date: Wed, 9 Oct 2013 23:53:23 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/relocation.c:2255!
Message-ID: <20131009155323.GA11404@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I hit a BUG_ON while playing with btrfs balance. Kernel is
3.12-rc4.

The reproducer is a script doing subvolume create/mount/umount/delete
in loop at back ground and do balance at the same time.

It's reproducable everytime. And seems like this is a regression, I
cannot reproduce it on 3.10 kernel. (I'll write a test case for
xfstests.)

Reproducer:

# cat test.sh
#!/bin/bash

btrfs_dev=$1
btrfs_mnt=$2
pid=$$
subvol_mnt=/mnt/subvol_$pid

mkdir -p $subvol_mnt

trap "umount $subvol_mnt; btrfs sub del $btrfs_mnt/sub_$pid; rmdir $subvol_mnt; exit 0" 0 1 2 3 15

while true;do
        btrfs subvolume create $btrfs_mnt/sub_$pid
        mount -o subvol=sub_$pid $btrfs_dev $subvol_mnt
        umount $subvol_mnt
        btrfs subvolume delete $btrfs_mnt/sub_$pid
done

and do

# mkfs -t btrfs -f /dev/loop0 /dev/loop1
# mount /dev/loop0 /mnt/btrfs
# ./test.sh /dev/loop0 /mnt/btrfs >/dev/null &
# btrfs fi balance /mnt/btrfs

Thanks,
Eryu Guan

---

Console log:

[  522.722337] ------------[ cut here ]------------
[  522.746792] kernel BUG at fs/btrfs/relocation.c:2255!
[  522.771882] invalid opcode: 0000 [#1] SMP
[  522.793021] Modules linked in: btrfs raid6_pq xor iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi sg igb iTCO_wdt ptp nfsd iTCO_vendor_support hpilo pps_core hpwdt auth_rpcgss sb_edac shpchp ioatdma ipmi_si lpc_ich edac_core mfd_core ipmi_msghandler dca acpi_power_meter microcode(+) serio_raw pcspkr nfs_acl acpi_cpufreq lockd sunrpc xfs libcrc32c mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm sd_mod crc_t10dif crct10dif_common drm mpt2sas hpsa raid_class i2c_core scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  523.044562] CPU: 3 PID: 5017 Comm: btrfs Not tainted 3.12.0-rc4+ #6
[  523.075900] Hardware name: Hewlett-Packard ProLiant DL388eGen8, BIOS P73 06/01/2012
[  523.115866] task: ffff880427a8c590 ti: ffff8800adba4000 task.ti: ffff8800adba4000
[  523.154002] RIP: 0010:[<ffffffffa069452e>]  [<ffffffffa069452e>] prepare_to_merge+0x148/0x1d2 [btrfs]
[  523.201194] RSP: 0018:ffff8800adba5b10  EFLAGS: 00010202
[  523.229041] RAX: fffffffffffffffe RBX: ffff88041f03d800 RCX: 0000000000000000
[  523.264378] RDX: 0000000000000000 RSI: 000000000a8a0a88 RDI: ffff8804243c0068
[  523.301155] RBP: ffff8800adba5b50 R08: ffff880426e24800 R09: ffff88042524b0d0
[  523.336509] R10: 000000000000003b R11: ffffea0010946300 R12: ffff88042518a0a0
[  523.373527] R13: ffff880426d20000 R14: 00000000fffffffe R15: ffff880426d20458
[  523.410232] FS:  00007f76a14bd780(0000) GS:ffff88043f460000(0000) knlGS:0000000000000000   
[  523.450607] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  523.480881] CR2: 00007fa57fc7fcc8 CR3: 00000000ac8e5000 CR4: 00000000000407e0
[  523.516852] Stack:
[  523.527781]  ffff88041f03dd90 ffff880426d21458 ffff880426d21458 ffff88041f03d800
[  523.566639]  ffff8804251441b0 ffff88041f03d908 ffff88041f03d8e8 ffff88042518a0a0
[  523.605131]  ffff8800adba5bc8 ffffffffa067538d fffffffe243c0900 ffff8804fffffffe
[  523.642256] Call Trace:
[  523.656123]  [<ffffffffa067538d>] relocate_block_group+0x3ad/0x690 [btrfs]
[  523.690950]  [<ffffffffa064118e>] ? btrfs_wait_all_ordered_extents+0x10e/0x140 [btrfs]
[  523.731975]  [<ffffffffa067580d>] btrfs_relocate_block_group+0x19d/0x2e0 [btrfs]
[  523.768891]  [<ffffffffa064cc58>] btrfs_relocate_chunk.isra.28+0x68/0x730 [btrfs]
[  523.807471]  [<ffffffffa06070f0>] ? btrfs_search_slot+0x390/0x970 [btrfs]
[  523.842172]  [<ffffffffa0642eb9>] ? release_extent_buffer+0xa9/0xd0 [btrfs]
[  523.877129]  [<ffffffffa0648c3f>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
[  523.912715]  [<ffffffffa06509eb>] __btrfs_balance+0x45b/0x820 [btrfs]
[  523.946676]  [<ffffffffa0651169>] btrfs_balance+0x3b9/0x670 [btrfs]
[  523.979359]  [<ffffffffa06586b4>] btrfs_ioctl_balance+0x164/0x520 [btrfs]
[  524.013768]  [<ffffffffa065c70d>] btrfs_ioctl+0xc6d/0x1f10 [btrfs]
[  524.044743]  [<ffffffff8107df78>] ? ptrace_do_notify+0x88/0xa0
[  524.074378]  [<ffffffff811c8395>] do_vfs_ioctl+0x2e5/0x4d0
[  524.102532]  [<ffffffff812ada16>] ? file_has_perm+0x86/0xa0
[  524.130290]  [<ffffffff811c8601>] SyS_ioctl+0x81/0xa0
[  524.156487]  [<ffffffff8163a277>] tracesys+0xdd/0xe2
[  524.181309] Code: a8 fb ff ff e8 44 f1 c8 e0 49 8b b7 88 fd ff ff 49 8b bf 90 fd ff ff 4d 89 3f 4d 89 7f 08 e8 7a a5 fd ff 48 3d 00 f0 ff ff 76 02 <0f> 0b 4c 39 68 18 74 02 0f 0b 45 85 f6 75 0b 41 c7 87 a0 fc ff
[  524.278478] RIP  [<ffffffffa069452e>] prepare_to_merge+0x148/0x1d2 [btrfs]
[  524.312841]  RSP <ffff8800adba5b10>
[  524.331155] ---[ end trace aa7142976f8b0598 ]---

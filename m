Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33298 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbbAOTqc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 14:46:32 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so37481341wiw.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jan 2015 11:46:31 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Jan 2015 20:46:30 +0100
Message-ID: <CADurGxwv9gyiA49dY12c5sZsZFc57BvfPbsXE5KRo-OU_J-iAg@mail.gmail.com>
Subject: Kernel bug in 3.19-rc4
From: Marcel Ritter <ritter.marcel@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I just started some btrfs stress testing on latest linux kernel 3.19-rc4:
A few hours later, filesystem stopped working - the kernel bug report
can be found below.

The test consists of one massive IO thread (writing 100GB files with dd),
and 2 tar instances extracting kernel sources and deleting them afterwards
(I can provide the simple bash script doing this, if needed).

System information (Ubuntu 14.04.1, latest kernel):

root@thunder # uname -a
Linux thunder 3.19.0-rc4-custom #1 SMP Mon Jan 12 16:13:44 CET 2015
x86_64 x86_64 x86_64 GNU/Linux

root@thunder # /root/btrfs-progs/btrfs --version
Btrfs v3.18-36-g0173148

Tests are done on 14 SCSI disks, using raid6 for data and metadata:

root@thunder # /root/btrfs-progs/btrfs fi show
Label: 'raid6'  uuid: cbe34d2b-5f75-46cf-9263-9813028ebc19
        Total devices 14 FS bytes used 674.62GiB
        devid    1 size 279.39GiB used 59.24GiB path /dev/cciss/c1d0
        devid    2 size 279.39GiB used 59.22GiB path /dev/cciss/c1d1
        devid    3 size 279.39GiB used 59.22GiB path /dev/cciss/c1d10
        devid    4 size 279.39GiB used 59.22GiB path /dev/cciss/c1d11
        devid    5 size 279.39GiB used 59.22GiB path /dev/cciss/c1d12
        devid    6 size 279.39GiB used 59.22GiB path /dev/cciss/c1d13
        devid    7 size 279.39GiB used 59.22GiB path /dev/cciss/c1d2
        devid    8 size 279.39GiB used 59.22GiB path /dev/cciss/c1d3
        devid    9 size 279.39GiB used 59.22GiB path /dev/cciss/c1d4
        devid   10 size 279.39GiB used 59.22GiB path /dev/cciss/c1d5
        devid   11 size 279.39GiB used 59.22GiB path /dev/cciss/c1d6
        devid   12 size 279.39GiB used 59.22GiB path /dev/cciss/c1d7
        devid   13 size 279.39GiB used 59.22GiB path /dev/cciss/c1d8
        devid   14 size 279.39GiB used 59.22GiB path /dev/cciss/c1d9

Btrfs v3.18-36-g0173148

# This is provided for completeness only, and is taken
# somewhen *before* the kernel crash occured, so basic
# setup is the same, but allocated/free sizes won't match
root@thunder # /root/btrfs-progs/btrfs fi df /tmp/m
Data, single: total=8.00MiB, used=0.00B
Data, RAID6: total=727.45GiB, used=697.84GiB
System, single: total=4.00MiB, used=0.00B
System, RAID6: total=13.50MiB, used=64.00KiB
Metadata, single: total=8.00MiB, used=0.00B
Metadata, RAID6: total=3.43GiB, used=805.91MiB
GlobalReserve, single: total=272.00MiB, used=0.00B


Here's what happens after some hours of stress testing:

[85162.472989] ------------[ cut here ]------------
[85162.473071] kernel BUG at fs/btrfs/inode.c:3142!
[85162.473139] invalid opcode: 0000 [#1] SMP
[85162.473212] Modules linked in: btrfs(E) xor(E) raid6_pq(E)
radeon(E) ttm(E) drm_kms_helper(E) drm(E) hpwdt(E) amd64_edac_mod(E)
kvm(E) edac_core(E) shpchp(E) k8temp(E) serio_raw(E) hpilo(E)
edac_mce_amd(E) mac_hid(E) i2c_algo_bit(E) ipmi_si(E) nfsd(E)
auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E) lp(E)
fscache(E) parport(E) hid_generic(E) usbhid(E) hid(E) hpsa(E)
psmouse(E) bnx2(E) cciss(E) pata_acpi(E) pata_amd(E)
[85162.473911] CPU: 4 PID: 3039 Comm: btrfs-cleaner Tainted: G
   E  3.19.0-rc4-custom #1
[85162.474028] Hardware name: HP ProLiant DL585 G2   , BIOS A07 05/02/2011
[85162.474122] task: ffff88085b054aa0 ti: ffff88205ad4c000 task.ti:
ffff88205ad4c000
[85162.474230] RIP: 0010:[<ffffffffa06a8182>]  [<ffffffffa06a8182>]
btrfs_orphan_add+0x1d2/0x1e0 [btrfs]
[85162.474422] RSP: 0018:ffff88205ad4fc48  EFLAGS: 00010286
[85162.474497] RAX: 00000000ffffffe4 RBX: ffff8810a35d42f8 RCX: ffff88185b896000
[85162.474595] RDX: 0000000000006a54 RSI: 0000000000040000 RDI: ffff88185b896138
[85162.474694] RBP: ffff88205ad4fc88 R08: 000000000001e670 R09: ffff88016194b240
[85162.474793] R10: ffffffffa06bd797 R11: ffffea0004f71800 R12: ffff88185baa2000
[85162.474892] R13: ffff88085f6d7630 R14: ffff88185baa2458 R15: 0000000000000001
[85162.474992] FS:  00007fb3f27fb740(0000) GS:ffff88085fd00000(0000)
knlGS:0000000000000000
[85162.475105] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[85162.475184] CR2: 00007f896c02c220 CR3: 000000085b328000 CR4: 00000000000007e0
[85162.475286] Stack:
[85162.475318]  ffff88205ad4fc88 ffffffffa06e6a14 ffff88185b896b04
ffff88105b03e800
[85162.475442]  ffff88016194b240 ffff8810a35d42f8 ffff881e8ffe9a00
ffff88133dc48ea0
[85162.475561]  ffff88205ad4fd18 ffffffffa0691a57 ffff88016194b244
ffff88016194b240
[85162.475680] Call Trace:
[85162.475738]  [<ffffffffa06e6a14>] ?
lookup_free_space_inode+0x44/0x100 [btrfs]
[85162.475849]  [<ffffffffa0691a57>]
btrfs_remove_block_group+0x137/0x740 [btrfs]
[85162.475964]  [<ffffffffa06ca8d2>] btrfs_remove_chunk+0x672/0x780 [btrfs]
[85162.476065]  [<ffffffffa06922bf>] btrfs_delete_unused_bgs+0x25f/0x280 [btrfs]
[85162.476172]  [<ffffffffa0699e0c>] cleaner_kthread+0x12c/0x190 [btrfs]
[85162.476269]  [<ffffffffa0699ce0>] ? check_leaf+0x350/0x350 [btrfs]
[85162.476355]  [<ffffffff8108f8d2>] kthread+0xd2/0xf0
[85162.476424]  [<ffffffff8108f800>] ? kthread_create_on_node+0x180/0x180
[85162.476519]  [<ffffffff8177bcbc>] ret_from_fork+0x7c/0xb0
[85162.476592]  [<ffffffff8108f800>] ? kthread_create_on_node+0x180/0x180
[85162.476648] Code: ff ff 0f 1f 80 00 00 00 00 89 45 c8 f0 80 63 80
fd 48 89 df e8 d0 23 fe ff 8b 45 c8 e9 14 ff ff ff b8 f4 ff ff ff e9
12 ff ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
55 48
[85162.476648] RIP  [<ffffffffa06a8182>] btrfs_orphan_add+0x1d2/0x1e0 [btrfs]
[85162.476648]  RSP <ffff88205ad4fc48>
[85162.640076] ---[ end trace 396c6a6abc5a7fce ]---

One reboot later, creating a new, clean filesystem and running the
same tests again:

[30204.556282] ------------[ cut here ]------------
[30204.556358] kernel BUG at fs/btrfs/inode.c:3142!
[30204.556422] invalid opcode: 0000 [#1] SMP
[30204.556492] Modules linked in: btrfs(E) xor(E) radeon(E) ttm(E)
drm_kms_helper(E) raid6_pq(E) drm(E) kvm(E) amd64_edac_mod(E)
edac_core(E) i2c_algo_bit(E) edac_mce_amd(E) mac_hid(E) shpchp(E)
serio_raw(E) k8temp(E) hpwdt(E) ipmi_si(E) hpilo(E) nfsd(E)
auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)
fscache(E) lp(E) parport(E) hpsa(E) hid_generic(E) usbhid(E) hid(E)
pata_acpi(E) psmouse(E) bnx2(E) cciss(E) pata_amd(E)
[30204.557194] CPU: 2 PID: 2186 Comm: btrfs-cleaner Tainted: G
   E  3.19.0-rc4-custom #1
[30204.557313] Hardware name: HP ProLiant DL585 G2   , BIOS A07 05/02/2011
[30204.557407] task: ffff88105b644aa0 ti: ffff88185c2b8000 task.ti:
ffff88185c2b8000
[30204.557510] RIP: 0010:[<ffffffffa0dab182>]  [<ffffffffa0dab182>]
btrfs_orphan_add+0x1d2/0x1e0 [btrfs]
[30204.557687] RSP: 0018:ffff88185c2bbc48  EFLAGS: 00010286
[30204.557762] RAX: 00000000ffffffe4 RBX: ffff881091e9fca0 RCX: ffff88205bb15000
[30204.557860] RDX: 000000000000bd74 RSI: 0000000000040000 RDI: ffff88205bb15138
[30204.557959] RBP: ffff88185c2bbc88 R08: 000000000001e670 R09: ffff8810a3c963f0
[30204.558058] R10: ffffffffa0dc0797 R11: ffffea004255ba00 R12: ffff882059bc5000
[30204.558157] R13: ffff8818588526e0 R14: ffff882059bc5458 R15: 0000000000000001
[30204.558256] FS:  00007f34ad4b3840(0000) GS:ffff88185fc00000(0000)
knlGS:0000000000000000
[30204.558374] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[30204.558453] CR2: 00007fab99cbe700 CR3: 0000000fbd16c000 CR4: 00000000000007e0
[30204.558552] Stack:
[30204.558582]  ffff88185c2bbc88 ffffffffa0de9a14 ffff88205bb15b04
ffff88205c62e000
[30204.558707]  ffff8810a3c963f0 ffff881091e9fca0 ffff88105b02c000
ffff8808b9130480
[30204.558826]  ffff88185c2bbd18 ffffffffa0d94a57 ffff8810a3c963f4
ffff8810a3c963f0
[30204.558945] Call Trace:
[30204.558996]  [<ffffffffa0de9a14>] ?
lookup_free_space_inode+0x44/0x100 [btrfs]
[30204.559102]  [<ffffffffa0d94a57>]
btrfs_remove_block_group+0x137/0x740 [btrfs]
[30204.559210]  [<ffffffffa0dcd8d2>] btrfs_remove_chunk+0x672/0x780 [btrfs]
[30204.559306]  [<ffffffffa0d952bf>] btrfs_delete_unused_bgs+0x25f/0x280 [btrfs]
[30204.559408]  [<ffffffffa0d9ce0c>] cleaner_kthread+0x12c/0x190 [btrfs]
[30204.559501]  [<ffffffffa0d9cce0>] ? check_leaf+0x350/0x350 [btrfs]
[30204.559583]  [<ffffffff8108f8d2>] kthread+0xd2/0xf0
[30204.559649]  [<ffffffff8108f800>] ? kthread_create_on_node+0x180/0x180
[30204.559743]  [<ffffffff8177bcbc>] ret_from_fork+0x7c/0xb0
[30204.559816]  [<ffffffff8108f800>] ? kthread_create_on_node+0x180/0x180
[30204.559907] Code: ff ff 0f 1f 80 00 00 00 00 89 45 c8 f0 80 63 80
fd 48 89 df e8 d0 23 fe ff 8b 45 c8 e9 14 ff ff ff b8 f4 ff ff ff e9
12 ff ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
55 48
[30204.560138] RIP  [<ffffffffa0dab182>] btrfs_orphan_add+0x1d2/0x1e0 [btrfs]
[30204.560138]  RSP <ffff88185c2bbc48>
[30204.719832] ---[ end trace bbc20b459964e0ed ]---

Maybe this helps to locate the error. If I can do more tests, or
provide more necessary information to diagnose this, please let me
know.

Bye,
    Marcel

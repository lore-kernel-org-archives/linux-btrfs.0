Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753647AbcLRVgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Dec 2016 16:36:14 -0500
MIME-Version: 1.0
Message-ID: <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Giuseppe Della Bianca" <bepi@adria.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Content-Type: text/plain; charset=UTF-8
Date: Sun, 18 Dec 2016 22:36:10 +0100
In-Reply-To: <9712851.I7FUyRd5GC@exnet.gdb.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
 <CAJCQCtRpppbJb4a_zEdRFi7Fbxnhg5VkLktHuLMW2Z0H-cOkDg@mail.gmail.com>
 <2329571.vMCvUE5AeF@exnet.gdb.it>, <9712851.I7FUyRd5GC@exnet.gdb.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Giuseppe,

Would you like to tell some details about:
1. the XYZ snapshot was taken from which subvolume
2. where the base (initial) snapshot is stored
3. The 3 partitions receives the same snapshot, are they in the same btrfs configuration and subvol structure?

Also, would you send the link reports "two files unreadable error" post mentioned in step 2? 
Hope can see the message and figure out if the issue first comes from sender or receiver side. 

Thanks,
Xin
 

Sent: Sunday, December 18, 2016 at 11:59 AM
From: "Giuseppe Della Bianca" <bepi@adria.it>
To: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
> Same problem, this time on a local subvolume.
>
> kernel-4.8.8-100.fc23.x86_64
>
> btrfs-progs v4.8.5
]zac[

I had three filesystem corruption.

The point at which the problem it appeared, is similar in all three cases.

Subvolume structure and operations sequence:

btrfsreceive/
btrfsreceive/root/
btrfsreceive/root/.part/

1) Sending XYZ differential snapshot in to ' btrfsreceive/root/.part/ '.
2) Create snapshot from ' btrfsreceive/root/.part/XYZ ' to ' btrfsreceive/root
/XYZ '.
3) Delete snapshot ' btrfsreceive/root/.part/XYZ '.

Always in step 2) I had two files unreadable error (view previous posts), and
one already existing object error (see below).

All three times I had to re-create from scratch the various partitions (on
disks and systems different).

I can help you, in some way, to find the problem?

Or is useless to continue report it?



dic 18 18:29:58 exnetold.gdb.it kernel: ------------[ cut here ]------------
dic 18 18:29:58 exnetold.gdb.it kernel: WARNING: CPU: 1 PID: 4325 at
fs/btrfs/extent-tree.c:2960 btrfs_run_delayed_refs+0x283/0x2b0 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: BTRFS: Transaction aborted (error -17)
dic 18 18:29:58 exnetold.gdb.it kernel: Modules linked in: fuse xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun nf_conntrack_netbios_ns
nf_conntrack_br
dic 18 18:29:58 exnetold.gdb.it kernel: soundcore acpi_cpufreq tpm_tis
tpm_tis_core tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc ata_generic
nouveau vide
dic 18 18:29:58 exnetold.gdb.it kernel: CPU: 1 PID: 4325 Comm: umount Tainted:
G W 4.8.8-100.fc23.x86_64 #1
dic 18 18:29:58 exnetold.gdb.it kernel: Hardware name: System manufacturer
System Product Name/M2N, BIOS 0902 02/16/2009
dic 18 18:29:58 exnetold.gdb.it kernel: 0000000000000286 00000000dd260fac
ffff8ffa0d25bb60 ffffffffbc3e493e
dic 18 18:29:58 exnetold.gdb.it kernel: ffff8ffa0d25bbb0 0000000000000000
ffff8ffa0d25bba0 ffffffffbc0a0ecb
dic 18 18:29:58 exnetold.gdb.it kernel: 00000b9000000049 ffff8ff9e61b40a0
ffff8ffa2da77800 ffffffffffffffff
dic 18 18:29:58 exnetold.gdb.it kernel: Call Trace:
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc3e493e>] dump_stack+0x63/0x85
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc0a0ecb>] __warn+0xcb/0xf0
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc0a0f4f>]
warn_slowpath_fmt+0x5f/0x80
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07eb4e3>]
btrfs_run_delayed_refs+0x283/0x2b0 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07d62ec>] ?
btrfs_cow_block+0x10c/0x1e0 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07ff62e>]
commit_cowonly_roots+0xae/0x2e0 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07eb466>] ?
btrfs_run_delayed_refs+0x206/0x2b0 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc08706b4>] ?
btrfs_qgroup_account_extents+0x84/0x180 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc0802187>]
btrfs_commit_transaction+0x547/0xa40 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07faa9f>]
btrfs_commit_super+0x8f/0xa0 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07fcbcb>]
close_ctree+0x2db/0x380 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc26d3da>] ?
evict_inodes+0x15a/0x180
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07ccf29>]
btrfs_put_super+0x19/0x20 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc2520bf>]
generic_shutdown_super+0x6f/0xf0
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc2523b2>]
kill_anon_super+0x12/0x20
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffc07cdd98>]
btrfs_kill_super+0x18/0x110 [btrfs]
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc252763>]
deactivate_locked_super+0x43/0x70
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc2527ec>]
deactivate_super+0x5c/0x60
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc2711bf>]
cleanup_mnt+0x3f/0x90
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc271252>]
__cleanup_mnt+0x12/0x20
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc0bf0ce>]
task_work_run+0x7e/0xa0
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc0032d2>]
exit_to_usermode_loop+0xc2/0xd0
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc003bf1>]
syscall_return_slowpath+0xa1/0xb0
dic 18 18:29:58 exnetold.gdb.it kernel: [<ffffffffbc7ffb3a>]
entry_SYSCALL_64_fastpath+0xa2/0xa4
dic 18 18:29:58 exnetold.gdb.it kernel: ---[ end trace f7eb2e818f727168 ]---
dic 18 18:29:58 exnetold.gdb.it kernel: BTRFS: error (device sda3) in
btrfs_run_delayed_refs:2960: errno=-17 Object already exists
dic 18 18:29:58 exnetold.gdb.it kernel: BTRFS info (device sda3): forced
readonly
dic 18 18:29:58 exnetold.gdb.it kernel: BTRFS warning (device sda3): Skipping
commit of aborted transaction.
dic 18 18:29:58 exnetold.gdb.it kernel: BTRFS: error (device sda3) in
cleanup_transaction:1854: errno=-17 Object already exists
dic 18 18:29:58 exnetold.gdb.it kernel: BTRFS error (device sda3): commit
super ret -17
dic 18 18:29:58 exnetold.gdb.it kernel: BTRFS error (device sda3): cleaner
transaction attach returned -30

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html

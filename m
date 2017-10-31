Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:41654 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdJaOSZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 10:18:25 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 1233CF9F60C
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:18:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 14:18:17 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 31 Oct 2017 23:18:15 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to run balance successfully (No space left on device)?
In-Reply-To: <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
References: <5ff267d206ae631e9d259eacacdf7924@wpkg.org>
 <19a1770cf67e63a84c3baeeb44af9e9a@wpkg.org>
Message-ID: <c6c0eb84c550f44ffe443d625c198a39@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-18 17:20, Tomasz Chmielewski wrote:
>>> # df -h /var/lib/lxd
>>> 
>>> FWIW, standard (aka util-linux) df is effectively useless in a 
>>> situation
>>> such as this, as it really doesn't give you the information you need 
>>> (it
>>> can say you have lots of space available, but if btrfs has all of it
>>> allocated into chunks, even if the chunks have space in them still, 
>>> there
>>> can be problems).
> 
> I see here on RAID-1, "df -h" it shows pretty much the same amount of
> free space as "btrfs fi show":
> 
> - "df -h" shows 105G free
> - "btrfs fi show" says: Free (estimated):            104.28GiB
> (min: 104.28GiB)
> 
> 
> 
>> But chances are pretty good that one you get that patch integrated,
>> whether by integrating it yourself to what you have currently, or by
>> trying 4.14-rc1 or waiting until it hits release or stable, that bug 
>> will
>> have been squashed! =:^)
> 
> OK, will wait for 4.14.

So I've tried to run balance with 4.14-rc6.

It succeeded on one server where it was failing with 4.13.x.


On a different server, however, it failed badly:

# time btrfs balance start /srv
WARNING:

         Full balance without filters requested. This operation is very
         intense and takes potentially very long. It is recommended to
         use the balance filters to narrow down the scope of balance.
         Use 'btrfs balance start --full-balance' option to skip this
         warning. The operation will start in 10 seconds.
         Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
ERROR: error during balancing '/srv': Read-only file system
There may be more info in syslog - try dmesg | tail

real    5194m41.749s
user    0m0.000s
sys     301m10.928s


[312304.050731] BTRFS info (device sda4): found 15073 extents
[313555.971253] BTRFS info (device sda4): relocating block group 
1208022466560 flags data|raid1
[314963.506580] BTRFS: Transaction aborted (error -28)
[314963.506608] ------------[ cut here ]------------
[314963.506639] WARNING: CPU: 2 PID: 27854 at 
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:3089 
btrfs_run_delayed_refs+0x244/0x250 [btrfs]
[314963.506640] Modules linked in: vhost_net vhost tap xt_REDIRECT 
nf_nat_redirect xt_NFLOG nfnetlink_log nfnetlink xt_conntrack veth 
ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 
nf_nat_ipv6 ip6table_filter ip6_tables xt_comment xt_CHECKSUM 
binfmt_misc iptable_mangle nf_log_ipv4 nf_log_common xt_LOG 
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ipt_REJECT nf_reject_ipv4 
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc btrfs 
zstd_compress shpchp intel_rapl lpc_ich x86_pkg_temp_thermal 
intel_powerclamp input_leds tpm_infineon ie31200_edac serio_raw coretemp 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel kvm_intel pcbc kvm 
aesni_intel irqbypass aes_x86_64 mac_hid crypto_simd glue_helper cryptd 
intel_cstate
[314963.506684]  eeepc_wmi asus_wmi sparse_keymap intel_rapl_perf 
wmi_bmof nfsd auth_rpcgss nfs_acl lockd grace sunrpc lp parport autofs4 
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx xor raid6_pq libcrc32c raid0 multipath linear raid1 e1000e ahci 
libahci ptp pps_core wmi video
[314963.506710] CPU: 2 PID: 27854 Comm: sadc Tainted: G        W       
4.14.0-041400rc6-generic #201710230731
[314963.506711] Hardware name: System manufacturer System Product 
Name/P8B WS, BIOS 0904 10/24/2011
[314963.506713] task: ffff8bc0fd39ae00 task.stack: ffffb28d49490000
[314963.506732] RIP: 0010:btrfs_run_delayed_refs+0x244/0x250 [btrfs]
[314963.506734] RSP: 0018:ffffb28d49493d30 EFLAGS: 00010286
[314963.506736] RAX: 0000000000000026 RBX: 00000000ffffffe4 RCX: 
0000000000000000
[314963.506737] RDX: 0000000000000000 RSI: ffff8bc8afa8dc98 RDI: 
ffff8bc8afa8dc98
[314963.506738] RBP: ffffb28d49493d88 R08: 0000000000000001 R09: 
000000000000242b
[314963.506740] R10: ffffb28d49493c20 R11: 0000000000000000 R12: 
ffff8bc883a81078
[314963.506741] R13: ffff8bc887eb0000 R14: ffff8bc1876ec400 R15: 
000000000018ba90
[314963.506743] FS:  00007f62a12d9700(0000) GS:ffff8bc8afa80000(0000) 
knlGS:0000000000000000
[314963.506744] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[314963.506746] CR2: 00007f25f6f53880 CR3: 00000003cf4f7004 CR4: 
00000000000626e0
[314963.506747] Call Trace:
[314963.506773]  btrfs_commit_transaction+0x9b/0x8d0 [btrfs]
[314963.506799]  ? btrfs_wait_ordered_range+0x9c/0x110 [btrfs]
[314963.506821]  btrfs_sync_file+0x348/0x410 [btrfs]
[314963.506826]  vfs_fsync_range+0x4b/0xb0
[314963.506828]  do_fsync+0x3d/0x70
[314963.506831]  SyS_fdatasync+0x13/0x20
[314963.506834]  do_syscall_64+0x61/0x120
[314963.506838]  entry_SYSCALL64_slow_path+0x25/0x25
[314963.506840] RIP: 0033:0x7f62a0dfec30
[314963.506841] RSP: 002b:00007fffca89f288 EFLAGS: 00000246 ORIG_RAX: 
000000000000004b
[314963.506844] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 
00007f62a0dfec30
[314963.506845] RDX: 0000000000000000 RSI: 00007f62a10c47a0 RDI: 
0000000000000003
[314963.506846] RBP: 00007fffca89f400 R08: 00007f62a12d9700 R09: 
00007f62a12d9700
[314963.506847] R10: 00007fffca89f050 R11: 0000000000000246 R12: 
00000000ffffffff
[314963.506848] R13: 00007fffca89f440 R14: 00007fffca89f2a0 R15: 
00007fffca89f29c
[314963.506851] Code: fe ff 89 d9 ba 11 0c 00 00 48 c7 c6 40 48 67 c0 4c 
89 e7 e8 c5 bc 09 00 e9 b5 fe ff ff 89 de 48 c7 c7 f8 b4 67 c0 e8 2d 28 
51 d2 <0f> ff eb d3 e8 3a be 09 00 0f 1f 00 66 66 66 66 90 55 48 89 e5
[314963.506889] ---[ end trace b11381065314a695 ]---
[314963.506955] BTRFS: error (device sda4) in 
btrfs_run_delayed_refs:3089: errno=-28 No space left
[314963.507032] BTRFS info (device sda4): forced readonly
[314963.510570] BTRFS warning (device sda4): Skipping commit of aborted 
transaction.
[314963.510577] BTRFS: error (device sda4) in cleanup_transaction:1873: 
errno=-28 No space left
[314970.954768] mail[32290]: segfault at c0 ip 00007f6b507ae33b sp 
00007ffec4849ac0 error 4 in libmailutils.so.4.0.0[7f6b50724000+b0000]
[314983.475988] BTRFS error (device sda4): pending csums is 167936




# btrfs fi show /srv
Label: 'btrfs'  uuid: 105b2e0c-8af2-45ee-b4c8-14ff0a3ca899
         Total devices 2 FS bytes used 2.31TiB
         devid    1 size 2.63TiB used 2.32TiB path /dev/sda4
         devid    2 size 2.63TiB used 2.32TiB path /dev/sdb4


# btrfs fi df /srv
Data, RAID1: total=2.30TiB, used=2.29TiB
System, RAID1: total=32.00MiB, used=384.00KiB
Metadata, RAID1: total=22.00GiB, used=19.61GiB
GlobalReserve, single: total=512.00MiB, used=481.56MiB



# btrfs fi usage /srv
Overall:
     Device size:                   5.25TiB
     Device allocated:              4.63TiB
     Device unallocated:          633.97GiB
     Device missing:                  0.00B
     Used:                          4.62TiB
     Free (estimated):            319.11GiB      (min: 319.11GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 481.56MiB)

Data,RAID1: Size:2.30TiB, Used:2.29TiB
    /dev/sda4       2.30TiB
    /dev/sdb4       2.30TiB

Metadata,RAID1: Size:22.00GiB, Used:19.61GiB
    /dev/sda4      22.00GiB
    /dev/sdb4      22.00GiB

System,RAID1: Size:32.00MiB, Used:384.00KiB
    /dev/sda4      32.00MiB
    /dev/sdb4      32.00MiB

Unallocated:
    /dev/sda4     316.99GiB
    /dev/sdb4     316.99GiB


Tomasz Chmielewski
https://lxadm.com

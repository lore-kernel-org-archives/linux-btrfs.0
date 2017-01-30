Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:50252 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754346AbdA3UyB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 15:54:01 -0500
Received: from dhcp-18-189-2-92.dyn.mit.edu ([18.189.2.92])
        by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.71)
        (envelope-from <matt@techsquare.com>)
        id 1cYITB-0008Nb-Dl
        for linux-btrfs@vger.kernel.org; Mon, 30 Jan 2017 15:22:35 -0500
To: linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <652f29d1-86fb-4984-f3c7-b59a88bec8b8@techsquare.com>
Date: Mon, 30 Jan 2017 15:22:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Hard crash on 4.9.5, part 2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have an error on this file system I've had in the distant pass where 
the mount would fail with a "file exists" error.  Running a btrfs check 
gives the following over and over again:

Found file extent holes:
         start: 0, len: 290816
root 257 inode 28472371 errors 1000, some csum missing
root 257 inode 28472416 errors 1000, some csum missing
root 257 inode 9182183 errors 1000, some csum missing
root 257 inode 9182186 errors 1000, some csum missing
root 257 inode 28419536 errors 1100, file extent discount, some csum missing
Found file extent holes:
         start: 0, len: 290816
root 257 inode 28472371 errors 1000, some csum missing
root 257 inode 28472416 errors 1000, some csum missing
root 257 inode 9182183 errors 1000, some csum missing
root 257 inode 9182186 errors 1000, some csum missing
root 257 inode 28419536 errors 1100, file extent discount, some csum missing


Are these found per subvolume snapshot I have and will eventually end?

Here is the crash after the mount (with recovery/usebackuproot):

[  627.233213] BTRFS warning (device sda1): 'recovery' is deprecated, 
use 'usebackuproot' instead
[  627.233216] BTRFS info (device sda1): trying to use backup root at 
mount time
[  627.233218] BTRFS info (device sda1): disk space caching is enabled
[  627.233220] BTRFS info (device sda1): has skinny extents
[  709.234688] ------------[ cut here ]------------
[  709.234734] WARNING: CPU: 5 PID: 3468 at fs/btrfs/file.c:546 
btrfs_drop_extent_cache+0x3e8/0x400 [btrfs]
[  709.234735] Modules linked in: ipmi_devintf nfsd auth_rpcgss nfs_acl 
nfs lockd grace sunrpc fscache lp parport intel_rapl sb_edac
  edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel 
xt_tcpudp kvm nf_conntrack_ipv4 nf_defrag_ipv4 irqbypass crct10d
if_pclmul crc32_pclmul ghash_clmulni_intel xt_conntrack aesni_intel 
btrfs nf_conntrack aes_x86_64 lrw gf128mul iptable_filter glue_h
elper ip_tables ablk_helper cryptd x_tables dm_multipath joydev mei_me 
ioatdma mei lpc_ich wmi ipmi_si ipmi_msghandler shpchp mac_hi
d ses enclosure scsi_transport_sas raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor hid_generic megarai
d_sas raid6_pq ahci libcrc32c libahci igb usbhid raid1 hid i2c_algo_bit 
raid0 dca ptp multipath pps_core linear dm_mirror dm_region_
hash dm_log
[  709.234812] CPU: 5 PID: 3468 Comm: mount Not tainted 4.9.5-custom #1
[  709.234813] Hardware name: Supermicro 
X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
[  709.234816]  ffffbd3784bb7568 ffffffff8e3c8e7c 0000000000000000 
0000000000000000
[  709.234820]  ffffbd3784bb75a8 ffffffff8e07d3d1 0000022200000070 
ffff9e5f0ae4d150
[  709.234823]  000000000002d000 ffff9e5f0bc91f78 ffff9e5f0bc91da8 
000000000002c000
[  709.234827] Call Trace:
[  709.234837]  [<ffffffff8e3c8e7c>] dump_stack+0x63/0x87
[  709.234846]  [<ffffffff8e07d3d1>] __warn+0xd1/0xf0
[  709.234850]  [<ffffffff8e07d4bd>] warn_slowpath_null+0x1d/0x20
[  709.234874]  [<ffffffffc07e47a8>] btrfs_drop_extent_cache+0x3e8/0x400 
[btrfs]
[  709.234895]  [<ffffffffc07e50b2>] __btrfs_drop_extents+0x5b2/0xd30 
[btrfs]
[  709.234914]  [<ffffffffc07a57bb>] ? 
generic_bin_search.constprop.36+0x8b/0x1e0 [btrfs]
[  709.234931]  [<ffffffffc07a3396>] ? btrfs_set_path_blocking+0x36/0x70 
[btrfs]
[  709.234942]  [<ffffffff8e1e83e4>] ? kmem_cache_alloc+0x194/0x1a0
[  709.234958]  [<ffffffffc07a335a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  709.234977]  [<ffffffffc07e6899>] btrfs_drop_extents+0x79/0xa0 [btrfs]
[  709.235002]  [<ffffffffc08131e4>] replay_one_extent+0x414/0x7b0 [btrfs]
[  709.235007]  [<ffffffff8e0c1580>] ? autoremove_wake_function+0x40/0x40
[  709.235030]  [<ffffffffc0813a4c>] replay_one_buffer+0x4cc/0x7c0 [btrfs]
[  709.235053]  [<ffffffffc07ed8ef>] ? 
mark_extent_buffer_accessed+0x4f/0x70 [btrfs]
[  709.235074]  [<ffffffffc080e21a>] walk_down_log_tree+0x1ba/0x3b0 [btrfs]
[  709.235094]  [<ffffffffc080e694>] walk_log_tree+0xb4/0x1a0 [btrfs]
[  709.235114]  [<ffffffffc0816bce>] btrfs_recover_log_trees+0x20e/0x460 
[btrfs]
[  709.235133]  [<ffffffffc0813580>] ? replay_one_extent+0x7b0/0x7b0 [btrfs]
[  709.235154]  [<ffffffffc07ccad0>] open_ctree+0x2640/0x27f0 [btrfs]
[  709.235171]  [<ffffffffc07a0804>] btrfs_mount+0xca4/0xec0 [btrfs]
[  709.235176]  [<ffffffff8e3def8e>] ? find_next_zero_bit+0x1e/0x20
[  709.235180]  [<ffffffff8e1aae0e>] ? pcpu_next_unpop+0x3e/0x50
[  709.235184]  [<ffffffff8e3def69>] ? find_next_bit+0x19/0x20
[  709.235190]  [<ffffffff8e213789>] mount_fs+0x39/0x160
[  709.235193]  [<ffffffff8e1ac045>] ? __alloc_percpu+0x15/0x20
[  709.235196]  [<ffffffff8e22fc57>] vfs_kern_mount+0x67/0x110
[  709.235213]  [<ffffffffc079fceb>] btrfs_mount+0x18b/0xec0 [btrfs]
[  709.235216]  [<ffffffff8e3def8e>] ? find_next_zero_bit+0x1e/0x20
[  709.235220]  [<ffffffff8e213789>] mount_fs+0x39/0x160
[  709.235223]  [<ffffffff8e1ac045>] ? __alloc_percpu+0x15/0x20
[  709.235225]  [<ffffffff8e22fc57>] vfs_kern_mount+0x67/0x110
[  709.235228]  [<ffffffff8e23229b>] do_mount+0x1bb/0xc80
[  709.235232]  [<ffffffff8e1e853b>] ? kmem_cache_alloc_trace+0x14b/0x1b0
[  709.235235]  [<ffffffff8e233053>] SyS_mount+0x83/0xd0
[  709.235240]  [<ffffffff8e800dfb>] entry_SYSCALL_64_fastpath+0x1e/0xad
[  709.235243] ---[ end trace d4e5dcddb432b7d3 ]---
[  709.354972] BTRFS: error (device sda1) in btrfs_replay_log:2506: 
errno=-17 Object already exists (Failed to recover log tree)
[  709.355570] BTRFS error (device sda1): cleaner transaction attach 
returned -30
[  709.548919] BTRFS error (device sda1): open_ctree failed


-Matt

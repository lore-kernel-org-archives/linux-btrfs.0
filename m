Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:55005 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932574AbcHJAaG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 20:30:06 -0400
To: Chris Murphy <lists@colorremedies.com>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
 <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
 <CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <34532105-4411-2a21-a83d-e48f4311400a@techsquare.com>
Date: Tue, 9 Aug 2016 20:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Spoke too soon.  Do I need to continue to run with that mount option in 
place?


[   83.775984] BTRFS warning (device sda1): block group 25741009879040 
has wrong amount of free space
[   83.775989] BTRFS warning (device sda1): failed to load free space 
cache for block group 25741009879040, rebuilding it now
[   85.231748] BTRFS warning (device sda1): block group 25737721544704 
has wrong amount of free space
[   85.231752] BTRFS warning (device sda1): failed to load free space 
cache for block group 25737721544704, rebuilding it now
[   98.913796] BTRFS info (device sda1): disk space caching is enabled
[   98.913803] BTRFS info (device sda1): has skinny extents
[  179.564408] BTRFS warning (device sda1): block group 78412513280 has 
wrong amount of free space
[  179.564414] BTRFS warning (device sda1): failed to load free space 
cache for block group 78412513280, rebuilding it now
[  667.106718] ------------[ cut here ]------------
[  667.106772] WARNING: CPU: 0 PID: 2726 at fs/btrfs/extent-tree.c:2963 
btrfs_run_delayed_refs+0x292/0x2d0 [btrfs]
[  667.106775] BTRFS: Transaction aborted (error -17)
[  667.106777] Modules linked in: ipt_REJECT nf_reject_ipv4 xt_tcpudp 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
iptable_filter ip_tables x_tables ipmi_devintf sb_edac edac_core 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel btrfs kvm 
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel 
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd dm_multipath 
joydev lpc_ich mei_me mei wmi ipmi_si ipmi_msghandler nfsd auth_rpcgss 
nfs_acl nfs lockd grace ioatdma sunrpc shpchp mac_hid fscache lp parport 
ses enclosure scsi_transport_sas raid10 raid456 async_raid6_recov 
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c 
hid_generic igb raid1 usbhid i2c_algo_bit ahci raid0 dca multipath ptp 
hid megaraid_sas libahci linear pps_core dm_mirror dm_region_hash dm_log
[  667.106859] CPU: 0 PID: 2726 Comm: btrfs-transacti Not tainted 
4.7.0-custom #1
[  667.106861] Hardware name: Supermicro 
X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
[  667.106864]  0000000000000000 ffff880464e73c08 ffffffff813b816c 
ffff880464e73c58
[  667.106869]  0000000000000000 ffff880464e73c48 ffffffff8107a321 
00000b936c3cc170
[  667.106873]  ffff880443191130 ffff88046c3cc170 ffff88046b43f000 
ffffffffffffffff
[  667.106878] Call Trace:
[  667.106889]  [<ffffffff813b816c>] dump_stack+0x63/0x87
[  667.106896]  [<ffffffff8107a321>] __warn+0xd1/0xf0
[  667.106901]  [<ffffffff8107a38f>] warn_slowpath_fmt+0x4f/0x60
[  667.106925]  [<ffffffffc06a2e52>] btrfs_run_delayed_refs+0x292/0x2d0 
[btrfs]
[  667.106947]  [<ffffffffc06a3be8>] 
btrfs_write_dirty_block_groups+0x178/0x3b0 [btrfs]
[  667.106974]  [<ffffffffc06b609c>] commit_cowonly_roots+0x23c/0x2e0 
[btrfs]
[  667.106999]  [<ffffffffc06b8d0b>] 
btrfs_commit_transaction+0x4fb/0xa80 [btrfs]
[  667.107021]  [<ffffffffc06b32b2>] transaction_kthread+0x1d2/0x200 [btrfs]
[  667.107042]  [<ffffffffc06b30e0>] ? 
btrfs_cleanup_transaction+0x580/0x580 [btrfs]
[  667.107047]  [<ffffffff81099109>] kthread+0xc9/0xe0
[  667.107053]  [<ffffffff817db85f>] ret_from_fork+0x1f/0x40
[  667.107056]  [<ffffffff81099040>] ? kthread_park+0x60/0x60
[  667.107060] ---[ end trace 336c80ba4db66e78 ]---
[  667.107065] BTRFS: error (device sda1) in 
btrfs_run_delayed_refs:2963: errno=-17 Object already exists
[  667.116389] BTRFS info (device sda1): forced readonly
[  667.117081] BTRFS warning (device sda1): Skipping commit of aborted 
transaction.
[  667.117086] BTRFS: error (device sda1) in cleanup_transaction:1853: 
errno=-17 Object already exists


On 08/09/2016 08:06 PM, Chris Murphy wrote:
> On Tue, Aug 9, 2016 at 6:01 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Tue, Aug 9, 2016 at 5:15 PM, Matt McKinnon <matt@techsquare.com> wrote:
>>> Hello,
>>>
>>> Our server recently crashed and was rebooted.  When it returned our BTRFS
>>> volume is mounting read-only:
>>
>> What happens when you try mounting with -o usebackuproot ?
>>
>> If that fails, what output do you get for 'btrfs check' (without
>> --repair)? If you only get some "errors 400, nbytes wrong" then
>> --repair should fix the problem.
>
> This could also be a regression somewhere...
> https://bugzilla.kernel.org/show_bug.cgi?id=60522
>
>

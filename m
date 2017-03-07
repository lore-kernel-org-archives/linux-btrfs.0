Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64695 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756022AbdCGUTM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 15:19:12 -0500
Subject: Re: BTRFS critical: corrupt leaf, slot offset bad; then read-only
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <7d3cccae-4761-4799-9ceb-2735519bee8f@gmx.net>
 <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
 <1774ecd3-a28c-908a-ec3b-bc98db36f34e@mendix.com>
 <f805f57f-eecb-03da-e480-5aed4474cdf5@gmx.net>
 <c08d6121-6cb7-ad9a-5d71-cd93d2f49196@mendix.com>
 <03805d15-11d4-090b-f81a-c7368eddd752@gmx.net>
 <52a26261-b913-adb4-a926-41550d404dec@mendix.com>
From: Lukas Tribus <lukyt@gmx.net>
Message-ID: <9b9499a7-413c-e897-4ad7-8a7eb40f3332@gmx.net>
Date: Tue, 7 Mar 2017 20:46:55 +0100
MIME-Version: 1.0
In-Reply-To: <52a26261-b913-adb4-a926-41550d404dec@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 07.03.2017 um 15:12 schrieb Hans van Kranenburg:
> On 03/05/2017 11:50 PM, Lukas Tribus wrote:
>>
>> I upgraded btrfs-tools to 4.8.1 as 4.4 didn't have btrfs
>> inspect-internal dump-tree.
>> But I cannot find anything about 5242107641856 in the dump-tree output.
>>
>> What does that mean?
> I have no idea. It probably means it's gone. Did you use the filesystem
> read/write? Are the symptoms also gone?
>

Well I read basically everything and copied it to other drivers. Nothing 
appears corrupted
from what I can tell. I didn't write to the pool consciously, although I 
did not mount it
readonly either not that I'm thinking about it ...


btrfs check --readonly reports block corruption (and a number of "no 
inode ref" in files/folders):

Checking filesystem on /dev/mapper/sda3_crypt
UUID: f50f980e-7640-49c7-bf8d-20d55cfe6005
The following tree block(s) is corrupted in tree 261:
         tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
The following tree block(s) is corrupted in tree 263:
         tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
The following tree block(s) is corrupted in tree 6685:
         tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
The following tree block(s) is corrupted in tree 6879:
         tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
The following tree block(s) is corrupted in tree 6893:
         tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
The following tree block(s) is corrupted in tree 6896:
         tree block bytenr: 5242107641856, level: 0, node key: 
(5241902333952, 169, 0)
found 4080263675904 bytes used err is 1
total csum bytes: 0
total tree bytes: 181780480
total fs tree bytes: 0
total extent tree bytes: 178765824
btree space waste bytes: 49102341
file data blocks allocated: 1545338880
  referenced 1545338880


Not sure how btrfs check finds a corrupted block that doesn't appear in 
the dump-tree output.


And I had an additional stack trace on the new btrfs pool I was copying 
the data to:

[873067.780479] BTRFS error (device sdf3): bdev /dev/sdf3 errs: wr 0, rd 
1, flush 0, corrupt 0, gen 0
[873067.790639] BTRFS error (device sdf3): bdev /dev/sdf3 errs: wr 0, rd 
2, flush 0, corrupt 0, gen 0
[873067.800708] ------------[ cut here ]------------
[873067.800727] WARNING: CPU: 3 PID: 12942 at 
/build/linux-hwe-6_oOe5/linux-hwe-4.8.0/fs/btrfs/extent-tree.c:6954 
__btrfs_free_extent.isra.71+0x2cb/0xcc0 [btrfs]
[873067.800730] BTRFS: Transaction aborted (error -5)
[873067.800731] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos 
jfs xfs algif_skcipher af_alg xen_gntdev xen_evtchn xenfs xen_privcmd 
dm_crypt intel_rapl x86_pkg_temp_thermal intel_powerclamp nls_iso8859_1 
coretemp crct10dif_pclmul crc32_pclmul ghash_clmulni_intel bridge stp 
llc intel_rapl_perf serio_raw lpc_ich joydev shpchp nuvoton_cir 
input_leds mei_me mei rc_core mac_hid ie31200_edac edac_core ib_iser 
rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi autofs4 uas usb_storage btrfs raid10 raid456 
async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq 
libcrc32c raid1 raid0 multipath linear hid_generic usbhid hid mxm_wmi 
aesni_intel aes_x86_64 i915 glue_helper lrw i2c_algo_bit ablk_helper tg3 
cryptd drm_kms_helper syscopyarea sysfillrect
[873067.800782]  firewire_ohci ptp sysimgblt psmouse firewire_core 
fb_sys_fops crc_itu_t pps_core ahci drm libahci wmi fjes video
[873067.800791] CPU: 3 PID: 12942 Comm: screen Tainted: G W       
4.8.0-39-generic #42~16.04.1-Ubuntu
[873067.800791] Hardware name: To Be Filled By O.E.M. To Be Filled By 
O.E.M./Z77 Extreme6, BIOS P2.80 07/01/2013
[873067.800793]  0000000000000200 00000000f56bf709 ffff880259f1f908 
ffffffff8142e043
[873067.800795]  ffff880259f1f958 0000000000000000 ffff880259f1f948 
ffffffff8108313b
[873067.800797]  00001b2a59f1faa0 00000000fffffffb 000001cda76bc000 
ffff8802a9fe0d20
[873067.800798] Call Trace:
[873067.800803]  [<ffffffff8142e043>] dump_stack+0x63/0x90
[873067.800805]  [<ffffffff8108313b>] __warn+0xcb/0xf0
[873067.800807]  [<ffffffff810831bf>] warn_slowpath_fmt+0x5f/0x80
[873067.800821]  [<ffffffffc03e22ab>] 
__btrfs_free_extent.isra.71+0x2cb/0xcc0 [btrfs]
[873067.800836]  [<ffffffffc04542af>] ? 
btrfs_merge_delayed_refs+0x8f/0x6a0 [btrfs]
[873067.800846]  [<ffffffffc03e7070>] 
__btrfs_run_delayed_refs+0xb10/0x12c0 [btrfs]
[873067.800857]  [<ffffffff811ad938>] ? set_page_dirty+0x58/0xb0
[873067.800869]  [<ffffffffc0428198>] ? 
set_extent_buffer_dirty+0x78/0xd0 [btrfs]
[873067.800879]  [<ffffffffc03ea8de>] btrfs_run_delayed_refs+0x8e/0x2b0 
[btrfs]
[873067.800890]  [<ffffffffc03fefee>] commit_cowonly_roots+0xae/0x300 
[btrfs]
[873067.800901]  [<ffffffffc0470fa4>] ? 
btrfs_qgroup_account_extents+0x84/0x180 [btrfs]
[873067.800911]  [<ffffffffc0401c33>] 
btrfs_commit_transaction+0x573/0xb00 [btrfs]
[873067.800920]  [<ffffffffc040225e>] ? start_transaction+0x9e/0x4c0 [btrfs]
[873067.800930]  [<ffffffffc03fa38f>] btrfs_commit_super+0x8f/0xa0 [btrfs]
[873067.800939]  [<ffffffffc03fc577>] close_ctree+0x2b7/0x360 [btrfs]
[873067.800947]  [<ffffffffc03cbf29>] btrfs_put_super+0x19/0x20 [btrfs]
[873067.800949]  [<ffffffff8123553f>] generic_shutdown_super+0x6f/0x100
[873067.800950]  [<ffffffff81235852>] kill_anon_super+0x12/0x20
[873067.800966]  [<ffffffffc03ccde8>] btrfs_kill_super+0x18/0x110 [btrfs]
[873067.800968]  [<ffffffff81235a23>] deactivate_locked_super+0x43/0x70
[873067.800969]  [<ffffffff81235efc>] deactivate_super+0x5c/0x60
[873067.800971]  [<ffffffff8125544f>] cleanup_mnt+0x3f/0x90
[873067.800972]  [<ffffffff812554e2>] __cleanup_mnt+0x12/0x20
[873067.800974]  [<ffffffff810a22fe>] task_work_run+0x7e/0xa0
[873067.800975]  [<ffffffff81087001>] do_exit+0x2d1/0xb50
[873067.800977]  [<ffffffff8106b4f5>] ? __do_page_fault+0x265/0x4e0
[873067.800978]  [<ffffffff81087903>] do_group_exit+0x43/0xb0
[873067.800979]  [<ffffffff81087984>] SyS_exit_group+0x14/0x20
[873067.800980]  [<ffffffff8189b7f6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
[873067.800981] ---[ end trace b0a630aaaf9a5946 ]---
[873067.800983] BTRFS: error (device sdf3) in __btrfs_free_extent:6954: 
errno=-5 IO failure
[873067.810114] BTRFS info (device sdf3): forced readonly
[873067.810116] BTRFS: error (device sdf3) in 
btrfs_run_delayed_refs:2960: errno=-5 IO failure
[873067.819481] BTRFS warning (device sdf3): Skipping commit of aborted 
transaction.
[873067.819482] BTRFS: error (device sdf3) in cleanup_transaction:1854: 
errno=-5 IO failure
[873067.828668] BTRFS error (device sdf3): commit super ret -5
[873067.835748] BTRFS error (device sdf3): cleaner transaction attach 
returned -30



I guess its time to rebuild this FS from scratch, unless you have a 
better idea?




Thanks, much appreciated,
Lukas


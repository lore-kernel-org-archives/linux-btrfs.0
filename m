Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:41839 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753664AbdJQDQa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 23:16:30 -0400
Received: from pool-96-252-13-8.bstnma.fios.verizon.net ([96.252.13.8] helo=[192.168.1.175])
        by techsquare.com with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.71)
        (envelope-from <matt@techsquare.com>)
        id 1e4Hg8-0003D3-R7
        for linux-btrfs@vger.kernel.org; Mon, 16 Oct 2017 22:32:37 -0400
To: linux-btrfs@vger.kernel.org
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <20473c65-e353-57cc-55f3-ea96eedc81a4@techsquare.com>
Date: Mon, 16 Oct 2017 22:32:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: kernel BUG at fs/btrfs/ctree.c:3182
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Been having issues on one machine and I was wondering if I could get 
some help tracking the issue down.

# uname -a
Linux riperton 4.13.5-custom #1 SMP Sat Oct 7 18:28:16 EDT 2017 x86_64 
x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.13.3

# btrfs fi show
Label: none  uuid: 8133a362-8e41-4da4-b607-a27832861157
         Total devices 1 FS bytes used 41.64TiB
         devid    1 size 50.93TiB used 41.88TiB path /dev/sda1

# btrfs fi df /export/
Data, single: total=41.70TiB, used=41.57TiB
System, DUP: total=64.00MiB, used=4.56MiB
Metadata, DUP: total=90.00GiB, used=72.30GiB
Metadata, single: total=1.53GiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B


[617994.948036] ------------[ cut here ]------------
[617994.948040] kernel BUG at fs/btrfs/ctree.c:3182!
[617994.952786] invalid opcode: 0000 [#1] SMP
[617994.956896] Modules linked in: ipmi_devintf xt_tcpudp 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack 
iptable_filter ip_tables x_tables intel_ra
pl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel btrfs pcbc 
aesni_intel aes_
x86_64 crypto_simd glue_helper cryptd dm_multipath joydev lpc_ich mei_me 
mei nfsd ioatdma auth_rpcgss nfs_acl ipmi_si wmi nfs ipmi_msghandler 
lockd grace sunrp
c fscache shpchp mac_hid lp parport ses enclosure scsi_transport_sas 
raid10 raid456 async_raid6_recov hid_generic async_memcpy async_pq 
usbhid async_xor hid as
ync_tx xor igb raid6_pq libcrc32c i2c_algo_bit raid1 ahci dca raid0 
libahci ptp megaraid_sas multipath pps_core linear dm_mirror 
dm_region_hash dm_log
[617995.025316] CPU: 1 PID: 3191 Comm: nfsd Tainted: G        W 
4.13.5-custom #1
[617995.032965] Hardware name: Supermicro 
X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
[617995.042092] task: ffff996bac7d5a00 task.stack: ffffbb7984b74000
[617995.048134] RIP: 0010:btrfs_set_item_key_safe+0x14e/0x160 [btrfs]
[617995.054310] RSP: 0018:ffffbb7984b77658 EFLAGS: 00010246
[617995.059622] RAX: 0000000000000000 RBX: 0000000000000037 RCX: 
0000000000018000
[617995.066834] RDX: 0000000000000000 RSI: ffffbb7984b7776e RDI: 
ffffbb7984b77677
[617995.074051] RBP: ffffbb7984b776b0 R08: ffffbb7984b77677 R09: 
0000000000000000
[617995.081263] R10: 0000000000000000 R11: 0000000000000003 R12: 
ffffbb7984b77666
[617995.088483] R13: ffff99679cc00460 R14: ffffbb7984b7776e R15: 
ffff9966184867a8
[617995.095705] FS:  0000000000000000(0000) GS:ffff9967afc80000(0000) 
knlGS:0000000000000000
[617995.103876] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[617995.109707] CR2: 00007fdbaad60000 CR3: 000000071fe09000 CR4: 
00000000001406e0
[617995.116921] Call Trace:
[617995.119493]  __btrfs_drop_extents+0x50c/0xdd0 [btrfs]
[617995.124663]  ? btrfs_encode_fh+0xd0/0xd0 [btrfs]
[617995.129390]  btrfs_log_changed_extents+0x31b/0x640 [btrfs]
[617995.134990]  ? free_extent_buffer+0x4b/0x90 [btrfs]
[617995.139976]  btrfs_log_inode+0x8de/0xb90 [btrfs]
[617995.144686]  ? dput+0xf1/0x1d0
[617995.147847]  btrfs_log_inode_parent+0x21a/0x960 [btrfs]
[617995.153164]  ? kmem_cache_alloc+0x194/0x1a0
[617995.157459]  ? start_transaction+0x120/0x440 [btrfs]
[617995.162528]  btrfs_log_dentry_safe+0x69/0x90 [btrfs]
[617995.167599]  btrfs_sync_file+0x2ab/0x3e0 [btrfs]
[617995.172309]  vfs_fsync_range+0x3d/0xb0
[617995.176168]  btrfs_file_write_iter+0x45b/0x560 [btrfs]
[617995.181396]  do_iter_readv_writev+0xe2/0x130
[617995.185753]  do_iter_write+0x7f/0x190
[617995.189506]  vfs_iter_write+0x19/0x30
[617995.193271]  nfsd_vfs_write+0xb1/0x310 [nfsd]
[617995.197719]  nfsd_write+0x134/0x1e0 [nfsd]
[617995.201908]  nfsd3_proc_write+0x92/0x110 [nfsd]
[617995.206533]  nfsd_dispatch+0xb9/0x250 [nfsd]
[617995.210915]  svc_process_common+0x36e/0x6f0 [sunrpc]
[617995.215979]  svc_process+0xfc/0x1c0 [sunrpc]
[617995.220339]  nfsd+0xe9/0x160 [nfsd]
[617995.223918]  kthread+0x109/0x140
[617995.227238]  ? nfsd_destroy+0x60/0x60 [nfsd]
[617995.231591]  ? kthread_park+0x60/0x60
[617995.235348]  ret_from_fork+0x25/0x30
[617995.239010] Code: 48 8b 45 bf 48 8d 7d c7 4c 89 f6 48 89 45 d0 0f b6 
45 be 88 45 cf 48 8b 45 b6 48 89 45 c7 e8 aa f3 ff ff 85 c0 0f 8f 55 ff 
ff ff <0f> 0b
0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
[617995.257983] RIP: btrfs_set_item_key_safe+0x14e/0x160 [btrfs] RSP: 
ffffbb7984b77658
[617995.265696] ---[ end trace 41d8bb716a419cdd ]---



And after a reboot we come up with this warning:



[  112.712899] ------------[ cut here ]------------
[  112.712943] WARNING: CPU: 5 PID: 505 at fs/btrfs/file.c:547 
btrfs_drop_extent_cache+0x3c5/0x3d0 [btrfs]
[  112.712944] Modules linked in: intel_rapl sb_edac 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel xt_tcpudp kvm 
nf_conntrack_ipv4 nf_defrag_ipv4 irqbypass xt_conntrack crct10dif_pclmul 
nf_conntrack crc32_pclmul ghash_clmulni_intel pcbc iptable_filter 
ip_tables aesni_intel x_tables aes_x86_64 crypto_simd glue_helper cryptd 
dm_multipath joydev mei_me lpc_ich mei wmi ipmi_si ipmi_msghandler 
ioatdma shpchp btrfs mac_hid lp parport ses enclosure scsi_transport_sas 
raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor 
async_tx hid_generic usbhid xor hid igb i2c_algo_bit raid6_pq libcrc32c 
dca raid1 ahci raid0 ptp megaraid_sas libahci multipath pps_core linear 
dm_mirror dm_region_hash dm_log
[  112.713000] CPU: 5 PID: 505 Comm: mount Not tainted 4.13.5-custom #1
[  112.713001] Hardware name: Supermicro 
X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014
[  112.713003] task: ffff9849ea549e00 task.stack: ffffa4a8449e8000
[  112.713022] RIP: 0010:btrfs_drop_extent_cache+0x3c5/0x3d0 [btrfs]
[  112.713023] RSP: 0018:ffffa4a8449eb5a8 EFLAGS: 00010287
[  112.713025] RAX: ffff9849e95c6f98 RBX: ffff9849ea485d90 RCX: 
0000000000000000
[  112.713026] RDX: 0000000000017fff RSI: 000000000001d000 RDI: 
ffff9849e95c6db0
[  112.713027] RBP: ffffa4a8449eb610 R08: 0000000000000001 R09: 
0000000000018000
[  112.713028] R10: 0000000000000000 R11: 0000000000000abf R12: 
000000000001d000
[  112.713029] R13: ffff9849e95c6f98 R14: ffff9849e95c6dd0 R15: 
0000000000018000
[  112.713030] FS:  00007f2eee389880(0000) GS:ffff9849ffc80000(0000) 
knlGS:0000000000000000
[  112.713032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  112.713033] CR2: 00007fe6d058a680 CR3: 0000000869c28000 CR4: 
00000000001406e0
[  112.713034] Call Trace:
[  112.713055]  __btrfs_drop_extents+0x5c9/0xdd0 [btrfs]
[  112.713070]  ? generic_bin_search.constprop.32+0x8b/0x1e0 [btrfs]
[  112.713084]  ? btrfs_set_path_blocking+0x36/0x70 [btrfs]
[  112.713098]  ? btrfs_search_slot+0x44e/0x950 [btrfs]
[  112.713104]  ? kmem_cache_alloc+0x194/0x1a0
[  112.713118]  ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  112.713134]  btrfs_drop_extents+0x79/0xa0 [btrfs]
[  112.713154]  replay_one_extent+0x229/0x7d0 [btrfs]
[  112.713173]  replay_one_buffer+0x4f7/0x7f0 [btrfs]
[  112.713192]  ? mark_extent_buffer_accessed+0x4f/0x70 [btrfs]
[  112.713210]  ? find_extent_buffer+0x50/0x90 [btrfs]
[  112.713228]  ? free_root_pointers+0x70/0x70 [btrfs]
[  112.713246]  walk_down_log_tree+0x1c5/0x340 [btrfs]
[  112.713263]  walk_log_tree+0xbf/0x190 [btrfs]
[  112.713278]  btrfs_recover_log_trees+0x20e/0x440 [btrfs]
[  112.713294]  ? replay_one_extent+0x7d0/0x7d0 [btrfs]
[  112.713311]  open_ctree+0x2560/0x2700 [btrfs]
[  112.713325]  btrfs_mount+0xcbb/0xee0 [btrfs]
[  112.713330]  ? find_next_bit+0xb/0x10
[  112.713334]  ? pcpu_next_unpop+0x3e/0x50
[  112.713335]  ? find_next_bit+0xb/0x10
[  112.713337]  ? pcpu_alloc+0x382/0x730
[  112.713341]  mount_fs+0x39/0x150
[  112.713343]  ? __alloc_percpu+0x15/0x20
[  112.713347]  vfs_kern_mount+0x67/0x110
[  112.713360]  btrfs_mount+0x18b/0xee0 [btrfs]
[  112.713362]  ? find_next_bit+0xb/0x10
[  112.713364]  ? pcpu_next_unpop+0x3e/0x50
[  112.713367]  mount_fs+0x39/0x150
[  112.713368]  ? __alloc_percpu+0x15/0x20
[  112.713371]  vfs_kern_mount+0x67/0x110
[  112.713373]  do_mount+0x1bb/0xc70
[  112.713375]  ? _copy_from_user+0x33/0x70
[  112.713378]  ? memdup_user+0x42/0x60
[  112.713380]  SyS_mount+0x83/0xd0
[  112.713384]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[  112.713386] RIP: 0033:0x7f2eed83e81a
[  112.713387] RSP: 002b:00007ffefa1bac68 EFLAGS: 00000202 ORIG_RAX: 
00000000000000a5
[  112.713389] RAX: ffffffffffffffda RBX: 00007f2eedb25764 RCX: 
00007f2eed83e81a
[  112.713390] RDX: 00000000007b01e0 RSI: 00000000007b01c0 RDI: 
00000000007b01a0
[  112.713390] RBP: 00007ffefa1bab94 R08: 0000000000000000 R09: 
00000000007b03c0
[  112.713391] R10: ffffffffc0ed0000 R11: 0000000000000202 R12: 
00007f2eedd2e400
[  112.713392] R13: 00007f2eedd2e400 R14: 0000000000000000 R15: 
00000000007b02e0
[  112.713394] Code: ff ff 48 89 4b 58 48 29 f2 49 03 57 50 48 89 53 50 
49 8b 47 38 48 89 43 38 eb b4 c7 45 b0 00 00 00 00 48 89 55 c8 e9 84 fc 
ff ff <0f> ff e9 61 fc ff ff 0f 1f 40 00 0f 1f 44 00 00 55 48 89 e5 41
[  112.713423] ---[ end trace a828ffcabb31a742 ]---




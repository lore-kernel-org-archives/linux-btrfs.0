Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33683 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbcBOEwT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 23:52:19 -0500
Received: by mail-ob0-f169.google.com with SMTP id jq7so12458682obb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Feb 2016 20:52:18 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 14 Feb 2016 23:52:18 -0500
Message-ID: <CALJXSJpwmOqXq07s_7N7shMCppTm4Kz80rOEAei_jW_XjP5KpQ@mail.gmail.com>
Subject: Out of memory purging snapshots
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I have encountered a weird out of memory problem using BTRFS,
snapshots and duperemove.
The workload is described as:
- Lots of static (400G/1T) data which was deduplicated using
duperemove which saved about 50GB.
- Backups are saved to the BTRFS every 2 days, backup take about 2 hours.
- Backups are deduped every weeks.
- Snapshots are taken every hour for 10 days.

After about 10 days worth of snapshot and 8 days worth of dedupe, the
system started slowing down after each snapshot removal.

I decided to wipe all snapshots and stop de-duping data, I proceeded
and removed snapshots 8 at a time, waiting for btrfs-transaction to
stop. After some time, PC locked up and I could not do anything else
but restart, reboot was caused because of the free memory and cache
being all used up. It seems the kernel module could not use any swap
and out of memory killer had no victim.

I was able to start the operation again by mounting using
thread_pool=1 and stopping all services, it went well for the first
~100 snapshots but then the condition appeared again, after multiple
attemps I tried mounting R/O and it worked.

I currently have a VM up on this machine which has 3GB RAM, the VM has
now 4GB RAM and the host has 4GB additional swap. It is currently
making progress but I think this might be considered as a bug. I have
some dmesg logs showing the problem.

16:53:17 srv kernel: [   68.040380] BTRFS info (device dm-6): disk
space caching is enabled
16:53:17 srv kernel: [   68.040385] BTRFS: has skinny extents
16:56:09 srv kernel: [  240.112032] INFO: task kworker/u8:6:162
blocked for more than 120 seconds.
16:56:09 srv kernel: [  240.112086]       Not tainted 4.2.0-27-generic
#32-Ubuntu
16:56:09 srv kernel: [  240.112124] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
16:56:09 srv kernel: [  240.112177] kworker/u8:6    D ffff8800bfa16640
    0   162      2 0x00000000
16:56:09 srv kernel: [  240.112213] Workqueue: btrfs-extent-refs
btrfs_extent_refs_helper [btrfs]
16:56:09 srv kernel: [  240.112217]  ffff880034f33c88 0000000000000046
ffffffff81c13500 ffff880000145780
16:56:09 srv kernel: [  240.112222]  0000000000000246 ffff880034f34000
ffff8800945b79f0 ffff8800945b79f0
16:56:09 srv kernel: [  240.112226]  ffff88005ddd1450 0000000000000001
ffff880034f33ca8 ffffffff817edc37
16:56:09 srv kernel: [  240.112230] Call Trace:
16:56:09 srv kernel: [  240.112239]  [<ffffffff817edc37>] schedule+0x37/0x80
16:56:09 srv kernel: [  240.112260]  [<ffffffffc03adc13>]
wait_current_trans.isra.21+0xd3/0x120 [btrfs]
16:56:09 srv kernel: [  240.112265]  [<ffffffff810bd760>] ?
wake_atomic_t_function+0x60/0x60
16:56:09 srv kernel: [  240.112286]  [<ffffffffc03af5ec>]
start_transaction+0x3ac/0x570 [btrfs]
16:56:09 srv kernel: [  240.112307]  [<ffffffffc03af807>]
btrfs_join_transaction+0x17/0x20 [btrfs]
16:56:09 srv kernel: [  240.112324]  [<ffffffffc0399d78>]
delayed_ref_async_start+0x18/0x90 [btrfs]
16:56:09 srv kernel: [  240.112346]  [<ffffffffc03e04aa>]
btrfs_scrubparity_helper+0xca/0x290 [btrfs]
16:56:09 srv kernel: [  240.112369]  [<ffffffffc03e06ae>]
btrfs_extent_refs_helper+0xe/0x10 [btrfs]
16:56:09 srv kernel: [  240.112374]  [<ffffffff810947ba>]
process_one_work+0x1aa/0x440
16:56:09 srv kernel: [  240.112378]  [<ffffffff81094a9b>]
worker_thread+0x4b/0x4c0
16:56:09 srv kernel: [  240.112382]  [<ffffffff81094a50>] ?
process_one_work+0x440/0x440
16:56:09 srv kernel: [  240.112386]  [<ffffffff8109ae38>] kthread+0xd8/0xf0
16:56:09 srv kernel: [  240.112390]  [<ffffffff8109ad60>] ?
kthread_create_on_node+0x1f0/0x1f0
16:56:09 srv kernel: [  240.112394]  [<ffffffff817f209f>]
ret_from_fork+0x3f/0x70
16:56:09 srv kernel: [  240.112398]  [<ffffffff8109ad60>] ?
kthread_create_on_node+0x1f0/0x1f0
16:56:09 srv kernel: [  240.112422] INFO: task mount:2323 blocked for
more than 120 seconds.
16:56:09 srv kernel: [  240.112466]       Not tainted 4.2.0-27-generic
#32-Ubuntu
16:56:09 srv kernel: [  240.112503] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
16:56:09 srv kernel: [  240.112555] mount           D 0000000000000000
    0  2323   2076 0x00000000
16:56:09 srv kernel: [  240.112560]  ffff8800b709b928 0000000000000086
ffff880000145780 ffff8800b8dd3e80
16:56:09 srv kernel: [  240.112564]  0000000000000246 ffff8800b709c000
ffff8800945b79f0 ffff8800945b79f0
16:56:09 srv kernel: [  240.112568]  ffff88005ddd1a10 0000000000000001
ffff8800b709b948 ffffffff817edc37
16:56:09 srv kernel: [  240.112573] Call Trace:
16:56:09 srv kernel: [  240.112577]  [<ffffffff817edc37>] schedule+0x37/0x80
16:56:09 srv kernel: [  240.112597]  [<ffffffffc03adc13>]
wait_current_trans.isra.21+0xd3/0x120 [btrfs]
16:56:09 srv kernel: [  240.112600]  [<ffffffff810bd760>] ?
wake_atomic_t_function+0x60/0x60
16:56:09 srv kernel: [  240.112620]  [<ffffffffc03af63c>]
start_transaction+0x3fc/0x570 [btrfs]
16:56:09 srv kernel: [  240.112639]  [<ffffffffc039fd50>] ?
btrfs_update_root+0xf0/0x340 [btrfs]
16:56:09 srv kernel: [  240.112658]  [<ffffffffc03af7cb>]
btrfs_start_transaction+0x1b/0x20 [btrfs]
16:56:09 srv kernel: [  240.112676]  [<ffffffffc03983b5>]
btrfs_drop_snapshot+0x555/0x850 [btrfs]
16:56:09 srv kernel: [  240.112698]  [<ffffffffc0404691>]
merge_reloc_roots+0xe1/0x260 [btrfs]
16:56:09 srv kernel: [  240.112720]  [<ffffffffc040550c>]
btrfs_recover_relocation+0x38c/0x440 [btrfs]
16:56:09 srv kernel: [  240.112740]  [<ffffffffc03abd4a>]
open_ctree+0x1bba/0x23e0 [btrfs]
16:56:09 srv kernel: [  240.112756]  [<ffffffffc0380fae>]
btrfs_mount+0x94e/0xa70 [btrfs]
16:56:09 srv kernel: [  240.112762]  [<ffffffff813daf15>] ?
find_next_bit+0x15/0x20
16:56:09 srv kernel: [  240.112767]  [<ffffffff811a6435>] ?
pcpu_alloc+0x385/0x670
16:56:09 srv kernel: [  240.112772]  [<ffffffff812017c8>] mount_fs+0x38/0x160
16:56:09 srv kernel: [  240.112776]  [<ffffffff811a6755>] ?
__alloc_percpu+0x15/0x20
16:56:09 srv kernel: [  240.112781]  [<ffffffff8121d5bb>]
vfs_kern_mount+0x6b/0x120
16:56:09 srv kernel: [  240.112785]  [<ffffffff8121fdc6>] do_mount+0x246/0xd10
16:56:09 srv kernel: [  240.112788]  [<ffffffff81220bbf>] SyS_mount+0x9f/0x100
16:56:09 srv kernel: [  240.112791]  [<ffffffff817f1c72>]
entry_SYSCALL_64_fastpath+0x16/0x75

Also
17:40:12 srv kernel: [  277.205013] Mem-Info:
17:40:12 srv kernel: [  277.205018] active_anon:0 inactive_anon:0
isolated_anon:0
17:40:12 srv kernel: [  277.205018]  active_file:27295
inactive_file:27755 isolated_file:33
17:40:12 srv kernel: [  277.205018]  unevictable:0 dirty:30888
writeback:0 unstable:0
17:40:12 srv kernel: [  277.205018]  slab_reclaimable:9787
slab_unreclaimable:659576
17:40:12 srv kernel: [  277.205018]  mapped:1 shmem:0 pagetables:1343 bounce:0
17:40:12 srv kernel: [  277.205018]  free:0 free_pcp:0 free_cma:0
17:40:12 srv kernel: [  277.205022] Node 0 DMA free:0kB min:36kB
low:44kB high:52kB active_anon:0kB inactive_anon:0kB active_file:4kB
inactive_file:12kB unevictable:0kB isolated(anon):0kB isolate
d(file):4kB present:15988kB managed:15904kB mlocked:0kB dirty:0kB
writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:48kB
slab_unreclaimable:15424kB kernel_stack:64kB pagetables:32kB
unstable:0kB bounce:0kB fr
ee_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:8 all_unreclaimable? no
17:40:12 srv kernel: [  277.205029] lowmem_reserve[]: 0 2862 2862 2862
17:40:12 srv kernel: [  277.205033] Node 0 DMA32 free:0kB min:6744kB
low:8428kB high:10116kB active_anon:0kB inactive_anon:0kB
active_file:109176kB inactive_file:111008kB unevictable:0kB isolated
(anon):0kB isolated(file):128kB present:3128768kB managed:2933204kB
mlocked:0kB dirty:123552kB writeback:0kB mapped:4kB shmem:0kB
slab_reclaimable:39100kB slab_unreclaimable:2622880kB
kernel_stack:3568kB pageta
bles:5340kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:2027488
all_unreclaimable? yes
17:40:12 srv kernel: [  277.205039] lowmem_reserve[]: 0 0 0 0
17:40:12 srv kernel: [  277.205042] Node 0 DMA: 0*4kB 0*8kB 0*16kB
0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
17:40:12 srv kernel: [  277.205051] Node 0 DMA32: 0*4kB 0*8kB 0*16kB
0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 0kB
17:40:12 srv kernel: [  277.205061] Node 0 hugepages_total=0
hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
17:40:12 srv kernel: [  277.205063] 55020 total pagecache pages
17:40:12 srv kernel: [  277.205065] 0 pages in swap cache
17:40:12 srv kernel: [  277.205067] Swap cache stats: add 19683,
delete 19683, find 1489/2940
17:40:12 srv kernel: [  277.205069] Free swap  = 2059728kB
17:40:12 srv kernel: [  277.205070] Total swap = 2097088kB
17:40:12 srv kernel: [  277.205071] 786189 pages RAM
17:40:12 srv kernel: [  277.205072] 0 pages HighMem/MovableOnly
17:40:12 srv kernel: [  277.205074] 48912 pages reserved
17:40:12 srv kernel: [  277.205075] 0 pages cma reserved
17:40:12 srv kernel: [  277.205076] 0 pages hwpoisoned
17:40:12 srv kernel: [  277.205078] SLUB: Unable to allocate memory on
node -1 (gfp=0x50)
17:40:12 srv kernel: [  277.205080]   cache: kmalloc-64, object size:
64, buffer size: 64, default order: 0, min order: 0
17:40:12 srv kernel: [  277.205082]   node 0: slabs: 650523, objs:
41633472, free: 0
17:40:12 srv kernel: [  277.205096] BTRFS warning (device dm-6):
Skipping commit of aborted transaction.
17:40:12 srv kernel: [  277.205098] ------------[ cut here ]------------
17:40:12 srv kernel: [  277.205112] WARNING: CPU: 2 PID: 2369 at
/build/linux-NgsOGa/linux-4.2.0/fs/btrfs/transaction.c:1710
cleanup_transaction+0x92/0x2d0 [btrfs]()
17:40:12 srv kernel: [  277.205113] BTRFS: Transaction aborted (error -12)
17:40:12 srv kernel: [  277.205115] Modules linked in: xt_CHECKSUM
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp ebtable_filter
ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables
softdog bridge stp llc dm_cache_smq dm_cache dm_persistent_data
dm_bio_prison dm_bufio libcrc32c snd_hda_codec_via
snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_codec
snd_hda_core snd_hwdep snd_pcm coretemp snd_seq_midi
snd_seq_midi_event snd_rawmidi joydev snd_seq input_leds
snd_seq_device snd_timer snd serio_raw lpc_ich soundcore mac_hid
kvm_intel shpchp 8250_fintek asus_atk0110 kvm parport_pc ppdev lp
parport autofs4 btrfs raid10 raid0 multipath linear raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq raid1 pata_acpi hid_generic usbhid hid amdkfd amd_iommu_v2
radeon psmouse ahci i2c_algo_bit libahci via_rhine ttm r8169
drm_kms_helper mii pata_jmicron drm
17:40:12 srv kernel: [  277.205181] CPU: 2 PID: 2369 Comm: mount Not
tainted 4.2.0-27-generic #32-Ubuntu
17:40:12 srv kernel: [  277.205183] Hardware name: System manufacturer
System Product Name/P5Q SE PLUS, BIOS 2204    08/28/2009
17:40:12 srv kernel: [  277.205184]  0000000000000000 0000000060da56dc
ffff8800b2bf3978 ffffffff817eae99
17:40:12 srv kernel: [  277.205187]  0000000000000000 ffff8800b2bf39d0
ffff8800b2bf39b8 ffffffff8107b9c6
17:40:12 srv kernel: [  277.205190]  0000000000000246 ffff880079c6e000
ffff8800b43e3000 ffff880079eb4a10
17:40:12 srv kernel: [  277.205193] Call Trace:
17:40:12 srv kernel: [  277.205195]  [<ffffffff817eae99>] dump_stack+0x45/0x57
17:40:12 srv kernel: [  277.205199]  [<ffffffff8107b9c6>]
warn_slowpath_common+0x86/0xc0
17:40:12 srv kernel: [  277.205202]  [<ffffffff8107ba55>]
warn_slowpath_fmt+0x55/0x70
17:40:12 srv kernel: [  277.205215]  [<ffffffffc03adcf2>]
cleanup_transaction+0x92/0x2d0 [btrfs]
17:40:12 srv kernel: [  277.205218]  [<ffffffff810bd760>] ?
wake_atomic_t_function+0x60/0x60
17:40:12 srv kernel: [  277.205232]  [<ffffffffc03aea7c>]
btrfs_commit_transaction+0x35c/0xb20 [btrfs]
17:40:12 srv kernel: [  277.205247]  [<ffffffffc040555e>]
btrfs_recover_relocation+0x3de/0x440 [btrfs]
17:40:12 srv kernel: [  277.205260]  [<ffffffffc03abd4a>]
open_ctree+0x1bba/0x23e0 [btrfs]
17:40:12 srv kernel: [  277.205270]  [<ffffffffc0380fae>]
btrfs_mount+0x94e/0xa70 [btrfs]
17:40:12 srv kernel: [  277.205273]  [<ffffffff813daf15>] ?
find_next_bit+0x15/0x20
17:40:12 srv kernel: [  277.205276]  [<ffffffff811a6435>] ?
pcpu_alloc+0x385/0x670
17:40:12 srv kernel: [  277.205279]  [<ffffffff812017c8>] mount_fs+0x38/0x160
17:40:12 srv kernel: [  277.205281]  [<ffffffff811a6755>] ?
__alloc_percpu+0x15/0x20
17:40:12 srv kernel: [  277.205284]  [<ffffffff8121d5bb>]
vfs_kern_mount+0x6b/0x120
17:40:12 srv kernel: [  277.205286]  [<ffffffff8121fdc6>] do_mount+0x246/0xd10
17:40:12 srv kernel: [  277.205288]  [<ffffffff81220bbf>] SyS_mount+0x9f/0x100
17:40:12 srv kernel: [  277.205290]  [<ffffffff817f1c72>]
entry_SYSCALL_64_fastpath+0x16/0x75
17:40:12 srv kernel: [  277.205292] ---[ end trace 619835a5df93183b ]---
17:40:12 srv kernel: [  277.205298] BTRFS: error (device dm-6) in
cleanup_transaction:1710: errno=-12 Out of memory
17:40:12 srv kernel: [  277.205343] BTRFS info (device dm-6):
delayed_refs has NO entry
17:40:12 srv kernel: [  277.230676] BTRFS: failed to recover relocation
17:40:12 srv kernel: [  277.231071] BTRFS error (device dm-6): cleaner
transaction attach returned -30
17:40:12 srv kernel: [  277.356087] BTRFS: open_ctree failed

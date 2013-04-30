Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52346 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3D3Gha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Apr 2013 02:37:30 -0400
Received: by mail-ob0-f169.google.com with SMTP id tb18so148604obb.28
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 23:37:29 -0700 (PDT)
Received: from mail-ob0-x233.google.com (mail-ob0-x233.google.com [2607:f8b0:4003:c01::233])
        by mx.google.com with ESMTPSA id zc8sm22514415obc.8.2013.04.29.23.37.28
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 29 Apr 2013 23:37:28 -0700 (PDT)
Received: by mail-ob0-f179.google.com with SMTP id oi10so146821obb.24
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Apr 2013 23:37:28 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Skwar <a@skwar.me>
Date: Tue, 30 Apr 2013 08:37:08 +0200
Message-ID: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com>
Subject: WARNING: at fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
 [btrfs]()
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

On my HP Compaq dc5800 with Ubuntu 13.04 and their 3.8.0-19-lowlatency
kernel, I've got quite some kernel traces in the syslog. You can find
them below or at http://pastebin.com/bLXPBX67 (to avoid line breaks…).

These kernel traces all begin with:

WARNING: at fs/btrfs/free-space-cache.c:921
__btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]()


Most of the time, it starts with:

Call Trace:
 [<ffffffff8105a8df>] warn_slowpath_common+0x7f/0xc0

But once, I also had:

Call Trace:
 [<ffffffff81138e59>] warn_alloc_failed+0xe9/0x140



It happens most of the time, when I copied something on a btrfs. But
it also happened right now, when the system was basically idle. The
fs is on a "normal" SATA disk (ie. no SSD or usb or such).


I created the btrfs on the linux 3.8.0-19-lowlatency kernel with:

a@ewzw032:~$ btrfs version
Btrfs v0.20-rc1

Line 921 of free-space-cache.c (-> http://pastebin.com/yNQMPG3P) is
the WARN_ON(1) in this block:


        /* Make sure we can fit our crcs into the first page */
        if (io_ctl.check_crcs &&
            (io_ctl.num_pages * sizeof(u32)) >= PAGE_CACHE_SIZE) {
                WARN_ON(1);
                goto out_nospc;
        }


Well - what can be done about it?



Here are my kernel traces:

Apr 29 12:59:31 ewzw032 kernel: [ 6275.016478] ------------[ cut here
]------------
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016507] WARNING: at
fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
[btrfs]()
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016509] Hardware name: HP
Compaq dc5800 Microtower
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016510] Modules linked in: arc4
md4 parport_pc ppdev bnep rfcomm bluetooth nls_utf8 cifs fscache ext2
snd_hda_codec_analog snd_hda_intel snd_hda_codec coretemp tpm_infineon
snd_hwdep snd_pcm snd_page_alloc dm_multipath snd_seq_midi
snd_seq_midi_event snd_rawmidi kvm_intel kvm snd_seq snd_seq_device
snd_timer scsi_dh snd psmouse soundcore gpio_ich hp_wmi sparse_keymap
serio_raw lpc_ich mei wmi microcode tpm_tis nvidia(POF) mac_hid lp
parport btrfs zlib_deflate libcrc32c hid_generic usbhid hid
usb_storage floppy e1000e
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016537] Pid: 4608, comm:
btrfs-transacti Tainted: PF       W  O 3.8.0-19-lowlatency #13-Ubuntu
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016538] Call Trace:
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016544]  [<ffffffff8105a8df>]
warn_slowpath_common+0x7f/0xc0
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016546]  [<ffffffff8105a93a>]
warn_slowpath_null+0x1a/0x20
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016556]  [<ffffffffa0107c29>]
__btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016559]  [<ffffffff81096c40>] ?
set_next_entity+0x80/0x90
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016570]  [<ffffffffa0107fa5>]
btrfs_write_out_cache+0x95/0xf0 [btrfs]
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016579]  [<ffffffffa00bcc07>]
btrfs_write_dirty_block_groups+0x527/0x620 [btrfs]
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016588]  [<ffffffffa012ed52>]
commit_cowonly_roots+0x15a/0x22c [btrfs]
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016598]  [<ffffffffa00cc4ec>]
btrfs_commit_transaction+0x62c/0xb00 [btrfs]
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016601]  [<ffffffff81080070>] ?
finish_wait+0x80/0x80
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016610]  [<ffffffffa00c54cd>]
transaction_kthread+0x1ad/0x230 [btrfs]
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016620]  [<ffffffffa00c5320>] ?
write_dev_flush.part.107+0xc0/0xc0 [btrfs]
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016622]  [<ffffffff8107f890>]
kthread+0xc0/0xd0
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016624]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016628]  [<ffffffff816dfdec>]
ret_from_fork+0x7c/0xb0
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016629]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 12:59:31 ewzw032 kernel: [ 6275.016631] ---[ end trace
3afa1c596d559b57 ]---





Apr 29 13:05:18 ewzw032 kernel: [ 6621.268618] ------------[ cut here
]------------
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268648] WARNING: at
fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
[btrfs]()
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268650] Hardware name: HP
Compaq dc5800 Microtower
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268651] Modules linked in: arc4
md4 parport_pc ppdev bnep rfcomm bluetooth nls_utf8 cifs fscache ext2
snd_hda_codec_analog snd_hda_intel snd_hda_codec coretemp tpm_infineon
snd_hwdep snd_pcm snd_page_alloc dm_multipath snd_seq_midi
snd_seq_midi_event snd_rawmidi kvm_intel kvm snd_seq snd_seq_device
snd_timer scsi_dh snd psmouse soundcore gpio_ich hp_wmi sparse_keymap
serio_raw lpc_ich mei wmi microcode tpm_tis nvidia(POF) mac_hid lp
parport btrfs zlib_deflate libcrc32c hid_generic usbhid hid
usb_storage floppy e1000e
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268678] Pid: 4608, comm:
btrfs-transacti Tainted: PF       W  O 3.8.0-19-lowlatency #13-Ubuntu
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268679] Call Trace:
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268685]  [<ffffffff8105a8df>]
warn_slowpath_common+0x7f/0xc0
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268687]  [<ffffffff8105a93a>]
warn_slowpath_null+0x1a/0x20
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268698]  [<ffffffffa0107c29>]
__btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268708]  [<ffffffffa00c713d>] ?
btrfs_buffer_uptodate+0x6d/0x80 [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268711]  [<ffffffff81096c40>] ?
set_next_entity+0x80/0x90
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268721]  [<ffffffffa0107fa5>]
btrfs_write_out_cache+0x95/0xf0 [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268731]  [<ffffffffa00bcc07>]
btrfs_write_dirty_block_groups+0x527/0x620 [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268739]  [<ffffffffa012ed52>]
commit_cowonly_roots+0x15a/0x22c [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268749]  [<ffffffffa00cc4ec>]
btrfs_commit_transaction+0x62c/0xb00 [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268752]  [<ffffffff81080070>] ?
finish_wait+0x80/0x80
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268761]  [<ffffffffa00c54cd>]
transaction_kthread+0x1ad/0x230 [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268771]  [<ffffffffa00c5320>] ?
write_dev_flush.part.107+0xc0/0xc0 [btrfs]
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268773]  [<ffffffff8107f890>]
kthread+0xc0/0xd0
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268775]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268778]  [<ffffffff816dfdec>]
ret_from_fork+0x7c/0xb0
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268780]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 13:05:18 ewzw032 kernel: [ 6621.268781] ---[ end trace
3afa1c596d559b62 ]---
Apr 29 13:05:55 ewzw032 kernel: [ 6658.063049] ------------[ cut here
]------------




Apr 29 17:29:59 ewzw032 kernel: [22502.923913] ------------[ cut here
]------------
Apr 29 17:29:59 ewzw032 kernel: [22502.923956] WARNING: at
fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
[btrfs]()
Apr 29 17:29:59 ewzw032 kernel: [22502.923957] Hardware name: HP
Compaq dc5800 Microtower
Apr 29 17:29:59 ewzw032 kernel: [22502.923958] Modules linked in: arc4
md4 parport_pc ppdev bnep rfcomm bluetooth nls_utf8 cifs fscache ext2
snd_hda_codec_analog snd_hda_intel snd_hda_codec coretemp tpm_infineon
snd_hwdep snd_pcm snd_page_alloc dm_multipath snd_seq_midi
snd_seq_midi_event snd_rawmidi kvm_intel kvm snd_seq snd_seq_device
snd_timer scsi_dh snd psmouse soundcore gpio_ich hp_wmi sparse_keymap
serio_raw lpc_ich mei wmi microcode tpm_tis nvidia(POF) mac_hid lp
parport btrfs zlib_deflate libcrc32c hid_generic usbhid hid
usb_storage floppy e1000e
Apr 29 17:29:59 ewzw032 kernel: [22502.923987] Pid: 13579, comm:
btrfs-transacti Tainted: PF       W  O 3.8.0-19-lowlatency #13-Ubuntu
Apr 29 17:29:59 ewzw032 kernel: [22502.923988] Call Trace:
Apr 29 17:29:59 ewzw032 kernel: [22502.923999]  [<ffffffff8105a8df>]
warn_slowpath_common+0x7f/0xc0
Apr 29 17:29:59 ewzw032 kernel: [22502.924013]  [<ffffffff8105a93a>]
warn_slowpath_null+0x1a/0x20
Apr 29 17:29:59 ewzw032 kernel: [22502.924024]  [<ffffffffa0107c29>]
__btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]
Apr 29 17:29:59 ewzw032 kernel: [22502.924027]  [<ffffffff810979bc>] ?
update_curr+0xec/0x1a0
Apr 29 17:29:59 ewzw032 kernel: [22502.924029]  [<ffffffff8109d2ee>] ?
dequeue_pushable_task+0x2e/0x70
Apr 29 17:29:59 ewzw032 kernel: [22502.924040]  [<ffffffffa0107fa5>]
btrfs_write_out_cache+0x95/0xf0 [btrfs]
Apr 29 17:29:59 ewzw032 kernel: [22502.924050]  [<ffffffffa00bcc07>]
btrfs_write_dirty_block_groups+0x527/0x620 [btrfs]
Apr 29 17:29:59 ewzw032 kernel: [22502.924059]  [<ffffffffa012ed52>]
commit_cowonly_roots+0x15a/0x22c [btrfs]
Apr 29 17:29:59 ewzw032 kernel: [22502.924069]  [<ffffffffa00cc4ec>]
btrfs_commit_transaction+0x62c/0xb00 [btrfs]
Apr 29 17:29:59 ewzw032 kernel: [22502.924072]  [<ffffffff81080070>] ?
finish_wait+0x80/0x80
Apr 29 17:29:59 ewzw032 kernel: [22502.924082]  [<ffffffffa00c54cd>]
transaction_kthread+0x1ad/0x230 [btrfs]
Apr 29 17:29:59 ewzw032 kernel: [22502.924091]  [<ffffffffa00c5320>] ?
write_dev_flush.part.107+0xc0/0xc0 [btrfs]
Apr 29 17:29:59 ewzw032 kernel: [22502.924093]  [<ffffffff8107f890>]
kthread+0xc0/0xd0
Apr 29 17:29:59 ewzw032 kernel: [22502.924095]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 17:29:59 ewzw032 kernel: [22502.924099]  [<ffffffff816dfdec>]
ret_from_fork+0x7c/0xb0
Apr 29 17:29:59 ewzw032 kernel: [22502.924101]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 17:29:59 ewzw032 kernel: [22502.924261] ---[ end trace
3afa1c596d559b6b ]---
Apr 29 17:30:45 ewzw032 kernel: [22548.083953] btrfs-transacti: page
allocation failure: order:5, mode:0x10c050
Apr 29 17:30:45 ewzw032 kernel: [22548.083958] Pid: 13579, comm:
btrfs-transacti Tainted: PF       W  O 3.8.0-19-lowlatency #13-Ubuntu
Apr 29 17:30:45 ewzw032 kernel: [22548.083960] Call Trace:
Apr 29 17:30:45 ewzw032 kernel: [22548.083968]  [<ffffffff81138e59>]
warn_alloc_failed+0xe9/0x140
Apr 29 17:30:45 ewzw032 kernel: [22548.083970]  [<ffffffff8113b6e6>] ?
drain_local_pages+0x16/0x20
Apr 29 17:30:45 ewzw032 kernel: [22548.083974]  [<ffffffff810bc82d>] ?
on_each_cpu_mask+0x8d/0xb0
Apr 29 17:30:45 ewzw032 kernel: [22548.083976]  [<ffffffff8113cd5c>]
__alloc_pages_nodemask+0x70c/0x950
Apr 29 17:30:45 ewzw032 kernel: [22548.083979]  [<ffffffff811787d8>]
alloc_pages_current+0xb8/0x180
Apr 29 17:30:45 ewzw032 kernel: [22548.083981]  [<ffffffff81137fce>]
__get_free_pages+0xe/0x50
Apr 29 17:30:45 ewzw032 kernel: [22548.083984]  [<ffffffff811807d9>]
kmalloc_order_trace+0x39/0xf0
Apr 29 17:30:45 ewzw032 kernel: [22548.083986]  [<ffffffff81182fc4>]
__kmalloc+0x184/0x190
Apr 29 17:30:45 ewzw032 kernel: [22548.084004]  [<ffffffffa0106fa1>]
io_ctl_init+0x91/0x140 [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084032]  [<ffffffffa01075de>]
__btrfs_write_out_cache+0x6e/0x9a0 [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084035]  [<ffffffff81096c40>] ?
set_next_entity+0x80/0x90
Apr 29 17:30:45 ewzw032 kernel: [22548.084045]  [<ffffffffa0107fa5>]
btrfs_write_out_cache+0x95/0xf0 [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084055]  [<ffffffffa00bcc07>]
btrfs_write_dirty_block_groups+0x527/0x620 [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084064]  [<ffffffffa012ed52>]
commit_cowonly_roots+0x15a/0x22c [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084074]  [<ffffffffa00cc4ec>]
btrfs_commit_transaction+0x62c/0xb00 [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084077]  [<ffffffff81080070>] ?
finish_wait+0x80/0x80
Apr 29 17:30:45 ewzw032 kernel: [22548.084086]  [<ffffffffa00c54cd>]
transaction_kthread+0x1ad/0x230 [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084096]  [<ffffffffa00c5320>] ?
write_dev_flush.part.107+0xc0/0xc0 [btrfs]
Apr 29 17:30:45 ewzw032 kernel: [22548.084098]  [<ffffffff8107f890>]
kthread+0xc0/0xd0
Apr 29 17:30:45 ewzw032 kernel: [22548.084103]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 17:30:45 ewzw032 kernel: [22548.084106]  [<ffffffff816dfdec>]
ret_from_fork+0x7c/0xb0
Apr 29 17:30:45 ewzw032 kernel: [22548.084108]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 29 17:30:45 ewzw032 kernel: [22548.084301] Mem-Info:
Apr 29 17:30:45 ewzw032 kernel: [22548.084303] Node 0 DMA per-cpu:
Apr 29 17:30:45 ewzw032 kernel: [22548.084305] CPU    0: hi:    0,
btch:   1 usd:   0
Apr 29 17:30:45 ewzw032 kernel: [22548.084307] CPU    1: hi:    0,
btch:   1 usd:   0
Apr 29 17:30:45 ewzw032 kernel: [22548.084308] Node 0 DMA32 per-cpu:
Apr 29 17:30:45 ewzw032 kernel: [22548.084309] CPU    0: hi:  186,
btch:  31 usd:   0
Apr 29 17:30:45 ewzw032 kernel: [22548.084311] CPU    1: hi:  186,
btch:  31 usd:   0
Apr 29 17:30:45 ewzw032 kernel: [22548.084311] Node 0 Normal per-cpu:
Apr 29 17:30:45 ewzw032 kernel: [22548.084313] CPU    0: hi:  186,
btch:  31 usd:   0
Apr 29 17:30:45 ewzw032 kernel: [22548.084314] CPU    1: hi:  186,
btch:  31 usd: 166
Apr 29 17:30:45 ewzw032 kernel: [22548.084317] active_anon:733665
inactive_anon:281330 isolated_anon:0
Apr 29 17:30:45 ewzw032 kernel: [22548.084317]  active_file:238672
inactive_file:562643 isolated_file:0
Apr 29 17:30:45 ewzw032 kernel: [22548.084317]  unevictable:8
dirty:17770 writeback:48555 unstable:0
Apr 29 17:30:45 ewzw032 kernel: [22548.084317]  free:49760
slab_reclaimable:25129 slab_unreclaimable:14172
Apr 29 17:30:45 ewzw032 kernel: [22548.084317]  mapped:52305
shmem:6399 pagetables:18147 bounce:0
Apr 29 17:30:45 ewzw032 kernel: [22548.084317]  free_cma:0
Apr 29 17:30:45 ewzw032 kernel: [22548.084320] Node 0 DMA free:15900kB
min:128kB low:160kB high:192kB active_anon:0kB inactive_anon:0kB
active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15652kB managed:15908kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:8kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
Apr 29 17:30:45 ewzw032 kernel: [22548.084324] lowmem_reserve[]: 0
3496 7969 7969
Apr 29 17:30:45 ewzw032 kernel: [22548.084327] Node 0 DMA32
free:99044kB min:29592kB low:36988kB high:44388kB active_anon:478348kB
inactive_anon:501448kB active_file:499548kB inactive_file:1787932kB
unevictable:16kB isolated(anon):0kB isolated(file):0kB
present:3580096kB managed:3539248kB mlocked:16kB dirty:20784kB
writeback:5060kB mapped:68704kB shmem:6976kB slab_reclaimable:29648kB
slab_unreclaimable:9508kB kernel_stack:696kB pagetables:10948kB
unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
Apr 29 17:30:45 ewzw032 kernel: [22548.084332] lowmem_reserve[]: 0 0 4473 4473
Apr 29 17:30:45 ewzw032 kernel: [22548.084334] Node 0 Normal
free:84212kB min:37860kB low:47324kB high:56788kB
active_anon:2456312kB inactive_anon:623872kB active_file:455140kB
inactive_file:462640kB unevictable:16kB isolated(anon):0kB
isolated(file):0kB present:4580352kB managed:4520784kB mlocked:16kB
dirty:50296kB writeback:189160kB mapped:140516kB shmem:18620kB
slab_reclaimable:70868kB slab_unreclaimable:47172kB
kernel_stack:6384kB pagetables:61640kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:28 all_unreclaimable? no
Apr 29 17:30:45 ewzw032 kernel: [22548.084339] lowmem_reserve[]: 0 0 0 0
Apr 29 17:30:45 ewzw032 kernel: [22548.084341] Node 0 DMA: 1*4kB (U)
1*8kB (U) 1*16kB (U) 0*32kB 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB
1*1024kB (U) 1*2048kB (R) 3*4096kB (M) = 15900kB
Apr 29 17:30:45 ewzw032 kernel: [22548.084351] Node 0 DMA32: 7768*4kB
(UEM) 4055*8kB (UEM) 1990*16kB (UM) 2*32kB (R) 0*64kB 1*128kB (R)
0*256kB 1*512kB (R) 1*1024kB (R) 1*2048kB (R) 0*4096kB = 99128kB
Apr 29 17:30:45 ewzw032 kernel: [22548.084361] Node 0 Normal: 6110*4kB
(UEM) 6160*8kB (UEM) 402*16kB (UEM) 11*32kB (UE) 0*64kB 1*128kB (R)
1*256kB (R) 1*512kB (R) 1*1024kB (R) 1*2048kB (R) 0*4096kB = 84472kB
Apr 29 17:30:45 ewzw032 kernel: [22548.084371] 807776 total pagecache pages
Apr 29 17:30:45 ewzw032 kernel: [22548.084372] 102 pages in swap cache
Apr 29 17:30:45 ewzw032 kernel: [22548.084374] Swap cache stats: add
7253, delete 7151, find 482/495
Apr 29 17:30:45 ewzw032 kernel: [22548.084375] Free swap  = 10068048kB
Apr 29 17:30:45 ewzw032 kernel: [22548.084376] Total swap = 10096632kB
Apr 29 17:30:45 ewzw032 kernel: [22548.114584] 2080752 pages RAM
Apr 29 17:30:45 ewzw032 kernel: [22548.114586] 129680 pages reserved
Apr 29 17:30:45 ewzw032 kernel: [22548.114587] 1156729 pages shared
Apr 29 17:30:45 ewzw032 kernel: [22548.114588] 1386865 pages non-shared
Apr 29 17:31:39 ewzw032 kernel: [22602.788543] device fsid
10fd7c6c-59df-47db-8659-577dd8ff1fd8 devid 1 transid 953 /dev/dm-6
Apr 29 17:31:47 ewzw032 kernel: [22610.323304] btrfs: new size for
/dev/dm-6 is 64424509440






Apr 30 08:07:05 ewzw032 kernel: [75128.655594] ------------[ cut here
]------------
Apr 30 08:07:05 ewzw032 kernel: [75128.655623] WARNING: at
fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
[btrfs]()
Apr 30 08:07:05 ewzw032 kernel: [75128.655625] Hardware name: HP
Compaq dc5800 Microtower
Apr 30 08:07:05 ewzw032 kernel: [75128.655626] Modules linked in: arc4
md4 parport_pc ppdev bnep rfcomm bluetooth nls_utf8 cifs fscache ext2
snd_hda_codec_analog snd_hda_intel snd_hda_codec coretemp tpm_infineon
snd_hwdep snd_pcm snd_page_alloc dm_multipath snd_seq_midi
snd_seq_midi_event snd_rawmidi kvm_intel kvm snd_seq snd_seq_device
snd_timer scsi_dh snd psmouse soundcore gpio_ich hp_wmi sparse_keymap
serio_raw lpc_ich mei wmi microcode tpm_tis nvidia(POF) mac_hid lp
parport btrfs zlib_deflate libcrc32c hid_generic usbhid hid
usb_storage floppy e1000e
Apr 30 08:07:05 ewzw032 kernel: [75128.655652] Pid: 13579, comm:
btrfs-transacti Tainted: PF       W  O 3.8.0-19-lowlatency #13-Ubuntu
Apr 30 08:07:05 ewzw032 kernel: [75128.655654] Call Trace:
Apr 30 08:07:05 ewzw032 kernel: [75128.655659]  [<ffffffff8105a8df>]
warn_slowpath_common+0x7f/0xc0
Apr 30 08:07:05 ewzw032 kernel: [75128.655662]  [<ffffffff8105a93a>]
warn_slowpath_null+0x1a/0x20
Apr 30 08:07:05 ewzw032 kernel: [75128.655672]  [<ffffffffa0107c29>]
__btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]
Apr 30 08:07:05 ewzw032 kernel: [75128.655675]  [<ffffffff81096c40>] ?
set_next_entity+0x80/0x90
Apr 30 08:07:05 ewzw032 kernel: [75128.655686]  [<ffffffffa0107fa5>]
btrfs_write_out_cache+0x95/0xf0 [btrfs]
Apr 30 08:07:05 ewzw032 kernel: [75128.655695]  [<ffffffffa00bcc07>]
btrfs_write_dirty_block_groups+0x527/0x620 [btrfs]
Apr 30 08:07:05 ewzw032 kernel: [75128.655704]  [<ffffffffa012ed52>]
commit_cowonly_roots+0x15a/0x22c [btrfs]
Apr 30 08:07:05 ewzw032 kernel: [75128.655715]  [<ffffffffa00cc4ec>]
btrfs_commit_transaction+0x62c/0xb00 [btrfs]
Apr 30 08:07:05 ewzw032 kernel: [75128.655717]  [<ffffffff81080070>] ?
finish_wait+0x80/0x80
Apr 30 08:07:05 ewzw032 kernel: [75128.655727]  [<ffffffffa00c54cd>]
transaction_kthread+0x1ad/0x230 [btrfs]
Apr 30 08:07:05 ewzw032 kernel: [75128.655736]  [<ffffffffa00c5320>] ?
write_dev_flush.part.107+0xc0/0xc0 [btrfs]
Apr 30 08:07:05 ewzw032 kernel: [75128.655738]  [<ffffffff8107f890>]
kthread+0xc0/0xd0
Apr 30 08:07:05 ewzw032 kernel: [75128.655740]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 30 08:07:05 ewzw032 kernel: [75128.655743]  [<ffffffff816dfdec>]
ret_from_fork+0x7c/0xb0
Apr 30 08:07:05 ewzw032 kernel: [75128.655745]  [<ffffffff8107f7d0>] ?
kthread_create_on_node+0x120/0x120
Apr 30 08:07:05 ewzw032 kernel: [75128.655747] ---[ end trace
3afa1c596d559b6d ]---



Thanks a lot,

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==

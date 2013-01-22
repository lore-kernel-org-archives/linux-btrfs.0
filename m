Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eithel.gem.pl ([85.232.225.132]:61578 "EHLO eithel.gem.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab3AVQwB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 11:52:01 -0500
Received: from localhost ([127.0.0.1] helo=[172.16.200.90])
	by eithel.gem.pl with esmtpa (Exim 4.69 (FreeBSD))
	(envelope-from <piotr.nowojski@adocean-global.com>)
	id 1Txh4p-000KWw-NO
	for linux-btrfs@vger.kernel.org; Tue, 22 Jan 2013 17:52:00 +0100
Message-ID: <50FEC3B5.1040100@adocean-global.com>
Date: Tue, 22 Jan 2013 17:52:05 +0100
From: Piotr Nowojski <piotr.nowojski@adocean-global.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS deadlock (btrfs_join_transaction?)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

os: Ubuntu 12.10
kernel: 3.7.2 from kernel.org
btrfs --version: Btrfs Btrfs v0.19

We are heavily testing new system, which uses BTRFS as an underlying 
storage, and we are hitting one problem after another. Currently we are 
struggling with another deadlock (main suspect is BTRFS). On heavy 
stress test, with hundreds/thousands of snapshots being created and 
deleted, we have lost connection with one of our servers. It was 
responding to ping, but we were unable to make an ssh connection. 
Happily, after previous problems, we are using remote syslog, with "echo 
w > /proc/sysrq-trigger" every couple of seconds. That's what we have found:

[14501.689372] BUG: soft lockup - CPU#2 stuck for 22s! 
[btrfs-delayed-m:29021]
[14501.689384] Modules linked in: veth ip_tables x_tables coretemp 
kvm_intel kvm ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw 
aes_x86_64 xts gf128mul bridge joydev sb_edac edac_core mac_hid ioatdma 
lp wmi lpc_ich mei 8021q garp stp llc parport microcode btrfs 
zlib_deflate libcrc32c raid10 raid456 async_pq async_xor hid_generic xor 
async_memcpy usbhid async_raid6_recov hid isci igb libsas dca 
scsi_transport_sas megaraid_sas raid6_pq async_tx raid1 raid0 multipath 
linear
[14501.689446] CPU 2
[14501.689452] Pid: 29021, comm: btrfs-delayed-m Not tainted 
3.7.2-custom2 #1 Intel Corporation S2600IP/S2600IP
[14501.689455] RIP: 0010:[<ffffffff81044ab5>] [<ffffffff81044ab5>] 
__ticket_spin_lock+0x25/0x30
[14501.689468] RSP: 0018:ffff88025c511d08  EFLAGS: 00000202
[14501.689471] RAX: 0000000000000002 RBX: 00ff880200000033 RCX: 
0000000000000000
[14501.689474] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 
ffff88078ac53150
[14501.689477] RBP: ffff88025c511d08 R08: 000060f7e08018b0 R09: 
ffff8807f7ef5e60
[14501.689479] R10: ffffea0009833680 R11: ffffffffa01d9654 R12: 
ffff8807f779d9c8
[14501.689482] R13: ffff8807f779d9c0 R14: ffff8807f779d900 R15: 
0000002400000000
[14501.689486] FS:  0000000000000000(0000) GS:ffff88081e640000(0000) 
knlGS:0000000000000000
[14501.689488] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14501.689491] CR2: 00007fd66b19c720 CR3: 0000000001c0b000 CR4: 
00000000000407e0
[14501.689494] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[14501.689497] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[14501.689500] Process btrfs-delayed-m (pid: 29021, threadinfo 
ffff88025c510000, task ffff88071b875c00)
[14501.689502] Stack:
[14501.689504]  ffff88025c511d18 ffffffff816a0b6e ffff88025c511d48 
ffffffffa018db85
[14501.689511]  0000000000000001 ffff88078ac52800 ffff88078ac529e8 
0000000000000000
[14501.689517]  ffff88025c511da8 ffffffffa01904d7 ffff88025c511d88 
ffffffff811793cf
[14501.689523] Call Trace:
[14501.689533]  [<ffffffff816a0b6e>] _raw_spin_lock+0xe/0x20
[14501.689560]  [<ffffffffa018db85>] join_transaction.isra.26+0x25/0x370 
[btrfs]
[14501.689579]  [<ffffffffa01904d7>] start_transaction+0x157/0x410 [btrfs]
[14501.689587]  [<ffffffff811793cf>] ? kmem_cache_alloc+0x11f/0x130
[14501.689604]  [<ffffffffa0190807>] btrfs_join_transaction+0x17/0x20 
[btrfs]
[14501.689626]  [<ffffffffa01d950d>] 
btrfs_async_run_delayed_node_done+0x4d/0x1b0 [btrfs]
[14501.689647]  [<ffffffffa01b822f>] worker_loop+0x16f/0x5d0 [btrfs]
[14501.689653]  [<ffffffff8169f526>] ? __schedule+0x3c6/0x7b0
[14501.689671]  [<ffffffffa01b80c0>] ? btrfs_queue_worker+0x330/0x330 
[btrfs]
[14501.689678]  [<ffffffff8107c200>] kthread+0xc0/0xd0
[14501.689683]  [<ffffffff8107c140>] ? kthread_create_on_node+0x130/0x130
[14501.689689]  [<ffffffff816a946c>] ret_from_fork+0x7c/0xb0
[14501.689694]  [<ffffffff8107c140>] ? kthread_create_on_node+0x130/0x130
[14501.689696] Code: 00 00 00 0f 1f 00 55 b8 00 00 01 00 48 89 e5 f0 0f 
c1 07 89 c1 c1 e9 10 66 39 c1 89 ca 74 11 0f 1f 80 00 00 00 00 f3 90 0f 
b7 07 <66> 39 d0 75 f6 5d c3 0f 1f 40 00 8b 17 55 31 c0 48 89 e5 89 d1

exact same message repeats 28 seconds later, and then it is followed by: 
pastebin.com/349ikn0c

After couple of weeks of testing 3.2.x and 3.5.x, kernels, we haven't 
encountered exact same message before (but we have lost syslogs from 
some crashes, so we are not sure). We have started testing 3.7 just 
recently (only 2 machines), and most of our servers are still running 
3.5. I'm not sure, but this crash might interleaved or been preceded 
with "sync;  echo 1 > /proc/sys/vm/drop_caches" operation or with 
massive snapshots cleaning up (~6000 snapshots).

Any ideas?

Piotr Nowojski

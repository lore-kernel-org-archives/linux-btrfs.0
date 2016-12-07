Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.123.212]:60546 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbcLGF3i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Dec 2016 00:29:38 -0500
Received: from [2001:470:28:88::100] (helo=fire)
        by demfloro.ru with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.84_2)
        (envelope-from <demfloro@demfloro.ru>)
        id 1cEUbe-0005SC-F4
        for linux-btrfs@vger.kernel.org; Wed, 07 Dec 2016 05:17:27 +0000
Date: Wed, 7 Dec 2016 08:17:13 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: linux-btrfs@vger.kernel.org
Subject: Couldn't delete a directory after power failure
Message-ID: <20161207081713.5a164bb2@fire>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had this problem today after power failure of the pc. Bitcoin wallet couldn't use his database, it said that the database is corrupted, 
so I decided to delete blockchain database from the wallet. But I couldn't delete directory "chainstate". 

The problem is solved at the moment I wrote the message to the list by btrfs check and I deleted corrupted directory so no need for support :). Just posting in case this trace and Sysrq+w may be useful for somebody.

07:28:40-user@host ~ $ btrfs version
btrfs-progs v4.8.5
07:29:00-user@host ~ $ uname -a
Linux host 4.9.0-rc8 #2 SMP PREEMPT Tue Dec 6 23:10:04 MSK 2016 x86_64 GNU/Linux
07:29:10 -user@host ~ $ sudo btrfs fi df storage
Data, single: total=494.00GiB, used=392.04GiB
System, DUP: total=32.00MiB, used=96.00KiB
Metadata, DUP: total=1.50GiB, used=532.12MiB
GlobalReserve, single: total=506.92MiB, used=0.00B
07:29:12-user@host ~ $ sudo btrfs fi sh storage
Label: 'storage'  uuid: f387eb37-f009-4723-9fda-2cc8f94c8b8d
	Total devices 1 FS bytes used 392.55GiB
	devid    1 size 996.26GiB used 497.06GiB path /dev/mapper/container
07:29:12-user@host ~/storage/.bitcoin $ ls -l
drwx------ 1 user user   22250 Dec  7 07:20 chainstate
-rw------- 1 user user       0 Oct 20 23:11 db.log
-rw-r--r-- 1 user user 7513379 Dec  7 07:23 debug.log
-rw------- 1 user user   28534 Dec  6 20:02 fee_estimates.dat
-rw------- 1 user user 4372424 Dec  7 01:56 peers.dat
-rw------- 1 user user  139264 Dec  7 01:57 wallet.dat
07:29:13-user@host ~/storage/.bitcoin $ rm -rf chainstate/
Segmentation fault
07:29:19-user@host ~/storage/.bitcoin $ ls -l
total 4436
drwx------ 1 user user    1892 Dec  7 07:29 chainstate
-rw------- 1 user user       0 Oct 20 23:11 db.log
-rw------- 1 user user   28534 Dec  6 20:02 fee_estimates.dat
-rw------- 1 user user 4372424 Dec  7 01:56 peers.dat
-rw------- 1 user user  139264 Dec  7 01:57 wallet.dat
07:29:24-user@host ~/storage/.bitcoin $ rm -rf chainstate/

After that rm hanged, subsequent ls of the chainstate directory also hanged.

dmesg with Sysrq+W included:

[  190.429798] BTRFS: device label storage devid 1 transid 486419 /dev/dm-6
[  190.459791] BTRFS info (device dm-6): enabling auto defrag
[  190.459796] BTRFS info (device dm-6): force lzo compression
[  190.459797] BTRFS info (device dm-6): using free space tree
[  190.459799] BTRFS info (device dm-6): has skinny extents
[  197.896560] BTRFS info (device dm-6): checking UUID tree
[  715.237873] BTRFS error (device dm-6): err add delayed dir index item(index: 667) into the deletion tree of the delayed node(root id: 3106, inode id: 1613, errno: -17)
[  715.237885] ------------[ cut here ]------------
[  715.239455] kernel BUG at fs/btrfs/delayed-inode.c:1555!
[  715.241014] invalid opcode: 0000 [#1] PREEMPT SMP
[  715.242575] Modules linked in: radeon ttm
[  715.244143] CPU: 6 PID: 2257 Comm: rm Not tainted 4.9.0-rc8 #2
[  715.245750] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX R2.0, BIOS 2501 04/08/2014
[  715.247352] task: ffff9134f45c3200 task.stack: ffff9ebb0392c000
[  715.248931] RIP: 0010:[<ffffffffb92d5ba9>]  [<ffffffffb92d5ba9>] btrfs_delete_delayed_dir_index+0x219/0x220
[  715.250508] RSP: 0018:ffff9ebb0392fd68  EFLAGS: 00010286
[  715.252114] RAX: 0000000000000000 RBX: ffff91355e687b00 RCX: 0000000000000000
[  715.253706] RDX: 0000000000000000 RSI: ffff91357ed8c7a8 RDI: ffff91357ed8c7a8
[  715.255301] RBP: ffff9134cecc8130 R08: 000000000003a131 R09: 0000000000000005
[  715.256904] R10: 0000000000000040 R11: ffffffffb9f6a12d R12: ffff9134cecc8178
[  715.258544] R13: 000000000000029b R14: ffff913570bbe000 R15: ffff91356ae3f500
[  715.260149] FS:  00007f102b9c6480(0000) GS:ffff91357ed80000(0000) knlGS:0000000000000000
[  715.261762] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  715.263358] CR2: 00000000006ceff4 CR3: 0000000290ddd000 CR4: 00000000000406e0
[  715.264892] Stack:
[  715.266422]  0000000000040000 4dff913555d705f0 6000000000000006 000000000000029b
[  715.267981]  00000000f32e21fa ffff913546f60a50 ffff9ebb0392fe40 ffff913546ea44f0
[  715.269546]  0000000000040ffd 000000000000064d ffff9134d45dc5b0 ffffffffb928143c
[  715.271134] Call Trace:
[  715.272683]  [<ffffffffb928143c>] ? __btrfs_unlink_inode+0x1ac/0x4b0
[  715.274246]  [<ffffffffb9285082>] ? btrfs_unlink_inode+0x12/0x40
[  715.275797]  [<ffffffffb9285111>] ? btrfs_unlink+0x61/0xb0
[  715.277371]  [<ffffffffb91c7e49>] ? vfs_unlink+0xb9/0x180
[  715.278903]  [<ffffffffb91cbc7d>] ? do_unlinkat+0x28d/0x310
[  715.280426]  [<ffffffffb96e5020>] ? entry_SYSCALL_64_fastpath+0x13/0x94
[  715.281950] Code: ff 0f 0b 48 8b 55 10 49 8b be f0 01 00 00 41 89 c1 4c 8b 45 00 48 c7 c6 10 b8 95 b9 48 8b 8a 48 03 00 00 4c 89 ea e8 77 55 f7 ff <0f> 0b e8 d0 1e de ff 53 48 89 fb e8 c7 d8 ff ff 48 85 c0 74 32 
[  715.283627] RIP  [<ffffffffb92d5ba9>] btrfs_delete_delayed_dir_index+0x219/0x220
[  715.285213]  RSP <ffff9ebb0392fd68>
[  715.293587] ---[ end trace fbbdb097ac89a28e ]---
[  808.445004] sysrq: SysRq : Show Blocked State
[  808.445008]   task                        PC stack   pid father
[  808.445085] btrfs-transacti D    0   936      2 0x00000000
[  808.445088]  0000000000000000 ffff913556cab200 ffff91357edd63c0 ffff91356bfa4b00
[  808.445090]  ffff913570972580 ffff9ebb02be7ce8 ffffffffb96e0603 ffffffffb90f1191
[  808.445092]  ffff913556cab200 ffff9134cecc817c ffff913556cab200 00000000ffffffff
[  808.445094] Call Trace:
[  808.445099]  [<ffffffffb96e0603>] ? __schedule+0x173/0x550
[  808.445102]  [<ffffffffb90f1191>] ? mutex_optimistic_spin+0x41/0x1a0
[  808.445103]  [<ffffffffb96e0a14>] ? schedule+0x34/0x80
[  808.445104]  [<ffffffffb96e0d1c>] ? schedule_preempt_disabled+0xc/0x20
[  808.445106]  [<ffffffffb96e28b6>] ? __mutex_lock_slowpath+0xc6/0x140
[  808.445107]  [<ffffffffb96e293e>] ? mutex_lock+0xe/0x20
[  808.445109]  [<ffffffffb92d43d0>] ? __btrfs_run_delayed_items+0xe0/0x630
[  808.445111]  [<ffffffffb92695f1>] ? btrfs_start_dirty_block_groups+0x3e1/0x460
[  808.445113]  [<ffffffffb927ae4a>] ? btrfs_commit_transaction+0x23a/0x9e0
[  808.445115]  [<ffffffffb927b682>] ? start_transaction+0x92/0x3f0
[  808.445116]  [<ffffffffb9275c51>] ? transaction_kthread+0x1a1/0x1e0
[  808.445117]  [<ffffffffb9275ab0>] ? btrfs_cleanup_transaction+0x500/0x500
[  808.445119]  [<ffffffffb90d28d9>] ? kthread+0xc9/0xe0
[  808.445120]  [<ffffffffb90d2810>] ? kthread_park+0x50/0x50
[  808.445122]  [<ffffffffb96e5262>] ? ret_from_fork+0x22/0x30
[  808.445159] rm              D    0  2290   1594 0x00000004
[  808.445161]  0000000000000000 ffff91355631cb00 ffff91357ed563c0 ffff91356f5021c0
[  808.445163]  ffff913570977080 ffff9ebb02c07dc0 ffffffffb96e0603 ffff913500000001
[  808.445165]  ffff91355631cb00 ffff913546f60af0 ffff9ebb02c07df0 ffff913546f60b08
[  808.445166] Call Trace:
[  808.445168]  [<ffffffffb96e0603>] ? __schedule+0x173/0x550
[  808.445170]  [<ffffffffb96e0a14>] ? schedule+0x34/0x80
[  808.445171]  [<ffffffffb96e385b>] ? rwsem_down_read_failed+0xeb/0x140
[  808.445173]  [<ffffffffb935df04>] ? call_rwsem_down_read_failed+0x14/0x30
[  808.445174]  [<ffffffffb96e2dee>] ? down_read+0xe/0x20
[  808.445176]  [<ffffffffb91cf54c>] ? iterate_dir+0x3c/0x160
[  808.445177]  [<ffffffffb91cfab3>] ? SyS_getdents+0x93/0x120
[  808.445178]  [<ffffffffb91cf850>] ? fillonedir+0xd0/0xd0
[  808.445180]  [<ffffffffb96e5020>] ? entry_SYSCALL_64_fastpath+0x13/0x94

So i couldn't unmount the fs because of that.

---------After Sysrq+S completed and Sysrq+B--------------------------

07:43:09-host /home/user # btrfs check --readonly /dev/mapper/container 
Checking filesystem on /dev/mapper/container
UUID: f387eb37-f009-4723-9fda-2cc8f94c8b8d
checking extents
checking free space tree
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 418360348672 bytes used err is 0
total csum bytes: 407542800
total tree bytes: 555958272
total fs tree bytes: 26198016
total extent tree bytes: 27836416
btree space waste bytes: 99121498
file data blocks allocated: 2009880506368
 referenced 421495439360
07:43:46-host /home/user # btrfs check --clear-space-cache v2 --readonly /dev/mapper/container 
Clear free space cache v2
free space cache v2 cleared

After that I mounted the fs and successfully deleted directory "chainstate".

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59398 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdLKDaG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 22:30:06 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eOEmy-0005K6-Id
        for linux-btrfs@vger.kernel.org; Mon, 11 Dec 2017 04:29:56 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Ref doesn't match the record start and is compressed
Date: Mon, 11 Dec 2017 04:29:57 +0100
Message-ID: <lma1ge-76s.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

Since my system was temporarily overloaded (load 500+ for probably
several hours but it recovered, no reboot needed), I'm seeing
btrfs-related backtraces in dmesg with the fs going RO.

I tried to fix it but it fails:

> Fixed 0 roots.
> checking extents
> ref mismatch on [3043919785984 57344] extent item 1, found 3
> Data backref 3043919785984 root 265 owner 83535 offset 131072 num_refs 0 not found in extent tree
> Incorrect local backref count on 3043919785984 root 265 owner 83535 offset 131072 found 1 wanted 0 back 0x61854760
> Backref disk bytenr does not match extent record, bytenr=3043919785984, ref bytenr=3043919790080
> Backref bytes do not match extent backref, bytenr=3043919785984, ref bytes=57344, backref bytes=40960
> Data backref 3043919785984 root 259 owner 11522804 offset 0 num_refs 0 not found in extent tree
> Incorrect local backref count on 3043919785984 root 259 owner 11522804 offset 0 found 1 wanted 0 back 0x57892430
> Backref disk bytenr does not match extent record, bytenr=3043919785984, ref bytenr=3043919831040
> Backref bytes do not match extent backref, bytenr=3043919785984, ref bytes=57344, backref bytes=8192
> backpointer mismatch on [3043919785984 57344]
> attempting to repair backref discrepency for bytenr 3043919785984
> Ref doesn't match the record start and is compressed, please take a btrfs-image of this file system and send it to a btrfs developer so they can complete this functionality for bytenr 3043919790080
> failed to repair damaged filesystem, aborting
> enabling repair mode
> Checking filesystem on /dev/bcacache48 8 UUID:
> bc201ce5-8f2b-4263-995a-6641e89d4c88  

When I identify the files with "btrfs inspect-internal" and try to
delete them, btrfs fails and goes into RO mode:

[  735.877040] ------------[ cut here ]------------
[  735.877048] WARNING: CPU: 2 PID: 809 at fs/btrfs/extent-tree.c:7053 __btrfs_free_extent.isra.71+0x740/0xbc0                                                                                                                                                                    
[  735.877049] Modules linked in: uas usb_storage r8168(O) nvidia_drm(PO) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) nvidia_uvm(PO) nvidia_modeset(PO) nvidia(PO) nct6775 hwmon_vid coretemp hwmon efivarfs                                                                
[  735.877065] CPU: 2 PID: 809 Comm: umount Tainted: P           O    4.14.0-pf4 #1                                                                                                                                                                                               
[  735.877066] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3, BIOS L2.16A 02/22/2013                                                                                                                                                                      
[  735.877067] task: ffff88040b6cf080 task.stack: ffffc900035b0000                                                                                                                                                                                                                
[  735.877070] RIP: 0010:__btrfs_free_extent.isra.71+0x740/0xbc0                                                                                                                                                                                                                  
[  735.877071] RSP: 0018:ffffc900035b3c00 EFLAGS: 00010246                                                                                                                                                                                                                        
[  735.877073] RAX: 00000000fffffffe RBX: 000002c4b7c20000 RCX: ffffc900035b3bb8                                                                                                                                                                                                  
[  735.877074] RDX: 000002c4b7c2d000 RSI: ffff88021c22f607 RDI: ffffc900035b3bb8                                                                                                                                                                                                  
[  735.877075] RBP: 00000000fffffffe R08: 0000000000000000 R09: 000000000001464f                                                                                                                                                                                                  
[  735.877076] R10: 0000000000020000 R11: 000000000000076d R12: ffff880414618000                                                                                                                                                                                                  
[  735.877077] R13: ffff880406b3d850 R14: 0000000000000000 R15: 0000000000000109                                                                                                                                                                                                  
[  735.877079] FS:  00007f6d13424780(0000) GS:ffff88042f280000(0000) knlGS:0000000000000000                                                                                                                                                                                       
[  735.877080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                                                                                                                                  
[  735.877081] CR2: 0000003d9afb3730 CR3: 000000017b391002 CR4: 00000000001606e0                                                                                                                                                                                                  
[  735.877082] Call Trace:                                                                                                                                                                                                                                                        
[  735.877090]  __btrfs_run_delayed_refs+0x3de/0x1000                                                                                                                                                                                                                             
[  735.877094]  btrfs_run_delayed_refs+0x75/0x240                                                                                                                                                                                                                                 
[  735.877098]  btrfs_commit_transaction+0x31/0x820                                                                                                                                                                                                                               
[  735.877102]  ? btrfs_attach_transaction_barrier+0x19/0x40                                                                                                                                                                                                                      
[  735.877105]  sync_filesystem+0x65/0x80                                                                                                                                                                                                                                         
[  735.877109]  generic_shutdown_super+0x1d/0x110                                                                                                                                                                                                                                 
[  735.877111]  kill_anon_super+0x9/0x10                                                                                                                                                                                                                                          
[  735.877115]  btrfs_kill_super+0xd/0x90                                                                                                                                                                                                                                         
[  735.877118]  deactivate_locked_super+0x34/0x60                                                                                                                                                                                                                                 
[  735.877121]  cleanup_mnt+0x36/0x70                                                                                                                                                                                                                                             
[  735.877126]  task_work_run+0x84/0xa0
[  735.877128]  exit_to_usermode_loop+0x81/0x90
[  735.877131]  syscall_return_slowpath+0x7b/0xa0
[  735.877135]  entry_SYSCALL_64_fastpath+0x92/0x94
[  735.877138] RIP: 0033:0x3d9acf94b7
[  735.877139] RSP: 002b:00007ffe139c98a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
[  735.877141] RAX: 0000000000000000 RBX: 0000000001094260 RCX: 0000003d9acf94b7
[  735.877142] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001094440
[  735.877143] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffe139c87c8
[  735.877144] R10: 0000000000000073 R11: 0000000000000202 R12: 0000000001094440
[  735.877145] R13: 000000349aa55e84 R14: 0000000000000001 R15: 0000000000000000
[  735.877146] Code: ff 4d 89 fd 41 bf 4c 00 00 00 e9 d8 fc ff ff 48 8b 3c 24 4d 89 f9 4d 89 f0 48 89 d9 4c 89 ea e8 57 b1 ff ff 89 c5 e9 51 fc ff ff <0f> ff 49 8b 7d 00 e8 f5 b7 00 00 4d 89 f8 4c 89 f1 48 89 da ff 
[  735.877180] ---[ end trace 5c0765d6f8b69164 ]---


Full dmesg is located here:
https://gist.github.com/kakra/82bc726457ee4d401162195d5da1357b

It also includes a second dmesg log (20171209) which occurred during
normal operation when the system tried to access the affected files.


-- 
Regards,
Kai

Replies to list-only preferred.


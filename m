Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D23C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 12:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4536420811
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 12:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbfDXM2h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 08:28:37 -0400
Received: from 207-102-58-17.static.silvernet.ca ([207.102.58.17]:22930 "EHLO
        efa-1.silver.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726880AbfDXM2g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 08:28:36 -0400
X-silvernetworks-MailScanner-EFA-Watermark: 1556713715.84158@/4AQmdCvuE2idiuWwyfTjA
X-silvernetworks-MailScanner-EFA-From: gregory.malloff@silvernetworks.ca
X-silvernetworks-MailScanner-EFA: Found to be clean
X-silvernetworks-MailScanner-EFA-ID: 85EB66096D.A6801
X-silvernetworks-MailScanner-EFA-Information: Please contact administrator@silver.local for more information
Received: from zimbra-1.silver.local (zimbra-1.silver.local [10.0.0.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by efa-1.silver.local (Postfix) with ESMTPS id 85EB66096D
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 05:28:34 -0700 (PDT)
Received: from zimbra-1.silver.local (localhost [127.0.0.1])
        by zimbra-1.silver.local (Postfix) with ESMTPS id 7D39FE3F8F
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 05:28:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by zimbra-1.silver.local (Postfix) with ESMTP id 6F230E3F6D
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 05:28:34 -0700 (PDT)
X-Virus-Scanned: amavisd-new at zimbra-1.silver.local
Received: from zimbra-1.silver.local ([127.0.0.1])
        by localhost (zimbra-1.silver.local [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KK7K9r_t6smx for <linux-btrfs@vger.kernel.org>;
        Wed, 24 Apr 2019 05:28:34 -0700 (PDT)
Received: from zimbra-1.silver.local (zimbra-1.silver.local [10.0.0.51])
        by zimbra-1.silver.local (Postfix) with ESMTP id 579E5E3E30
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 05:28:34 -0700 (PDT)
Date:   Wed, 24 Apr 2019 05:28:34 -0700 (PDT)
From:   Gregory Malloff <gregory.malloff@silvernetworks.ca>
To:     linux-btrfs@vger.kernel.org
Message-ID: <1497429336.5464.1556108913480.JavaMail.gregory.malloff@wks-2>
In-Reply-To: <2091001788.5454.1556108813463.JavaMail.gregory.malloff@wks-2>
Subject: kernel BUG at fs/btrfs/ctree.c:3230!
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.0.51]
X-Mailer: Zimbra 8.8.11_GA_3772 (Zimbra Desktop/7.3.0_13060_Windows)
Thread-Index: EfMbpOqxjSAr5wvVheLz8beIBrpRCw==
Thread-Topic: kernel BUG at fs/btrfs/ctree.c:3230!
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hello, 

After 7 days, BTRFS crashed again with the same error: 

[Tue Apr 23 21:59:40 2019] ------------[ cut here ]------------ 
[Tue Apr 23 21:59:40 2019] kernel BUG at fs/btrfs/ctree.c:3230! 
[Tue Apr 23 21:59:40 2019] invalid opcode: 0000 [#1] SMP PTI 
[Tue Apr 23 21:59:40 2019] CPU: 0 PID: 526 Comm: nfsd Not tainted 4.19.0-4-amd64 #1 Debian 4.19.28-2 
[Tue Apr 23 21:59:40 2019] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/17/2015 
[Tue Apr 23 21:59:40 2019] RIP: 0010:btrfs_set_item_key_safe+0x116/0x190 [btrfs] 
[Tue Apr 23 21:59:40 2019] Code: 48 8d 7c 24 17 48 89 44 24 20 0f b6 44 24 0e 88 44 24 1f 48 8b 44 24 06 48 89 44 24 17 e8 c2 f3 ff ff 85 c0 0f 8f 46 ff ff ff <0f> 0b 8d 43 ff 48 8d 74 24 06 4c 89 e7 b9 11 00 00 00 48 98 48 8d 
[Tue Apr 23 21:59:40 2019] RSP: 0018:ffffb23fc082f6a0 EFLAGS: 00010246 
[Tue Apr 23 21:59:40 2019] RAX: 0000000000000000 RBX: 000000000000008d RCX: 000000000c71b000 
[Tue Apr 23 21:59:40 2019] RDX: 000000000003996e RSI: ffffb23fc082f795 RDI: ffffb23fc082f6b7 
[Tue Apr 23 21:59:40 2019] RBP: ffff9e9ec6bc95b0 R08: 0000000000001000 R09: 0000000000004000 
[Tue Apr 23 21:59:40 2019] R10: 0000000000000000 R11: 00000000ffffffff R12: ffff9e9e90957000 
[Tue Apr 23 21:59:40 2019] R13: ffffb23fc082f795 R14: 0000000000000000 R15: 000000000d007000 
[Tue Apr 23 21:59:40 2019] FS: 0000000000000000(0000) GS:ffff9e9efda00000(0000) knlGS:0000000000000000 
[Tue Apr 23 21:59:40 2019] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[Tue Apr 23 21:59:40 2019] CR2: 00007f8bddd7fae4 CR3: 00000000735de000 CR4: 00000000000406f0 
[Tue Apr 23 21:59:40 2019] Call Trace: 
[Tue Apr 23 21:59:40 2019] __btrfs_drop_extents+0x7ae/0xcf0 [btrfs] 
[Tue Apr 23 21:59:40 2019] btrfs_log_changed_extents.isra.24+0x391/0x990 [btrfs] 
[Tue Apr 23 21:59:40 2019] btrfs_log_inode+0xb54/0x1240 [btrfs] 
[Tue Apr 23 21:59:40 2019] ? __schedule+0x2aa/0x870 
[Tue Apr 23 21:59:40 2019] ? __switch_to_asm+0x34/0x70 
[Tue Apr 23 21:59:40 2019] btrfs_log_inode_parent+0x2a1/0xac0 [btrfs] 
[Tue Apr 23 21:59:40 2019] ? wait_current_trans+0x2f/0xf0 [btrfs] 
[Tue Apr 23 21:59:40 2019] ? refcount_inc_checked+0x5/0x30 
[Tue Apr 23 21:59:40 2019] ? join_transaction+0xec/0x410 [btrfs] 
[Tue Apr 23 21:59:40 2019] btrfs_log_dentry_safe+0x4a/0x70 [btrfs] 
[Tue Apr 23 21:59:40 2019] btrfs_sync_file+0x1cb/0x3d0 [btrfs] 
[Tue Apr 23 21:59:40 2019] btrfs_file_write_iter+0x495/0x590 [btrfs] 
[Tue Apr 23 21:59:40 2019] ? apparmor_cred_prepare+0x4c/0x60 
[Tue Apr 23 21:59:40 2019] do_iter_readv_writev+0x13a/0x1b0 
[Tue Apr 23 21:59:40 2019] do_iter_write+0x80/0x190 
[Tue Apr 23 21:59:40 2019] nfsd_vfs_write+0xe6/0x450 [nfsd] 
[Tue Apr 23 21:59:40 2019] ? do_dentry_open+0xd1/0x330 
[Tue Apr 23 21:59:40 2019] nfsd_write+0x88/0x170 [nfsd] 
[Tue Apr 23 21:59:40 2019] ? _cond_resched+0x15/0x30 
[Tue Apr 23 21:59:40 2019] nfsd3_proc_write+0xc3/0x170 [nfsd] 
[Tue Apr 23 21:59:40 2019] nfsd_dispatch+0x9e/0x210 [nfsd] 
[Tue Apr 23 21:59:40 2019] svc_process_common+0x4a5/0x720 [sunrpc] 
[Tue Apr 23 21:59:40 2019] ? nfsd_destroy+0x50/0x50 [nfsd] 
[Tue Apr 23 21:59:40 2019] svc_process+0xb7/0xf0 [sunrpc] 
[Tue Apr 23 21:59:40 2019] nfsd+0xe3/0x140 [nfsd] 
[Tue Apr 23 21:59:40 2019] kthread+0x112/0x130 
[Tue Apr 23 21:59:40 2019] ? kthread_bind+0x30/0x30 
[Tue Apr 23 21:59:40 2019] ret_from_fork+0x35/0x40 
[Tue Apr 23 21:59:40 2019] Modules linked in: vmw_vsock_vmci_transport vsock coretemp crct10dif_pclmul crc32_pclmul vmwgfx ttm ghash_clmulni_intel ppdev drm_kms_helper vmw_balloon intel_rapl_perf joydev evdev drm pcspkr serio_raw sg vmw_vmci parport_pc parport button ac nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb btrfs xor zstd_decompress zstd_compress xxhash raid6_pq libcrc32c crc32c_generic sd_mod sr_mod cdrom ata_generic crc32c_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse ata_piix mptspi mptscsih mptbase libata vmxnet3 scsi_transport_spi scsi_mod i2c_piix4 floppy 
[Tue Apr 23 21:59:40 2019] ---[ end trace 9153b7dc6f042f19 ]--- 
[Tue Apr 23 21:59:40 2019] RIP: 0010:btrfs_set_item_key_safe+0x116/0x190 [btrfs] 
[Tue Apr 23 21:59:40 2019] Code: 48 8d 7c 24 17 48 89 44 24 20 0f b6 44 24 0e 88 44 24 1f 48 8b 44 24 06 48 89 44 24 17 e8 c2 f3 ff ff 85 c0 0f 8f 46 ff ff ff <0f> 0b 8d 43 ff 48 8d 74 24 06 4c 89 e7 b9 11 00 00 00 48 98 48 8d 
[Tue Apr 23 21:59:40 2019] RSP: 0018:ffffb23fc082f6a0 EFLAGS: 00010246 
[Tue Apr 23 21:59:40 2019] RAX: 0000000000000000 RBX: 000000000000008d RCX: 000000000c71b000 
[Tue Apr 23 21:59:40 2019] RDX: 000000000003996e RSI: ffffb23fc082f795 RDI: ffffb23fc082f6b7 
[Tue Apr 23 21:59:40 2019] RBP: ffff9e9ec6bc95b0 R08: 0000000000001000 R09: 0000000000004000 
[Tue Apr 23 21:59:40 2019] R10: 0000000000000000 R11: 00000000ffffffff R12: ffff9e9e90957000 
[Tue Apr 23 21:59:40 2019] R13: ffffb23fc082f795 R14: 0000000000000000 R15: 000000000d007000 
[Tue Apr 23 21:59:40 2019] FS: 0000000000000000(0000) GS:ffff9e9efda00000(0000) knlGS:0000000000000000 
[Tue Apr 23 21:59:40 2019] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[Tue Apr 23 21:59:40 2019] CR2: 00007f8bddd7fae4 CR3: 00000000735de000 CR4: 00000000000406f0 
[05:24 AM] root@nas-201-b:~> uptime 
05:24:56 up 7 days, 15:05, 1 user, load average: 16.07, 16.03, 15.85 

Please let me know if you need any other details to help me resolve this issue. 

----- Original Message -----

From: "Gregory Malloff" <gregory.malloff@silvernetworks.ca> 
To: linux-btrfs@vger.kernel.org 
Sent: Tuesday, April 16, 2019 12:53:20 PM 
Subject: kernel BUG at fs/btrfs/ctree.c:3230! 


Hello, 

Problem: On a Debian 9 or 10 system with an NFS share and heavy I/O, about every 5 days or so, I get the following: 

http://cwillu.com:8080/207.102.58.55 

4,1352,538395169676,-;------------[ cut here ]------------ 
2,1353,538395169680,-;kernel BUG at fs/btrfs/ctree.c:3230! 
4,1354,538395169742,-;invalid opcode: 0000 [#1] SMP PTI 
4,1355,538395169767,-;CPU: 0 PID: 859 Comm: nfsd Not tainted 4.19.0-4-amd64 #1 Debian 4.19.28-2 
4,1356,538395169802,-;Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/17/2015 
4,1357,538395169884,-;RIP: 0010:btrfs_set_item_key_safe+0x116/0x190 [btrfs] 
4,1358,538395169921,-;Code: 48 8d 7c 24 17 48 89 44 24 20 0f b6 44 24 0e 88 44 24 1f 48 8b 44 24 06 48 89 44 24 17 e8 c2 f3 ff ff 85 c0 0f 8f 46 ff ff ff <0f> 0b 8d 43 ff 48 8d 74 24 06 4c 89 e7 b9 11 00 00 00 48 98 48 8d 
4,1359,538395170000,-;RSP: 0018:ffffc08a41fbf6a0 EFLAGS: 00010246 
4,1360,538395171003,-;RAX: 0000000000000000 RBX: 000000000000008f RCX: 000000005baa2000 
4,1361,538395171948,-;RDX: 0000000000031b05 RSI: ffffc08a41fbf795 RDI: ffffc08a41fbf6b7 
4,1362,538395172882,-;RBP: ffff9d6b33ef3460 R08: 0000000000001000 R09: 0000000000004000 
4,1363,538395173774,-;R10: 0000000000000000 R11: 00000000ffffffff R12: ffff9d6c5a788c08 
4,1364,538395174713,-;R13: ffffc08a41fbf795 R14: 0000000000000000 R15: 000000005c01a000 
4,1365,538395175761,-;FS: 0000000000000000(0000) GS:ffff9d6cb7a00000(0000) knlGS:0000000000000000 
4,1366,538395176716,-;CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
4,1367,538395177582,-;CR2: 00007ffe8161dbe8 CR3: 000000022b3fa000 CR4: 00000000000406f0 
4,1368,538395178523,-;Call Trace: 
4,1369,538395179418,-; __btrfs_drop_extents+0x7ae/0xcf0 [btrfs] 
4,1370,538395180296,-; btrfs_log_changed_extents.isra.24+0x391/0x990 [btrfs] 
4,1371,538395181233,-; btrfs_log_inode+0xb54/0x1240 [btrfs] 
4,1372,538395182096,-; ? __kprobes_text_end+0xe5c68/0xe5c68 
4,1373,538395182930,-; ? __switch_to_asm+0x34/0x70 
4,1374,538395183747,-; ? __switch_to_asm+0x40/0x70 
4,1375,538395184542,-; ? __switch_to_asm+0x34/0x70 
4,1376,538395185320,-; ? __switch_to_asm+0x34/0x70 
4,1377,538395186078,-; ? __switch_to_asm+0x40/0x70 
4,1378,538395186859,-; btrfs_log_inode_parent+0x2a1/0xac0 [btrfs] 
4,1379,538395187644,-; ? wait_current_trans+0x2f/0xf0 [btrfs] 
4,1380,538395188379,-; ? refcount_inc_checked+0x5/0x30 
4,1381,538395189254,-; ? join_transaction+0xec/0x410 [btrfs] 
4,1382,538395190159,-; btrfs_log_dentry_safe+0x4a/0x70 [btrfs] 
4,1383,538395190901,-; btrfs_sync_file+0x1cb/0x3d0 [btrfs] 
4,1384,538395191826,-; btrfs_file_write_iter+0x495/0x590 [btrfs] 
4,1385,538395192631,-; ? apparmor_cred_prepare+0x4c/0x60 
4,1386,538395193334,-; do_iter_readv_writev+0x13a/0x1b0 
4,1387,538395195201,-; do_iter_write+0x80/0x190 
4,1388,538395195877,-; nfsd_vfs_write+0xe6/0x450 [nfsd] 
4,1389,538395196537,-; ? do_dentry_open+0xd1/0x330 
4,1390,538395197182,-; nfsd_write+0x88/0x170 [nfsd] 
4,1391,538395197785,-; ? _cond_resched+0x15/0x30 
4,1392,538395198386,-; nfsd3_proc_write+0xc3/0x170 [nfsd] 
4,1393,538395198980,-; nfsd_dispatch+0x9e/0x210 [nfsd] 
4,1394,538395199561,-; svc_process_common+0x4a5/0x720 [sunrpc] 
4,1395,538395200128,-; ? nfsd_destroy+0x50/0x50 [nfsd] 
4,1396,538395200682,-; svc_process+0xb7/0xf0 [sunrpc] 
4,1397,538395201219,-; nfsd+0xe3/0x140 [nfsd] 
4,1398,538395201742,-; kthread+0x112/0x130 
4,1399,538395202263,-; ? kthread_bind+0x30/0x30 
4,1400,538395202776,-; ret_from_fork+0x35/0x40 
4,1401,538395203296,-;Modules linked in: vmw_vsock_vmci_transport vsock coretemp crct10dif_pclmul crc32_pclmul vmwgfx vmw_balloon ttm ghash_clmulni_intel ppdev drm_kms_helper intel_rapl_perf joydev pcspkr serio_raw drm sg vmw_vmci evdev parport_pc parport button ac nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb btrfs xor zstd_decompress zstd_compress xxhash raid6_pq libcrc32c crc32c_generic sd_mod sr_mod cdrom ata_generic crc32c_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse mptspi mptscsih ata_piix mptbase scsi_transport_spi libata scsi_mod vmxnet3 i2c_piix4 floppy 
4,1402,538395207304,-;---[ end trace 4eda186227cc8ba6 ]--- 

#uname -a 
Linux nas-201-b 4.19.0-4-amd64 #1 SMP Debian 4.19.28-2 (2019-03-15) x86_64 GNU/Linux 

#btrfs --version 
btrfs-progs v4.20.1 

#btrfs fi show 
Label: none uuid: 1388dd44-f704-42bd-bdfd-95f2b43af671 
Total devices 1 FS bytes used 2.95TiB 
devid 1 size 5.00TiB used 3.35TiB path /dev/sdb 

#btrfs fi df /data 
Data, single: total=3.33TiB, used=2.94TiB 
System, DUP: total=40.00MiB, used=416.00KiB 
Metadata, DUP: total=10.00GiB, used=7.21GiB 
GlobalReserve, single: total=512.00MiB, used=0.00B 

#btrfs check --readonly /dev/sdb 
Opening filesystem to check... 
Checking filesystem on /dev/sdb 
UUID: 1388dd44-f704-42bd-bdfd-95f2b43af671 
[1/7] checking root items 
[2/7] checking extents 
[3/7] checking free space cache 
[4/7] checking fs roots 
[5/7] checking only csums items (without verifying data) 
[6/7] checking root refs 
[7/7] checking quota groups skipped (not enabled on this FS) 
found 3244857946112 bytes used, no error found 
total csum bytes: 3160375372 
total tree bytes: 7738867712 
total fs tree bytes: 2187886592 
total extent tree bytes: 1546764288 
btree space waste bytes: 1368283474 
file data blocks allocated: 6333316149248 
referenced 6330266890240 

#btrfs scrub start /data 
scrub started on /data, fsid 1388dd44-f704-42bd-bdfd-95f2b43af671 (pid=887) 

#btrfs scrub status /data 
scrub status for 1388dd44-f704-42bd-bdfd-95f2b43af671 
scrub started at Tue Apr 16 11:06:49 2019 and finished after 01:27:55 
total bytes scrubbed: 2.96TiB with 0 errors 

#btrfs device stats /data 
[/dev/sdb].write_io_errs 0 
[/dev/sdb].read_io_errs 0 
[/dev/sdb].flush_io_errs 0 
[/dev/sdb].corruption_errs 0 
[/dev/sdb].generation_errs 0 

[dmesg.log file attached] 

Cheers, 
Greg 

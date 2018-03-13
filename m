Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v150-95-217-78.ll6w.static.cnode.io ([150.95.217.78]:60282 "EHLO
        mail.reasonset.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932277AbeCMTZI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 15:25:08 -0400
Date: Wed, 14 Mar 2018 04:25:07 +0900
From: MASAKI haruka <yek@reasonset.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs broken in massive transfar
Message-Id: <20180314042507.f20bbf949ce07f88ca01cb38@reasonset.net>
In-Reply-To: <c938a753-deb6-39bb-0f17-701ec1e0226b@gmx.com>
References: <20180313065743.c3ec9ade3e90dc4fc4b5adc9@reasonset.net>
        <f4e1a551-fc29-f7e8-a738-76365af403f7@gmx.com>
        <20180313131928.5f3f1d053eaf50424b6dbff8@reasonset.net>
        <c938a753-deb6-39bb-0f17-701ec1e0226b@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

journal(Kernel log), 7th try (to be readonly):

---
 3月 12 16:25:51 lily kernel: BTRFS info (device dm-6): creating UUID tree
 3月 12 16:25:53 lily iscsid[1406]: Connection-1:0 to [target: iqn.1994-11.com.netgear:eggplant-01:edc9adcf:btr1group, portal: 192.168.1.166,3260] through [iface: default] is shutdown.
 3月 12 16:25:53 lily iscsid[1406]: IPC qtask write failed: Broken pipe
 3月 12 16:26:18 lily kernel:  connection1:0: detected conn error (1020)
 3月 12 16:26:19 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 Sense Key : 0x2 [current] [descriptor] 
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 ASC=0x8 ASCQ=0x0 
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#5 CDB: opcode=0x8a 8a 00 00 00 00 00 00 42 5c 00 00 00 34 00 00 00
 3月 12 16:26:21 lily kernel: print_req_error: I/O error, dev sdg, sector 4348928
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#6 Sense Key : 0x2 [current] [descriptor] 
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#6 ASC=0x8 ASCQ=0x0 
 3月 12 16:26:21 lily kernel: sd 8:0:0:0: [sdg] tag#6 CDB: opcode=0x8a 8a 00 00 00 00 00 00 42 20 00 00 00 3c 00 00 00
 3月 12 16:26:21 lily kernel: print_req_error: I/O error, dev sdg, sector 4333568
 3月 12 16:26:21 lily kernel:  connection1:0: detected conn error (1020)
 3月 12 16:26:21 lily iscsid[1406]: connection1:0 is operational after recovery (1 attempts)
 3月 12 16:26:21 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
 3月 12 16:26:23 lily kernel:  connection1:0: detected conn error (1020)
 3月 12 16:26:23 lily iscsid[1406]: connection1:0 is operational after recovery (1 attempts)
 3月 12 16:26:23 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
 3月 12 16:26:25 lily kernel:  connection1:0: detected conn error (1020)
 3月 12 16:26:25 lily iscsid[1406]: connection1:0 is operational after recovery (1 attempts)
 3月 12 16:26:25 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
 3月 12 16:26:27 lily iscsid[1406]: connection1:0 is operational after recovery (1 attempts)
 3月 12 16:31:31 lily kernel:  connection1:0: detected conn error (1020)
 3月 12 16:31:32 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
 3月 12 16:31:34 lily iscsid[1406]: connection1:0 is operational after recovery (1 attempts)
 3月 12 16:35:13 lily systemd[1]: Starting Cleanup of Temporary Directories...
 3月 12 16:35:13 lily systemd[1]: Started Cleanup of Temporary Directories.
...
 3月 12 16:53:40 lily kernel: hrtimer: interrupt took 14162 ns
 3月 12 17:01:01 lily CROND[1926]: (root) CMD (run-parts /etc/cron.hourly)
 3月 12 18:01:01 lily CROND[2095]: (root) CMD (run-parts /etc/cron.hourly)
 3月 12 18:11:32 lily kernel: sd 8:0:0:0: [sdg] tag#15 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 12 18:11:32 lily kernel: sd 8:0:0:0: [sdg] tag#15 Sense Key : 0x2 [current] [descriptor] 
 3月 12 18:11:32 lily kernel: sd 8:0:0:0: [sdg] tag#15 ASC=0x8 ASCQ=0x0 
 3月 12 18:11:32 lily kernel: sd 8:0:0:0: [sdg] tag#15 CDB: opcode=0x8a 8a 00 00 00 00 00 35 9f df 30 00 00 40 00 00 00
 3月 12 18:11:32 lily kernel: print_req_error: I/O error, dev sdg, sector 899669808
 3月 12 18:11:32 lily kernel: btrfs_dev_stat_print_on_error: 18 callbacks suppressed
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 29, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 30, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 31, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 32, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 33, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 34, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 35, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 36, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 37, rd 0, flush 0, corrupt 0, gen 0
 3月 12 18:11:32 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 38, rd 0, flush 0, corrupt 0, gen 0
 3月 12 19:01:01 lily CROND[2257]: (root) CMD (run-parts /etc/cron.hourly)
 3月 12 19:14:24 lily kernel:  connection1:0: detected conn error (1020)
 3月 12 19:14:25 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
 3月 12 19:14:27 lily iscsid[1406]: connection1:0 is operational after recovery (1 attempts)
 3月 12 19:14:34 lily kernel:  connection1:0: detected conn error (1020)
 3月 12 19:14:35 lily iscsid[1406]: Kernel reported iSCSI connection 1:0 error (1020 - ISCSI_ERR_TCP_CONN_CLOSE: TCP connection closed) state (3)
 3月 12 19:14:37 lily iscsid[1406]: connection1:0 is operational after recovery (1 attempts)
...
 3月 13 00:15:26 lily kernel: sd 8:0:0:0: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:15:26 lily kernel: sd 8:0:0:0: [sdg] tag#2 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:15:26 lily kernel: sd 8:0:0:0: [sdg] tag#2 ASC=0x8 ASCQ=0x0 
 3月 13 00:15:26 lily kernel: sd 8:0:0:0: [sdg] tag#2 CDB: opcode=0x8a 8a 00 00 00 00 00 c9 e0 8b 80 00 00 40 00 00 00
 3月 13 00:15:26 lily kernel: print_req_error: I/O error, dev sdg, sector 3386936192
 3月 13 00:15:26 lily kernel: btrfs_dev_stat_print_on_error: 6 callbacks suppressed
 3月 13 00:15:26 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 45, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:15:26 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 46, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:15:26 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 47, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:15:26 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 48, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:27:47 lily systemd[1]: Started Update locate database.
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#22 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#22 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#22 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#22 CDB: opcode=0x8a 8a 00 00 00 00 00 ee 9e bb c0 00 00 40 00 00 00
 3月 13 00:36:43 lily kernel: print_req_error: I/O error, dev sdg, sector 4003380160
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 49, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 50, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 51, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 52, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 53, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 54, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 55, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#23 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#23 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#23 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:43 lily kernel: sd 8:0:0:0: [sdg] tag#23 CDB: opcode=0x8a 8a 00 00 00 00 00 ee 9e fb c0 00 00 38 80 00 00
 3月 13 00:36:43 lily kernel: print_req_error: I/O error, dev sdg, sector 4003396544
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 56, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 57, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:43 lily kernel: BTRFS error (device dm-6): bdev /dev/mapper/hymaster_1 errs: wr 58, rd 0, flush 0, corrupt 0, gen 0
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 CDB: opcode=0x8a 8a 00 00 00 00 00 cd 6f 0b 80 00 00 2a 20 00 00
 3月 13 00:36:47 lily kernel: print_req_error: I/O error, dev sdg, sector 3446606720
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 CDB: opcode=0x8a 8a 00 00 00 00 00 cd 6f 35 c0 00 00 3f c0 00 00
 3月 13 00:36:47 lily kernel: print_req_error: I/O error, dev sdg, sector 3446617536
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#1 CDB: opcode=0x8a 8a 00 00 00 00 00 cd 6f 0b 80 00 00 2a 20 00 00
 3月 13 00:36:47 lily kernel: print_req_error: I/O error, dev sdg, sector 3446606720
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#2 CDB: opcode=0x8a 8a 00 00 00 00 00 cd 6f 35 c0 00 00 3f c0 00 00
 3月 13 00:36:47 lily kernel: print_req_error: I/O error, dev sdg, sector 3446617536
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#3 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#3 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#3 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#3 CDB: opcode=0x8a 8a 00 00 00 00 00 cd 6f 75 80 00 00 30 80 00 00
 3月 13 00:36:47 lily kernel: print_req_error: I/O error, dev sdg, sector 3446633856
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#5 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#5 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#5 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#5 CDB: opcode=0x8a 8a 00 00 00 00 00 cd 7f 35 c0 00 00 3f c0 00 00
 3月 13 00:36:47 lily kernel: print_req_error: I/O error, dev sdg, sector 3447666112
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#6 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte=0x08
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#6 Sense Key : 0x2 [current] [descriptor] 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#6 ASC=0x8 ASCQ=0x0 
 3月 13 00:36:47 lily kernel: sd 8:0:0:0: [sdg] tag#6 CDB: opcode=0x8a 8a 00 00 00 00 00 cd 7f 75 80 00 00 30 80 00 00
 3月 13 00:36:47 lily kernel: print_req_error: I/O error, dev sdg, sector 3447682432
 3月 13 00:36:47 lily kernel: BTRFS: error (device dm-6) in btrfs_commit_transaction:2253: errno=-5 IO failure (Error while writing out transaction)
 3月 13 00:36:47 lily kernel: BTRFS info (device dm-6): forced readonly
 3月 13 00:36:47 lily kernel: BTRFS warning (device dm-6): Skipping commit of aborted transaction.
 3月 13 00:36:47 lily kernel: BTRFS: error (device dm-6) in cleanup_transaction:1873: errno=-5 IO failure
 3月 13 00:36:47 lily kernel: BTRFS info (device dm-6): delayed_refs has NO entry
---


btrfs check output, 11th try (to be readonly):

---
checking extents
checking free space cache
checking fs roots
root 257 inode 503608 errors 100, file extent discount
Found file extent holes:
        start: 1610612736, len: 134217728
ERROR: errors found in fs roots
Checking filesystem on /dev/mapper/hymaster_1
UUID: ed789994-420e-4781-bab8-d395cfff27ed
found 1333560619008 bytes used, error(s) found
total csum bytes: 1299853404
total tree bytes: 2184232960
total fs tree bytes: 560693248
total extent tree bytes: 76267520
btree space waste bytes: 302431759
file data blocks allocated: 1331376386048
 referenced 1332755861504
---

Note: This system's structure is;
Computer (Linux 4.14/4.15) - btrfs (original) - dm-crypt plain - internal 4 disks
 \_ btrfs (destination) - dm-crypt plain - iSCSI (single) - NAS - Hardware RAID5 - 8 disks




> 
> 
> On 2018年03月13日 12:19, MASAKI haruka wrote:
> > *Now* I tried with Linux 4.14 and 4.15.
> > I experienced same probrem and reported in 2014 with Linux 3.9 and 3.10. (Perchance, actually the kernel was newer than 3.10, anyway I experienced same probrem with old 3.x kernel.)
> 
> Then kernel message please.
> 
> Especially for the readonly case.
> 
> And "btrfs check" output please.
> 
> Thanks,
> Qu
> 
> 
> > 
> >>
> >>
> >> On 2018年03月13日 05:57, MASAKI haruka wrote:
> >>> I'm trying to clone 18TiB data between btrfs,
> >>> but it will crash anyway.
> >>>
> >>> This probrem is occured even how to clone (btrfs send/receive, rsync or cp.)
> >>> I experienced same probrem in Linux 3.9 and Linux 3.10.
> >>
> >> Did you really mean *3*.9 and *3*.10?
> >>
> >> That's too old for btrfs usage IIRC.
> >>
> >> It would be *4*.9 or *4*.10 for a relative new kernel for btrfs.
> >>
> >> Would you please try some latest mainline kernel again?
> >>
> >>>
> >>> What happen:
> >>>
> >>> 1. Failed to write because I/O error (read only filesystem)
> >>> 2. writing to the btrfs succeeds and fails randomly.
> >>> 3. The btrfs unable to unmount (resource is busy.) Unable to umount even forcely, so cannot halt.
> >>>
> >>> Example:
> >>> ---
> >>> mkfile o7784-11-0
> >>> rename o7784-11-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
> >>> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo
> >>> truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw size=1073698824
> >>> chown .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - uid=1000, gid=1000
> >>> chmod .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw - mode=0600
> >>> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/kVxX8RdGhryQiEMOm4II2qMw
> >>> mkfile o7785-12-0
> >>> rename o7785-12-0 -> .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X
> >>> utimes .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo
> >>> truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X size=864067592
> >>> ERROR: truncate .filesystem/HDD/.XFV_pp/,fQO40jotqhUZ0/5JSSubx1Ph5xYNOcXhIAoIK3/XDGOWpbx,5zYWEi0L5LHdWBo/lSABmfoArm9pAtade-gHmS6X failed: Input/output error
> >>> btrfs send 180310235348  0.09s user 11.98s system 16% cpu 1:14.42 total
> >>> ---
> >>
> >> In that case, we need kernel message to investigate.
> >> (And of course, please use at least 4.x kernel)
> >>
> >> Thanks,
> >> Qu
> >>
> >>>
> >>> Tries:
> >>> 1.
> >>> Connect between host A (btrfs, 4disks) and B with socat (TCP).
> >>> Host B write to iSCSI disk (btrfs, single).
> >>> clone with btrfs send/receive. Linux 4.15.
> >>> -> Crashed at transfarred 1.78TB
> >>>
> >>> 2.
> >>> Delete snapshot and retry.
> >>> Connect between host A and B with SSH and socat (UNIX).
> >>> Host B write to iSCSI disk (btrfs, single).
> >>> clone with btrfs send/receive. Linux 4.15.
> >>> -> Crashed at transfarred 90GB
> >>>
> >>> 3.
> >>> Recreate btrfs.
> >>> Host A write to iSCSI disk.
> >>> clone with btrfs send/receive. Linux 4.15.
> >>> -> Crashed at transfarred 260GB
> >>>
> >>> 4.
> >>> Recreate btrfs.
> >>> Original disk attach to other computer (having more resource.)
> >>> clone with btrfs send/receive. Linux 4.15.
> >>> -> Crashed at transfarred 120GB
> >>>
> >>> 5.
> >>> Recreate btrfs.
> >>> Clone with rsync. Linux 4.15.
> >>> -> Crashed at transfarred 100GB
> >>>
> >>> 6.
> >>> Recreate btrfs.
> >>> Try with Linux 4.14, btrfs send/receive.
> >>> -> Crashed at transfarred 3.98TB
> >>>
> >>> 7.
> >>> Recreate btrfs.
> >>> Connect between host and NAS (iSCSI) with GbE cable directly.
> >>> Mounted with options relatime, spase_cache, compress=lzo.
> >>> clone with btrfs send/receive. Linux 4.14.
> >>> -> Crashed at transfarred 2.13TB
> >>>
> >>
> > 
> > 
> 


-- 
MASAKI haruka <yek@reasonset.net>

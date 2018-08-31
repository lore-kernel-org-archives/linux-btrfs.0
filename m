Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:27614 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbeHaUo3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 16:44:29 -0400
Received: from mail.tol.fr (unknown [78.234.252.95])
        by smtp1-g21.free.fr (Postfix) with ESMTP id 27306B0054E
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 18:36:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.tol.fr (Postfix) with ESMTP id A524A978034E
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 18:36:07 +0200 (CEST)
Received: from mail.tol.fr ([127.0.0.1])
        by localhost (sos.couderc.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id z2vgg9EaKjiq for <linux-btrfs@vger.kernel.org>;
        Fri, 31 Aug 2018 18:36:07 +0200 (CEST)
Received: from [192.168.163.11] (unknown [192.168.163.254])
        by mail.tol.fr (Postfix) with ESMTPSA id 1A73497802D9
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 18:36:00 +0200 (CEST)
From: Pierre Couderc <pierre@couderc.eu>
Subject: IO errors when building RAID1.... ?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
Date: Fri, 31 Aug 2018 18:35:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When trying to build a RAID1 on main fs. After  normal debian stretch 
install :

<code>

root@server:/home/nous# btrfs device add /dev/sdb1 /
root@server:/home/nous# btrfs fi show
Label: none  uuid: ef0b9dad-c0eb-4a3b-9b41-e5e249363abc
         Total devices 2 FS bytes used 824.60MiB
         devid    1 size 1.82TiB used 3.02GiB path /dev/sda1
         devid    2 size 1.82TiB used 0.00B path /dev/sdb1

root@server:/home/nous# btrfs balance start -v -mconvert=raid1 
-dconvert=raid1 /
Dumping filters: flags 0x7, state 0x0, force is off
   DATA (flags 0x100): converting, target=16, soft is off
   METADATA (flags 0x100): converting, target=16, soft is off
   SYSTEM (flags 0x100): converting, target=16, soft is off
Killed
root@server:/home/nous# btrfs fi show
Label: none  uuid: ef0b9dad-c0eb-4a3b-9b41-e5e249363abc
         Total devices 2 FS bytes used 1.29GiB
         devid    2 size 1.82TiB used 1.00GiB path /dev/sdb1
         *** Some devices missing
</code>

Some IO errors on /dev/sda are found in journalctl (see them below)

I cannot believe that /dev/sda has no hard disk errors when installing 
without problems, but has many ones when I "btrfs device add /dev/sdb1 /".

I can reproduce the problem : reinstall (3times...) and try "btrfs 
device add /dev/sdb1 /" with the same results...


<journalctl>

Aug 31 17:34:55 server su[559]: Successful su for root by nous
Aug 31 17:34:55 server su[559]: + /dev/pts/1 nous:root
Aug 31 17:34:55 server su[559]: pam_unix(su:session): session opened for 
user root by nous(uid=1000)
Aug 31 17:34:55 server su[559]: pam_systemd(su:session): Cannot create 
session: Already running in a session
Aug 31 17:35:03 server kernel: BTRFS info (device sda1): disk added 
/dev/sdb1
Aug 31 17:35:40 server kernel: BTRFS info (device sda1): relocating 
block group 1103101952 flags 1
Aug 31 17:36:12 server sshd[572]: Accepted password for nous from 
2a01:e34:eeaf:c5f0:e54:15ff:feb1:b1c9 port 49308 ssh2
Aug 31 17:36:12 server sshd[572]: pam_unix(sshd:session): session opened 
for user nous by (uid=0)
Aug 31 17:36:12 server systemd-logind[415]: New session 4 of user nous.
Aug 31 17:36:12 server systemd[1]: Started Session 4 of user nous.
Aug 31 17:36:16 server kernel: ata1: lost interrupt (Status 0x50)
Aug 31 17:36:16 server kernel: ata1.00: exception Emask 0x50 SAct 0x0 
SErr 0x40d0802 action 0xe frozen
Aug 31 17:36:16 server kernel: ata1.00: SError: { RecovComm HostInt 
PHYRdyChg CommWake 10B8B DevExch }
Aug 31 17:36:16 server kernel: ata1.00: failed command: READ DMA
Aug 31 17:36:16 server kernel: ata1.00: cmd 
c8/00:60:00:cd:02/00:00:00:00:00/e0 tag 0 dma 49152 in
                                         res 
40/00:01:00:00:00/00:00:00:00:00/40 Emask 0x54 (ATA bus error)
Aug 31 17:36:16 server kernel: ata1.00: status: { DRDY }
Aug 31 17:36:16 server kernel: ata1.00: hard resetting link
Aug 31 17:36:17 server kernel: ata1.01: hard resetting link
Aug 31 17:36:18 server kernel: ata1.01: failed to resume link (SControl 0)
Aug 31 17:36:18 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 
133 SControl 300)
Aug 31 17:36:18 server kernel: ata1.01: SATA link down (SStatus 4 
SControl 0)
Aug 31 17:36:18 server kernel: ata1.00: NODEV after polling detection
Aug 31 17:36:18 server kernel: ata1.00: revalidation failed (errno=-2)
Aug 31 17:36:20 server su[590]: Successful su for root by nous
Aug 31 17:36:20 server su[590]: + /dev/pts/2 nous:root
Aug 31 17:36:20 server su[590]: pam_unix(su:session): session opened for 
user root by nous(uid=1000)
Aug 31 17:36:20 server su[590]: pam_systemd(su:session): Cannot create 
session: Already running in a session
Aug 31 17:36:23 server kernel: ata1.00: hard resetting link
Aug 31 17:36:23 server kernel: ata1.01: hard resetting link
Aug 31 17:36:24 server kernel: ata1.01: failed to resume link (SControl 0)
Aug 31 17:36:25 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 
133 SControl 300)
Aug 31 17:36:25 server kernel: ata1.01: SATA link down (SStatus 4 
SControl 0)
Aug 31 17:36:25 server kernel: ata1.00: NODEV after polling detection
Aug 31 17:36:25 server kernel: ata1.00: revalidation failed (errno=-2)
Aug 31 17:36:30 server kernel: ata1.00: hard resetting link
Aug 31 17:36:30 server kernel: ata1.01: hard resetting link
Aug 31 17:36:31 server kernel: ata1.01: failed to resume link (SControl 0)
Aug 31 17:36:31 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 
133 SControl 300)
Aug 31 17:36:31 server kernel: ata1.01: SATA link down (SStatus 4 
SControl 0)
Aug 31 17:36:31 server kernel: ata1.00: NODEV after polling detection
Aug 31 17:36:31 server kernel: ata1.00: revalidation failed (errno=-2)
Aug 31 17:36:31 server kernel: ata1.00: disabled
Aug 31 17:36:36 server kernel: ata1.00: hard resetting link
Aug 31 17:36:37 server kernel: ata1.01: hard resetting link
Aug 31 17:36:38 server kernel: ata1.01: failed to resume link (SControl 0)
Aug 31 17:36:38 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 
133 SControl 300)
Aug 31 17:36:38 server kernel: ata1.01: SATA link down (SStatus 4 
SControl 0)
Aug 31 17:36:38 server kernel: ata1.00: NODEV after polling detection
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 Sense Key : 
Illegal Request [current]
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 Add. Sense: 
Unaligned write command
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 CDB: Read(10) 28 
00 00 02 cd 00 00 00 60 00
Aug 31 17:36:38 server kernel: blk_update_request: I/O error, dev sda, 
sector 183552
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] killing request
Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 1, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 2, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 3, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 4, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 5, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 6, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1 
errs: wr 7, rd 3, flush 0, corrupt 0, gen 0
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] FAILED Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] CDB: Write(10) 2a 00 00 
61 9c 00 00 0a 00 00
Aug 31 17:36:38 server kernel: blk_update_request: I/O error, dev sda, 
sector 6396928
Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device

more than 100 identical lines...

Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
Aug 31 17:36:38 server kernel: ata1: EH complete
Aug 31 17:36:38 server kernel: ata1.00: detaching (SCSI 0:0:0:0)
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Synchronize Cache(10) 
failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Stopping disk
Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Start/Stop Unit failed: 
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Aug 31 17:36:38 server kernel: Buffer I/O error on dev sda1, logical 
block 488378352, async page read
Aug 31 17:36:38 server kernel: scsi 0:0:0:0: rejecting I/O to dead device
Aug 31 17:36:38 server kernel: blk_update_request: I/O error, dev sda, 
sector 6762624
Aug 31 17:36:38 server kernel: BTRFS: error (device sda1) in 
btrfs_commit_transaction:2227: errno=-5 IO failure (Error while writing 
out transaction)
Aug 31 17:36:38 server kernel: BTRFS info (device sda1): forced readonly
Aug 31 17:36:38 server kernel: BTRFS warning (device sda1): Skipping 
commit of aborted transaction.
Aug 31 17:36:38 server kernel: ------------[ cut here ]------------
Aug 31 17:36:38 server kernel: WARNING: CPU: 1 PID: 159 at 
/build/linux-cRtIym/linux-4.9.30/fs/btrfs/transaction.c:1850 
cleanup_transaction+0x1f0/0x2e0 [btrfs]
Aug 31 17:36:38 server kernel: BTRFS: Transaction aborted (error -5)
Aug 31 17:36:38 server kernel: Modules linked in: intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass eeepc_wmi 
asus_wmi crct10dif_pclmul sparse_keymap crc32_pclmul g

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f42.google.com ([209.85.167.42]:34646 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbeHaXBK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 19:01:10 -0400
Received: by mail-lf1-f42.google.com with SMTP id c29-v6so4606612lfj.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 11:52:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
References: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 31 Aug 2018 12:52:19 -0600
Message-ID: <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
Subject: Re: IO errors when building RAID1.... ?
To: Pierre Couderc <pierre@couderc.eu>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:35 AM, Pierre Couderc <pierre@couderc.eu> wrote:


>
> Aug 31 17:34:55 server su[559]: Successful su for root by nous
> Aug 31 17:34:55 server su[559]: + /dev/pts/1 nous:root
> Aug 31 17:34:55 server su[559]: pam_unix(su:session): session opened for
> user root by nous(uid=1000)
> Aug 31 17:34:55 server su[559]: pam_systemd(su:session): Cannot create
> session: Already running in a session
> Aug 31 17:35:03 server kernel: BTRFS info (device sda1): disk added
> /dev/sdb1
> Aug 31 17:35:40 server kernel: BTRFS info (device sda1): relocating block
> group 1103101952 flags 1
> Aug 31 17:36:12 server sshd[572]: Accepted password for nous from
> 2a01:e34:eeaf:c5f0:e54:15ff:feb1:b1c9 port 49308 ssh2
> Aug 31 17:36:12 server sshd[572]: pam_unix(sshd:session): session opened for
> user nous by (uid=0)
> Aug 31 17:36:12 server systemd-logind[415]: New session 4 of user nous.
> Aug 31 17:36:12 server systemd[1]: Started Session 4 of user nous.
> Aug 31 17:36:16 server kernel: ata1: lost interrupt (Status 0x50)
> Aug 31 17:36:16 server kernel: ata1.00: exception Emask 0x50 SAct 0x0 SErr
> 0x40d0802 action 0xe frozen
> Aug 31 17:36:16 server kernel: ata1.00: SError: { RecovComm HostInt
> PHYRdyChg CommWake 10B8B DevExch }
> Aug 31 17:36:16 server kernel: ata1.00: failed command: READ DMA
> Aug 31 17:36:16 server kernel: ata1.00: cmd
> c8/00:60:00:cd:02/00:00:00:00:00/e0 tag 0 dma 49152 in
>                                         res
> 40/00:01:00:00:00/00:00:00:00:00/40 Emask 0x54 (ATA bus error)
> Aug 31 17:36:16 server kernel: ata1.00: status: { DRDY }
> Aug 31 17:36:16 server kernel: ata1.00: hard resetting link
> Aug 31 17:36:17 server kernel: ata1.01: hard resetting link
> Aug 31 17:36:18 server kernel: ata1.01: failed to resume link (SControl 0)
> Aug 31 17:36:18 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> Aug 31 17:36:18 server kernel: ata1.01: SATA link down (SStatus 4 SControl
> 0)
> Aug 31 17:36:18 server kernel: ata1.00: NODEV after polling detection
> Aug 31 17:36:18 server kernel: ata1.00: revalidation failed (errno=-2)
> Aug 31 17:36:20 server su[590]: Successful su for root by nous
> Aug 31 17:36:20 server su[590]: + /dev/pts/2 nous:root
> Aug 31 17:36:20 server su[590]: pam_unix(su:session): session opened for
> user root by nous(uid=1000)
> Aug 31 17:36:20 server su[590]: pam_systemd(su:session): Cannot create
> session: Already running in a session
> Aug 31 17:36:23 server kernel: ata1.00: hard resetting link
> Aug 31 17:36:23 server kernel: ata1.01: hard resetting link
> Aug 31 17:36:24 server kernel: ata1.01: failed to resume link (SControl 0)
> Aug 31 17:36:25 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> Aug 31 17:36:25 server kernel: ata1.01: SATA link down (SStatus 4 SControl
> 0)
> Aug 31 17:36:25 server kernel: ata1.00: NODEV after polling detection
> Aug 31 17:36:25 server kernel: ata1.00: revalidation failed (errno=-2)
> Aug 31 17:36:30 server kernel: ata1.00: hard resetting link
> Aug 31 17:36:30 server kernel: ata1.01: hard resetting link
> Aug 31 17:36:31 server kernel: ata1.01: failed to resume link (SControl 0)
> Aug 31 17:36:31 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> Aug 31 17:36:31 server kernel: ata1.01: SATA link down (SStatus 4 SControl
> 0)
> Aug 31 17:36:31 server kernel: ata1.00: NODEV after polling detection
> Aug 31 17:36:31 server kernel: ata1.00: revalidation failed (errno=-2)
> Aug 31 17:36:31 server kernel: ata1.00: disabled
> Aug 31 17:36:36 server kernel: ata1.00: hard resetting link
> Aug 31 17:36:37 server kernel: ata1.01: hard resetting link
> Aug 31 17:36:38 server kernel: ata1.01: failed to resume link (SControl 0)
> Aug 31 17:36:38 server kernel: ata1.00: SATA link up 6.0 Gbps (SStatus 133
> SControl 300)
> Aug 31 17:36:38 server kernel: ata1.01: SATA link down (SStatus 4 SControl
> 0)
> Aug 31 17:36:38 server kernel: ata1.00: NODEV after polling detection
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 FAILED Result:
> hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal
> Request [current]
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 Add. Sense: Unaligned
> write command
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] tag#0 CDB: Read(10) 28 00
> 00 02 cd 00 00 00 60 00
> Aug 31 17:36:38 server kernel: blk_update_request: I/O error, dev sda,
> sector 183552
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] killing request
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 1, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 2, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 3, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 4, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 5, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 6, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: BTRFS error (device sda1): bdev /dev/sda1
> errs: wr 7, rd 3, flush 0, corrupt 0, gen 0
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] FAILED Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] CDB: Write(10) 2a 00 00 61
> 9c 00 00 0a 00 00
> Aug 31 17:36:38 server kernel: blk_update_request: I/O error, dev sda,
> sector 6396928
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
>
> more than 100 identical lines...
>
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: rejecting I/O to offline device
> Aug 31 17:36:38 server kernel: ata1: EH complete
> Aug 31 17:36:38 server kernel: ata1.00: detaching (SCSI 0:0:0:0)
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Synchronizing SCSI cache
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Synchronize Cache(10)
> failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Stopping disk
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] Start/Stop Unit failed:
> Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> Aug 31 17:36:38 server kernel: Buffer I/O error on dev sda1, logical block
> 488378352, async page read
> Aug 31 17:36:38 server kernel: scsi 0:0:0:0: rejecting I/O to dead device
> Aug 31 17:36:38 server kernel: blk_update_request: I/O error, dev sda,
> sector 6762624
> Aug 31 17:36:38 server kernel: BTRFS: error (device sda1) in
> btrfs_commit_transaction:2227: errno=-5 IO failure (Error while writing out
> transaction)
> Aug 31 17:36:38 server kernel: BTRFS info (device sda1): forced readonly
> Aug 31 17:36:38 server kernel: BTRFS warning (device sda1): Skipping commit
> of aborted transaction.
> Aug 31 17:36:38 server kernel: ------------[ cut here ]------------
> Aug 31 17:36:38 server kernel: WARNING: CPU: 1 PID: 159 at
> /build/linux-cRtIym/linux-4.9.30/fs/btrfs/transaction.c:1850
> cleanup_transaction+0x1f0/0x2e0 [btrfs]
> Aug 31 17:36:38 server kernel: BTRFS: Transaction aborted (error -5)
> Aug 31 17:36:38 server kernel: Modules linked in: intel_rapl
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass eeepc_wmi
> asus_wmi crct10dif_pclmul sparse_keymap crc32_pclmul g
>
>


These are hardware problems and aren't related to Btrfs.

>sd 0:0:0:0: [sda] FAILED Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Aug 31 17:36:38 server kernel: sd 0:0:0:0: [sda] CDB: Write(10) 2a 00 00 61
> 9c 00 00 0a 00 00
> Aug 31 17:36:38 server kernel: blk_update_request: I/O error, dev sda,
> sector 6396928

Bad sector which is failing write. This is fatal, there isn't anything
the block layer or Btrfs (or ext4 or XFS) can do about it. Well,
ext234 do have an option to scan for bad sectors and create a bad
sector map which then can be used at mkfs time, and ext234 will avoid
using those sectors. And also the md driver has a bad sector option
for the same, and does remapping. But XFS and Btrfs don't do that.

If the drive is under warranty, get it swapped out, this is definitely
a warranty covered problem.




-- 
Chris Murphy

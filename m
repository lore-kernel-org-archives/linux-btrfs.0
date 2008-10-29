From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Raid1 with failing drive
Date: Wed, 29 Oct 2008 15:18:27 -0400
Message-ID: <1225307907.6448.284.camel@think.oraclecorp.com>
References: <20081028164851.70f9d92e@extreme>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081028164851.70f9d92e@extreme>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-10-28 at 16:48 -0700, Stephen Hemminger wrote:
> I have a system with a pair of small/fast but unreliable scsi drives.
> I tried setting up a raid1 configuration and using it for builds.
> Using 2.6.26.7 and btrfs 0.16.   When using ext3 (no raid) on same partition,
> the driver would recalibrate and log something an keep going. But with
> btrfs it doesn't recover and takes drive offline. 
> 

Btrfs doesn't really take drives offline.  In the future we'll notice
that a drive is returning all errors, but for now we'll probably just
keep beating on it.

The IO error handling code in btrfs currently expects it'll be able to
find at least one good mirror.  You're probably hitting some bad
conditions as it fails to clean up.

-chris

> Layout is:
>   sda1 root (ext3)
>   sda5 swap
>   sda6 raid1 btrfs
>   sdb6 raid1 btrfs
> 
> 
> After several hours, a build failed with an i/o error returned to
> the compile.  Then all i/o fails.  Perhaps block layer or btrfs is
> taking it offline and stopping the root filesystem
> 
> The log was:
> 
> 
> device fsid e7426a4edc6e8e0b-232901a8db06e89e devid 1 transid 18 /dev/sda6
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2a 0x3f 0x9f 0x0 0x0 0x10 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x32 Mode 0x0
> Card was paused
> INTSTAT[0x0] SELOID[0x8] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x14 NEXTSCB 0x0
> qinstart = 34965 qinfifonext = 34965
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x21
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x0] 
> scsi0: REG0 == 0x2eb5, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x0, SCB_NEXT == 0x1, SCB_NEXT2 == 0x1d
> CDB 2a 0 1 2a 39 57
> STACK: 0x23 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 11 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2a 0x40 0x2f 0x0 0x0 0x80 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x24 Mode 0x22
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0xb NEXTSCB 0x0
> qinstart = 34967 qinfifonext = 34967
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0xb
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xb, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0xff0b, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> CDB b 1 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 38 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2a 0x9b 0xaf 0x0 0x2 0x58 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x35 Mode 0x11
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x26 NEXTSCB 0x0
> qinstart = 34969 qinfifonext = 34969
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x26
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xb101, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x26, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x23 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 37 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2f 0xba 0x6f 0x0 0x0 0x40 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x6 Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x25 NEXTSCB 0x0
> qinstart = 34971 qinfifonext = 34971
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x25
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x25, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 30 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2f 0xba 0xaf 0x0 0x2 0xf8 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x35 Mode 0x11
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x1e NEXTSCB 0x0
> qinstart = 34973 qinfifonext = 34973
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x1e
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xb101, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x1e, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x23 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 25 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x3a 0xca 0xaf 0x0 0x0 0x98 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x24 Mode 0x22
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x19 NEXTSCB 0x0
> qinstart = 34975 qinfifonext = 34975
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x19
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0x19, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0xff19, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> CDB 19 1 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 24 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x3c 0x47 0x7f 0x0 0x1 0xb0 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x7 Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x18 NEXTSCB 0x0
> qinstart = 34977 qinfifonext = 34977
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x18
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x18, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 39 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2f 0x9d 0xb7 0x0 0x0 0x78 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x22 Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x27 NEXTSCB 0x0
> qinstart = 34979 qinfifonext = 34979
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x27
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x27, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 7 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2f 0x9e 0x2f 0x0 0x2 0x0 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x32 Mode 0x0
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x7 NEXTSCB 0x0
> qinstart = 34981 qinfifonext = 34981
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x7
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0x2eb5, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x0, SCB_NEXT == 0x1, SCB_NEXT2 == 0x1d
> CDB 2a 0 1 2a 39 57
> STACK: 0x23 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 26 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x3a 0xc9 0xf 0x0 0x1 0xa0 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x1f Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x1a NEXTSCB 0x0
> qinstart = 34983 qinfifonext = 34983
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x1a
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x1a, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 18 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x3c 0x49 0x2f 0x0 0x1 0x80 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x21 Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x12 NEXTSCB 0x0
> qinstart = 34985 qinfifonext = 34985
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x12
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x12, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 8 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x25 0x62 0xe7 0x0 0x0 0x10 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x38 Mode 0x22
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x8 NEXTSCB 0x0
> qinstart = 34987 qinfifonext = 34987
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x8
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0x8, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0xff08, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> CDB 8 1 0 0 0 0
> STACK: 0x24 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 4 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x25 0x63 0x47 0x0 0x0 0x10 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x1f Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x4 NEXTSCB 0x0
> qinstart = 34989 qinfifonext = 34989
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x4
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x4, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 35 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> found == 0x1
> Recovery code awake
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x23 Mode 0x11
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 16 LASTSCB 0xffff CURRSCB 0x23 NEXTSCB 0x0
> qinstart = 34991 qinfifonext = 34991
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  35 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 16
> Kernel Free SCB list: 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x23
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xb101, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x23, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 35 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2a 0x39 0x57 0x0 0x0 0x38 0x0
> found == 0x1
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x24 Mode 0x22
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 15 LASTSCB 0xffff CURRSCB 0x23 NEXTSCB 0x0
> qinstart = 34992 qinfifonext = 34992
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 15
> Kernel Free SCB list: 35 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x23
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0x23, SINDEX = 0x107, DINDEX = 0x10a
> scsi0: SCBPTR == 0xff23, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> CDB 23 1 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 0 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2a 0x3b 0x2f 0x0 0x0 0x38 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x24 Mode 0x22
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 15 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
> qinstart = 34994 qinfifonext = 34994
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 15
> Kernel Free SCB list: 35 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0x0, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0xff00, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> CDB 0 1 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 1 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0 0x1 0x2a 0x3f 0xaf 0x0 0x0 0x28 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x35 Mode 0x11
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x3] 
> KERNEL_QFREEZE_COUNT[0x3] MK_MESSAGE_SCB[0xff00] 
> MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 15 LASTSCB 0xffff CURRSCB 0x1 NEXTSCB 0x0
> qinstart = 34996 qinfifonext = 34996
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>   1 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   0 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   4 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   8 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  18 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  26 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>   7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  39 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  24 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  25 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  30 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  37 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  38 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  11 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
>  15 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 15
> Kernel Free SCB list: 35 33 36 20 14 9 42 23 32 28 16 29 6 27 43 10 21 2 3 17 31 19 22 34 5 12 13 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x1
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xb101, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x1, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x23 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 15 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue a TARGET RESET message:CDB: 0x2a 0x0 0x1 0x2a 0x3f 0x9f 0x0 0x0 0x10 0x0
> scsi0: Device reset code sleeping
> (scsi0:A:4:0): Bus Device Reset Message Sent
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: Device reset returning 0x2002
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: device overrun (status 9) on 0:4:0
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x1c 0x10 0x17 0x0 0x0 0x8 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x7 Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x8] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x6] 
> KERNEL_QFREEZE_COUNT[0x6] MK_MESSAGE_SCB[0x14] 
> MK_MESSAGE_SCSIID[0x87] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x10 NEXTSCB 0x0
> qinstart = 316 qinfifonext = 316
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  31 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 1
> Kernel Free SCB list: 16 33 21 35 18 43 7 14 8 13 34 11 12 22 32 20 15 28 9 39 37 0 27 3 17 30 42 4 25 1 2 38 19 24 6 23 29 26 5 36 10 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x81f7, SCB 0x10
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x0] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x10, SCB_NEXT == 0xff40, SCB_NEXT2 == 0xff29
> CDB 2a 0 0 80 a1 90
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 31 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> Recovery code awake
> found == 0x1
> sd 0:0:4:0: [sda] Attempting to queue a TARGET RESET message:CDB: 0x28 0x0 0x0 0x1c 0x10 0x17 0x0 0x0 0x8 0x0
> scsi0: Device reset code sleeping
> (scsi0:A:4:0): Bus Device Reset Message Sent
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> scsi0: Device reset returning 0x2002
> scsi0: device overrun (status 9) on 0:4:0
> sd 0:0:4:0: [sda] Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State at program address 0x21 Mode 0x33
> Card was paused
> INTSTAT[0x0] SELOID[0x4] SELID[0x80] HS_MAILBOX[0x0] 
> INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33] 
> SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1] 
> SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
> SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x7] 
> KERNEL_QFREEZE_COUNT[0x7] MK_MESSAGE_SCB[0x14] 
> MK_MESSAGE_SCSIID[0x87] SSTAT0[0x0] SSTAT1[0x8] 
> SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xa4] 
> LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
> LQOSTAT1[0x0] LQOSTAT2[0x0] 
> 
> SCB Count = 44 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x1f NEXTSCB 0x0
> qinstart = 322 qinfifonext = 322
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  31 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x47] 
> Total 1
> Kernel Free SCB list: 16 33 21 35 18 43 7 14 8 13 34 11 12 22 32 20 15 28 9 39 37 0 27 3 17 30 42 4 25 1 2 38 19 24 6 23 29 26 5 36 10 41 40 
> Sequencer Complete DMA-inprog list: 
> Sequencer Complete list: 
> Sequencer DMA-Up and Complete list: 
> Sequencer On QFreeze and Complete list: 
> 
> 
> scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> 
> scsi0: FIFO1 Free, LONGJMP == 0x80f7, SCB 0x1f
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89] 
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
> scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
> SIMODE0[0xc] 
> CCSCBCTL[0x4] 
> scsi0: REG0 == 0xff00, SINDEX = 0x1e0, DINDEX = 0xe1
> scsi0: SCBPTR == 0x1f, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff29
> CDB 0 0 0 0 0 0
> STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> (scsi0:A:4:0): Device is disconnected, re-queuing SCB
> scsi0: Recovery code sleeping
> (scsi0:A:4:0): Abort Tag Message Sent
> (scsi0:A:4:0): SCB 31 - Abort Completed.
> Recovery SCB completes
> scsi0: device overrun (status 9) on 0:4:0
> found == 0x1
> Recovery code awake
> sd 0:0:4:0: Device offlined - not ready after error recovery
> sd 0:0:4:0: [sda] Result: hostbyte=0x03 driverbyte=0x00
> end_request: I/O error, dev sda, sector 1839127
> EXT3-fs error (device sda1): ext3_get_inode_loc: unable to read inode block - inode=57833, block=229883<3>sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device
> sd 0:0:4:0: rejecting I/O to offline device


From: Hullen@t-online.de (Helmut Hullen)
Subject: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 12:46:00 +0200
Message-ID: <C8PBkd9uCXB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

"never change a running system" ...

=46or some months I run btrfs unter kernel 3.2.5 and 3.2.9, without =20
problems.

Yesterday I compiled kernel 3.3.4, and this morning I started the =20
machine with this kernel. There may be some ugly problems.

Copying something into the btrfs "directory" worked well for some files=
, =20
and then I got error messages (I've not copied them, something with "IO=
 =20
error" under Samba).

Rebooting the machine with kernel 3.2.9 worked, copying 1 file worked, =
=20
but copying more than this file didn't work. And I can't delete this =20
file.

That doesn't please me - copying more than 4 TBytes wastes time and =20
money.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D configuration =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

/dev/sdc1 on /srv/MM type btrfs (rw,noatime)

/dev/sdc: SAMSUNG HD204UI: 25 =B0C
/dev/sdf: WDC WD30EZRX-00MMMB0: 30 =B0C
/dev/sdi: WDC WD30EZRX-00MMMB0: 29 =B0C

Data, RAID0: total=3D5.29TB, used=3D4.29TB
System, RAID1: total=3D8.00MB, used=3D352.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D149.00GB, used=3D5.00GB

Label: 'MMedia'  uuid: 9adfdc84-0fbe-431b-bcb1-cabb6a915e91
	Total devices 3 FS bytes used 4.29TB
	devid    3 size 2.73TB used 1.98TB path /dev/sdi1
	devid    2 size 2.73TB used 1.94TB path /dev/sdf1
	devid    1 size 1.82TB used 1.63TB path /dev/sdc1

Btrfs Btrfs v0.19

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D boot messages=
, kernel related =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[boot with kernel 3.3.4]
May  7 06:55:26 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0 SErr=
 0x10000 action 0xe frozen
May  7 06:55:26 Arktur kernel: ata5: SError: { PHYRdyChg }
May  7 06:55:26 Arktur kernel: ata5: hard resetting link
May  7 06:55:31 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 06:55:31 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 6 secs
May  7 06:55:36 Arktur kernel: ata5: hard resetting link
May  7 06:55:38 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 06:55:38 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 9 secs
May  7 06:55:46 Arktur kernel: ata5: hard resetting link
May  7 06:55:47 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 06:55:47 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 34 secs
May  7 06:56:21 Arktur kernel: ata5: hard resetting link
May  7 06:56:22 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113=
 SControl 310)
May  7 06:56:22 Arktur kernel: ata5.00: configured for UDMA/100
May  7 06:56:22 Arktur kernel: ata5: EH complete
May  7 07:12:07 Arktur kernel: ata5.00: exception Emask 0x10 SAct 0x0 S=
Err 0x10000 action 0xe frozen
May  7 07:12:07 Arktur kernel: ata5: SError: { PHYRdyChg }
May  7 07:12:07 Arktur kernel: ata5.00: failed command: WRITE DMA EXT
May  7 07:12:07 Arktur kernel: ata5.00: cmd 35/00:00:00:62:50/00:04:5e:=
00:00/e0 tag 0 dma 524288 out
May  7 07:12:07 Arktur kernel:          res d8/d8:d8:d8:d8:d8/d8:d8:d8:=
d8:d8/d8 Emask 0x12 (ATA bus error)
May  7 07:12:07 Arktur kernel: ata5.00: status: { Busy }
May  7 07:12:07 Arktur kernel: ata5.00: error: { ICRC UNC IDNF }
May  7 07:12:07 Arktur kernel: ata5: hard resetting link
May  7 07:12:13 Arktur kernel: ata5: link is slow to respond, please be=
 patient (ready=3D-19)
May  7 07:12:15 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113=
 SControl 310)
May  7 07:12:15 Arktur kernel: ata5.00: failed to IDENTIFY (I/O error, =
err_mask=3D0x100)
May  7 07:12:15 Arktur kernel: ata5.00: revalidation failed (errno=3D-5=
)
May  7 07:12:20 Arktur kernel: ata5: hard resetting link
May  7 07:12:20 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:12:20 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 10 secs
May  7 07:12:30 Arktur kernel: ata5: hard resetting link
May  7 07:12:30 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:12:30 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 10 secs
May  7 07:12:40 Arktur kernel: ata5: hard resetting link
May  7 07:12:42 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113=
 SControl 310)
May  7 07:12:43 Arktur kernel: ata5.00: configured for UDMA/100
May  7 07:12:43 Arktur kernel: ata5: EH complete
May  7 07:12:43 Arktur kernel: ata5.00: exception Emask 0x10 SAct 0x0 S=
Err 0x10000 action 0xe frozen
May  7 07:12:43 Arktur kernel: ata5: SError: { PHYRdyChg }
May  7 07:12:43 Arktur kernel: ata5.00: failed command: WRITE DMA EXT
May  7 07:12:43 Arktur kernel: ata5.00: cmd 35/00:00:00:72:50/00:04:5e:=
00:00/e0 tag 0 dma 524288 out
May  7 07:12:43 Arktur kernel:          res d0/d0:d0:d0:d0:d0/d0:d0:d0:=
d0:d0/d0 Emask 0x12 (ATA bus error)
May  7 07:12:43 Arktur kernel: ata5.00: status: { Busy }
May  7 07:12:43 Arktur kernel: ata5.00: error: { ICRC UNC IDNF }
May  7 07:12:43 Arktur kernel: ata5: hard resetting link
May  7 07:12:49 Arktur kernel: ata5: link is slow to respond, please be=
 patient (ready=3D-19)
May  7 07:12:50 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113=
 SControl 310)
May  7 07:12:51 Arktur kernel: ata5.00: configured for UDMA/100
May  7 07:12:51 Arktur kernel: ata5: EH complete
May  7 07:12:51 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0 SErr=
 0x10000 action 0xe frozen
May  7 07:12:51 Arktur kernel: ata5: SError: { PHYRdyChg }
May  7 07:12:51 Arktur kernel: ata5: hard resetting link
May  7 07:12:54 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:12:54 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 7 secs
May  7 07:13:01 Arktur kernel: ata5: hard resetting link
May  7 07:13:04 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:13:04 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 7 secs
May  7 07:13:11 Arktur kernel: ata5: hard resetting link
May  7 07:13:14 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:13:14 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 33 secs
May  7 07:13:46 Arktur kernel: ata5: hard resetting link
May  7 07:13:47 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113=
 SControl 310)
May  7 07:13:47 Arktur kernel: ata5.00: failed to read native max addre=
ss (err_mask=3D0x100)
May  7 07:13:47 Arktur kernel: ata5.00: HPA support seems broken, skipp=
ing HPA handling
May  7 07:13:47 Arktur kernel: ata5.00: revalidation failed (errno=3D-5=
)
May  7 07:13:52 Arktur kernel: ata5: hard resetting link
May  7 07:13:53 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:13:53 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 9 secs
May  7 07:14:02 Arktur kernel: ata5: hard resetting link
May  7 07:14:05 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:14:05 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 8 secs
May  7 07:14:12 Arktur kernel: ata5: hard resetting link
May  7 07:14:14 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:14:14 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 33 secs
May  7 07:14:47 Arktur kernel: ata5: hard resetting link
May  7 07:14:47 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:14:47 Arktur kernel: ata5: reset failed, giving up
May  7 07:14:47 Arktur kernel: ata5.00: disabled
May  7 07:14:47 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0 SErr=
 0x10000 action 0xe frozen t4
May  7 07:14:47 Arktur kernel: ata5: SError: { PHYRdyChg }
May  7 07:14:47 Arktur kernel: ata5: hard resetting link
May  7 07:14:47 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:14:47 Arktur kernel: sd 5:0:0:0: [sdf] killing request
May  7 07:14:47 Arktur kernel: sd 5:0:0:0: [sdf] Unhandled error code
May  7 07:14:47 Arktur kernel: sd 5:0:0:0: [sdf]  Result: hostbyte=3D0x=
01 driverbyte=3D0x00
May  7 07:14:47 Arktur kernel: sd 5:0:0:0: [sdf] CDB: cdb[0]=3D0x28: 28=
 00 d0 d1 07 20 00 00 08 00
May  7 07:14:47 Arktur kernel: end_request: I/O error, dev sdf, sector =
3503359776
May  7 07:14:48 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:14:48 Arktur kernel: end_request: I/O error, dev sdf, sector =
0
May  7 07:14:48 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:14:49 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:14:49 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:14:49 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:14:49 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:14:49 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:14:50 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:14:54 Arktur kernel: ata5: link is slow to respond, please be=
 patient (ready=3D-19)
May  7 07:14:57 Arktur kernel: ata5: COMRESET failed (errno=3D-16)
May  7 07:14:57 Arktur kernel: ata5: hard resetting link
May  7 07:15:01 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:03 Arktur kernel: ata5: link is slow to respond, please be=
 patient (ready=3D-19)
May  7 07:15:07 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:07 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:15:07 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 1 secs
May  7 07:15:07 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:07 Arktur kernel: ata5: hard resetting link
May  7 07:15:07 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:12 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:15:12 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 31 secs
May  7 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:19 Arktur kernel: end_request: I/O error, dev sdf, sector =
0
May  7 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:19 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:19 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:15:19 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:19 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:15:22 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:42 Arktur kernel: ata5: hard resetting link
May  7 07:15:44 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:15:44 Arktur kernel: ata5: reset failed, giving up
May  7 07:15:44 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0 SErr=
 0x10000 action 0xe frozen t3
May  7 07:15:44 Arktur kernel: ata5: SError: { PHYRdyChg }
May  7 07:15:44 Arktur kernel: ata5: hard resetting link
May  7 07:15:44 Arktur kernel: ata5: COMRESET failed (errno=3D-19)
May  7 07:15:44 Arktur kernel: ata5: reset failed (errno=3D-19), retryi=
ng in 10 secs
May  7 07:15:49 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:50 Arktur kernel: end_request: I/O error, dev sdf, sector =
0
May  7 07:15:50 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:50 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:15:50 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:50 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:15:50 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:50 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:15:54 Arktur kernel: ata5: hard resetting link
May  7 07:15:55 Arktur kernel: sd 5:0:0:0: rejecting I/O to offline dev=
ice
May  7 07:15:59 Arktur kernel: ata5: link is slow to respond, please be=
 patient (ready=3D-19)
May  7 07:16:04 Arktur kernel: ata5: COMRESET failed (errno=3D-16)
May  7 07:16:04 Arktur kernel: ata5: hard resetting link
May  7 07:16:05 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113=
 SControl 310)
May  7 07:16:05 Arktur kernel: ata5.00: ATA-8: WDC WD30EZRX-00MMMB0, 80=
=2E00A80, max UDMA/133
May  7 07:16:05 Arktur kernel: ata5.00: 5860533168 sectors, multi 0: LB=
A48 NCQ (depth 0/32)
May  7 07:16:05 Arktur kernel: ata5.00: configured for UDMA/100
May  7 07:16:05 Arktur kernel: ata5: EH complete
May  7 07:16:05 Arktur kernel: ata5.00: detaching (SCSI 5:0:0:0)
May  7 07:16:05 Arktur kernel: sd 5:0:0:0: [sdf] Synchronizing SCSI cac=
he
May  7 07:16:20 Arktur kernel: end_request: I/O error, dev sdf, sector =
0
May  7 07:16:20 Arktur kernel: lost page write due to I/O error on sdf1
May  7 07:22:05 Arktur kernel: sd 5:0:0:0: timing out command, waited 3=
60s
May  7 07:28:05 Arktur kernel: sd 5:0:0:0: timing out command, waited 3=
60s
May  7 07:34:05 Arktur kernel: sd 5:0:0:0: timing out command, waited 3=
60s
May  7 07:34:05 Arktur kernel: sd 5:0:0:0: [sdf]  Result: hostbyte=3D0x=
00 driverbyte=3D0x00
May  7 07:34:05 Arktur kernel: sd 5:0:0:0: [sdf] Stopping disk
May  7 07:37:05 Arktur kernel: sd 5:0:0:0: timing out command, waited 1=
80s
May  7 07:37:05 Arktur kernel: sd 5:0:0:0: [sdf] START_STOP FAILED
May  7 07:37:05 Arktur kernel: sd 5:0:0:0: [sdf]  Result: hostbyte=3D0x=
00 driverbyte=3D0x00
May  7 07:37:06 Arktur kernel: ata5: SATA link up 1.5 Gbps (SStatus 113=
 SControl 310)
May  7 07:37:07 Arktur kernel: ata5.00: configured for UDMA/100
May  7 07:37:07 Arktur kernel: scsi 5:0:0:0: Direct-Access     ATA     =
 WDC WD30EZRX-00M 80.0 PQ: 0 ANSI: 5

May  7 10:47:22 Arktur kernel: lost page write due to I/O error on sdf1

May  7 11:11:21 Arktur kernel: lost page write due to I/O error on sdf1
May  7 11:12:07 Arktur kernel: lost page write due to I/O error on sdf1

[reboot with kernel 3.2.9]

May  7 11:15:25 Arktur kernel: ata5.00: configured for UDMA/100
May  7 11:15:25 Arktur kernel: scsi 5:0:0:0: Direct-Access     ATA     =
 WDC WD30EZRX-00M 80.0 PQ: 0 ANSI: 5
May  7 11:15:26 Arktur kernel: sd 5:0:0:0: [sdf] 5860533168 512-byte lo=
gical blocks: (3.00 TB/2.72 TiB)
May  7 11:15:26 Arktur kernel: sd 5:0:0:0: [sdf] 4096-byte physical blo=
cks
May  7 11:15:26 Arktur kernel: sd 5:0:0:0: [sdf] Write Protect is off
May  7 11:15:26 Arktur kernel: sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 0=
0
May  7 11:15:26 Arktur kernel: sd 5:0:0:0: [sdf] Write cache: enabled, =
read cache: enabled, doesn't support DPO or FUA
May  7 11:15:26 Arktur kernel:  sdf: sdf1
May  7 11:15:26 Arktur kernel: sd 5:0:0:0: [sdf] Attached SCSI disk

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  dmesg output =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

btrfs: free space inode generation (0) did not match free space cache =20
generation (36740)
btrfs: space cache generation (36727) does not match inode (36747)
btrfs: failed to load free space cache for block group 9193084223488
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:80:00:b3:d7/00:00:02:01:00/e0 tag 0 dma 65536 in
         res 51/40:6f:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:80:00:b3:d7/00:00:02:01:00/e0 tag 0 dma 65536 in
         res 51/40:6f:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:80:00:b3:d7/00:00:02:01:00/e0 tag 0 dma 65536 in
         res 51/40:6f:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:80:00:b3:d7/00:00:02:01:00/e0 tag 0 dma 65536 in
         res 51/40:6f:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:80:00:b3:d7/00:00:02:01:00/e0 tag 0 dma 65536 in
         res 51/40:6f:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:80:00:b3:d7/00:00:02:01:00/e0 tag 0 dma 65536 in
         res 51/40:6f:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
sd 5:0:0:0: [sdf] Unhandled sense code
sd 5:0:0:0: [sdf]  Result: hostbyte=3D0x00 driverbyte=3D0x08
sd 5:0:0:0: [sdf]  Sense Key : 0x3 [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01
        02 d7 b3 08
sd 5:0:0:0: [sdf]  ASC=3D0x11 ASCQ=3D0x4
sd 5:0:0:0: [sdf] CDB: cdb[0]=3D0x88: 88 00 00 00 00 01 02 d7 b3 00 00 =
00 00 80 00 00
end_request: I/O error, dev sdf, sector 4342657800
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:08:08:b3:d7/00:00:02:01:00/e0 tag 0 dma 4096 in
         res 51/40:08:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:08:08:b3:d7/00:00:02:01:00/e0 tag 0 dma 4096 in
         res 51/40:08:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:08:08:b3:d7/00:00:02:01:00/e0 tag 0 dma 4096 in
         res 51/40:08:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:08:08:b3:d7/00:00:02:01:00/e0 tag 0 dma 4096 in
         res 51/40:08:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:08:08:b3:d7/00:00:02:01:00/e0 tag 0 dma 4096 in
         res 51/40:08:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
ata5: EH complete
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata5.00: BMDMA2 stat 0x80d0009
ata5.00: failed command: READ DMA EXT
ata5.00: cmd 25/00:08:08:b3:d7/00:00:02:01:00/e0 tag 0 dma 4096 in
         res 51/40:08:08:b3:d7/00:00:02:01:00/f0 Emask 0x9 (media error=
)
ata5.00: status: { DRDY ERR }
ata5.00: error: { UNC }
ata5.00: configured for UDMA/100
sd 5:0:0:0: [sdf] Unhandled sense code
sd 5:0:0:0: [sdf]  Result: hostbyte=3D0x00 driverbyte=3D0x08
sd 5:0:0:0: [sdf]  Sense Key : 0x3 [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 01
        02 d7 b3 08
sd 5:0:0:0: [sdf]  ASC=3D0x11 ASCQ=3D0x4
sd 5:0:0:0: [sdf] CDB: cdb[0]=3D0x88: 88 00 00 00 00 01 02 d7 b3 08 00 =
00 00 08 00 00
end_request: I/O error, dev sdf, sector 4342657800
ata5: EH complete
btrfs: error reading free space cache
BUG: unable to handle kernel NULL pointer dereference at 00000001
IP: [<c1295c36>] io_ctl_drop_pages+0x26/0x50
*pdpt =3D 0000000029712001 *pde =3D 0000000000000000
Oops: 0002 [#1]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D syslogd output =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D kernel 3.2.9 after the 3.3.4=
 try =3D=3D=3D=3D

Message from syslogd@Arktur at Mon May    7  11:21:55 2012
Arktur kernel: Oops: 0002 [#1]
Message from syslogd@Arktur at Mon May    7  11:21:56 2012
es existieren nur
Arktur kernel:   Process flush-btrfs-l  (pid:   51 ti=3De9f12000)
=F2 at Mon May
=F2 at Mon May
ti=3De9f12000 task=3Df6882a50 task. 11:21:56 2012   .. . 11:21:56 2012 =
  ...

Message from syslogd@Arktur at Mon May    7  11:21:56 2012   ...
Arktur kernel: Code: c3 8d 74 26 00 55 89 e5 56 53 3e 8d 74 26 00 89 c6=
 e8 2f ff
ff ff 8b 5e 1c 85 db 7e 30 31 db 8d b6 00 00 00 00 8b 46 0c 8b 04 98 <8=
0> 60 01
fe 8b 46 0c 8b 04 98 e8 1b 96 df ff 8b 46 0c 8b 04 98

Message from syslogd@Arktur at Mon May    7  11:21:56 2012   ...
Arktur kernel:   EIP:   [<c1295c36>]   io_cfl_drop_pages+0x26/0x50 SS:E=
SP 0068:e9fl396

Message from syslogd@Arktur at Mon May 7 11:21:56 2012
Arktur kernel: CR2: 0000000000000001
Arktur:- #

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The 3 btrfs disks are connected via a SiI 3114 SATA-PCI-Controller.
Only 1 of the 3 disks seems to be damaged.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Ca I repair the system? Or have I to copy it to a set of other disks?

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

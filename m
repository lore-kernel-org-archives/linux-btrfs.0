From: "=?UTF-8?B?VG9tw6HFoSBUaGllbWVs?=" <thiemel@centrum.cz>
Subject: Re: "open_ctree failed", unable to mount the fs
Date: Thu, 10 Mar 2011 00:28:11 +0100
Message-ID: <20110309232811.B424641C@mail1015.cent>
References: <S1750921Ab1CIXPz/20110309231555Z+1799@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <S1750921Ab1CIXPz/20110309231555Z+1799@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Hi,
I've got similar problem - after HW failure - two of three disks became=
 unavailable and now I'm unable to btrfsck.
Btrfs lays on /dev/sdb1,/dev/sdc1,/dev/sdd1 - sdc+sdd became unavailabl=
e

Here is kernel log:
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593338] ata7.00: exception Em=
ask 0x60 SAct 0x1 SErr 0x800 action 0x6 frozen
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593343] ata7.00: irq_stat 0x2=
0000000, host bus error
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593347] ata7: SError: { HostI=
nt }
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593351] ata7.00: failed comma=
nd: WRITE FPDMA QUEUED
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593359] ata7.00: cmd 61/80:00=
:bf:72:7a/00:00:6a:00:00/40 tag 0 ncq 65536 out
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593361]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res 40/00:04:bf:72:7a/00:00:6a:00:00/40 =
Emask 0x60 (host bus error)
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593364] ata7.00: status: { DR=
DY }
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.593373] ata7: hard resetting =
link
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610037] ata8.00: exception Em=
ask 0x60 SAct 0x1b SErr 0x800 action 0x6 frozen
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610041] ata8.00: irq_stat 0x2=
0000000, host bus error
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610045] ata8: SError: { HostI=
nt }
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610049] ata8.00: failed comma=
nd: WRITE FPDMA QUEUED
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610057] ata8.00: cmd 61/80:00=
:3f:da:79/00:00:6a:00:00/40 tag 0 ncq 65536 out
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610058]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res 40/00:04:3f:da:79/00:00:6a:00:00/40 =
Emask 0x60 (host bus error)
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610062] ata8.00: status: { DR=
DY }
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610065] ata8.00: failed comma=
nd: WRITE FPDMA QUEUED
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610072] ata8.00: cmd 61/80:08=
:bf:da:79/00:00:6a:00:00/40 tag 1 ncq 65536 out
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610074]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res 40/00:04:3f:da:79/00:00:6a:00:00/40 =
Emask 0x60 (host bus error)
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610078] ata8.00: status: { DR=
DY }
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610081] ata8.00: failed comma=
nd: WRITE FPDMA QUEUED
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610088] ata8.00: cmd 61/80:18=
:3f:d9:79/00:00:6a:00:00/40 tag 3 ncq 65536 out
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610090]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res 40/00:04:3f:da:79/00:00:6a:00:00/40 =
Emask 0x60 (host bus error)
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610093] ata8.00: status: { DR=
DY }
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610096] ata8.00: failed comma=
nd: WRITE FPDMA QUEUED
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610103] ata8.00: cmd 61/80:20=
:bf:d9:79/00:00:6a:00:00/40 tag 4 ncq 65536 out
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610105]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 res 40/00:04:3f:da:79/00:00:6a:00:00/40 =
Emask 0x60 (host bus error)
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610108] ata8.00: status: { DR=
DY }
Mar=C2=A0 9 23:56:28 ftp2 kernel: [121492.610116] ata8: hard resetting =
link
Mar=C2=A0 9 23:56:30 ftp2 kernel: [121494.160055] ata7: failed to resum=
e link (SControl 3B8)
Mar=C2=A0 9 23:56:30 ftp2 kernel: [121494.180035] ata8: failed to resum=
e link (SControl 4F0)
Mar=C2=A0 9 23:56:30 ftp2 kernel: [121494.340046] ata7: SATA link up 3.=
0 Gbps (SStatus 123 SControl 3B8)
Mar=C2=A0 9 23:56:30 ftp2 kernel: [121494.360070] ata8: SATA link up 3.=
0 Gbps (SStatus 123 SControl 4F0)
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.340040] ata7.00: qc timeout (=
cmd 0xec)
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.340053] ata7.00: failed to ID=
ENTIFY (I/O error, err_mask=3D0x4)
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.340058] ata7.00: revalidation=
 failed (errno=3D-5)
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.340065] ata7: hard resetting =
link
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.360041] ata8.00: qc timeout (=
cmd 0xec)
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.360054] ata8.00: failed to ID=
ENTIFY (I/O error, err_mask=3D0x4)
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.360058] ata8.00: revalidation=
 failed (errno=3D-5)
Mar=C2=A0 9 23:56:35 ftp2 kernel: [121499.360063] ata8: hard resetting =
link
Mar=C2=A0 9 23:56:36 ftp2 kernel: [121500.430032] ata8: failed to resum=
e link (SControl A12)
Mar=C2=A0 9 23:56:36 ftp2 kernel: [121500.610042] ata8: SATA link up 3.=
0 Gbps (SStatus 623 SControl A12)
Mar=C2=A0 9 23:56:36 ftp2 kernel: [121500.910026] ata7: failed to resum=
e link (SControl 3AB)
Mar=C2=A0 9 23:56:41 ftp2 kernel: [121506.130047] ata7: SATA link up 1.=
5 Gbps (SStatus 113 SControl 3AB)
Mar=C2=A0 9 23:56:41 ftp2 kernel: [121506.130056] ata7.00: link online =
but device misclassifed
Mar=C2=A0 9 23:56:41 ftp2 kernel: [121506.130068] ata7.00: failed to ID=
ENTIFY (I/O error, err_mask=3D0x40)
Mar=C2=A0 9 23:56:41 ftp2 kernel: [121506.130073] ata7.00: revalidation=
 failed (errno=3D-5)
Mar=C2=A0 9 23:56:41 ftp2 kernel: [121506.130078] ata7: limiting SATA l=
ink speed to 1.5 Gbps
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130060] ata7: hard resetting =
link
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130086] ata8.00: qc timeout (=
cmd 0xec)
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130098] ata8.00: failed to ID=
ENTIFY (I/O error, err_mask=3D0x4)
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130102] ata8.00: revalidation=
 failed (errno=3D-5)
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130108] ata8: limiting SATA l=
ink speed to 1.5 Gbps
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130060] ata7: hard resetting =
link
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130086] ata8.00: qc timeout (=
cmd 0xec)
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130098] ata8.00: failed to ID=
ENTIFY (I/O error, err_mask=3D0x4)
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130102] ata8.00: revalidation=
 failed (errno=3D-5)
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130108] ata8: limiting SATA l=
ink speed to 1.5 Gbps
Mar=C2=A0 9 23:56:46 ftp2 kernel: [121511.130114] ata8: hard resetting =
link
Mar=C2=A0 9 23:56:48 ftp2 kernel: [121512.200036] ata7: failed to resum=
e link (SControl B63)
Mar=C2=A0 9 23:56:48 ftp2 kernel: [121512.200067] ata8: failed to resum=
e link (SControl FBB)
Mar=C2=A0 9 23:56:56 ftp2 kernel: [121521.130040] ata8: softreset faile=
d (1st FIS failed)
Mar=C2=A0 9 23:56:56 ftp2 kernel: [121521.130046] ata8: hard resetting =
link
Mar=C2=A0 9 23:56:56 ftp2 kernel: [121521.130117] ata7: softreset faile=
d (1st FIS failed)
Mar=C2=A0 9 23:56:56 ftp2 kernel: [121521.130122] ata7: hard resetting =
link
Mar=C2=A0 9 23:56:58 ftp2 kernel: [121522.200015] ata8: failed to resum=
e link (SControl 0)
Mar=C2=A0 9 23:56:58 ftp2 kernel: [121522.200033] ata7: failed to resum=
e link (SControl 49)
Mar=C2=A0 9 23:57:06 ftp2 kernel: [121531.140041] ata7: softreset faile=
d (1st FIS failed)
Mar=C2=A0 9 23:57:06 ftp2 kernel: [121531.140047] ata7: hard resetting =
link
Mar=C2=A0 9 23:57:06 ftp2 kernel: [121531.140082] ata8: softreset faile=
d (device not ready)
Mar=C2=A0 9 23:57:06 ftp2 kernel: [121531.140086] ata8: hard resetting =
link
Mar=C2=A0 9 23:57:08 ftp2 kernel: [121532.210022] ata8: failed to resum=
e link (SControl 810)
Mar=C2=A0 9 23:57:08 ftp2 kernel: [121532.210034] ata7: failed to resum=
e link (SControl 0)
Mar=C2=A0 9 23:57:18 ftp2 kernel: [121542.470033] ata8: link is slow to=
 respond, please be patient (ready=3D-19)
Mar=C2=A0 9 23:57:41 ftp2 kernel: [121566.140039] ata7: softreset faile=
d (1st FIS failed)
Mar=C2=A0 9 23:57:41 ftp2 kernel: [121566.140047] ata7: hard resetting =
link
Mar=C2=A0 9 23:57:42 ftp2 kernel: [121566.170032] ata8: softreset faile=
d (device not ready)
Mar=C2=A0 9 23:57:42 ftp2 kernel: [121566.170038] ata8: hard resetting =
link
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210047] ata7: failed to resum=
e link (SControl 1)
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210068] ata7: SATA link down =
(SStatus 0 SControl 1)
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210080] ata7.00: disabled
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210103] sd 6:0:0:0: [sdc]=C2=A0=
 Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210109] sd 6:0:0:0: [sdc]=C2=A0=
 Sense Key : Aborted Command [current] [descriptor]
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210117] Descriptor sense data=
 with sense descriptors (in hex):
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210120]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 0=
0=20
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210133]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 6a 7a 72 bf=20
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210140] sd 6:0:0:0: [sdc]=C2=A0=
 Add. Sense: No additional sense information
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210146] sd 6:0:0:0: [sdc] CDB=
: Write(10): 2a 00 6a 7a 72 bf 00 00 80 00
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210159] end_request: I/O erro=
r, dev sdc, sector 1786409663
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210177] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210186] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210201] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210212] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210223] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210233] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210243] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210263] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210270] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210275] sd 6:0:0:0: rejecting=
 I/O to offline device
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210283] ata7: EH complete
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210292] sd 6:0:0:0: [sdc] Unh=
andled error code
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210295] sd 6:0:0:0: [sdc]=C2=A0=
 Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210299] sd 6:0:0:0: [sdc] CDB=
: Write(10): 2a 00 6a 7a 73 3f 00 00 80 00
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210308] end_request: I/O erro=
r, dev sdc, sector 1786409791
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.210727] ata7.00: detaching (S=
CSI 6:0:0:0)
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.240037] ata8: failed to resum=
e link (SControl 45)
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.250170] sd 6:0:0:0: [sdc] Syn=
chronizing SCSI cache
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.250220] sd 6:0:0:0: [sdc]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.250227] sd 6:0:0:0: [sdc] Sto=
pping disk
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.250249] sd 6:0:0:0: [sdc] STA=
RT_STOP FAILED
Mar=C2=A0 9 23:57:43 ftp2 kernel: [121567.250252] sd 6:0:0:0: [sdc]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:57:47 ftp2 kernel: [121571.380062] ata8: SATA link up 1.=
5 Gbps (SStatus 113 SControl 45)
Mar=C2=A0 9 23:58:17 ftp2 kernel: [121601.380051] ata8.00: qc timeout (=
cmd 0xec)
Mar=C2=A0 9 23:58:17 ftp2 kernel: [121601.380065] ata8.00: failed to ID=
ENTIFY (I/O error, err_mask=3D0x4)
Mar=C2=A0 9 23:58:17 ftp2 kernel: [121601.380069] ata8.00: revalidation=
 failed (errno=3D-5)
Mar=C2=A0 9 23:58:17 ftp2 kernel: [121601.380073] ata8.00: disabled
Mar=C2=A0 9 23:58:17 ftp2 kernel: [121601.380097] ata8: exception Emask=
 0x40 SAct 0x0 SErr 0x4850800 action 0x6 frozen t4
Mar=C2=A0 9 23:58:17 ftp2 kernel: [121601.380104] ata8: SError: { HostI=
nt PHYRdyChg CommWake LinkSeq DevExch }
Mar=C2=A0 9 23:58:17 ftp2 kernel: [121601.380114] ata8: hard resetting =
link
Mar=C2=A0 9 23:58:18 ftp2 kernel: [121602.450056] ata8: failed to resum=
e link (SControl 2)
Mar=C2=A0 9 23:58:27 ftp2 kernel: [121611.390038] ata8: softreset faile=
d (1st FIS failed)
Mar=C2=A0 9 23:58:27 ftp2 kernel: [121611.390044] ata8: hard resetting =
link
Mar=C2=A0 9 23:58:28 ftp2 kernel: [121612.460048] ata8: failed to resum=
e link (SControl 0)
Mar=C2=A0 9 23:58:36 ftp2 proftpd[15555]: ftp2.wifizabreh.net (192.168.=
1.3[192.168.1.3]) - FTP session opened.
Mar=C2=A0 9 23:58:36 ftp2 proftpd[15555]: ftp2.wifizabreh.net (192.168.=
1.3[192.168.1.3]) - Preparing to chroot to directory '/FTP'
Mar=C2=A0 9 23:58:36 ftp2 proftpd[15555]: ftp2.wifizabreh.net (192.168.=
1.3[192.168.1.3]) - ANON ftp: Login successful.
Mar=C2=A0 9 23:58:37 ftp2 kernel: [121621.400039] ata8: softreset faile=
d (1st FIS failed)
Mar=C2=A0 9 23:58:37 ftp2 kernel: [121621.400046] ata8: hard resetting =
link
Mar=C2=A0 9 23:58:38 ftp2 kernel: [121622.250035] ata8: failed to reset=
 engine (errno=3D-5)
Mar=C2=A0 9 23:59:12 ftp2 kernel: [121656.410040] ata8: softreset faile=
d (1st FIS failed)
Mar=C2=A0 9 23:59:12 ftp2 kernel: [121656.410049] ata8: hard resetting =
link
Mar=C2=A0 9 23:59:13 ftp2 kernel: [121657.270034] ata8: link resume suc=
ceeded after 3 retries
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650051] ata8: SATA link up 1.=
5 Gbps (SStatus 113 SControl 310)
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650083] ata8: EH complete
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650173] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650177] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650184] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 d9 bf 00 00 80 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650197] end_request: I/O erro=
r, dev sdd, sector 1786370495
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650216] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650220] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650225] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 d9 3f 00 00 80 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650247] end_request: I/O erro=
r, dev sdd, sector 1786370367
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650255] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650257] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650262] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 da bf 00 00 80 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650270] end_request: I/O erro=
r, dev sdd, sector 1786370751
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650278] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650280] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650284] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 da 3f 00 00 80 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650293] end_request: I/O erro=
r, dev sdd, sector 1786370623
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650300] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650303] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650307] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 db 3f 00 00 80 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650316] end_request: I/O erro=
r, dev sdd, sector 1786370879
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650325] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650327] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650332] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 db bf 00 04 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650340] end_request: I/O erro=
r, dev sdd, sector 1786371007
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650356] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650359] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650363] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 df bf 00 04 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650372] end_request: I/O erro=
r, dev sdd, sector 1786372031
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650383] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650385] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650389] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 e3 bf 00 04 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650398] end_request: I/O erro=
r, dev sdd, sector 1786373055
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650409] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650411] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650415] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 e7 bf 00 04 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650424] end_request: I/O erro=
r, dev sdd, sector 1786374079
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650435] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650437] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650441] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 eb bf 00 04 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650450] end_request: I/O erro=
r, dev sdd, sector 1786375103
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650460] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650463] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650467] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 ef bf 00 04 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650476] end_request: I/O erro=
r, dev sdd, sector 1786376127
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650486] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650489] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650493] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 f3 bf 00 04 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650502] end_request: I/O erro=
r, dev sdd, sector 1786377151
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650510] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650513] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650517] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 f7 bf 00 00 90 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650525] end_request: I/O erro=
r, dev sdd, sector 1786378175
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650531] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650534] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650538] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 00 d0 75 3f 00 01 00 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.650547] end_request: I/O erro=
r, dev sdd, sector 13661503
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651378] lost page write due t=
o I/O error on sdc1
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651411] lost page write due t=
o I/O error on sdc1
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651445] end_request: I/O erro=
r, dev sdc, sector 536870912
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651447] lost page write due t=
o I/O error on sdc1
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651463] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651466] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651470] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 00 00 00 bf 00 00 08 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651479] end_request: I/O erro=
r, dev sdd, sector 191
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651482] lost page write due t=
o I/O error on sdd1
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651489] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651492] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651496] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 00 02 00 3f 00 00 08 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651505] end_request: I/O erro=
r, dev sdd, sector 131135
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651508] lost page write due t=
o I/O error on sdd1
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651518] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651521] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651525] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 20 00 00 3f 00 00 08 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651533] end_request: I/O erro=
r, dev sdd, sector 536870975
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651540] end_request: I/O erro=
r, dev sdd, sector 536870975
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.651543] lost page write due t=
o I/O error on sdd1
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.732781] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.732785] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.732790] sd 7:0:0:0: [sdd] CDB=
: Read(10): 28 00 00 d0 75 57 00 00 08 00
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.732801] end_request: I/O erro=
r, dev sdd, sector 13661527
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.732937] ------------[ cut her=
e ]------------
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.737741] kernel BUG at fs/btrf=
s/inode.c:2897!
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742630] invalid opcode: 0000 =
[#1] SMP=20
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] last sysfs file: /sys=
/devices/pci0000:00/0000:00:1c.2/0000:03:00.0/host7/target7:0:0/7:0:0:0=
/block/sdd/sdd1/uevent
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] CPU 0=20
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] Modules linked in: us=
blp btrfs zlib_deflate crc32c libcrc32c tun coretemp it87 hwmon_vid nfs=
d lockd auth_rpcgss sunrpc exportfs fuse dummy dm_mod ehci_hcd iTCO_wdt=
 uhci_hcd iTCO_vendor_support usbcore i2c_i801 i2c_core sky2 intel_agp =
pcspkr intel_gtt sg processor button
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=20
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] Pid: 15572, comm: rm =
Not tainted 2.6.37-gentoo-mykernel #2 965GM-S2/965GM-S2
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] RIP: 0010:[]=C2=A0 []=
 btrfs_unlink+0x74/0xe7 [btrfs]
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] RSP: 0018:ffff880123e=
3be68=C2=A0 EFLAGS: 00010282
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] RAX: 00000000fffffffb=
 RBX: ffff880103770900 RCX: ffff8801277ce510
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] RDX: 0000000000000000=
 RSI: ffffea00040a3510 RDI: ffff8801277ce480
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] RBP: ffff880106db2028=
 R08: fffffffffffffffb R09: 0000000000000000
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] R10: 0000000000000400=
 R11: ffff880127ab76c0 R12: ffff880041976180
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] R13: ffff880123f2a800=
 R14: ffff8800633e54b8 R15: 00000000fffffffb
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] FS:=C2=A0 00007f6844e=
e9700(0000) GS:ffff8800cf400000(0000) knlGS:0000000000000000
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] CS:=C2=A0 0010 DS: 00=
00 ES: 0000 CR0: 000000008005003b
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] CR2: 00007fa5e4712bc8=
 CR3: 0000000115117000 CR4: 00000000000006f0
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] Process rm (pid: 1557=
2, threadinfo ffff880123e3a000, task ffff880127ab76c0)
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] Stack:
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 00000000fffffff=
0 ffff880041976180 00000000fffffff0 ffff880106db2028
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 00000000ffffff9=
c 000000000060f030 0000000000000003 ffffffff810b5fb0
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 ffff8800633e54b=
8 ffff880041976180 0000000000000000 ffffffff810b80b8
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] Call Trace:
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 [] ? vfs_unlink=
+0x5b/0xb9
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 [] ? do_unlinka=
t+0xbe/0x145
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 [] ? page_fault=
+0x1f/0x30
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 [] ? system_cal=
l_fastpath+0x16/0x1b
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] Code: 24 10 e8 da eb =
01 00 49 8b 4c 24 10 45 8b 4c 24 34 48 89 ea 4d 8b 44 24 38 4c 89 ee 48=
 89 df e8 7a f3 ff ff 85 c0 41 89 c7 74 04  0b eb fe 41 83 7e 5c 00 75 =
13 4c 89 f6 48 89 df e8 9f f8 ff=20
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911] RIP=C2=A0 [] btrfs_un=
link+0x74/0xe7 [btrfs]
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.742911]=C2=A0 RSP=20
Mar=C2=A0 9 23:59:17 ftp2 kernel: [121661.991467] ---[ end trace e58b77=
d4855c2f73 ]---
Mar=C2=A0 9 23:59:23 ftp2 kernel: [121668.128813] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.136408] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144133] sd 7:0:0:0: [sdd] CDB=
: Read(10): 28 00 00 cf 92 67 00 00 08 00
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144142] end_request: I/O erro=
r, dev sdd, sector 13603431
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144190] ------------[ cut her=
e ]------------
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144193] kernel BUG at fs/btrf=
s/ctree.c:310!
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144195] invalid opcode: 0000 =
[#2] SMP=20
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144198] last sysfs file: /sys=
/devices/pci0000:00/0000:00:1c.2/0000:03:00.0/host7/target7:0:0/7:0:0:0=
/block/sdd/sdd1/uevent
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144201] CPU 0=20
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144203] Modules linked in: us=
blp btrfs zlib_deflate crc32c libcrc32c tun coretemp it87 hwmon_vid nfs=
d lockd auth_rpcgss sunrpc exportfs fuse dummy dm_mod ehci_hcd iTCO_wdt=
 uhci_hcd iTCO_vendor_support usbcore i2c_i801 i2c_core sky2 intel_agp =
pcspkr intel_gtt sg processor button
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144222]=20
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144226] Pid: 15555, comm: pro=
ftpd Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=C2=A0=C2=A0=C2=A0=C2=A0=
 2.6.37-gentoo-mykernel #2 965GM-S2/965GM-S2
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144230] RIP: 0010:[]=C2=A0 []=
 update_ref_for_cow+0x48/0x260 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144247] RSP: 0018:ffff880125e=
9b8e8=C2=A0 EFLAGS: 00010282
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144250] RAX: 00000000fffffffb=
 RBX: ffff880106e7d770 RCX: ffff8801277ce360
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144253] RDX: 0000000000000000=
 RSI: ffffea00040a3510 RDI: ffff8801277ce510
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144256] RBP: ffff880123f2a800=
 R08: 0000000000000001 R09: 0000000000000000
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144259] R10: ffff8801264e6ae0=
 R11: ffff8801264e6ae0 R12: ffff8801037708c0
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144262] R13: ffff880050a8cee0=
 R14: ffff880125e9b984 R15: ffff880125e9ba98
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144265] FS:=C2=A0 00007fa659d=
5b700(0000) GS:ffff8800cf400000(0000) knlGS:0000000000000000
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144268] CS:=C2=A0 0010 DS: 00=
00 ES: 0000 CR0: 0000000080050033
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144271] CR2: 00000000004482a0=
 CR3: 0000000123e39000 CR4: 00000000000006f0
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144274] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144277] DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144280] Process proftpd (pid:=
 15555, threadinfo ffff880125e9a000, task ffff8801264e6ae0)
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144282] Stack:
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144284]=C2=A0 000000000000035=
4 ffff880123f2a800 ffff880123f2a800 ffff880106e7d770
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144288]=C2=A0 ffff880050a8cee=
0 ffff8801037708c0 ffff880050a8ce58 ffffffffa01b8556
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144292]=C2=A0 ffff88010000000=
0 000004ed00000000 0000000000000000 0000000000005924
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144296] Call Trace:
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144308]=C2=A0 [] ? __btrfs_co=
w_block+0x320/0x55e [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144322]=C2=A0 [] ? btrfs_buff=
er_uptodate+0x3b/0x48 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144333]=C2=A0 [] ? btrfs_cow_=
block+0x17f/0x19d [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144344]=C2=A0 [] ? btrfs_sear=
ch_slot+0x724/0x774 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144355]=C2=A0 [] ? btrfs_inse=
rt_empty_items+0x62/0xb5 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144368]=C2=A0 [] ? insert_wit=
h_overflow+0x30/0xec [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144381]=C2=A0 [] ? btrfs_inse=
rt_dir_item+0x83/0x266 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144391]=C2=A0 [] ? btrfs_rele=
ase_path+0x3b/0x52 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144405]=C2=A0 [] ? __btrfs_ge=
txattr+0xed/0xff [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144420]=C2=A0 [] ? btrfs_add_=
link+0x108/0x160 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144435]=C2=A0 [] ? btrfs_add_=
nondir+0x25/0x4e [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144450]=C2=A0 [] ? btrfs_init=
_inode_security+0x12/0x2d [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144464]=C2=A0 [] ? btrfs_crea=
te+0xfb/0x1b5 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144471]=C2=A0 [] ? vfs_create=
+0x77/0xd0
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144475]=C2=A0 [] ? do_last+0x=
2f4/0x617
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144479]=C2=A0 [] ? do_filp_op=
en+0x1ed/0x5ad
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144484]=C2=A0 [] ? do_sys_ope=
n+0x56/0xde
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144489]=C2=A0 [] ? system_cal=
l_fastpath+0x16/0x1b
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144491] Code: 48 83 ec 10 e8 =
64 c0 ff ff 85 c0 74 2e 48 8b 4b 08 48 8b 13 4c 8d 44 24 08 49 89 e1 48=
 89 ee 4c 89 e7 e8 06 b0 00 00 85 c0 74 04  0b eb fe 48 83 7c 24 08 00 =
75 7c 0f 0b eb fe 48 c7 44 24 08=20
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144512] RIP=C2=A0 [] update_r=
ef_for_cow+0x48/0x260 [btrfs]
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144523]=C2=A0 RSP=20
Mar=C2=A0 9 23:59:24 ftp2 kernel: [121668.144526] ---[ end trace e58b77=
d4855c2f74 ]---
Mar=C2=A0 9 23:59:26 ftp2 proftpd[15574]: ftp2.wifizabreh.net (192.168.=
1.3[192.168.1.3]) - FTP session opened.
Mar=C2=A0 9 23:59:26 ftp2 proftpd[15574]: ftp2.wifizabreh.net (192.168.=
1.3[192.168.1.3]) - Preparing to chroot to directory '/FTP'
Mar=C2=A0 9 23:59:26 ftp2 proftpd[15574]: ftp2.wifizabreh.net (192.168.=
1.3[192.168.1.3]) - ANON ftp: Login successful.
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.690225] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.697091] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.703936] sd 7:0:0:0: [sdd] CDB=
: Read(10): 28 00 00 d0 75 f7 00 00 08 00
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704123] end_request: I/O erro=
r, dev sdd, sector 13661687
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704172] ------------[ cut her=
e ]------------
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704174] kernel BUG at fs/btrf=
s/extent-tree.c:5420!
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704177] invalid opcode: 0000 =
[#3] SMP=20
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704180] last sysfs file: /sys=
/devices/pci0000:00/0000:00:1c.2/0000:03:00.0/host7/target7:0:0/7:0:0:0=
/block/sdd/sdd1/uevent
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704183] CPU 1=20
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704185] Modules linked in: us=
blp btrfs zlib_deflate crc32c libcrc32c tun coretemp it87 hwmon_vid nfs=
d lockd auth_rpcgss sunrpc exportfs fuse dummy dm_mod ehci_hcd iTCO_wdt=
 uhci_hcd iTCO_vendor_support usbcore i2c_i801 i2c_core sky2 intel_agp =
pcspkr intel_gtt sg processor button
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704204]=20
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704208] Pid: 4883, comm: btrf=
s-transacti Tainted: G=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 D=C2=A0=C2=A0=C2=A0=
=C2=A0 2.6.37-gentoo-mykernel #2 965GM-S2/965GM-S2
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704212] RIP: 0010:[]=C2=A0 []=
 alloc_reserved_file_extent+0xa3/0x218 [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704231] RSP: 0018:ffff880121a=
c5bf0=C2=A0 EFLAGS: 00010282
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704234] RAX: 00000000fffffffb=
 RBX: ffff8801238136c0 RCX: ffff880121ac5b40
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704238] RDX: ffff88005ee2be80=
 RSI: ffff8801238136c0 RDI: 0000000000000000
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704241] RBP: ffff880121ac5d10=
 R08: 0000000000000001 R09: 0000000000000000
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704244] R10: ffff880121ac5d10=
 R11: 000000000000004e R12: 00000000000000b2
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704247] R13: 0000000000000000=
 R14: ffff8801037b8d00 R15: ffff880124d17800
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704251] FS:=C2=A0 00000000000=
00000(0000) GS:ffff8800cf500000(0000) knlGS:0000000000000000
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704254] CS:=C2=A0 0010 DS: 00=
00 ES: 0000 CR0: 000000008005003b
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704257] CR2: 00000000006fa1b0=
 CR3: 0000000124dd8000 CR4: 00000000000006e0
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704260] DR0: 0000000000000000=
 DR1: 0000000000000000 DR2: 0000000000000000
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704264] DR3: 0000000000000000=
 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704267] Process btrfs-transac=
ti (pid: 4883, threadinfo ffff880121ac4000, task ffff88012640d320)
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704269] Stack:
ar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704271]=C2=A0 ffff880125c68000=
 ffff88010000001d ffff8800cf511280 ffff8800cf511280
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704275]=C2=A0 ffff8800cf5112f=
0 0000000000000005 0000000000000000 0000000000008d6c
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704279]=C2=A0 ffff8801271e860=
8 000000355a7bf600 ffff8800cac3b0f0 ffff8800377d9ea0
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704284] Call Trace:
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704297]=C2=A0 [] ? run_cluste=
red_refs+0x667/0x771 [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704304]=C2=A0 [] ? schedule+0=
x6ff/0x79d
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704315]=C2=A0 [] ? tree_searc=
h_offset+0x128/0x1ab [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704328]=C2=A0 [] ? btrfs_run_=
delayed_refs+0xcd/0x1c0 [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704343]=C2=A0 [] ? btrfs_comm=
it_transaction+0x7e/0x61e [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704349]=C2=A0 [] ? autoremove=
_wake_function+0x0/0x2a
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704363]=C2=A0 [] ? transactio=
n_kthread+0x16d/0x214 [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704376]=C2=A0 [] ? transactio=
n_kthread+0x0/0x214 [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704389]=C2=A0 [] ? transactio=
n_kthread+0x0/0x214 [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704394]=C2=A0 [] ? kthread+0x=
7a/0x82
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704398]=C2=A0 [] ? kernel_thr=
ead_helper+0x4/0x10
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704402]=C2=A0 [] ? kthread+0x=
0/0x82
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704406]=C2=A0 [] ? kernel_thr=
ead_helper+0x0/0x10
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704408] Code: 00 00 08 83 c2 =
18 4c 8d 44 24 4c 48 8b 71 20 41 b9 01 00 00 00 89 54 24 4c 48 89 e9 48=
 89 c2 4c 89 f7 e8 88 b0 ff ff 85 c0 74 04  0b eb fe 48 8b 03 48 89 44 =
24 10 48 63 73 40 48 89 c7 48 6b=20
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704429] RIP=C2=A0 [] alloc_re=
served_file_extent+0xa3/0x218 [btrfs]
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704441]=C2=A0 RSP=20
Mar=C2=A0 9 23:59:47 ftp2 kernel: [121691.704444] ---[ end trace e58b77=
d4855c2f75 ]---
Mar=C2=A0 9 23:59:52 ftp2 kernel: [121696.650612] sd 7:0:0:0: [sdd] Unh=
andled error code
Mar=C2=A0 9 23:59:52 ftp2 kernel: [121696.657920] sd 7:0:0:0: [sdd]=C2=A0=
 Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Mar=C2=A0 9 23:59:52 ftp2 kernel: [121696.665378] sd 7:0:0:0: [sdd] CDB=
: Write(10): 2a 00 6a 79 f8 4f 00 00 70 00
Mar=C2=A0 9 23:59:52 ftp2 kernel: [121696.665543] end_request: I/O erro=
r, dev sdd, sector 1786378319
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 ftp2 ~ # btrfsck /dev/sdd1
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' =
failed.
Aborted
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 ftp2 ~ # uname -a
Linux ftp2 2.6.37-gentoo-mykernel #2 SMP Fri Jan 28 00:39:02 CET 2011 x=
86_64 Genuine Intel(R) CPU 2140 @ 1.60GHz GenuineIntel GNU/Linux
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
I also tried "btrfs-select-super" from git on all disks (sdb1,sdc1,sdd1=
) with "-s 1" and "-s 2" and nothing helped.

Only one good thing is that this is "backup machine" so I can tranfer a=
ll data from "main machine". But it is 3TB so it would take about 40day=
s to fully transfer all data :-(

Is there any possible way to (partially) restore some data? (I use rsyn=
c syncing data between both machines)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

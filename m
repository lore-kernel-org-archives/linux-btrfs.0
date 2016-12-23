Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:50252 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756758AbcLWG1F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Dec 2016 01:27:05 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 1EBBC5FC92
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 06:27:03 +0000 (UTC)
Received: from mailgw-02.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id 4mjvasVcF8xD for <linux-btrfs@vger.kernel.org>;
        Fri, 23 Dec 2016 06:26:59 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-85-125.dynamic.mnet-online.de [82.135.85.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailgw-02.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Dec 2016 06:26:59 +0000 (UTC)
Message-ID: <1482474418.23663.1.camel@scientia.net>
Subject: strange btrfs deadlock
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: linux-btrfs@vger.kernel.org
Date: Fri, 23 Dec 2016 07:26:58 +0100
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-bMSsMkvxmonlsNNKTVGf"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-bMSsMkvxmonlsNNKTVGf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

Had the following on a Debian sid:
Linux heisenberg 4.8.0-2-amd64 #1 SMP Debian 4.8.11-1 (2016-12-02)
x86_64 GNU/Linux


I was basically copying data between several filesystems all on SATA
disks attached via USB.

Unfortunately I have only little data...



The first part may be totally unrelated... here I was doing some
recursive diff between data on sdb and sdc (both mounted ro), when I
connected a 3rd disk to the same USB3.0 hub on which the other two
disks were already connected.

That somehow made sdc failing... (interestingly sdb seemed to continue
working).

Dec 23 04:36:04 heisenberg kernel: [38080.618202] BTRFS info (device dm-1):=
 disk space caching is enabled
Dec 23 04:36:18 heisenberg kernel: [38093.903212] bash (7006): drop_caches:=
 3
Dec 23 04:58:44 heisenberg kernel: [39440.832610] scsi host7: uas_pre_reset=
: timed out
Dec 23 04:58:44 heisenberg kernel: [39440.832760] sd 7:0:0:0: [sdc] tag#4 u=
as_zap_pending 0 uas-tag 5 inflight: CMD=20
Dec 23 04:58:44 heisenberg kernel: [39440.832767] sd 7:0:0:0: [sdc] tag#4 C=
DB: Read(10) 28 00 3f 03 45 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832777] sd 7:0:0:0: [sdc] tag#5 u=
as_zap_pending 0 uas-tag 6 inflight: CMD=20
Dec 23 04:58:44 heisenberg kernel: [39440.832780] sd 7:0:0:0: [sdc] tag#5 C=
DB: Read(10) 28 00 3f 03 49 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832785] sd 7:0:0:0: [sdc] tag#6 u=
as_zap_pending 0 uas-tag 7 inflight: CMD=20
Dec 23 04:58:44 heisenberg kernel: [39440.832788] sd 7:0:0:0: [sdc] tag#6 C=
DB: Read(10) 28 00 3f 03 4d 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832792] sd 7:0:0:0: [sdc] tag#8 u=
as_zap_pending 0 uas-tag 9 inflight: CMD=20
Dec 23 04:58:44 heisenberg kernel: [39440.832796] sd 7:0:0:0: [sdc] tag#8 C=
DB: Read(10) 28 00 3f 03 51 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832858] sd 7:0:0:0: [sdc] tag#4 F=
AILED Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
Dec 23 04:58:44 heisenberg kernel: [39440.832864] sd 7:0:0:0: [sdc] tag#4 C=
DB: Read(10) 28 00 3f 03 45 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832870] blk_update_request: I/O e=
rror, dev sdc, sector 1057178952
Dec 23 04:58:44 heisenberg kernel: [39440.832917] sd 7:0:0:0: [sdc] tag#5 F=
AILED Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
Dec 23 04:58:44 heisenberg kernel: [39440.832921] sd 7:0:0:0: [sdc] tag#5 C=
DB: Read(10) 28 00 3f 03 49 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832924] blk_update_request: I/O e=
rror, dev sdc, sector 1057179976
Dec 23 04:58:44 heisenberg kernel: [39440.832937] BTRFS error (device dm-2)=
: bdev /dev/mapper/data-c errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
Dec 23 04:58:44 heisenberg kernel: [39440.832959] sd 7:0:0:0: [sdc] tag#6 F=
AILED Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
Dec 23 04:58:44 heisenberg kernel: [39440.832963] sd 7:0:0:0: [sdc] tag#6 C=
DB: Read(10) 28 00 3f 03 4d 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832966] blk_update_request: I/O e=
rror, dev sdc, sector 1057181000
Dec 23 04:58:44 heisenberg kernel: [39440.832980] sd 7:0:0:0: [sdc] tag#8 F=
AILED Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
Dec 23 04:58:44 heisenberg kernel: [39440.832985] sd 7:0:0:0: [sdc] tag#8 C=
DB: Read(10) 28 00 3f 03 51 48 00 04 00 00
Dec 23 04:58:44 heisenberg kernel: [39440.832988] blk_update_request: I/O e=
rror, dev sdc, sector 1057182024
Dec 23 04:58:44 heisenberg kernel: [39440.832995] BTRFS error (device dm-2)=
: bdev /dev/mapper/data-c errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
Dec 23 04:58:44 heisenberg kernel: [39440.833807] sd 7:0:0:0: [sdc] Synchro=
nizing SCSI cache
Dec 23 04:58:45 heisenberg kernel: [39441.072663] sd 7:0:0:0: [sdc] Synchro=
nize Cache(10) failed: Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Dec 23 04:58:45 heisenberg kernel: [39441.096973] usb 4-2.4: Disable of dev=
ice-initiated U1 failed.
Dec 23 04:58:45 heisenberg kernel: [39441.100670] usb 4-2.4: Disable of dev=
ice-initiated U2 failed.
Dec 23 04:58:45 heisenberg kernel: [39441.107663] usb 4-2.4: Set SEL for de=
vice-initiated U1 failed.
Dec 23 04:58:45 heisenberg kernel: [39441.111155] usb 4-2.4: Set SEL for de=
vice-initiated U2 failed.
Dec 23 04:58:45 heisenberg kernel: [39441.188752] usb 4-2.4: reset SuperSpe=
ed USB device number 4 using xhci_hcd
Dec 23 04:58:45 heisenberg kernel: [39441.225703] scsi host8: uas
Dec 23 04:58:45 heisenberg kernel: [39441.227043] scsi 8:0:0:0: Direct-Acce=
ss     Seagate  Expansion        0636 PQ: 0 ANSI: 6
Dec 23 04:58:45 heisenberg kernel: [39441.429443] sd 8:0:0:0: Attached scsi=
 generic sg2 type 0
Dec 23 04:58:45 heisenberg kernel: [39441.429572] sd 8:0:0:0: [sdd] 3907029=
167 512-byte logical blocks: (2.00 TB/1.82 TiB)
Dec 23 04:58:45 heisenberg kernel: [39441.430756] sd 8:0:0:0: [sdd] Write P=
rotect is off
Dec 23 04:58:45 heisenberg kernel: [39441.430764] sd 8:0:0:0: [sdd] Mode Se=
nse: 2b 00 10 08
Dec 23 04:58:45 heisenberg kernel: [39441.431593] sd 8:0:0:0: [sdd] Write c=
ache: enabled, read cache: enabled, supports DPO and FUA
Dec 23 04:58:45 heisenberg kernel: [39441.448659] usb 4-2.1: new SuperSpeed=
 USB device number 5 using xhci_hcd
Dec 23 04:58:45 heisenberg kernel: [39441.469427] usb 4-2.1: New USB device=
 found, idVendor=3D174c, idProduct=3D55aa
Dec 23 04:58:45 heisenberg kernel: [39441.469458] usb 4-2.1: New USB device=
 strings: Mfr=3D2, Product=3D3, SerialNumber=3D1
Dec 23 04:58:45 heisenberg kernel: [39441.469463] usb 4-2.1: Product: ASMT1=
053
Dec 23 04:58:45 heisenberg kernel: [39441.469491] usb 4-2.1: Manufacturer: =
asmedia
Dec 23 04:58:45 heisenberg kernel: [39441.469495] usb 4-2.1: SerialNumber: =
123456789012
Dec 23 04:58:45 heisenberg kernel: [39441.469811] usb 4-2.1: Device is not =
authorized for usage
Dec 23 04:58:45 heisenberg kernel: [39441.471714]  sdd: sdd1 sdd2
Dec 23 04:58:45 heisenberg kernel: [39441.474685] sd 8:0:0:0: [sdd] Attache=
d SCSI disk
Dec 23 04:58:53 heisenberg kernel: [39448.996935] usb-storage 4-2.1:1.0: US=
B Mass Storage device detected
Dec 23 04:58:53 heisenberg kernel: [39448.997704] usb-storage 4-2.1:1.0: Qu=
irks match for vid 174c pid 55aa: 400000
Dec 23 04:58:53 heisenberg kernel: [39448.998277] scsi host9: usb-storage 4=
-2.1:1.0
Dec 23 04:58:53 heisenberg kernel: [39448.998372] usb 4-2.1: authorized to =
connect
Dec 23 04:58:54 heisenberg kernel: [39450.017454] scsi 9:0:0:0: Direct-Acce=
ss     ASMT     2105             0    PQ: 0 ANSI: 6
Dec 23 04:58:54 heisenberg kernel: [39450.017856] sd 9:0:0:0: Attached scsi=
 generic sg3 type 0
Dec 23 04:58:54 heisenberg kernel: [39450.018874] sd 9:0:0:0: [sde] 3907029=
168 512-byte logical blocks: (2.00 TB/1.82 TiB)
Dec 23 04:58:54 heisenberg kernel: [39450.018878] sd 9:0:0:0: [sde] 4096-by=
te physical blocks
Dec 23 04:58:54 heisenberg kernel: [39450.019078] sd 9:0:0:0: [sde] Write P=
rotect is off
Dec 23 04:58:54 heisenberg kernel: [39450.019081] sd 9:0:0:0: [sde] Mode Se=
nse: 43 00 00 00
Dec 23 04:58:54 heisenberg kernel: [39450.019283] sd 9:0:0:0: [sde] Write c=
ache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 23 04:58:54 heisenberg kernel: [39450.035842]  sde: sde1 sde2 sde3
Dec 23 04:58:54 heisenberg kernel: [39450.036801] sd 9:0:0:0: [sde] Attache=
d SCSI disk
Dec 23 04:59:10 heisenberg kernel: [39466.013964] usb 4-2.2: reset SuperSpe=
ed USB device number 3 using xhci_hcd
Dec 23 04:59:10 heisenberg kernel: [39466.161252] BTRFS error (device dm-2)=
: bdev /dev/mapper/data-c errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
Dec 23 04:59:10 heisenberg kernel: [39466.161389] BTRFS error (device dm-2)=
: bdev /dev/mapper/data-c errs: wr 0, rd 4, flush 0, corrupt 0, gen 0
Dec 23 04:59:10 heisenberg kernel: [39466.161617] BTRFS error (device dm-2)=
: bdev /dev/mapper/data-c errs: wr 0, rd 5, flush 0, corrupt 0, gen 0
Dec 23 04:59:10 heisenberg kernel: [39466.162021] BTRFS error (device dm-2)=
: bdev /dev/mapper/data-c errs: wr 0, rd 6, flush 0, corrupt 0, gen 0
Dec 23 04:59:10 heisenberg kernel: [39466.370066] BTRFS error (device dm-2)=
: bdev /dev/mapper/data-c errs: wr 0, rd 7, flush 0, corrupt 0, gen 0

Here I unmounted/disconnected the 3 devices and started over (btrfs
check was fine on all devices, so I guess nothing happened to the fs on
them):


Dec 23 04:59:37 heisenberg kernel: [39493.279922] usb 4-2.1: Disable of dev=
ice-initiated U1 failed.
Dec 23 04:59:37 heisenberg kernel: [39493.283662] usb 4-2.1: Disable of dev=
ice-initiated U2 failed.
Dec 23 04:59:37 heisenberg kernel: [39493.305407] usb 4-2.1: USB disconnect=
, device number 5
Dec 23 04:59:37 heisenberg kernel: [39493.306597] sd 9:0:0:0: [sde] Synchro=
nizing SCSI cache
Dec 23 04:59:37 heisenberg kernel: [39493.306668] sd 9:0:0:0: [sde] Synchro=
nize Cache(10) failed: Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVE=
R_OK
Dec 23 05:00:41 heisenberg kernel: [39557.839699] usb 4-2.4: USB disconnect=
, device number 4
Dec 23 05:00:41 heisenberg kernel: [39557.840627] sd 8:0:0:0: [sdd] Synchro=
nizing SCSI cache
Dec 23 05:00:42 heisenberg kernel: [39558.090160] sd 8:0:0:0: [sdd] Synchro=
nize Cache(10) failed: Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK
Dec 23 05:00:52 heisenberg kernel: [39568.368484] usb 4-2.2: USB disconnect=
, device number 3
Dec 23 05:00:52 heisenberg kernel: [39568.369808] sd 6:0:0:0: [sdb] Synchro=
nizing SCSI cache
Dec 23 05:00:52 heisenberg kernel: [39568.369863] sd 6:0:0:0: [sdb] Synchro=
nize Cache(10) failed: Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVE=
R_OK

And reconnecting for btrfs check...


Dec 23 05:01:03 heisenberg kernel: [39579.079147] usb 4-2.2: new SuperSpeed=
 USB device number 6 using xhci_hcd
Dec 23 05:01:03 heisenberg kernel: [39579.100076] usb 4-2.2: New USB device=
 found, idVendor=3D174c, idProduct=3D55aa
Dec 23 05:01:03 heisenberg kernel: [39579.100082] usb 4-2.2: New USB device=
 strings: Mfr=3D2, Product=3D3, SerialNumber=3D1
Dec 23 05:01:03 heisenberg kernel: [39579.100085] usb 4-2.2: Product: ASMT1=
053
Dec 23 05:01:03 heisenberg kernel: [39579.100088] usb 4-2.2: Manufacturer: =
asmedia
Dec 23 05:01:03 heisenberg kernel: [39579.100091] usb 4-2.2: SerialNumber: =
123456789012
Dec 23 05:01:03 heisenberg kernel: [39579.100331] usb 4-2.2: Device is not =
authorized for usage
Dec 23 05:01:06 heisenberg kernel: [39582.456999] usb-storage 4-2.2:1.0: US=
B Mass Storage device detected
Dec 23 05:01:06 heisenberg kernel: [39582.457146] usb-storage 4-2.2:1.0: Qu=
irks match for vid 174c pid 55aa: 400000
Dec 23 05:01:06 heisenberg kernel: [39582.457245] scsi host6: usb-storage 4=
-2.2:1.0
Dec 23 05:01:06 heisenberg kernel: [39582.457434] usb 4-2.2: authorized to =
connect
Dec 23 05:01:07 heisenberg kernel: [39583.464101] scsi 6:0:0:0: Direct-Acce=
ss     ASMT     2105             0    PQ: 0 ANSI: 6
Dec 23 05:01:07 heisenberg kernel: [39583.464893] sd 6:0:0:0: Attached scsi=
 generic sg1 type 0
Dec 23 05:01:07 heisenberg kernel: [39583.465645] sd 6:0:0:0: [sdb] Spinnin=
g up disk...
Dec 23 05:01:22 heisenberg kernel: [39584.487358] ...............ready
Dec 23 05:01:22 heisenberg kernel: [39598.825905] sd 6:0:0:0: [sdb] 1562805=
3168 512-byte logical blocks: (8.00 TB/7.28 TiB)
Dec 23 05:01:22 heisenberg kernel: [39598.825912] sd 6:0:0:0: [sdb] 4096-by=
te physical blocks
Dec 23 05:01:22 heisenberg kernel: [39598.826179] sd 6:0:0:0: [sdb] Write P=
rotect is off
Dec 23 05:01:22 heisenberg kernel: [39598.826184] sd 6:0:0:0: [sdb] Mode Se=
nse: 43 00 00 00
Dec 23 05:01:22 heisenberg kernel: [39598.826395] sd 6:0:0:0: [sdb] Write c=
ache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 23 05:01:23 heisenberg kernel: [39599.313636]  sdb: sdb1 sdb2
Dec 23 05:01:23 heisenberg kernel: [39599.315444] sd 6:0:0:0: [sdb] Attache=
d SCSI disk

That sdc must have been the other disk from the diffing, where I ran a
btrfs check upon

Dec 23 05:03:44 heisenberg kernel: [39740.534836] usb 4-2.4: new SuperSpeed=
 USB device number 7 using xhci_hcd
Dec 23 05:03:44 heisenberg kernel: [39740.558382] usb 4-2.4: New USB device=
 found, idVendor=3D0bc2, idProduct=3D2312
Dec 23 05:03:44 heisenberg kernel: [39740.558390] usb 4-2.4: New USB device=
 strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
Dec 23 05:03:44 heisenberg kernel: [39740.558393] usb 4-2.4: Product: Expan=
sion
Dec 23 05:03:44 heisenberg kernel: [39740.558396] usb 4-2.4: Manufacturer: =
Seagate=20
Dec 23 05:03:44 heisenberg kernel: [39740.558398] usb 4-2.4: SerialNumber: =
NA49AWZB
Dec 23 05:03:44 heisenberg kernel: [39740.558655] usb 4-2.4: Device is not =
authorized for usage
Dec 23 05:03:47 heisenberg kernel: [39743.222350] scsi host7: uas
Dec 23 05:03:47 heisenberg kernel: [39743.222497] usb 4-2.4: authorized to =
connect
Dec 23 05:03:47 heisenberg kernel: [39743.223740] scsi 7:0:0:0: Direct-Acce=
ss     Seagate  Expansion        0636 PQ: 0 ANSI: 6
Dec 23 05:03:47 heisenberg kernel: [39743.275286] sd 7:0:0:0: Attached scsi=
 generic sg2 type 0
Dec 23 05:03:47 heisenberg kernel: [39743.277391] sd 7:0:0:0: [sdc] Spinnin=
g up disk...
Dec 23 05:03:49 heisenberg kernel: [39745.518933] .ready
Dec 23 05:03:49 heisenberg kernel: [39745.519260] sd 7:0:0:0: [sdc] 3907029=
167 512-byte logical blocks: (2.00 TB/1.82 TiB)
Dec 23 05:03:49 heisenberg kernel: [39745.520277] sd 7:0:0:0: [sdc] Write P=
rotect is off
Dec 23 05:03:49 heisenberg kernel: [39745.520280] sd 7:0:0:0: [sdc] Mode Se=
nse: 2b 00 10 08
Dec 23 05:03:49 heisenberg kernel: [39745.521048] sd 7:0:0:0: [sdc] Write c=
ache: enabled, read cache: enabled, supports DPO and FUA
Dec 23 05:03:49 heisenberg kernel: [39745.592360]  sdc: sdc1 sdc2
Dec 23 05:03:49 heisenberg kernel: [39745.595296] sd 7:0:0:0: [sdc] Attache=
d SCSI disk
Dec 23 05:28:23 heisenberg kernel: [41219.475656] BTRFS info (device dm-1):=
 use zlib compression
Dec 23 05:28:23 heisenberg kernel: [41219.475661] BTRFS info (device dm-1):=
 disk space caching is enabled
Dec 23 05:28:23 heisenberg kernel: [41219.475662] BTRFS info (device dm-1):=
 has skinny extents
Dec 23 05:28:39 heisenberg kernel: [41235.805576] usb 1-1.2: new high-speed=
 USB device number 30 using ehci-pci
Dec 23 05:28:40 heisenberg kernel: [41235.959906] usb 1-1.2: New USB device=
 found, idVendor=3D174c, idProduct=3D55aa
Dec 23 05:28:40 heisenberg kernel: [41235.959913] usb 1-1.2: New USB device=
 strings: Mfr=3D2, Product=3D3, SerialNumber=3D1
Dec 23 05:28:40 heisenberg kernel: [41235.959916] usb 1-1.2: Product: ASMT1=
053
Dec 23 05:28:40 heisenberg kernel: [41235.959918] usb 1-1.2: Manufacturer: =
asmedia
Dec 23 05:28:40 heisenberg kernel: [41235.959920] usb 1-1.2: SerialNumber: =
123456789012
Dec 23 05:28:40 heisenberg kernel: [41235.960179] usb 1-1.2: Device is not =
authorized for usage

And that sdd was the one I tried to connect before, when the USB hub
(I'd guess) made some failure... it was this time not connected to the
USB3.0 hub, but rather to another USB2.0 port on my notebook.

Dec 23 05:28:43 heisenberg kernel: [41239.034746] usb-storage 1-1.2:1.0: US=
B Mass Storage device detected
Dec 23 05:28:43 heisenberg kernel: [41239.035584] usb-storage 1-1.2:1.0: Qu=
irks match for vid 174c pid 55aa: 400000
Dec 23 05:28:43 heisenberg kernel: [41239.035748] scsi host8: usb-storage 1=
-1.2:1.0
Dec 23 05:28:43 heisenberg kernel: [41239.035963] usb 1-1.2: authorized to =
connect
Dec 23 05:28:44 heisenberg kernel: [41240.054955] scsi 8:0:0:0: Direct-Acce=
ss     ASMT     2105             0    PQ: 0 ANSI: 6
Dec 23 05:28:44 heisenberg kernel: [41240.055816] sd 8:0:0:0: Attached scsi=
 generic sg3 type 0
Dec 23 05:28:44 heisenberg kernel: [41240.059527] sd 8:0:0:0: [sdd] Spinnin=
g up disk...
Dec 23 05:28:48 heisenberg kernel: [41241.077794] ....ready
Dec 23 05:28:48 heisenberg kernel: [41244.151621] sd 8:0:0:0: [sdd] 3907029=
168 512-byte logical blocks: (2.00 TB/1.82 TiB)
Dec 23 05:28:48 heisenberg kernel: [41244.151624] sd 8:0:0:0: [sdd] 4096-by=
te physical blocks
Dec 23 05:28:48 heisenberg kernel: [41244.152689] sd 8:0:0:0: [sdd] Write P=
rotect is off
Dec 23 05:28:48 heisenberg kernel: [41244.152692] sd 8:0:0:0: [sdd] Mode Se=
nse: 43 00 00 00
Dec 23 05:28:48 heisenberg kernel: [41244.153687] sd 8:0:0:0: [sdd] Write c=
ache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 23 05:28:48 heisenberg kernel: [41244.177352]  sdd: sdd1 sdd2 sdd3
Dec 23 05:28:48 heisenberg kernel: [41244.180594] sd 8:0:0:0: [sdd] Attache=
d SCSI disk
Dec 23 05:29:33 heisenberg kernel: [41289.371204] BTRFS info (device dm-1):=
 disk space caching is enabled


Now I was copying from sdd (which is NTFS or FAT) to sdb (btrfs).
After some ~800MB out of 31GB were copied,... the copying simply
stopped (but no kernel error occurred, neither did cp error out).
iotop also showed no further IO going on (so it wasn't a case of dm-
crypt doing it's work or so).

After a while I got these:

Dec 23 05:34:13 heisenberg kernel: [41569.317504] INFO: task kworker/u16:1:=
8564 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.317513]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.317515] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.317518] kworker/u16:1   D ffff9b5=
25e318180     0  8564      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.317573] Workqueue: btrfs-endio-wr=
ite btrfs_endio_write_helper [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317577]  ffff9b4f4e13f040 ffff9b5=
24be5b0c0 ffff9b4fd6ba3080 ffff9b4f6a01bc10
Dec 23 05:34:13 heisenberg kernel: [41569.317582]  ffff9b4f6a01c000 ffff9b4=
f6a01bc88 ffff9b51061c7560 ffff9b4f4e13f040
Dec 23 05:34:13 heisenberg kernel: [41569.317586]  0000000000000020 ffff9b5=
0ef41c000 ffffffff8bdeb6d1 ffff9b51061c7568
Dec 23 05:34:13 heisenberg kernel: [41569.317591] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.317602]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.317609]  [<ffffffff8bdeeb65>] ? s=
chedule_timeout+0x235/0x3f0
Dec 23 05:34:13 heisenberg kernel: [41569.317616]  [<ffffffff8b8a4720>] ? c=
heck_preempt_curr+0x50/0x90
Dec 23 05:34:13 heisenberg kernel: [41569.317621]  [<ffffffff8b8a4774>] ? t=
twu_do_wakeup+0x14/0xe0
Dec 23 05:34:13 heisenberg kernel: [41569.317625]  [<ffffffff8b8a5303>] ? t=
ry_to_wake_up+0x53/0x3a0
Dec 23 05:34:13 heisenberg kernel: [41569.317630]  [<ffffffff8bdec111>] ? w=
ait_for_completion+0xf1/0x130
Dec 23 05:34:13 heisenberg kernel: [41569.317634]  [<ffffffff8b8a56d0>] ? w=
ake_up_q+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.317663]  [<ffffffffc04802f8>] ? b=
trfs_async_run_delayed_refs+0x128/0x150 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317693]  [<ffffffffc049d98f>] ? _=
_btrfs_end_transaction+0x1ff/0x340 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317721]  [<ffffffffc04a6911>] ? b=
trfs_finish_ordered_io+0x161/0x680 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317751]  [<ffffffffc04d08b1>] ? b=
trfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317757]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.317760]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.317764]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.317768]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.317772]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.317777]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.317786] INFO: task kworker/u16:9:=
31391 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.317788]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.317790] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.317792] kworker/u16:9   D ffff9b5=
25e318180     0 31391      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.317804] Workqueue: writeback wb_w=
orkfn (flush-btrfs-7)
Dec 23 05:34:13 heisenberg kernel: [41569.317807]  ffff9b5090686140 ffff9b5=
24be5b0c0 ffff9b524d800180 0000000000000286
Dec 23 05:34:13 heisenberg kernel: [41569.317811]  ffff9b518bf08000 ffff9b5=
18bf07988 7fffffffffffffff ffff9b525e5b37a8
Dec 23 05:34:13 heisenberg kernel: [41569.317816]  ffff9b518bf07a20 fffffff=
f8bdebe80 ffffffff8bdeb6d1 0000000000000000
Dec 23 05:34:13 heisenberg kernel: [41569.317820] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.317825]  [<ffffffff8bdebe80>] ? b=
it_wait+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.317829]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.317834]  [<ffffffff8bdeeb65>] ? s=
chedule_timeout+0x235/0x3f0
Dec 23 05:34:13 heisenberg kernel: [41569.317839]  [<ffffffff8bdebe80>] ? b=
it_wait+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.317843]  [<ffffffff8bdeaedd>] ? i=
o_schedule_timeout+0x9d/0x100
Dec 23 05:34:13 heisenberg kernel: [41569.317848]  [<ffffffff8b8bcae5>] ? p=
repare_to_wait_exclusive+0x55/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.317852]  [<ffffffff8bdebe97>] ? b=
it_wait_io+0x17/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.317856]  [<ffffffff8bdebc38>] ? _=
_wait_on_bit_lock+0x48/0xa0
Dec 23 05:34:13 heisenberg kernel: [41569.317862]  [<ffffffff8b97ba0f>] ? _=
_lock_page+0xbf/0xe0
Dec 23 05:34:13 heisenberg kernel: [41569.317866]  [<ffffffff8b8bcec0>] ? a=
utoremove_wake_function+0x40/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.317899]  [<ffffffffc04c0277>] ? e=
xtent_write_cache_pages.isra.36.constprop.53+0x247/0x390 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317929]  [<ffffffffc04c156d>] ? e=
xtent_writepages+0x5d/0x90 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317955]  [<ffffffffc04a1d10>] ? b=
trfs_releasepage+0x40/0x40 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.317960]  [<ffffffff8ba3032d>] ? _=
_writeback_single_inode+0x3d/0x330
Dec 23 05:34:13 heisenberg kernel: [41569.317966]  [<ffffffff8ba30ae9>] ? w=
riteback_sb_inodes+0x229/0x500
Dec 23 05:34:13 heisenberg kernel: [41569.317971]  [<ffffffff8ba30e47>] ? _=
_writeback_inodes_wb+0x87/0xb0
Dec 23 05:34:13 heisenberg kernel: [41569.317976]  [<ffffffff8ba311a3>] ? w=
b_writeback+0x263/0x320
Dec 23 05:34:13 heisenberg kernel: [41569.317981]  [<ffffffff8ba31a92>] ? w=
b_workfn+0x212/0x3e0
Dec 23 05:34:13 heisenberg kernel: [41569.317985]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.317988]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.317991]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.317995]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.318000]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.318004]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.318008] INFO: task kworker/u16:3:=
31631 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.318010]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.318012] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.318013] kworker/u16:3   D ffff9b5=
25e398180     0 31631      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.318048] Workqueue: btrfs-delalloc=
 btrfs_delalloc_helper [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318050]  ffff9b4f67374080 ffff9b5=
24be65140 0000000000000000 ffff9b4f9837f828
Dec 23 05:34:13 heisenberg kernel: [41569.318055]  ffff9b4f98380000 ffff9b5=
070ffd738 00000000ffffff00 ffff9b4f67374080
Dec 23 05:34:13 heisenberg kernel: [41569.318059]  ffff9b4f67374080 ffff9b4=
f9837f840 ffffffff8bdeb6d1 ffff9b5070ffd6d0
Dec 23 05:34:13 heisenberg kernel: [41569.318063] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.318068]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.318097]  [<ffffffffc04da6b5>] ? b=
trfs_tree_read_lock+0xd5/0x120 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318101]  [<ffffffff8b8bce80>] ? w=
ake_atomic_t_function+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.318124]  [<ffffffffc046ff8f>] ? b=
trfs_read_lock_root_node+0x2f/0x40 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318146]  [<ffffffffc0474fa6>] ? b=
trfs_search_slot+0x756/0x9f0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318172]  [<ffffffffc049df80>] ? d=
o_async_commit+0x40/0x40 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318176]  [<ffffffff8b9e1482>] ? k=
mem_cache_alloc+0x122/0x530
Dec 23 05:34:13 heisenberg kernel: [41569.318202]  [<ffffffffc04915ba>] ? b=
trfs_lookup_inode+0x3a/0xc0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318228]  [<ffffffffc04a9e2e>] ? b=
trfs_iget+0xfe/0x6e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318257]  [<ffffffffc04e5ac7>] ? _=
_lookup_free_space_inode+0x107/0x160 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318282]  [<ffffffffc04e749c>] ? l=
ookup_free_space_inode+0x5c/0xd0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318308]  [<ffffffffc04e8aeb>] ? l=
oad_free_space_cache+0x8b/0x190 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318331]  [<ffffffffc047b1e5>] ? c=
ache_block_group+0x1c5/0x3c0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318335]  [<ffffffff8b8bce80>] ? w=
ake_atomic_t_function+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.318360]  [<ffffffffc04896dd>] ? f=
ind_free_extent+0x73d/0xfe0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318384]  [<ffffffffc048a01c>] ? b=
trfs_reserve_extent+0x9c/0x200 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318409]  [<ffffffffc04a419d>] ? c=
ow_file_range.isra.58+0x15d/0x4e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318434]  [<ffffffffc04a5a30>] ? s=
ubmit_compressed_extents+0x550/0x550 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318457]  [<ffffffffc04a56c8>] ? s=
ubmit_compressed_extents+0x1e8/0x550 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318486]  [<ffffffffc04d0a05>] ? b=
trfs_scrubparity_helper+0x225/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318509]  [<ffffffffc04a5a30>] ? s=
ubmit_compressed_extents+0x550/0x550 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318536]  [<ffffffffc04d09e1>] ? b=
trfs_scrubparity_helper+0x201/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318540]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.318543]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.318546]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.318550]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.318554]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.318558]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.318562] INFO: task kworker/u16:4:=
31757 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.318564]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.318566] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.318568] kworker/u16:4   D ffff9b5=
25e298180     0 31757      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.318598] Workqueue: btrfs-endio-wr=
ite btrfs_endio_write_helper [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318601]  ffff9b509b2b7080 ffff9b5=
24be59040 0000000000000000 ffff9b51a22d7608
Dec 23 05:34:13 heisenberg kernel: [41569.318605]  ffff9b51a22d8000 ffff9b5=
070ffd738 00000000ffffff00 ffff9b509b2b7080
Dec 23 05:34:13 heisenberg kernel: [41569.318609]  ffff9b509b2b7080 ffff9b5=
1a22d7620 ffffffff8bdeb6d1 ffff9b5070ffd6d0
Dec 23 05:34:13 heisenberg kernel: [41569.318613] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.318618]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.318645]  [<ffffffffc04da6b5>] ? b=
trfs_tree_read_lock+0xd5/0x120 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318649]  [<ffffffff8b8bce80>] ? w=
ake_atomic_t_function+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.318672]  [<ffffffffc046ff8f>] ? b=
trfs_read_lock_root_node+0x2f/0x40 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318694]  [<ffffffffc0474fa6>] ? b=
trfs_search_slot+0x756/0x9f0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318698]  [<ffffffff8b9e1482>] ? k=
mem_cache_alloc+0x122/0x530
Dec 23 05:34:13 heisenberg kernel: [41569.318725]  [<ffffffffc04915ba>] ? b=
trfs_lookup_inode+0x3a/0xc0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318751]  [<ffffffffc04a9e2e>] ? b=
trfs_iget+0xfe/0x6e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318778]  [<ffffffffc04e5ac7>] ? _=
_lookup_free_space_inode+0x107/0x160 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318803]  [<ffffffffc04e749c>] ? l=
ookup_free_space_inode+0x5c/0xd0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318829]  [<ffffffffc04e8aeb>] ? l=
oad_free_space_cache+0x8b/0x190 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318851]  [<ffffffffc047b1e5>] ? c=
ache_block_group+0x1c5/0x3c0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318855]  [<ffffffff8b8bce80>] ? w=
ake_atomic_t_function+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.318880]  [<ffffffffc04896dd>] ? f=
ind_free_extent+0x73d/0xfe0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318905]  [<ffffffffc048a01c>] ? b=
trfs_reserve_extent+0x9c/0x200 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318928]  [<ffffffffc048a298>] ? b=
trfs_alloc_tree_block+0x118/0x4e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318950]  [<ffffffffc0470939>] ? _=
_btrfs_cow_block+0x149/0x5b0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318972]  [<ffffffffc0470f23>] ? b=
trfs_cow_block+0x103/0x1e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.318994]  [<ffffffffc0474a53>] ? b=
trfs_search_slot+0x203/0x9f0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319019]  [<ffffffffc048ed1e>] ? b=
trfs_lookup_csum+0x4e/0x150 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319043]  [<ffffffffc0490316>] ? b=
trfs_csum_file_blocks+0x156/0x610 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319069]  [<ffffffffc049f5f6>] ? a=
dd_pending_csums.isra.43+0x46/0x70 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319094]  [<ffffffffc04a6af2>] ? b=
trfs_finish_ordered_io+0x342/0x680 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319122]  [<ffffffffc04d08b1>] ? b=
trfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319126]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.319129]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.319132]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.319136]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.319141]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.319145]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.319160] INFO: task kworker/u16:0:=
2042 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.319162]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.319164] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.319166] kworker/u16:0   D ffff9b5=
25e318180     0  2042      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.319197] Workqueue: btrfs-endio-wr=
ite btrfs_endio_write_helper [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319200]  ffff9b5067742100 ffff9b5=
24be5b0c0 ffff9b4f4684c180 ffff9b4f7822fc10
Dec 23 05:34:13 heisenberg kernel: [41569.319204]  ffff9b4f78230000 ffff9b4=
f7822fc88 ffff9b4e50a7a7a0 ffff9b5067742100
Dec 23 05:34:13 heisenberg kernel: [41569.319208]  0000000000000020 ffff9b5=
0ef41c000 ffffffff8bdeb6d1 ffff9b4e50a7a7a8
Dec 23 05:34:13 heisenberg kernel: [41569.319213] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.319218]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.319223]  [<ffffffff8bdeeb65>] ? s=
chedule_timeout+0x235/0x3f0
Dec 23 05:34:13 heisenberg kernel: [41569.319228]  [<ffffffff8b8a4720>] ? c=
heck_preempt_curr+0x50/0x90
Dec 23 05:34:13 heisenberg kernel: [41569.319232]  [<ffffffff8b8a4774>] ? t=
twu_do_wakeup+0x14/0xe0
Dec 23 05:34:13 heisenberg kernel: [41569.319237]  [<ffffffff8b8a5303>] ? t=
ry_to_wake_up+0x53/0x3a0
Dec 23 05:34:13 heisenberg kernel: [41569.319241]  [<ffffffff8bdec111>] ? w=
ait_for_completion+0xf1/0x130
Dec 23 05:34:13 heisenberg kernel: [41569.319246]  [<ffffffff8b8a56d0>] ? w=
ake_up_q+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.319270]  [<ffffffffc04802f8>] ? b=
trfs_async_run_delayed_refs+0x128/0x150 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319295]  [<ffffffffc049d98f>] ? _=
_btrfs_end_transaction+0x1ff/0x340 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319320]  [<ffffffffc04a6911>] ? b=
trfs_finish_ordered_io+0x161/0x680 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319347]  [<ffffffffc04d08b1>] ? b=
trfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319351]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.319354]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.319357]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.319361]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.319366]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.319370]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.319374] INFO: task kworker/u16:5:=
2064 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.319376]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.319378] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.319379] kworker/u16:5   D ffff9b5=
25e398180     0  2064      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.319410] Workqueue: btrfs-endio-wr=
ite btrfs_endio_write_helper [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319413]  ffff9b50f5af60c0 ffff9b5=
24be65140 ffff9b4fd6ba3080 ffff9b4fba913c10
Dec 23 05:34:13 heisenberg kernel: [41569.319417]  ffff9b4fba914000 ffff9b4=
fba913c88 ffff9b4e4c8f4020 ffff9b50f5af60c0
Dec 23 05:34:13 heisenberg kernel: [41569.319421]  0000000000000020 ffff9b5=
0ef41c000 ffffffff8bdeb6d1 ffff9b4e4c8f4028
Dec 23 05:34:13 heisenberg kernel: [41569.319425] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.319430]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.319436]  [<ffffffff8bdeeb65>] ? s=
chedule_timeout+0x235/0x3f0
Dec 23 05:34:13 heisenberg kernel: [41569.319440]  [<ffffffff8b8a4720>] ? c=
heck_preempt_curr+0x50/0x90
Dec 23 05:34:13 heisenberg kernel: [41569.319444]  [<ffffffff8b8a4774>] ? t=
twu_do_wakeup+0x14/0xe0
Dec 23 05:34:13 heisenberg kernel: [41569.319448]  [<ffffffff8b8a5303>] ? t=
ry_to_wake_up+0x53/0x3a0
Dec 23 05:34:13 heisenberg kernel: [41569.319453]  [<ffffffff8bdec111>] ? w=
ait_for_completion+0xf1/0x130
Dec 23 05:34:13 heisenberg kernel: [41569.319457]  [<ffffffff8b8a56d0>] ? w=
ake_up_q+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.319482]  [<ffffffffc04802f8>] ? b=
trfs_async_run_delayed_refs+0x128/0x150 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319507]  [<ffffffffc049d98f>] ? _=
_btrfs_end_transaction+0x1ff/0x340 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319531]  [<ffffffffc04a6911>] ? b=
trfs_finish_ordered_io+0x161/0x680 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319558]  [<ffffffffc04d08b1>] ? b=
trfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319562]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.319565]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.319568]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.319572]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.319576]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.319580]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.319592] INFO: task btrfs-transact=
i:2169 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.319594]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.319595] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.319597] btrfs-transacti D ffff9b5=
25e2d8180     0  2169      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.319602]  ffff9b4ff41870c0 ffff9b5=
24be5a080 ffff9b50ef41cbf0 ffff9b50a2cb3960
Dec 23 05:34:13 heisenberg kernel: [41569.319606]  ffff9b50a2cb4000 ffff9b4=
f6dd33200 ffff9b4e8d1570c0 ffff9b50ef41c000
Dec 23 05:34:13 heisenberg kernel: [41569.319610]  ffff9b523e694c00 ffff9b5=
23e694c38 ffffffff8bdeb6d1 ffff9b4f6dd33240
Dec 23 05:34:13 heisenberg kernel: [41569.319614] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.319619]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.319644]  [<ffffffffc047b166>] ? c=
ache_block_group+0x146/0x3c0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319648]  [<ffffffff8b8bce80>] ? w=
ake_atomic_t_function+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.319674]  [<ffffffffc04896dd>] ? f=
ind_free_extent+0x73d/0xfe0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319713]  [<ffffffffc048a01c>] ? b=
trfs_reserve_extent+0x9c/0x200 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319735]  [<ffffffffc048a298>] ? b=
trfs_alloc_tree_block+0x118/0x4e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319768]  [<ffffffffc0470939>] ? _=
_btrfs_cow_block+0x149/0x5b0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319789]  [<ffffffffc0470f23>] ? b=
trfs_cow_block+0x103/0x1e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319811]  [<ffffffffc0474a53>] ? b=
trfs_search_slot+0x203/0x9f0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319837]  [<ffffffffc04915ba>] ? b=
trfs_lookup_inode+0x3a/0xc0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319861]  [<ffffffffc04a0497>] ? b=
trfs_update_inode_item+0x47/0x100 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319885]  [<ffffffffc0486924>] ? c=
ache_save_setup+0xa4/0x3a0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319908]  [<ffffffffc048aa35>] ? b=
trfs_start_dirty_block_groups+0x205/0x420 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319933]  [<ffffffffc049c8fe>] ? b=
trfs_commit_transaction+0x15e/0xa40 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319957]  [<ffffffffc049d275>] ? s=
tart_transaction+0x95/0x4b0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.319981]  [<ffffffffc0497449>] ? t=
ransaction_kthread+0x1e9/0x200 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320004]  [<ffffffffc0497260>] ? b=
trfs_cleanup_transaction+0x590/0x590 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320009]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.320014]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.320018]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.320023] INFO: task cp:2226 blocke=
d for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.320026]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.320028] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.320030] cp              D ffff9b5=
25e218180     0  2226   8015 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.320035]  ffff9b50d74e3080 fffffff=
f8c20d500 ffff9b4fd6ba3080 ffff9b51a4227c10
Dec 23 05:34:13 heisenberg kernel: [41569.320039]  ffff9b51a4228000 ffff9b5=
1a4227c88 ffff9b500b4f1320 ffff9b50d74e3080
Dec 23 05:34:13 heisenberg kernel: [41569.320043]  0000000000000020 ffff9b5=
0ef41c000 ffffffff8bdeb6d1 ffff9b500b4f1328
Dec 23 05:34:13 heisenberg kernel: [41569.320047] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.320052]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.320057]  [<ffffffff8bdeeb65>] ? s=
chedule_timeout+0x235/0x3f0
Dec 23 05:34:13 heisenberg kernel: [41569.320062]  [<ffffffff8b8a4720>] ? c=
heck_preempt_curr+0x50/0x90
Dec 23 05:34:13 heisenberg kernel: [41569.320066]  [<ffffffff8b8a4774>] ? t=
twu_do_wakeup+0x14/0xe0
Dec 23 05:34:13 heisenberg kernel: [41569.320070]  [<ffffffff8b8a5303>] ? t=
ry_to_wake_up+0x53/0x3a0
Dec 23 05:34:13 heisenberg kernel: [41569.320075]  [<ffffffff8bdec111>] ? w=
ait_for_completion+0xf1/0x130
Dec 23 05:34:13 heisenberg kernel: [41569.320079]  [<ffffffff8b8a56d0>] ? w=
ake_up_q+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.320105]  [<ffffffffc04802f8>] ? b=
trfs_async_run_delayed_refs+0x128/0x150 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320129]  [<ffffffffc049d98f>] ? _=
_btrfs_end_transaction+0x1ff/0x340 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320153]  [<ffffffffc04a386b>] ? b=
trfs_dirty_inode+0x5b/0xc0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320158]  [<ffffffff8ba1fa62>] ? s=
etattr_copy+0x82/0x100
Dec 23 05:34:13 heisenberg kernel: [41569.320182]  [<ffffffffc04a92fc>] ? b=
trfs_setattr+0x9c/0x340 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320187]  [<ffffffff8ba1ffa9>] ? n=
otify_change+0x2e9/0x430
Dec 23 05:34:13 heisenberg kernel: [41569.320191]  [<ffffffff8ba36044>] ? u=
times_common+0xd4/0x1b0
Dec 23 05:34:13 heisenberg kernel: [41569.320195]  [<ffffffff8ba361f9>] ? d=
o_utimes+0xd9/0x150
Dec 23 05:34:13 heisenberg kernel: [41569.320199]  [<ffffffff8ba36367>] ? S=
yS_utimensat+0x67/0xa0
Dec 23 05:34:13 heisenberg kernel: [41569.320203]  [<ffffffff8bdefa76>] ? s=
ystem_call_fast_compare_end+0xc/0x96
Dec 23 05:34:13 heisenberg kernel: [41569.320207] INFO: task kworker/u16:6:=
2228 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.320209]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.320211] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.320213] kworker/u16:6   D ffff9b5=
25e2d8180     0  2228      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.320243] Workqueue: btrfs-endio-wr=
ite btrfs_endio_write_helper [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320245]  ffff9b50a0f99080 ffff9b5=
24be5a080 ffff9b4fd6ba3080 ffff9b5168aebc10
Dec 23 05:34:13 heisenberg kernel: [41569.320250]  ffff9b5168aec000 ffff9b5=
168aebc88 ffff9b523e511c20 ffff9b50a0f99080
Dec 23 05:34:13 heisenberg kernel: [41569.320254]  0000000000000020 ffff9b5=
0ef41c000 ffffffff8bdeb6d1 ffff9b523e511c28
Dec 23 05:34:13 heisenberg kernel: [41569.320258] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.320263]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.320268]  [<ffffffff8bdeeb65>] ? s=
chedule_timeout+0x235/0x3f0
Dec 23 05:34:13 heisenberg kernel: [41569.320272]  [<ffffffff8b8a4720>] ? c=
heck_preempt_curr+0x50/0x90
Dec 23 05:34:13 heisenberg kernel: [41569.320276]  [<ffffffff8b8a4774>] ? t=
twu_do_wakeup+0x14/0xe0
Dec 23 05:34:13 heisenberg kernel: [41569.320281]  [<ffffffff8b8a5303>] ? t=
ry_to_wake_up+0x53/0x3a0
Dec 23 05:34:13 heisenberg kernel: [41569.320286]  [<ffffffff8bdec111>] ? w=
ait_for_completion+0xf1/0x130
Dec 23 05:34:13 heisenberg kernel: [41569.320290]  [<ffffffff8b8a56d0>] ? w=
ake_up_q+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.320315]  [<ffffffffc04802f8>] ? b=
trfs_async_run_delayed_refs+0x128/0x150 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320339]  [<ffffffffc049d98f>] ? _=
_btrfs_end_transaction+0x1ff/0x340 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320362]  [<ffffffffc04a6911>] ? b=
trfs_finish_ordered_io+0x161/0x680 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320390]  [<ffffffffc04d08b1>] ? b=
trfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320393]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.320397]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.320400]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.320404]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.320408]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.320412]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190
Dec 23 05:34:13 heisenberg kernel: [41569.320415] INFO: task kworker/u16:7:=
2229 blocked for more than 120 seconds.
Dec 23 05:34:13 heisenberg kernel: [41569.320418]       Not tainted 4.8.0-2=
-amd64 #1
Dec 23 05:34:13 heisenberg kernel: [41569.320419] "echo 0 > /proc/sys/kerne=
l/hung_task_timeout_secs" disables this message.
Dec 23 05:34:13 heisenberg kernel: [41569.320421] kworker/u16:7   D ffff9b5=
25e2d8180     0  2229      2 0x00000000
Dec 23 05:34:13 heisenberg kernel: [41569.320452] Workqueue: btrfs-extent-r=
efs btrfs_extent_refs_helper [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320455]  ffff9b514256d0c0 ffff9b5=
24be5a080 ffff9b50ef41cbf0 ffff9b4faf4e7760
Dec 23 05:34:13 heisenberg kernel: [41569.320459]  ffff9b4faf4e8000 ffff9b4=
f6dd33200 ffff9b4e8d157900 ffff9b50ef41c000
Dec 23 05:34:13 heisenberg kernel: [41569.320463]  ffff9b523e694c00 ffff9b5=
23e694c38 ffffffff8bdeb6d1 ffff9b4f6dd33240
Dec 23 05:34:13 heisenberg kernel: [41569.320467] Call Trace:
Dec 23 05:34:13 heisenberg kernel: [41569.320473]  [<ffffffff8bdeb6d1>] ? s=
chedule+0x31/0x80
Dec 23 05:34:13 heisenberg kernel: [41569.320496]  [<ffffffffc047b166>] ? c=
ache_block_group+0x146/0x3c0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320500]  [<ffffffff8b8bce80>] ? w=
ake_atomic_t_function+0x60/0x60
Dec 23 05:34:13 heisenberg kernel: [41569.320525]  [<ffffffffc04896dd>] ? f=
ind_free_extent+0x73d/0xfe0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320549]  [<ffffffffc048a01c>] ? b=
trfs_reserve_extent+0x9c/0x200 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320573]  [<ffffffffc048a298>] ? b=
trfs_alloc_tree_block+0x118/0x4e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320595]  [<ffffffffc0470939>] ? _=
_btrfs_cow_block+0x149/0x5b0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320617]  [<ffffffffc0470f23>] ? b=
trfs_cow_block+0x103/0x1e0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320639]  [<ffffffffc0474a53>] ? b=
trfs_search_slot+0x203/0x9f0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320662]  [<ffffffffc047c43a>] ? l=
ookup_inline_extent_backref+0x10a/0x610 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320690]  [<ffffffffc04bcbd9>] ? s=
et_extent_bit+0x29/0x30 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320694]  [<ffffffff8b9e1482>] ? k=
mem_cache_alloc+0x122/0x530
Dec 23 05:34:13 heisenberg kernel: [41569.320717]  [<ffffffffc047dad9>] ? _=
_btrfs_free_extent.isra.71+0x119/0xd60 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320745]  [<ffffffffc04edab9>] ? b=
trfs_merge_delayed_refs+0x69/0x580 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320771]  [<ffffffffc04828ac>] ? _=
_btrfs_run_delayed_refs+0xadc/0x1240 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320775]  [<ffffffff8b9e1482>] ? k=
mem_cache_alloc+0x122/0x530
Dec 23 05:34:13 heisenberg kernel: [41569.320780]  [<ffffffff8b8a4774>] ? t=
twu_do_wakeup+0x14/0xe0
Dec 23 05:34:13 heisenberg kernel: [41569.320803]  [<ffffffffc0485eee>] ? b=
trfs_run_delayed_refs+0x8e/0x2a0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320826]  [<ffffffffc0486189>] ? d=
elayed_ref_async_start+0x89/0xa0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320853]  [<ffffffffc04d08b1>] ? b=
trfs_scrubparity_helper+0xd1/0x2d0 [btrfs]
Dec 23 05:34:13 heisenberg kernel: [41569.320856]  [<ffffffff8b894e00>] ? p=
rocess_one_work+0x160/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.320860]  [<ffffffff8b8950fd>] ? w=
orker_thread+0x4d/0x480
Dec 23 05:34:13 heisenberg kernel: [41569.320863]  [<ffffffff8b8950b0>] ? p=
rocess_one_work+0x410/0x410
Dec 23 05:34:13 heisenberg kernel: [41569.320867]  [<ffffffff8b89aecd>] ? k=
thread+0xcd/0xf0
Dec 23 05:34:13 heisenberg kernel: [41569.320871]  [<ffffffff8bdefcaf>] ? r=
et_from_fork+0x1f/0x40
Dec 23 05:34:13 heisenberg kernel: [41569.320875]  [<ffffffff8b89ae00>] ? k=
thread_create_on_node+0x190/0x190


And I also had a number of kworker threads in D state, as well as the
cp, a sync and remount,ro that I've tried.

The copy-source disk just idled, the target was doing something but
this was rather just disk internal (it's a SMR HDD and likely just
reshuffled data).

Interestingly, I could still cat files from both filesystems.



Disconnected the anyway unmounted/unused sdc.

Dec 23 05:36:53 heisenberg kernel: [41729.248524] usb 4-2.4: USB disconnect=
, device number 7
Dec 23 05:36:53 heisenberg kernel: [41729.249733] sd 7:0:0:0: [sdc] Synchro=
nizing SCSI cache
Dec 23 05:36:53 heisenberg kernel: [41729.489007] sd 7:0:0:0: [sdc] Synchro=
nize Cache(10) failed: Result: hostbyte=3DDID_ERROR driverbyte=3DDRIVER_OK



When things didn't seem=C2=A0to recover, I simply disconnected the source
disk (sdc) hoping that the kernel would notice and abort all
transaction, ending the deadlock:

Dec 23 05:40:05 heisenberg kernel: [41921.444610] usb 1-1.2: USB disconnect=
, device number 30
Dec 23 05:40:05 heisenberg kernel: [41921.509155] sd 8:0:0:0: [sdd] Synchro=
nizing SCSI cache
Dec 23 05:40:05 heisenberg kernel: [41921.509190] sd 8:0:0:0: [sdd] Synchro=
nize Cache(10) failed: Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVE=
R_OK

Didn't work... though.
Then I tried to a halt(1) (sdb still connected), but that also stopped
without actually unmounting and halting the system.


After a reboot, I made btrfs check on sdb,... no errors...
After mounting it, the files from the already copied ~800MB were gone
(so I guess no new generation was committed)... and it seems so far
that the btrfs is fine otherwise.



Not sure if the above call traces help you to identify a possible bug,
wanted to report it though.


Cheers,
Chris.
--=-bMSsMkvxmonlsNNKTVGf
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEmow
ggXiMIIDyqADAgECAhBctkhuRwyYxn/2gNtkSuKNMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0
aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xNTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDuD1CMlQkjhKz1UGqP1jeiTiH9MgllRz6vOPrVG/eE0H/J4QQLV/PeL8RT
4xc44bEzsoJu0IhwnEchb+TxE/qw88w7hxODuw3N8Faxix6a1jp83+RWvZHZf78+O+3GYBpekZfT
Oe9A/FoTXbcgwZfLTMQodn+ckNnX31M/1M2f2/7VA7QBlvihontyHQOlIlryQXnGI0UMCD21oopK
tW48ckv0wUVg8irBKGMeD65gTON/Fsw/ZBbBqadoD1jt85FIM1ql24WUBEBwO1d0ykCKOIbgcqes
3fbcjQpruUNMBbIu1MMIRMqwjx/M7IvSKcS7VYRWl0/K2byzWvBAHh/1AgMBAAGjggFkMIIBYDAO
BgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQI
MAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2ZzY2Eu
Y3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29t
MDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0O
BBYEFJmXqxg1OotZRUOYsnJxyPT7Cc8WMB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7y
MD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNv
bS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggIBAJlBQQTO9iT1TjA0eEO7V/1AbBvMAfibjAgofxmJ
01jBmHKg0pbTjWInTTYoxb3LBgz3mfjvvS1PjnIfb29MyVm0G/PSHjgq7Ews1dEJMPC9XTuxPf2c
+MWLkynBlotW542JprW+iTWfZafyUtzIKW1hk0YASJ8zSSj8D++9yR+0UhkbvlECJkdi1+et0EaI
7HIX6ccj1rfcFFflWX/fPT64dn9jpg9s0nuJug4WsVkEK236WndZoMHrZmgF7CIyZ3T0muqYwkAS
DDcRt9A21o/Mc+D8Q6GVmKRGB3gEKvOtsioHZEqJv6CdAm3a6gloo5pX3RL1eCzc8Lzfs4T0ISZj
r8xNMbTGlsuHaFH+stDewKsfnpo4N64OtAGrzmVfFFsMIRENRHsVlSEe/6LVpBpjn00+7bqEN3qe
qSxIOraYJ12mJ08G4YnP2U1fadHIaS50O5ZXqAivoBl9pi/6CBNc5wIMlkXMyFZ0sLsI+9ErFDu9
OJhX7iWCo69X0ydlzXj08+2K1PKyr+g6/vTPHur63JotNrhyoWEJyWEjBLA4QmJXfGpB5u+bCwNf
sFpcYAlkiFt1Rs2vemgSBy3q4DHDbPKvr1YImZNRSHP+TX9NP94JRkmqcyD/qaN7u2JV1pRAlwG0
npyrn6ZQM1QHV+iFbwQ4VqLMWk//QVo/rZy1MIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwcz1F+2kRA
DzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEp
MCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0
Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIzNlowejEL
MAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAfBgNVBAMM
GENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9Ac2NpZW50
aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqeP2vwE3Cp
YosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjrFe0zmZWZ
0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ0+c1NYFQ
T6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJnmiiId9e
0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7r2NVLkpo
Gbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA0BtydQC0
mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS7XEGOuCU
09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6a1rkhJl7
1rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8bxPJiX2/
VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/MAsGA1Ud
DwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAdBgNVHQ4E
FgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI9PsJzxYw
bwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wOQYI
KwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQyLmNydDA4
BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50Mi5jcmww
IAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcBAgQwLDAq
BggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3DQEBCwUA
A4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7SG3MQkyO
kvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndjZIHMfSkn
hdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9RS51K1gt
H4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11Yeq6UTW/
JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMIIGPjCCBSagAwIBAgIQPZ6tDP/RHLwc
z1F+2kRADzANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20g
THRkLjEpMCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMT
GlN0YXJ0Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMDIzNloXDTE4MDEwMjAyMDIz
NlowejELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8GA1UEBwwITcO8bmNoZW4xITAf
BgNVBAMMGENocmlzdG9waCBBbnRvbiBNaXR0ZXJlcjEkMCIGCSqGSIb3DQEJARYVY2FsZXN0eW9A
c2NpZW50aWEubmV0MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsoxs789VtR81tlqe
P2vwE3CpYosZYRfrovj+Wb91paoV5OQcFuXA7yONnLsWxOnJ3AGgy1/wG79Ko+yHSmF2K88pEWjr
Fe0zmZWZ0b2OtMoKLEjxz7Nz2N7/lmgss8XinJ083LwLKSe4f+JLjnF5hX/g6wG4NkFXVOIf2YFZ
0+c1NYFQT6Vy42EWdk+JLDoXjyd2hEperLCz9rQr2k3wh0cn8R1FDUGerBGpMnvyKV6JXj5vZsqJ
nmiiId9e0IdBj4Wcs3hT2usk6dJYwHrZ8b7Fkv6BRq90DUI7i8+ukTdp5hnAb8TPSbe1JS4h3Jc7
r2NVLkpoGbuw98er9s2PEAvpECD3toO3ojBevL56vEDbGa5tXpvvcWCz6t3QyEKJ2E54hWw1fbUA
0BtydQC0mhKBtrENVnnCDrSgiyBMnd8y+kw6iPKeJEjNObGubc4BZp47zPn/ZiDBaHue6S0MXsoS
7XEGOuCU09S/8kD8wTecBg+KdlLSNkLm+xqx6Cy7zwcj3IuQv0PeWi4kfEkAJfl8IeAP/4049iA6
a1rkhJl71rDjpEGBCG+i9BAgBeNdHLtQ7bugdvU+GfHjFXEU1emUk91E2liML8kpCvhUAXcLhhL8
bxPJiX2/VQ2esrpQVO56OzpivNauonLaWmHEKOSfPC3s5AKMytMTiUiszEUCAwEAAaOCAcMwggG/
MAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAd
BgNVHQ4EFgQUwRklxF1ZV2ooSMkFwLiK13apkK0wHwYDVR0jBBgwFoAUmZerGDU6i1lFQ5iycnHI
9PsJzxYwbwYIKwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5j
b20wOQYIKwYBBQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQy
LmNydDA4BgNVHR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50
Mi5jcmwwIAYDVR0RBBkwF4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0MCMGA1UdEgQcMBqGGGh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcB
AgQwLDAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3
DQEBCwUAA4IBAQBb8EIsoUN/tgUgQqrNXNtlksPep84kx5yRBgr71uf3ITLddGtzfDBj6KdZUoy7
SG3MQkyOkvYmXBClj23rv8Iol48/3oi9XWZw5EV3uHrRse1TzQgMPZE0hZsDgkqXVoxMQfk55ndj
ZIHMfSknhdnqSP5zZ4TCmDEKLppPMDcQSSrjilnbthpxlIJzeGeEFtrh6ssh/oF6mUaEGFcd8kx9
RS51K1gtH4J36y4E6pKB7EdxG2+0yVzAIta8dkD/BiMCKRWhp1EmzQ2uIh2nX5y8t4e2xHHuiy11
Yeq6UTW/JmfxF4xcbkNK/rv9ISBg9K+mZtg2QXr+P/CJBtej2RLUMYIEfjCCBHoCAQEwgYkwdTEL
MAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENl
cnRpZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAyIENsaWVudCBD
QQIQPZ6tDP/RHLwcz1F+2kRADzANBglghkgBZQMEAgMFAKCCAcUwGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYxMjIzMDYyNjU4WjBPBgkqhkiG9w0BCQQxQgRAJcGM
H0u7EeoRBsI/U7rIZKri+gG9YkwZEj5RlkukyzkqjD9mjBsbSXLlYwMsG3qBwp3dxVxucwNXjU18
G6i5lTCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UE
AxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wgZwGCyqGSIb3
DQEJEAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYD
VQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20g
Q2xhc3MgMiBDbGllbnQgQ0ECED2erQz/0Ry8HM9RftpEQA8wDQYJKoZIhvcNAQEBBQAEggIALSJE
N3jTZowbZh/QIKDtb31sVqwrS5YvGoA6WepeGGiexgLo+BKSS7Sx8A0klON7PJlqjuc1KHaeFYgY
GR53wtZfgAp7IPNERx68j6PFFJDMe5WNHNs+kP+Ra/+jB5qI5yWbGD0vgloX/QUnuwE7UFDULm45
YIYcucq4cZ9zi3TSiIWwuhALYrWYlcPxACSWsEDRJPvYo5KOEt2A/4FKAz23aHRDhXYR0yE7wWJd
czdZvmRof+fV6QAPgXo/Nrx6CSLXgLzMZzhBArkf35ByVa/GyQBbEvJQS/RfmgDKLChjkFzCONmU
EIBHC6maKzVBp1cRFi2Q+AdjZ3Xtt4GAvlayMkxfRMqFGkjPjGWRYtk1aWg6kEvIX/jMJAXTbO1O
1uAZez3qvfxn4Aa31bsiNI8/Nzp4fwt1gSF1M+IAnOHUiNxwkynCbobknM9AjVV6/AgjlfMok2ME
gkHzvMQZV+hvGZanM/QZN1nAhkydQmslAaccOdFpbyBCsOnG4PcOvJPCyETq9rQcFMQGuacKavxQ
/cx2OLs/m2pjCtV4TvIpjlgJXkcXvcEKI5eRCNnMDfZGmt6eNN66Xj3ViBj8EpTZVcbyqmEnWy2D
zmARjxDpnHc59/9Yl+H74rkFzN2Tic4zO8/TRlHqcQxsEZT+BSTci/OAuXwUnddS49UcnPIAAAAA
AAA=


--=-bMSsMkvxmonlsNNKTVGf--


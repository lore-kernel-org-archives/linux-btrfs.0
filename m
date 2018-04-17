Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wecheer.com ([54.200.0.65]:39557 "EHLO wecheer.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755434AbeDQQI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 12:08:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by wecheer.com (Postfix) with ESMTP id A631F435B9
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 16:08:25 +0000 (UTC)
Received: from wecheer.com ([127.0.0.1])
        by localhost (wecheer.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ECUpjIMfa3Km for <linux-btrfs@vger.kernel.org>;
        Tue, 17 Apr 2018 16:08:23 +0000 (UTC)
Received: from matthewlai-macbookpro1.roam.corp.google.com (unknown [104.132.45.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: m)
        by wecheer.com (Postfix) with ESMTPSA id 27241435B5
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Apr 2018 16:08:21 +0000 (UTC)
Subject: Filesystem full with unallocated space?
From: Matthew Lai <m@matthewlai.ca>
To: linux-btrfs@vger.kernel.org
References: <89d90bb8-dbe3-1789-60eb-a29f9d1e3a64@matthewlai.ca>
Message-ID: <b7c2b3f9-89cf-9ae4-7d73-cfdd274f56cd@matthewlai.ca>
Date: Tue, 17 Apr 2018 17:08:19 +0100
MIME-Version: 1.0
In-Reply-To: <89d90bb8-dbe3-1789-60eb-a29f9d1e3a64@matthewlai.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I am getting ENOSPC on my root filesystem with plenty of unallocated 
space according to "fi usage". Any idea why that may be? This is a root 
partition for Debian Stable. Not doing anything unusual that I'm aware 
of. No snapshots.

Thanks!

Matthew

uname -a:
Linux bigfoot 4.9.0-4-amd64 #1 SMP Debian 4.9.65-3+deb9u1 (2017-12-23) 
x86_64 GNU/Linux

btrfs --version:
btrfs-progs v4.7.3

btrfs fi show:
Label: none  uuid: 2364c63f-e20c-410f-90b4-05f722ee1c77
     Total devices 1 FS bytes used 176.27GiB
     devid    1 size 246.33GiB used 185.01GiB path /dev/sda2

btrfs fi df /:
Data, single: total=183.00GiB, used=175.78GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=2.01GiB, used=504.81MiB
GlobalReserve, single: total=211.39MiB, used=0.00B

dmesg (I had tried balancing - "balance start -dusage=95 /" completed 
successfully and didn't help):
62411.020348] usb 2-1.2.4: USB disconnect, device number 12
[62656.848845] usb 2-1.2: new high-speed USB device number 14 using 
ehci-pci
[62656.958066] usb 2-1.2: New USB device found, idVendor=0451, 
idProduct=8044
[62656.958071] usb 2-1.2: New USB device strings: Mfr=0, Product=0, 
SerialNumber=1
[62656.958073] usb 2-1.2: SerialNumber: A80108717AA4
[62656.958692] hub 2-1.2:1.0: USB hub found
[62656.958828] hub 2-1.2:1.0: 4 ports detected
[62657.244860] usb 2-1.2.2: new high-speed USB device number 15 using 
ehci-pci
[62657.360966] usb 2-1.2.2: New USB device found, idVendor=2109, 
idProduct=2813
[62657.360970] usb 2-1.2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[62657.360972] usb 2-1.2.2: Product: USB2.0 Hub
[62657.360974] usb 2-1.2.2: Manufacturer: VIA Labs, Inc.
[62657.361955] hub 2-1.2.2:1.0: USB hub found
[62657.362734] hub 2-1.2.2:1.0: 4 ports detected
[62657.456890] usb 2-1.2.3: new high-speed USB device number 16 using 
ehci-pci
[62657.692872] usb 2-1.2.2.1: new full-speed USB device number 17 using 
ehci-pci
[62657.815204] usb 2-1.2.2.1: New USB device found, idVendor=1050, 
idProduct=0211
[62657.815209] usb 2-1.2.2.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[62657.815227] usb 2-1.2.2.1: Product: Yubico WinUSB Gnubby (gnubby1)
[62657.815228] usb 2-1.2.2.1: Manufacturer: Yubico
[62657.908881] usb 2-1.2.2.2: new full-speed USB device number 18 using 
ehci-pci
[62658.032771] usb 2-1.2.2.2: New USB device found, idVendor=046d, 
idProduct=c52b
[62658.032775] usb 2-1.2.2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[62658.032778] usb 2-1.2.2.2: Product: USB Receiver
[62658.032780] usb 2-1.2.2.2: Manufacturer: Logitech
[62658.040715] logitech-djreceiver 0003:046D:C52B.000D: hiddev0,hidraw4: 
USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:1d.0-1.2.2.2/input2
[62658.188708] input: Logitech M705 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.2/2-1.2.2.2:1.2/0003:046D:C52B.000D/0003:046D:101B.000E/input/input15
[62658.189329] logitech-hidpp-device 0003:046D:101B.000E: input,hidraw5: 
USB HID v1.11 Mouse [Logitech M705] on usb-0000:00:1d.0-1.2.2.2:2
[62658.248907] usb 2-1.2.2.3: new full-speed USB device number 19 using 
ehci-pci
[62658.370856] usb 2-1.2.2.3: New USB device found, idVendor=2a03, 
idProduct=0042
[62658.370859] usb 2-1.2.2.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=220
[62658.370861] usb 2-1.2.2.3: Product: Arduino Mega
[62658.370862] usb 2-1.2.2.3: Manufacturer: Arduino Srl
[62658.370863] usb 2-1.2.2.3: SerialNumber: 75533353437351C07182
[62658.371497] cdc_acm 2-1.2.2.3:1.0: ttyACM0: USB ACM device
[62659.062915] input: Logitech K270 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.2/2-1.2.2.2:1.2/0003:046D:C52B.000D/0003:046D:4003.000F/input/input16
[62659.063686] logitech-hidpp-device 0003:046D:4003.000F: input,hidraw6: 
USB HID v1.11 Keyboard [Logitech K270] on usb-0000:00:1d.0-1.2.2.2:3
[62659.807183] usb 2-1.2.3: New USB device found, idVendor=046d, 
idProduct=082d
[62659.807188] usb 2-1.2.3: New USB device strings: Mfr=0, Product=2, 
SerialNumber=1
[62659.807190] usb 2-1.2.3: Product: HD Pro Webcam C920
[62659.807192] usb 2-1.2.3: SerialNumber: C034F41F
[62659.807647] uvcvideo: Found UVC 1.00 device HD Pro Webcam C920 
(046d:082d)
[62659.808304] uvcvideo 2-1.2.3:1.0: Entity type for entity Processing 3 
was not initialized!
[62659.808308] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 6 
was not initialized!
[62659.808311] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 12 
was not initialized!
[62659.808314] uvcvideo 2-1.2.3:1.0: Entity type for entity Camera 1 was 
not initialized!
[62659.808316] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 8 
was not initialized!
[62659.808319] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 9 
was not initialized!
[62659.808321] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 10 
was not initialized!
[62659.808324] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 11 
was not initialized!
[62659.808551] input: HD Pro Webcam C920 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.0/input/input17
[62660.065016] usb 2-1.2.4: new full-speed USB device number 20 using 
ehci-pci
[62660.420784] usb 2-1.2.4: New USB device found, idVendor=413c, 
idProduct=a503
[62660.420789] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[62660.420792] usb 2-1.2.4: Product: Dell AC511 USB SoundBar
[62660.420794] usb 2-1.2.4: Manufacturer: Dell
[62660.468723] input: Dell Dell AC511 USB SoundBar as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.4/2-1.2.4:1.3/0003:413C:A503.0010/input/input18
[62660.525388] hid-generic 0003:413C:A503.0010: input,hidraw7: USB HID 
v1.00 Device [Dell Dell AC511 USB SoundBar] on 
usb-0000:00:1d.0-1.2.4/input3
[63468.633701] usb 2-1.2.2.4: new high-speed USB device number 21 using 
ehci-pci
[63468.756780] usb 2-1.2.2.4: New USB device found, idVendor=0bda, 
idProduct=0109
[63468.756785] usb 2-1.2.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[63468.756787] usb 2-1.2.2.4: Product: USB2.0-CRW
[63468.756790] usb 2-1.2.2.4: Manufacturer: Generic
[63468.756792] usb 2-1.2.2.4: SerialNumber: 20090815198100000
[63468.767886] usb-storage 2-1.2.2.4:1.0: USB Mass Storage device detected
[63468.768497] scsi host7: usb-storage 2-1.2.2.4:1.0
[63468.945729] usb 2-1.2.3: reset high-speed USB device number 16 using 
ehci-pci
[63469.799162] scsi 7:0:0:0: Direct-Access     Generic- SD/MMC           
1.00 PQ: 0 ANSI: 0 CCS
[63469.799942] sd 7:0:0:0: Attached scsi generic sg3 type 0
[63470.593975] sd 7:0:0:0: [sdc] 250085376 512-byte logical blocks: (128 
GB/119 GiB)
[63470.595138] sd 7:0:0:0: [sdc] Write Protect is off
[63470.595143] sd 7:0:0:0: [sdc] Mode Sense: 03 00 00 00
[63470.596202] sd 7:0:0:0: [sdc] No Caching mode page found
[63470.596210] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[63470.601606]  sdc: sdc1
[63470.605301] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[63804.306391] sd 7:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[63804.306404] sd 7:0:0:0: [sdc] tag#0 Sense Key : Not Ready [current]
[63804.306407] sd 7:0:0:0: [sdc] tag#0 Add. Sense: Medium not present
[63804.306410] sd 7:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 83 00 
00 00 f0 00
[63804.306413] blk_update_request: I/O error, dev sdc, sector 33536
[63804.308143] sd 7:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[63804.308147] sd 7:0:0:0: [sdc] tag#0 Sense Key : Not Ready [current]
[63804.308149] sd 7:0:0:0: [sdc] tag#0 Add. Sense: Medium not present
[63804.308152] sd 7:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 83 f0 
00 00 10 00
[63804.308154] blk_update_request: I/O error, dev sdc, sector 33776
[63804.309234] sd 7:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[63804.309239] sd 7:0:0:0: [sdc] tag#0 Sense Key : Not Ready [current]
[63804.309244] sd 7:0:0:0: [sdc] tag#0 Add. Sense: Medium not present
[63804.309248] sd 7:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 83 00 
00 00 08 00
[63804.309251] blk_update_request: I/O error, dev sdc, sector 33536
[63804.309258] Buffer I/O error on dev sdc1, logical block 96, async 
page read
[63804.310364] sd 7:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[63804.310368] sd 7:0:0:0: [sdc] tag#0 Sense Key : Not Ready [current]
[63804.310371] sd 7:0:0:0: [sdc] tag#0 Add. Sense: Medium not present
[63804.310374] sd 7:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 90 00 
00 00 08 00
[63804.310376] blk_update_request: I/O error, dev sdc, sector 36864
[63804.311484] sd 7:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[63804.311501] sd 7:0:0:0: [sdc] tag#0 Sense Key : Not Ready [current]
[63804.311512] sd 7:0:0:0: [sdc] tag#0 Add. Sense: Medium not present
[63804.311515] sd 7:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 90 00 
00 00 08 00
[63804.311517] blk_update_request: I/O error, dev sdc, sector 36864
[63804.311520] Buffer I/O error on dev sdc1, logical block 512, async 
page read
[63813.084001] usb 2-1.2.2.4: USB disconnect, device number 21
[64015.189202] BTRFS info (device sda2): relocating block group 
192220758016 flags 1
[64015.270950] BTRFS info (device sda2): relocating block group 
191147016192 flags 1
[64015.447773] BTRFS info (device sda2): relocating block group 
188999532544 flags 1
[64015.647983] BTRFS info (device sda2): relocating block group 
180409597952 flags 1
[64015.828668] BTRFS info (device sda2): relocating block group 
178262114304 flags 1
[...]
[64364.072399] BTRFS info (device sda2): relocating block group 
31159484416 flags 1
[64364.256058] BTRFS info (device sda2): relocating block group 
4315938816 flags 1
[64364.337106] BTRFS info (device sda2): 105 enospc errors during balance
[66298.979251] usb 2-1.2.3: reset high-speed USB device number 16 using 
ehci-pci
[66341.916718] BTRFS info (device sda2): relocating block group 
195441983488 flags 1
[66342.475676] BTRFS info (device sda2): found 1282 extents
[66343.651133] BTRFS info (device sda2): found 1282 extents
[66343.680560] BTRFS info (device sda2): relocating block group 
193294499840 flags 1
[66343.947346] BTRFS info (device sda2): found 451 extents
[66344.573711] BTRFS info (device sda2): found 451 extents
[66344.596728] BTRFS info (device sda2): relocating block group 
192220758016 flags 1
[66344.866005] BTRFS info (device sda2): found 536 extents
[66345.357061] BTRFS info (device sda2): found 536 extents
[...]
[66623.150734] BTRFS info (device sda2): relocating block group 
4315938816 flags 1
[66625.418663] BTRFS info (device sda2): found 10668 extents
[66632.834573] BTRFS info (device sda2): found 10668 extents
[71376.049516] logitech-djreceiver 0003:046D:C52B.0013: hiddev0,hidraw4: 
USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:1d.0-1.2.2.2/input2
[71376.231951] input: Logitech M705 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.2/2-1.2.2.2:1.2/0003:046D:C52B.0013/0003:046D:101B.0014/input/input19
[71376.232235] logitech-hidpp-device 0003:046D:101B.0014: input,hidraw5: 
USB HID v1.11 Mouse [Logitech M705] on usb-0000:00:1d.0-1.2.2.2:2
[71376.238107] input: Logitech K270 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.2/2-1.2.2.2:1.2/0003:046D:C52B.0013/0003:046D:4003.0015/input/input20
[71376.238633] logitech-hidpp-device 0003:046D:4003.0015: input,hidraw6: 
USB HID v1.11 Keyboard [Logitech K270] on usb-0000:00:1d.0-1.2.2.2:3
[71376.258109] usb 2-1.2.2.3: new full-speed USB device number 27 using 
ehci-pci
[71376.380199] usb 2-1.2.2.3: New USB device found, idVendor=2a03, 
idProduct=0042
[71376.380204] usb 2-1.2.2.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=220
[71376.380206] usb 2-1.2.2.3: Product: Arduino Mega
[71376.380208] usb 2-1.2.2.3: Manufacturer: Arduino Srl
[71376.380210] usb 2-1.2.2.3: SerialNumber: 75533353437351C07182
[71376.380804] cdc_acm 2-1.2.2.3:1.0: ttyACM0: USB ACM device
[71377.796331] usb 2-1.2.3: New USB device found, idVendor=046d, 
idProduct=082d
[71377.796335] usb 2-1.2.3: New USB device strings: Mfr=0, Product=2, 
SerialNumber=1
[71377.796336] usb 2-1.2.3: Product: HD Pro Webcam C920
[71377.796338] usb 2-1.2.3: SerialNumber: C034F41F
[71377.796807] uvcvideo: Found UVC 1.00 device HD Pro Webcam C920 
(046d:082d)
[71377.797635] uvcvideo 2-1.2.3:1.0: Entity type for entity Processing 3 
was not initialized!
[71377.797640] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 6 
was not initialized!
[71377.797643] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 12 
was not initialized!
[71377.797646] uvcvideo 2-1.2.3:1.0: Entity type for entity Camera 1 was 
not initialized!
[71377.797649] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 8 
was not initialized!
[71377.797652] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 9 
was not initialized!
[71377.797655] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 10 
was not initialized!
[71377.797658] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 11 
was not initialized!
[71377.797900] input: HD Pro Webcam C920 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.0/input/input21
[71378.054223] usb 2-1.2.4: new full-speed USB device number 28 using 
ehci-pci
[71378.402070] usb 2-1.2.4: New USB device found, idVendor=413c, 
idProduct=a503
[71378.402075] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[71378.402078] usb 2-1.2.4: Product: Dell AC511 USB SoundBar
[71378.402081] usb 2-1.2.4: Manufacturer: Dell
[71378.449592] input: Dell Dell AC511 USB SoundBar as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.4/2-1.2.4:1.3/0003:413C:A503.0016/input/input22
[71378.506637] hid-generic 0003:413C:A503.0016: input,hidraw7: USB HID 
v1.00 Device [Dell Dell AC511 USB SoundBar] on 
usb-0000:00:1d.0-1.2.4/input3
[71392.632498] hub 2-1.2:1.0: USB hub found
[71392.632551] hub 2-1.2:1.0: 4 ports detected
[71392.919281] usb 2-1.2.2: new high-speed USB device number 30 using 
ehci-pci
[71393.031889] usb 2-1.2.2: New USB device found, idVendor=2109, 
idProduct=2813
[71393.031893] usb 2-1.2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[71393.031896] usb 2-1.2.2: Product: USB2.0 Hub
[71393.031898] usb 2-1.2.2: Manufacturer: VIA Labs, Inc.
[71393.032846] hub 2-1.2.2:1.0: USB hub found
[71393.033765] hub 2-1.2.2:1.0: 4 ports detected
[71393.131269] usb 2-1.2.3: new high-speed USB device number 31 using 
ehci-pci
[71393.371298] usb 2-1.2.2.1: new full-speed USB device number 32 using 
ehci-pci
[71393.493476] usb 2-1.2.2.1: New USB device found, idVendor=1050, 
idProduct=0211
[71393.493481] usb 2-1.2.2.1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[71393.493483] usb 2-1.2.2.1: Product: Yubico WinUSB Gnubby (gnubby1)
[71393.493486] usb 2-1.2.2.1: Manufacturer: Yubico
[71393.587314] usb 2-1.2.2.2: new full-speed USB device number 33 using 
ehci-pci
[71393.711812] usb 2-1.2.2.2: New USB device found, idVendor=046d, 
idProduct=c52b
[71393.711816] usb 2-1.2.2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[71393.711818] usb 2-1.2.2.2: Product: USB Receiver
[71393.711820] usb 2-1.2.2.2: Manufacturer: Logitech
[71393.719447] logitech-djreceiver 0003:046D:C52B.0019: hiddev0,hidraw4: 
USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:1d.0-1.2.2.2/input2
[71393.856821] input: Logitech M705 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.2/2-1.2.2.2:1.2/0003:046D:C52B.0019/0003:046D:101B.001A/input/input23
[71393.857386] logitech-hidpp-device 0003:046D:101B.001A: input,hidraw5: 
USB HID v1.11 Mouse [Logitech M705] on usb-0000:00:1d.0-1.2.2.2:2
[71393.920938] input: Logitech K270 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.2/2-1.2.2.2:1.2/0003:046D:C52B.0019/0003:046D:4003.001B/input/input24
[71393.921595] logitech-hidpp-device 0003:046D:4003.001B: input,hidraw6: 
USB HID v1.11 Keyboard [Logitech K270] on usb-0000:00:1d.0-1.2.2.2:3
[71393.935317] usb 2-1.2.2.3: new full-speed USB device number 34 using 
ehci-pci
[71394.057559] usb 2-1.2.2.3: New USB device found, idVendor=2a03, 
idProduct=0042
[71394.057563] usb 2-1.2.2.3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=220
[71394.057565] usb 2-1.2.2.3: Product: Arduino Mega
[71394.057567] usb 2-1.2.2.3: Manufacturer: Arduino Srl
[71394.057569] usb 2-1.2.2.3: SerialNumber: 75533353437351C07182
[71394.058184] cdc_acm 2-1.2.2.3:1.0: ttyACM0: USB ACM device
[71395.457644] usb 2-1.2.3: New USB device found, idVendor=046d, 
idProduct=082d
[71395.457649] usb 2-1.2.3: New USB device strings: Mfr=0, Product=2, 
SerialNumber=1
[71395.457651] usb 2-1.2.3: Product: HD Pro Webcam C920
[71395.457653] usb 2-1.2.3: SerialNumber: C034F41F
[71395.458173] uvcvideo: Found UVC 1.00 device HD Pro Webcam C920 
(046d:082d)
[71395.458905] uvcvideo 2-1.2.3:1.0: Entity type for entity Processing 3 
was not initialized!
[71395.458909] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 6 
was not initialized!
[71395.458923] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 12 
was not initialized!
[71395.458925] uvcvideo 2-1.2.3:1.0: Entity type for entity Camera 1 was 
not initialized!
[71395.458927] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 8 
was not initialized!
[71395.458929] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 9 
was not initialized!
[71395.458931] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 10 
was not initialized!
[71395.458933] uvcvideo 2-1.2.3:1.0: Entity type for entity Extension 11 
was not initialized!
[71395.459117] input: HD Pro Webcam C920 as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.3/2-1.2.3:1.0/input/input25
[71395.719490] usb 2-1.2.4: new full-speed USB device number 35 using 
ehci-pci
[71396.063188] usb 2-1.2.4: New USB device found, idVendor=413c, 
idProduct=a503
[71396.063194] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[71396.063196] usb 2-1.2.4: Product: Dell AC511 USB SoundBar
[71396.063198] usb 2-1.2.4: Manufacturer: Dell
[71396.111516] input: Dell Dell AC511 USB SoundBar as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.4/2-1.2.4:1.3/0003:413C:A503.001C/input/input26
[71396.171814] hid-generic 0003:413C:A503.001C: input,hidraw7: USB HID 
v1.00 Device [Dell Dell AC511 USB SoundBar] on 
usb-0000:00:1d.0-1.2.4/input3
[92315.300812] perf: interrupt took too long (6337 > 6327), lowering 
kernel.perf_event_max_sample_rate to 31500
[153887.149707] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[187327.910473] do_trap: 248 callbacks suppressed
[187327.910475] traps: chrome[14303] trap invalid opcode ip:56427b7f4315 
sp:7ffdb7894b80 error:0
[187327.910483]  in chrome[564277785000+5a95000]
[203071.626665] perf: interrupt took too long (7963 > 7921), lowering 
kernel.perf_event_max_sample_rate to 25000
[206658.985787] traps: chrome[30066] trap invalid opcode ip:56427b7f4315 
sp:7ffdb7894840 error:0
[206658.985795]  in chrome[564277785000+5a95000]
[231976.702684] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[232257.246359] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[232876.041511] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[233234.986638] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[236362.917134] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[236691.460083] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[252719.702862] traps: DedicatedWorker[14155] trap invalid opcode 
ip:56427b6f1612 sp:7f5aa6ef7c58 error:0
[252719.702870]  in chrome[564277785000+5a95000]
[252719.849077] traps: DedicatedWorker[14162] trap invalid opcode 
ip:56427b6f1612 sp:7f5a866f6c58 error:0
[252719.849084]  in chrome[564277785000+5a95000]
[252725.266089] traps: DedicatedWorker[14259] trap invalid opcode 
ip:56427b6f1612 sp:7f5aa594dc58 error:0
[252725.266113]  in chrome[564277785000+5a95000]
[252725.414211] traps: DedicatedWorker[14260] trap invalid opcode 
ip:56427b6f1612 sp:7f5aa514cc58 error:0
[252725.414219]  in chrome[564277785000+5a95000]
[252725.516584] traps: DedicatedWorker[14259] trap invalid opcode 
ip:56427b6f1612 sp:7f5aa594dc58 error:0
[252725.516591]  in chrome[564277785000+5a95000]
[258310.296820] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[260698.611854] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[264066.313718] usb 2-1.2.2.3: USB disconnect, device number 34
[274595.848777] usb 2-1.2.2.4: new full-speed USB device number 36 using 
ehci-pci
[274595.972870] usb 2-1.2.2.4: New USB device found, idVendor=054c, 
idProduct=0830
[274595.972874] usb 2-1.2.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[274595.972877] usb 2-1.2.2.4: Product: USB Bus-powered Device
[274595.972879] usb 2-1.2.2.4: Manufacturer: Sony
[274595.972881] usb 2-1.2.2.4: SerialNumber: 6CA56033A49A
[274595.975966] input: Sony USB Bus-powered Device as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.4/2-1.2.2.4:1.0/0003:054C:0830.001D/input/input27
[274595.976254] hid-generic 0003:054C:0830.001D: input,hidraw8: USB HID 
v1.11 Device [Sony USB Bus-powered Device] on 
usb-0000:00:1d.0-1.2.2.4/input0
[274598.681205] usb 2-1.2.2.4: USB disconnect, device number 36
[274606.089485] usb 2-1.2.2.4: new high-speed USB device number 37 using 
ehci-pci
[274606.211204] usb 2-1.2.2.4: New USB device found, idVendor=054c, 
idProduct=0773
[274606.211208] usb 2-1.2.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[274606.211211] usb 2-1.2.2.4: Product: FDR-X3000
[274606.211213] usb 2-1.2.2.4: Manufacturer: Sony
[274606.211215] usb 2-1.2.2.4: SerialNumber: 6CA56033A49A
[274606.212159] usb-storage 2-1.2.2.4:1.0: USB Mass Storage device detected
[274606.212672] scsi host7: usb-storage 2-1.2.2.4:1.0
[274607.223936] scsi 7:0:0:0: Direct-Access     Sony Camcorder        
1.00 PQ: 0 ANSI: 0
[274607.235984] scsi 7:0:0:1: Direct-Access     Sony Camcorder        
1.00 PQ: 0 ANSI: 0
[274607.237299] sd 7:0:0:0: Attached scsi generic sg3 type 0
[274607.237780] sd 7:0:0:1: Attached scsi generic sg4 type 0
[274607.297844] sd 7:0:0:0: [sdc] 250085376 512-byte logical blocks: 
(128 GB/119 GiB)
[274607.303986] sd 7:0:0:0: [sdc] Write Protect is on
[274607.303991] sd 7:0:0:0: [sdc] Mode Sense: 03 00 80 00
[274607.304444] sd 7:0:0:1: [sdd] 4096 512-byte logical blocks: (2.10 
MB/2.00 MiB)
[274607.305447] sd 7:0:0:0: [sdc] No Caching mode page found
[274607.305454] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[274607.306474] sd 7:0:0:1: [sdd] Write Protect is on
[274607.306479] sd 7:0:0:1: [sdd] Mode Sense: 03 00 80 00
[274607.308424] sd 7:0:0:1: [sdd] No Caching mode page found
[274607.308430] sd 7:0:0:1: [sdd] Assuming drive cache: write through
[274607.317561]  sdc: sdc1
[274607.320317]  sdd: sdd1
[274607.326318] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[274607.327662] sd 7:0:0:1: [sdd] Attached SCSI removable disk
[275149.368123] usb 2-1.2.2.4: USB disconnect, device number 37
[351449.572856] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[356131.736831] systemd[1]: anacron.timer: Adding 54.202069s random time.
[356132.188245] systemd[1]: anacron.timer: Adding 4min 20.949842s random 
time.
[356132.271721] systemd[1]: anacron.timer: Adding 1min 14.225247s random 
time.
[356132.358551] systemd[1]: anacron.timer: Adding 32.534777s random time.
[356134.970606] systemd[1]: anacron.timer: Adding 12.757668s random time.
[356135.310122] systemd[1]: anacron.timer: Adding 4min 7.944294s random 
time.
[356135.657365] systemd[1]: anacron.timer: Adding 3min 4.761747s random 
time.
[356135.986168] systemd[1]: anacron.timer: Adding 4min 48.973218s random 
time.
[356136.350692] systemd[1]: anacron.timer: Adding 3min 19.004236s random 
time.
[356136.703686] systemd[1]: anacron.timer: Adding 2min 34.489948s random 
time.
[356136.795945] systemd[1]: anacron.timer: Adding 2min 45.898803s random 
time.
[356136.882359] systemd[1]: anacron.timer: Adding 5.853368s random time.
[356137.018617] systemd[1]: anacron.timer: Adding 4min 10.355421s random 
time.
[356137.108095] systemd[1]: anacron.timer: Adding 4min 16.141841s random 
time.
[356137.301495] systemd[1]: anacron.timer: Adding 4min 26.735095s random 
time.
[356137.369589] systemd[1]: anacron.timer: Adding 45.463659s random time.
[356137.480320] systemd[1]: anacron.timer: Adding 3min 6.993275s random 
time.
[356137.520607] ip6_tables: (C) 2000-2006 Netfilter Core Team
[356137.529363] Ebtables v2.0 registered
[356137.570125] systemd[1]: anacron.timer: Adding 4min 44.307529s random 
time.
[356138.136084] systemd[1]: anacron.timer: Adding 4min 15.603450s random 
time.
[356138.201280] systemd[1]: anacron.timer: Adding 1min 30.837344s random 
time.
[356144.618043] systemd[1]: anacron.timer: Adding 16.351069s random time.
[356144.691171] systemd[1]: anacron.timer: Adding 1min 4.943094s random 
time.
[356144.774446] systemd[1]: anacron.timer: Adding 1min 37.689206s random 
time.
[356144.903180] systemd[1]: anacron.timer: Adding 24.144051s random time.
[356144.981225] systemd[1]: anacron.timer: Adding 4min 59.219583s random 
time.
[356145.362587] systemd[1]: anacron.timer: Adding 3min 32.630243s random 
time.
[356145.701048] systemd[1]: anacron.timer: Adding 3min 22.313660s random 
time.
[356146.063178] systemd[1]: anacron.timer: Adding 1min 42.512794s random 
time.
[356146.633390] systemd[1]: anacron.timer: Adding 3min 57.866762s random 
time.
[356865.015692] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[359181.808131] systemd[1]: anacron.timer: Adding 2min 29.396921s random 
time.
[359181.875873] systemd[1]: anacron.timer: Adding 1min 52.826890s random 
time.
[359194.442116] systemd[1]: anacron.timer: Adding 1min 32.952916s random 
time.
[359196.776483] systemd[1]: anacron.timer: Adding 48.066696s random time.
[359197.993007] systemd[1]: anacron.timer: Adding 2min 25.649984s random 
time.
[359198.071096] systemd[1]: anacron.timer: Adding 3min 18.206226s random 
time.
[359198.131240] systemd[1]: anacron.timer: Adding 1min 4.014553s random 
time.
[359198.156677] systemd: 28 output lines suppressed due to ratelimiting
[359359.262185] device-mapper: uevent: version 1.0.3
[359359.262425] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) 
initialised: dm-devel@redhat.com
[359360.810988] SGI XFS with ACLs, security attributes, realtime, no 
debug enabled
[359360.814164] JFS: nTxBlock = 8192, nTxLock = 65536
[359360.822101] ntfs: driver 2.1.32 [Flags: R/O MODULE].
[359360.831036] QNX4 filesystem 0.2.3 registered.
[360276.795340] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[415929.788377] traps: chrome[15632] trap invalid opcode ip:56427b7f4315 
sp:7ffdb7894910 error:0
[415929.788396]  in chrome (deleted)[564277785000+5a95000]
[604836.102738] usb 2-1.2.2.4: new full-speed USB device number 38 using 
ehci-pci
[604836.226587] usb 2-1.2.2.4: New USB device found, idVendor=054c, 
idProduct=0830
[604836.226592] usb 2-1.2.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[604836.226595] usb 2-1.2.2.4: Product: USB Bus-powered Device
[604836.226597] usb 2-1.2.2.4: Manufacturer: Sony
[604836.226599] usb 2-1.2.2.4: SerialNumber: 6CA56033A49A
[604836.229850] input: Sony USB Bus-powered Device as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.4/2-1.2.2.4:1.0/0003:054C:0830.001E/input/input28
[604836.230061] hid-generic 0003:054C:0830.001E: input,hidraw8: USB HID 
v1.11 Device [Sony USB Bus-powered Device] on 
usb-0000:00:1d.0-1.2.2.4/input0
[604897.309694] usb 2-1.2.2.4: USB disconnect, device number 38
[604904.459480] usb 2-1.2.2.4: new high-speed USB device number 39 using 
ehci-pci
[604904.581575] usb 2-1.2.2.4: New USB device found, idVendor=054c, 
idProduct=0773
[604904.581580] usb 2-1.2.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[604904.581584] usb 2-1.2.2.4: Product: FDR-X3000
[604904.581587] usb 2-1.2.2.4: Manufacturer: Sony
[604904.581590] usb 2-1.2.2.4: SerialNumber: 6CA56033A49A
[604904.582718] usb-storage 2-1.2.2.4:1.0: USB Mass Storage device detected
[604904.583286] scsi host7: usb-storage 2-1.2.2.4:1.0
[604905.601585] scsi 7:0:0:0: Direct-Access     Sony Camcorder        
1.00 PQ: 0 ANSI: 0
[604905.614803] scsi 7:0:0:1: Direct-Access     Sony Camcorder        
1.00 PQ: 0 ANSI: 0
[604905.615946] sd 7:0:0:0: Attached scsi generic sg3 type 0
[604905.616417] sd 7:0:0:1: Attached scsi generic sg4 type 0
[604905.779014] sd 7:0:0:0: [sdc] 250085376 512-byte logical blocks: 
(128 GB/119 GiB)
[604905.779504] sd 7:0:0:1: [sdd] 4096 512-byte logical blocks: (2.10 
MB/2.00 MiB)
[604905.780611] sd 7:0:0:0: [sdc] Write Protect is on
[604905.780616] sd 7:0:0:0: [sdc] Mode Sense: 03 00 80 00
[604905.782238] sd 7:0:0:1: [sdd] Write Protect is on
[604905.782243] sd 7:0:0:1: [sdd] Mode Sense: 03 00 80 00
[604905.783211] sd 7:0:0:0: [sdc] No Caching mode page found
[604905.783219] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[604905.784359] sd 7:0:0:1: [sdd] No Caching mode page found
[604905.784367] sd 7:0:0:1: [sdd] Assuming drive cache: write through
[604905.795292]  sdc: sdc1
[604905.801057]  sdd: sdd1
[604905.807460] sd 7:0:0:1: [sdd] Attached SCSI removable disk
[604905.808501] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[604958.497496] usb 2-1.2.2.4: USB disconnect, device number 39
[611174.981715] usb 2-1.2.2.4: new full-speed USB device number 40 using 
ehci-pci
[611175.105068] usb 2-1.2.2.4: New USB device found, idVendor=054c, 
idProduct=0830
[611175.105072] usb 2-1.2.2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[611175.105075] usb 2-1.2.2.4: Product: USB Bus-powered Device
[611175.105077] usb 2-1.2.2.4: Manufacturer: Sony
[611175.105080] usb 2-1.2.2.4: SerialNumber: 6419B034A52B
[611175.108315] input: Sony USB Bus-powered Device as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2.2/2-1.2.2.4/2-1.2.2.4:1.0/0003:054C:0830.001F/input/input29
[611175.108655] hid-generic 0003:054C:0830.001F: input,hidraw8: USB HID 
v1.11 Device [Sony USB Bus-powered Device] on 
usb-0000:00:1d.0-1.2.2.4/input0
[618763.989938] usb 2-1.2.2.4: USB disconnect, device number 40
[659602.302492] traps: chrome[27917] trap invalid opcode ip:56427b7f4315 
sp:7ffdb7894a30 error:0
[659602.302506]  in chrome (deleted)[564277785000+5a95000]
[673289.372788] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[746838.475598] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[800919.136024] perf: interrupt took too long (9965 > 9953), lowering 
kernel.perf_event_max_sample_rate to 20000
[827710.962447] traps: chrome[11959] trap invalid opcode ip:56427b7f4315 
sp:7ffdb7894d20 error:0
[827710.962453]  in chrome (deleted)[564277785000+5a95000]
[961315.633302] usb 2-1.2.3: reset high-speed USB device number 31 using 
ehci-pci
[1320962.251950] usb 2-1.2.3: reset high-speed USB device number 31 
using ehci-pci
[1364361.902678] usb 2-1.2.3: reset high-speed USB device number 31 
using ehci-pci
[1438672.037592] usb 2-1.2.3: reset high-speed USB device number 31 
using ehci-pci
[1468413.699131] usb 2-1.2.2.4: new full-speed USB device number 41 
using ehci-pci
[1468413.791135] usb 2-1.2.2.4: device descriptor read/64, error -32
[1468413.991181] usb 2-1.2.2.4: device descriptor read/64, error -32
[1468414.191146] usb 2-1.2.2.4: new full-speed USB device number 42 
using ehci-pci
[1468414.283146] usb 2-1.2.2.4: device descriptor read/64, error -32
[1468414.483192] usb 2-1.2.2.4: device descriptor read/64, error -32
[1468414.683204] usb 2-1.2.2.4: new full-speed USB device number 43 
using ehci-pci
[1468415.103230] usb 2-1.2.2.4: device not accepting address 43, error -32
[1468415.195234] usb 2-1.2.2.4: new full-speed USB device number 44 
using ehci-pci
[1468415.611235] usb 2-1.2.2.4: device not accepting address 44, error -32
[1468415.611432] usb 2-1.2.2-port4: unable to enumerate USB device
[1468464.162716] usb 2-1.2.2.4: new high-speed USB device number 45 
using ehci-pci
[1468464.297518] usb 2-1.2.2.4: unable to get BOS descriptor
[1468464.310269] usb 2-1.2.2.4: unable to read config index 0 
descriptor/start: -71
[1468464.310275] usb 2-1.2.2.4: can't read configurations, error -71
[1468487.428384] usb 2-1.2.2.4: new high-speed USB device number 47 
using ehci-pci
[1468487.577238] usb 2-1.2.2.4: New USB device found, idVendor=0bda, 
idProduct=0326
[1468487.577252] usb 2-1.2.2.4: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
[1468487.577254] usb 2-1.2.2.4: Product: USB3.0 Card Reader
[1468487.577256] usb 2-1.2.2.4: Manufacturer: Realtek
[1468487.577258] usb 2-1.2.2.4: SerialNumber: 201404081410
[1468487.583730] usb-storage 2-1.2.2.4:1.0: USB Mass Storage device 
detected
[1468487.584200] scsi host7: usb-storage 2-1.2.2.4:1.0
[1468487.772450] usb 2-1.2.3: reset high-speed USB device number 31 
using ehci-pci
[1468488.623209] scsi 7:0:0:0: Direct-Access     Generic- USB3.0 CRW   
-SD 1.00 PQ: 0 ANSI: 4
[1468488.631940] scsi 7:0:0:1: Direct-Access     Generic- USB3.0 CRW   
-SD 1.00 PQ: 0 ANSI: 4
[1468488.633351] sd 7:0:0:0: Attached scsi generic sg3 type 0
[1468488.633823] sd 7:0:0:1: Attached scsi generic sg4 type 0
[1468489.811770] sd 7:0:0:1: [sdd] 250085376 512-byte logical blocks: 
(128 GB/119 GiB)
[1468489.813563] sd 7:0:0:1: [sdd] Write Protect is off
[1468489.813567] sd 7:0:0:1: [sdd] Mode Sense: 2f 00 00 00
[1468489.815415] sd 7:0:0:1: [sdd] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[1468489.817190] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[1468489.825470]  sdd: sdd1
[1468489.829870] sd 7:0:0:1: [sdd] Attached SCSI removable disk
[1470787.447021] usb 2-1.2.3: reset high-speed USB device number 31 
using ehci-pci
[1470790.759315] usb 2-1.2.3: reset high-speed USB device number 31 
using ehci-pci
[1471448.438578] BTRFS info (device sda2): 11 enospc errors during balance
[1471476.257855] BTRFS info (device sda2): relocating block group 
318922293248 flags 1
[1471476.369287] BTRFS info (device sda2): found 147 extents
[1471476.551036] BTRFS info (device sda2): found 147 extents
[1471476.566284] BTRFS info (device sda2): relocating block group 
317848551424 flags 1
[1471476.584626] BTRFS info (device sda2): found 3 extents
[1471476.631155] BTRFS info (device sda2): found 3 extents
[...]

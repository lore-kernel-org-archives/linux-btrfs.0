Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37231 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2IPNZO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Sep 2012 09:25:14 -0400
Received: by vbbff1 with SMTP id ff1so2014702vbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Sep 2012 06:25:13 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?S=C3=A9bastien_Kalt?= <skalt@throka.org>
Date: Sun, 16 Sep 2012 15:24:53 +0200
Message-ID: <CAN64BFbykhT6FqnW9i8j=t0nUTxXXfb9vjJeA3fUOFptsUpQVw@mail.gmail.com>
Subject: btrfs: open_ctree failed on external usb drive
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have formated a previous ntfs partition to btrfs using gparted last
week. It's an external usb drive.

I used it to backup another disk, then moving the datas back to the other disk.

I ran a crashplan backup and a couple of rsync of my home directory. I
moved back to this disk some data.

I'm running Debian Sid, 3.2.0-3-amd64 kernel and Btrfs v0.19
(0.19+20120328-8 according to dpkg), using XFCE4 and dolphin as a file
manager. The usb drive is auto-mounting, and I'm accessing it with
dolphin or console. I always use the "remove device safely" feature
from dolphin before disconnecting the drive or shutting down my
laptop.

Unfotunately, I can't access anymore the drive :

75446.148236] usb 8-6: new high-speed USB device number 5 using ehci_hcd
[75446.281867] usb 8-6: New USB device found, idVendor=13fd, idProduct=1840
[75446.281877] usb 8-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[75446.281884] usb 8-6: Product: USB 2.0 Drive
[75446.281889] usb 8-6: Manufacturer: PI-239
[75446.281893] usb 8-6: SerialNumber: 533157464A39444233313232
[75446.282628] scsi9 : usb-storage 8-6:1.0
[75447.281188] scsi 9:0:0:0: Direct-Access     PI-239   USB 2.0 Drive
  1.08 PQ: 0 ANSI: 4
[75447.282934] sd 9:0:0:0: Attached scsi generic sg3 type 0
[75447.284169] sd 9:0:0:0: [sdc] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[75447.284728] sd 9:0:0:0: [sdc] Write Protect is off
[75447.284736] sd 9:0:0:0: [sdc] Mode Sense: 23 00 00 00
[75447.285345] sd 9:0:0:0: [sdc] No Caching mode page present
[75447.285352] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[75447.288349] sd 9:0:0:0: [sdc] No Caching mode page present
[75447.288356] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[75447.309900]  sdc: sdc1
[75447.312608] sd 9:0:0:0: [sdc] No Caching mode page present
[75447.312612] sd 9:0:0:0: [sdc] Assuming drive cache: write through
[75447.312615] sd 9:0:0:0: [sdc] Attached SCSI disk
[75447.624772] device label DD_SEB devid 1 transid 390 /dev/sdc1
[75447.626348] btrfs: disk space caching is enabled
[75447.666137] parent transid verify failed on 464265216 wanted 390 found 392
[75447.666146] parent transid verify failed on 464265216 wanted 390 found 392
[75447.666150] parent transid verify failed on 464265216 wanted 390 found 392
[75447.679199] btrfs: open_ctree failed

btrfsck shows lots or problems (see
https://dl.dropbox.com/u/747851/btrfsck.txt.gz 257K)

I've looked at my logfiles from thurday, and I didn't see any error
concerning btrfs.

So I have three questions :

1) did I do something wrong ?
2) is there a way to recover the data on this disk ?
3) is btrfs a good choice for an external usb drive ?

If you need more information, feel free to ask.

Regards,

Sebastien

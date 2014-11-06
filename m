Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40422 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750984AbaKFC5E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Nov 2014 21:57:04 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56276 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XmDFv-000Q71-Ey
	for linux-btrfs@vger.kernel.org; Wed, 05 Nov 2014 19:57:03 -0700
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [bug] btrfs fi show lists wrong (old) devid size after btrfs replace
Message-Id: <EC620053-6EDC-4122-AAA5-0AC86814B04A@colorremedies.com>
Date: Wed, 5 Nov 2014 19:57:02 -0700
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Summary: After successfully completed btrfs replace start, btrfs fi show lists the old devid size not the new devid size.

kernel-3.17.2-300.fc21.x86_64
btrfs-progs-3.17-1.fc21.x86_64


##Before devid2 is missing (normal mount of 2x HDDs, raw block devices are formatted, no partitioning)

#btrfs fi show /mnt/btrfs1

Label: 'btrfs1'  uuid: 0f1c615f-30a0-4166-8a3c-987849551513
	Total devices 2 FS bytes used 270.58GiB
	devid    1 size 465.76GiB used 272.03GiB path /dev/sdc
	devid    2 size 298.09GiB used 272.03GiB path /dev/sdb

##During btrfs replace start 2 /dev/sdb /mnt/btrfs1; new /dev/sdb is 750GB

#btrfs fi show /mnt/btrfs1
Label: 'btrfs1'  uuid: 0f1c615f-30a0-4166-8a3c-987849551513
	Total devices 4 FS bytes used 270.58GiB
	devid    0 size 298.09GiB used 272.03GiB path /dev/sdb
	devid    1 size 465.76GiB used 272.03GiB path /dev/sdc
	*** Some devices missing

##After btrfs replace completes, and after umount, physically disconnecting/reconnecting, and remounting

Label: 'btrfs1'  uuid: 0f1c615f-30a0-4166-8a3c-987849551513
	Total devices 2 FS bytes used 270.58GiB
	devid    1 size 465.76GiB used 272.03GiB path /dev/sdc
	devid    2 size 298.09GiB used 272.03GiB path /dev/sdb


devid2/sdb is now the new device (750GB, 698.7GiB as reported by lsblk). The value from btrfs fi show is still the old value and is now wrong.

[ 6141.864212] usb 4-2: USB disconnect, device number 5
[ 6141.865378] sd 9:0:0:0: [sdb] Synchronizing SCSI cache
[ 6141.865448] sd 9:0:0:0: [sdb]  
[ 6141.865452] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 6145.254144] usb 4-1: new SuperSpeed USB device number 6 using xhci_hcd
[ 6145.266077] usb 4-1: New USB device found, idVendor=174c, idProduct=5136
[ 6145.266084] usb 4-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[ 6145.266088] usb 4-1: Product: AS2105
[ 6145.266090] usb 4-1: Manufacturer: ASMedia
[ 6145.266093] usb 4-1: SerialNumber: 00000000000000000000
[ 6145.266861] usb-storage 4-1:1.0: USB Mass Storage device detected
[ 6145.267536] scsi host10: usb-storage 4-1:1.0
[ 6146.271397] scsi 10:0:0:0: Direct-Access     ASMT     2105             0    PQ: 0 ANSI: 6
[ 6146.272183] sd 10:0:0:0: Attached scsi generic sg2 type 0
[ 6148.239288] sd 10:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[ 6148.239748] sd 10:0:0:0: [sdb] Write Protect is off
[ 6148.239755] sd 10:0:0:0: [sdb] Mode Sense: 43 00 00 00
[ 6148.240077] sd 10:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 6148.265774]  sdb: unknown partition table
[ 6148.267153] sd 10:0:0:0: [sdb] Attached SCSI disk



# df -h
/dev/sdc        382G  271G   27G  92% /mnt/btrfs1


This is incorrect as well, it's the exact same information provided by df before the replace. It seems like btrfs replace is not doing a resize to fill all available space on the specified new block device.


Chris Murphy


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34707 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbcDULKH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 07:10:07 -0400
Received: by mail-io0-f173.google.com with SMTP id 2so82158393ioy.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 04:10:07 -0700 (PDT)
Subject: Re: Question: raid1 behaviour on failure
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Matthias Bodenbinder <matthias@bodenbinder.de>,
        linux-btrfs@vger.kernel.org
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org> <571871FC.2010101@jp.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5718B4EA.8080301@gmail.com>
Date: Thu, 21 Apr 2016 07:09:30 -0400
MIME-Version: 1.0
In-Reply-To: <571871FC.2010101@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-21 02:23, Satoru Takeuchi wrote:
> On 2016/04/20 14:17, Matthias Bodenbinder wrote:
>> Am 18.04.2016 um 09:22 schrieb Qu Wenruo:
>>> BTW, it would be better to post the dmesg for better debug.
>>
>> So here we. I did the same test again. Here is a full log of what i
>> did. It seems to be mean like a bug in btrfs.
>> Sequenz of events:
>> 1. mount the raid1 (2 disc with different size)
>> 2. unplug the biggest drive (hotplug)
>> 3. try to copy something to the degraded raid1
>> 4. plugin the device again (hotplug)
>>
>> This scenario does not work. The disc array is NOT redundant! I can
>> not work with it while a drive is missing and I can not reattach the
>> device so that everything works again.
>>
>> The btrfs module crashes during the test.
>>
>> I am using LMDE2 with backports:
>> btrfs-tools 4.4-1~bpo8+1
>> linux-image-4.4.0-0.bpo.1-amd64
>>
>> Matthias
>>
>>
>> rakete - root - /root
>> 1# mount /mnt/raid1/
>>
>> Journal:
>>
>> Apr 20 07:01:16 rakete kernel: BTRFS info (device sdi): enabling auto
>> defrag
>> Apr 20 07:01:16 rakete kernel: BTRFS info (device sdi): disk space
>> caching is enabled
>> Apr 20 07:01:16 rakete kernel: BTRFS: has skinny extents
>>
>> rakete - root - /mnt/raid1
>> 3# ll
>> insgesamt 0
>> drwxrwxr-x 1 root root   36 Nov 14  2014 AfterShot2(64-bit)
>> drwxrwxr-x 1 root root 5082 Apr 17 09:06 etc
>> drwxr-xr-x 1 root root  108 Mär 24 07:31 var
>>
>> 4# btrfs fi show
>> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
>>     Total devices 3 FS bytes used 1.60GiB
>>     devid    1 size 698.64GiB used 3.03GiB path /dev/sdg
>>     devid    2 size 465.76GiB used 3.03GiB path /dev/sdh
>>     devid    3 size 232.88GiB used 0.00B path /dev/sdi
>>
>> ####
>> unplug device sdg:
>>
>> Apr 20 07:03:05 rakete kernel: Buffer I/O error on dev sdf1, logical
>> block 243826688, lost sync page write
>> Apr 20 07:03:05 rakete kernel: JBD2: Error -5 detected when updating
>> journal superblock for sdf1-8.
>> Apr 20 07:03:05 rakete kernel: Aborting journal on device sdf1-8.
>> Apr 20 07:03:05 rakete kernel: Buffer I/O error on dev sdf1, logical
>> block 243826688, lost sync page write
>> Apr 20 07:03:05 rakete kernel: JBD2: Error -5 detected when updating
>> journal superblock for sdf1-8.
>> Apr 20 07:03:05 rakete umount[16405]: umount: /mnt/raid1: target is busy
>> Apr 20 07:03:05 rakete umount[16405]: (In some cases useful info about
>> processes that
>> Apr 20 07:03:05 rakete umount[16405]: use the device is found by
>> lsof(8) or fuser(1).)
>> Apr 20 07:03:05 rakete systemd[1]: mnt-raid1.mount mount process
>> exited, code=exited status=32
>> Apr 20 07:03:05 rakete systemd[1]: Failed unmounting /mnt/raid1.
>> Apr 20 07:03:24 rakete kernel: usb 3-1: new SuperSpeed USB device
>> number 3 using xhci_hcd
>> Apr 20 07:03:24 rakete kernel: usb 3-1: New USB device found,
>> idVendor=152d, idProduct=0567
>> Apr 20 07:03:24 rakete kernel: usb 3-1: New USB device strings:
>> Mfr=10, Product=11, SerialNumber=5
>> Apr 20 07:03:24 rakete kernel: usb 3-1: Product: USB to ATA/ATAPI Bridge
>> Apr 20 07:03:24 rakete kernel: usb 3-1: Manufacturer: JMicron
>> Apr 20 07:03:24 rakete kernel: usb 3-1: SerialNumber: 152D00539000
>> Apr 20 07:03:24 rakete kernel: usb-storage 3-1:1.0: USB Mass Storage
>> device detected
>> Apr 20 07:03:24 rakete kernel: usb-storage 3-1:1.0: Quirks match for
>> vid 152d pid 0567: 5000000
>> Apr 20 07:03:24 rakete kernel: scsi host9: usb-storage 3-1:1.0
>> Apr 20 07:03:24 rakete mtp-probe[16424]: checking bus 3, device 3:
>> "/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/usb3/3-1"
>> Apr 20 07:03:24 rakete mtp-probe[16424]: bus: 3, device: 3 was not an
>> MTP device
>> Apr 20 07:03:25 rakete kernel: scsi 9:0:0:0: Direct-Access     WDC
>> WD20 02FAEX-007BA0    0125 PQ: 0 ANSI: 6
>> Apr 20 07:03:25 rakete kernel: scsi 9:0:0:1: Direct-Access     WDC
>> WD50 01AALS-00L3B2    0125 PQ: 0 ANSI: 6
>> Apr 20 07:03:25 rakete kernel: scsi 9:0:0:2: Direct-Access
>> SAMSUNG  SP2504C          0125 PQ: 0 ANSI: 6
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: Attached scsi generic sg6
>> type 0
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: Attached scsi generic sg7
>> type 0
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] 3907029168 512-byte
>> logical blocks: (2.00 TB/1.82 TiB)
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Write Protect is off
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Mode Sense: 67 00 10 08
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: Attached scsi generic sg8
>> type 0
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] 976773168 512-byte
>> logical blocks: (500 GB/466 GiB)
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] No Caching mode page
>> found
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Assuming drive cache:
>> write through
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Write Protect is off
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Mode Sense: 67 00 10 08
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] 488395055 512-byte
>> logical blocks: (250 GB/233 GiB)
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] No Caching mode page
>> found
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Assuming drive cache:
>> write through
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Write Protect is off
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Mode Sense: 67 00 10 08
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] No Caching mode page
>> found
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Assuming drive cache:
>> write through
>> Apr 20 07:03:25 rakete kernel:  sdf: sdf1
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:0: [sdf] Attached SCSI disk
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:1: [sdj] Attached SCSI disk
>> Apr 20 07:03:25 rakete kernel: sd 9:0:0:2: [sdk] Attached SCSI disk
>> Apr 20 07:03:25 rakete kernel: EXT4-fs (sdf1): recovery complete
>> Apr 20 07:03:25 rakete kernel: EXT4-fs (sdf1): mounted filesystem with
>> ordered data mode. Opts: (null)
>> Apr 20 07:03:25 rakete udisksd[3671]: Error statting /dev/sdg: No such
>> file or directory
>>
>>
>> ####
>> 5# btrfs fi show
>> Label: none  uuid: 16d5891f-5d52-4b29-8591-588ddf11e73d
>>     Total devices 3 FS bytes used 1.60GiB
>>     devid    2 size 465.76GiB used 3.03GiB path /dev/sdj
>>     devid    3 size 232.88GiB used 0.00B path /dev/sdk
>>     *** Some devices missing
>> ####
>
> Here the names of *online* devices are changed
> (/dev/sdh => /dev/sdj, /dev/sdi => /dev/sdk) after just
> offlining a device (/dev/sdf). It's odd regardless of
> whether Btrfs works fine or not.
>
> Can anyone explain this behavior?
It's a side effect of the reference counting done in the kernel.  If 
something is holding open references to the block device (for example, 
if there's a mounted filesystem on one of it's partitions), then the 
kernel has to keep the internal structures relating to that block device 
around, even if the device isn't there anymore.  This means that when 
the disk reappears, the old name is still in use, so the kernel has to 
allocate a new one (because it can't safely assume that the disk is the 
same one that was there previously).  It has some annoying side effects, 
but it's still a whole lot better than the system crashing from a NULL 
pointer reference.

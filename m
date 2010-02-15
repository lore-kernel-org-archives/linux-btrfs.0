From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: Btrfs - Unable to mount, can't read superblock?
Date: Mon, 15 Feb 2010 09:28:23 +0900
Message-ID: <4B789527.1040309@jp.fujitsu.com>
References: <d0c6e4d91002130445x18cbb05fv6e54411283158775@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: victorhooi@yahoo.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d0c6e4d91002130445x18cbb05fv6e54411283158775@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This disk was used as /dev/sdd previously, and now it's named
/dev/sdc, isn't it?
If so, you can use this usb disk after reboot, or adjusting
that the disk is recognized as /dev/sdd.
Btrfs does not support device file renaming yet.


Regards,
taruisi

(2010/02/13 21:45), Victor Hooi wrote:
> heya,
> 
> This is on kernel 2.6.32.8-1, on Arch Linux 64-bit. I have an external
> harddisk, with a btrfs filessystem on it. Just now, after a reboot, I
> seem to be unable to mount it.
> 
> KDE gives a message about being unable to find the superblock, trying
> to mount it from the command-line gives something similar:
> 
>> mount: /dev/sdc1: can't read superblock
> 
> I do know the last time I used the disk, it may not have been
> unmounted cleanly. Could that have caused this current issue? Any
> possible remedy? I'm really hoping it is, because that's a 1.5 Tb
> external disk...lol.
> 
> Also, dmesg contains:
>>
>> usb 2-2: new high speed USB device using ehci_hcd and address 8
>> usb 2-2: configuration #1 chosen from 1 choice
>> scsi10 : SCSI emulation for USB Mass Storage devices
>> usb-storage: device found at 8
>> usb-storage: waiting for device to settle before scanning
>> scsi 10:0:0:0: Direct-Access     WDC WD15 EADS-00P8B0           PQ: 0 ANSI: 2
>> sd 10:0:0:0: Attached scsi generic sg2 type 0
>> usb-storage: device scan complete
>> sd 10:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
>> sd 10:0:0:0: [sdc] Write Protect is off
>> sd 10:0:0:0: [sdc] Mode Sense: 38 00 00 00
>> sd 10:0:0:0: [sdc] Assuming drive cache: write through
>> sd 10:0:0:0: [sdc] Assuming drive cache: write through
>>  sdc: sdc1
>> sd 10:0:0:0: [sdc] Assuming drive cache: write through
>> sd 10:0:0:0: [sdc] Attached SCSI disk
>> device label tessier-ashpool devid 1 transid 4882 /dev/sdc1
>> open /dev/sdd1 failed
> 
> Cheers,
> Victor
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


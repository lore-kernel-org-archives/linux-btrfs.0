From: Victor Hooi <victorhooi@yahoo.com>
Subject: Btrfs - Unable to mount, can't read superblock?
Date: Sat, 13 Feb 2010 23:45:21 +1100
Message-ID: <d0c6e4d91002130445x18cbb05fv6e54411283158775@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

heya,

This is on kernel 2.6.32.8-1, on Arch Linux 64-bit. I have an external
harddisk, with a btrfs filessystem on it. Just now, after a reboot, I
seem to be unable to mount it.

KDE gives a message about being unable to find the superblock, trying
to mount it from the command-line gives something similar:

> mount: /dev/sdc1: can't read superblock

I do know the last time I used the disk, it may not have been
unmounted cleanly. Could that have caused this current issue? Any
possible remedy? I'm really hoping it is, because that's a 1.5 Tb
external disk...lol.

Also, dmesg contains:
>
> usb 2-2: new high speed USB device using ehci_hcd and address 8
> usb 2-2: configuration #1 chosen from 1 choice
> scsi10 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 8
> usb-storage: waiting for device to settle before scanning
> scsi 10:0:0:0: Direct-Access=A0=A0=A0=A0 WDC WD15 EADS-00P8B0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 PQ: 0 ANSI: 2
> sd 10:0:0:0: Attached scsi generic sg2 type 0
> usb-storage: device scan complete
> sd 10:0:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50 TB/1.36 =
TiB)
> sd 10:0:0:0: [sdc] Write Protect is off
> sd 10:0:0:0: [sdc] Mode Sense: 38 00 00 00
> sd 10:0:0:0: [sdc] Assuming drive cache: write through
> sd 10:0:0:0: [sdc] Assuming drive cache: write through
> =A0sdc: sdc1
> sd 10:0:0:0: [sdc] Assuming drive cache: write through
> sd 10:0:0:0: [sdc] Attached SCSI disk
> device label tessier-ashpool devid 1 transid 4882 /dev/sdc1
> open /dev/sdd1 failed

Cheers,
Victor
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

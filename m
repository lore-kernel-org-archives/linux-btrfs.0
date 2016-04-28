Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32844 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbcD1TOd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 15:14:33 -0400
Received: by mail-lf0-f67.google.com with SMTP id p64so16666173lfg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 12:14:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nfs5ts$o0e$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org>
	<57148B2E.6010904@cn.fujitsu.com>
	<nf73cv$7vh$1@ger.gmane.org>
	<571871FC.2010101@jp.fujitsu.com>
	<CAPmG0jZd7AaH+u52_gqBmke-3S=yH_i9Pmk1R=mOFmdnsj6BgQ@mail.gmail.com>
	<nfb2hr$6i0$1@ger.gmane.org>
	<CAPmG0jY5RRS_8YcECyCts6BEeJKT+74Uxr-2kitouruyBDwgfQ@mail.gmail.com>
	<nfs5ts$o0e$1@ger.gmane.org>
Date: Thu, 28 Apr 2016 21:14:31 +0200
Message-ID: <CAPmG0jb6tNHq5UTKyBuqW5daD+x8PhiVu-gLchmtz5fW1f3CjA@mail.gmail.com>
Subject: Re: Question: raid1 behaviour on failure
From: Henk Slager <eye1tm@gmail.com>
To: Matthias Bodenbinder <matthias@bodenbinder.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 28, 2016 at 7:09 AM, Matthias Bodenbinder
<matthias@bodenbinder.de> wrote:
> Am 26.04.2016 um 18:19 schrieb Henk Slager:
>> It looks like a JMS567 + SATA port multipliers behaind it are used in
>> this drivebay. The command   lsusb -v  could show that. So your HW
>> setup is like JBOD, not RAID.
>
> Here is the output of lsusb -v:
>
>
> Bus 003 Device 004: ID 152d:0567 JMicron Technology Corp. / JMicron USA Technology Corp.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               3.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0         9
>   idVendor           0x152d JMicron Technology Corp. / JMicron USA Technology Corp.
>   idProduct          0x0567
>   bcdDevice            2.05
>   iManufacturer          10 JMicron
>   iProduct               11 USB to ATA/ATAPI Bridge
>   iSerial                 5 152D00539000
>   bNumConfigurations      1

OK, that is how the drivebay presents itself. It does not really
correspond to this:
http://www.jmicron.com/PDF/brief/jms567.pdf
It looks more like a jms562 is used, but I don't know what is on the
PCB and in the FW

Anyhow, hot (un)plug capability on the 4 internal SATA i/f is not
explicitly mentioned. If you expect or want that, ask Fantec I would
say.

>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           44
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xc0
>       Self Powered
>     MaxPower                2mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     80 Bulk-Only
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst              15
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst              15
> Binary Object Store Descriptor:
>   bLength                 5
>   bDescriptorType        15
>   wTotalLength           22
>   bNumDeviceCaps          2
>   USB 2.0 Extension Device Capability:
>     bLength                 7
>     bDescriptorType        16
>     bDevCapabilityType      2
>     bmAttributes   0x00000002
>       Link Power Management (LPM) Supported
>   SuperSpeed USB Device Capability:
>     bLength                10
>     bDescriptorType        16
>     bDevCapabilityType      3
>     bmAttributes         0x00
>     wSpeedsSupported   0x000e
>       Device can operate at Full Speed (12Mbps)
>       Device can operate at High Speed (480Mbps)
>       Device can operate at SuperSpeed (5Gbps)
>     bFunctionalitySupport   1
>       Lowest fully-functional device speed is Full Speed (12Mbps)
>     bU1DevExitLat          10 micro seconds
>     bU2DevExitLat        2047 micro seconds
> Device Status:     0x0001
>   Self Powered
>
>
>
>> IMHO, using such a setup for software RAID (like btrfs RAID1)
>> fundamentally violates the concept of RAID (redundant array of
>> independent disks). It depends on where you define the system border
>> of the (independent) disks.
>> If it is at:
>>
>> A) the 4 (or 3 disk in this case) SATA+power interfaces inside the drivebay or
>>
>> B) inside the PC's chipset.
>>
>> In case A) there is a shared removable link (USB) inside the
>> filesystem processing machine.
>> In case B) the disks aren't really independent as they share a
>> removable link (and as proven by the (un)plug of 1 device affecting
>> all others).
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

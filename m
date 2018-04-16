Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:41870 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbeDPEdc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 00:33:32 -0400
Received: by mail-ot0-f171.google.com with SMTP id m22-v6so15936316otf.8
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 21:33:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFd7XodEGFDaR6XFr2i1t4CzmogkofQogzFGLNM7cWB2EifEyg@mail.gmail.com>
References: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
 <CAJCQCtRf5UhQiWvriKQvW6aru6OpsYqKgadYyz54x1FDgKg_yg@mail.gmail.com>
 <CAFd7XodPi5DOvk0ezAsrb57EpgMivLNZz+QZCYkb1js1Wx-R0w@mail.gmail.com>
 <CAJCQCtTHLEvgjnK_Kz6u01znPPVtztAJzETWnrX6Hfyj0LhPNQ@mail.gmail.com>
 <CAJCQCtRknKH5_J83b0h9SHzGELbSKFYzjkyz9-gH8vk-sV4w=w@mail.gmail.com> <CAFd7XodEGFDaR6XFr2i1t4CzmogkofQogzFGLNM7cWB2EifEyg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 15 Apr 2018 22:33:30 -0600
Message-ID: <CAJCQCtRR=gDO3GcYm+wL08prEDhonZw_52+2_KouSgBmJdx4eg@mail.gmail.com>
Subject: Re: having issue removing a drive with a bad block
To: Alexander Zapatka <alexzapatka@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 15, 2018 at 7:45 PM, Alexander Zapatka
<alexzapatka@gmail.com> wrote:
> thanks, Chris.  i have given a timeout of 300 to all the drives.  they
> are all USB, all connected to an apollo lake based htpc.  then i
> started the command again... the dmesg output is here from a few
> minutes after i started the btrfs device remove command.
> https://paste.ee/p/H1R0i.  no hopes, high or low, but i'm still
> getting the same errors.  i'll let it run though the night tho, as it
> doesn't seem to hurt anything other then slowly lock the system up.
>
> on a side note, all the USB drives are either powered or are connected
> to a powered hub..  thanks again!

That's 5 minutes. I'd say something is wrong/badly designed if it's
not giving a clear error message inside of 1 minute but the
manufacturers have apparently decided upwards of 180. I haven't heard
of it taking longer than 180, but good grief.

Anyway, at this point it sounds like it continues indefinitely in this
state and there's no point in doing that. I would not persist in
trying to use device remove until this problem is fixed using scrub as
a confirmation rather than either balance or device removal. Scrub is
faster and it's safer.


>From smartctl, it's /dev/sdc that has the bad sector, and usb 2-3 is
the device being reset, which

[    3.921241] usb 2-3: Product: Elements 107C
[    3.921243] usb 2-3: Manufacturer: Western Digital
[    3.921245] usb 2-3: SerialNumber: 57434334453443414636334E

[    3.929353] usb-storage 2-3:1.0: USB Mass Storage device detected
[    3.929651] scsi host3: usb-storage 2-3:1.0

[    4.994087] sd 3:0:0:0: [sdc] 976746240 4096-byte logical blocks:
(4.00 TB/3.64 TiB)

So the device with bad sector is also the device being reset but even
a 300 second command timer isn't causing the drive to report a read
error, it just hangs instead.

That's not expected.

But also, this is the only device that has a 4096 byte logical sector
size, which probably isn't related unless there's a bug here.

The smart reported LBA 1372896792 for the first error should be a 4096
byte base LBA in that case so the proper command to just toss the data
in this sector and cause firmware remapping if necessary is:

dd if=/dev/zero of=/dev/sdX bs=4096 count=1 seek=1372896792 oflag=direct

Confirm the suspect drive is still in fact /dev/sdc, since that can
change between boots. And of course umount the file system first.
There's no reason to step on 16KiB.

You can try that and then restart the long test from just prior to
that LBA and see if it finishes or stops on another sector.

smartctl -t select,1372896792-max /dev/sdX

Then mount the volume and do a scrub and see if it completes with no errors.


-- 
Chris Murphy

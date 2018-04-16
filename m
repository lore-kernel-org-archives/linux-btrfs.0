Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:46547 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbeDPAaw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 20:30:52 -0400
Received: by mail-ot0-f176.google.com with SMTP id v64-v6so15561030otb.13
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 17:30:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFd7XodPi5DOvk0ezAsrb57EpgMivLNZz+QZCYkb1js1Wx-R0w@mail.gmail.com>
References: <CAFd7Xoev1N4yQpM-THMSgu2NNO19eK+Hd14Nx9XOPZC2BcOTWA@mail.gmail.com>
 <CAJCQCtRf5UhQiWvriKQvW6aru6OpsYqKgadYyz54x1FDgKg_yg@mail.gmail.com> <CAFd7XodPi5DOvk0ezAsrb57EpgMivLNZz+QZCYkb1js1Wx-R0w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 15 Apr 2018 18:30:51 -0600
Message-ID: <CAJCQCtTHLEvgjnK_Kz6u01znPPVtztAJzETWnrX6Hfyj0LhPNQ@mail.gmail.com>
Subject: Re: having issue removing a drive with a bad block
To: Alexander Zapatka <alexzapatka@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please keep the list in the cc:

On Sun, Apr 15, 2018 at 5:55 PM, Alexander Zapatka
<alexzapatka@gmail.com> wrote:
> output:
>
> $  sudo smartctl -l scterc /dev/sdc
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.13.0-38-generic] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>
> SCT Error Recovery Control command not supported

OK you'll need to increase the scsi command timer to something like
120. Hopefully that works. This needs to be done for each device.


# echo value > /sys/block/device-name/device/timeout

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/scsi-command-timer-device-status


> after the last reboot i haven't done anything to restart the scrub or
> remove the device...   i have a syslog from the last crash, you can
> see it here https://paste.ee/p/R2Pt7.  if is not enough, i will
> certainly start a scrub and let it crash.

>Apr 13 23:53:41 kodbox kernel: [225349.101299] usb 1-1.4.2: reset high-speed USB device number 7 using xhci_hcd

Hmmm, could be there's a power issue. Not sure if it's related to the
problem or not. I see this when I direct connect laptop drives in USB
powered enclosures (no external power) directly to a my Intel NUC, but
then the problem goes away when the drive is connected to a suitably
powered USB hub, which is then connected to the computer.

But it's worth a shot to change the scsi command timer as described
resolves the problem first.

-- 
Chris Murphy

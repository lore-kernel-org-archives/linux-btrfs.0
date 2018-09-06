Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f47.google.com ([209.85.167.47]:40600 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbeIFWx3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 18:53:29 -0400
Received: by mail-lf1-f47.google.com with SMTP id x26-v6so9871227lfi.7
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 11:16:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com> <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 6 Sep 2018 12:16:47 -0600
Message-ID: <CAJCQCtTHxM+Bx8akyV+QdYch=y6-0hCf_3r1KonPC2vKsujkxQ@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: =?UTF-8?Q?Stefan_L=C3=B6wen?= <stefan.loewen@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 6, 2018 at 10:03 AM, Stefan Löwen <stefan.loewen@gmail.com> wrote:
> I have one subvolume (rw) and 2 snapshots (ro) of it.
>
> I just tested 'btrfs send <subvol> > /dev/null' and that also shows no IO
> after a while but also no significant CPU usage.
> During this I tried 'ls' on the source subvolume and it hangs as well.
> dmesg has some interesting messages I think (see attached dmesg.log)
>

OK you've got a different problem.

[  186.898756] sd 2:0:0:0: [sdb] tag#0 FAILED Result:
hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  186.898762] sd 2:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 15 26 a0 d0
00 08 00 00
[  186.898764] print_req_error: I/O error, dev sdb, sector 354853072
[  187.109641] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
using xhci_hcd
[  187.345245] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
using xhci_hcd
[  187.657844] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
using xhci_hcd
[  187.851336] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
using xhci_hcd
[  188.026882] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
using xhci_hcd
[  188.215881] usb 2-1: reset SuperSpeed Gen 1 USB device number 2
using xhci_hcd
[  188.247028] sd 2:0:0:0: [sdb] tag#0 FAILED Result:
hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  188.247041] sd 2:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 15 26 a8 d0
00 08 00 00
[  188.247048] print_req_error: I/O error, dev sdb, sector 354855120


This is a read error for a specific sector.  So your drive has media
problems. And I think that's the instigating problem here, from which
a bunch of other tasks that depend on one or more reads completing but
never do. But weirdly there also isn't any kind of libata reset. At
least on SATA, by default we see a link reset after a command has not
returned in 30 seconds. That reset would totally clear the drive's
command queue, and then things either can recover or barf. But in your
case, neither happens and it just sits there with hung tasks.

[  189.350360] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 0,
rd 2, flush 0, corrupt 0, gen 0

And that's the last we really see from Btrfs. After that, it's all
just hung task traces and are rather unsurprising to me.

Drives in USB cases add a whole bunch of complicating factors for
troubleshooting and repair. Including often masking the actual logical
and physical sector size, the min and max IO size, alignment offset,
and all kinds of things. They can have all sorts of bugs. And I'm also
not totally certain about the relationship between the usb reset
messages and the bad sector. As far as I know the only way we can get
a sector LBA expressly noted in dmesg along with the failed read(10)
command, is if the drive has reported back to libata that discrete
error with sense information. So I'm accepting that as a reliable
error, rather than it being something like a cable. But the reset
messages could possibly be something else in addition to that.

Anyway, the central issue is sector 354855120 is having problems. I
can't tell from the trace if it's transient or persistent. Maybe if
it's transient, that would explain how you sometimes get send to start
working again briefly but then it reverts to hanging. What do you get
for:

fdisk -l /dev/sdb
smartctl -x /dev/sdb
smartctl -l sct erc /dev/sdb

Those are all read only commands, nothing is written or changed.



-- 
Chris Murphy

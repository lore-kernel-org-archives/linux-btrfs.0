Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52651 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215AbaBZGnA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 01:43:00 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Detailed RAID Status and Errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKZK7uxkTtOkrU-v+CN=OLvX_9v7+6N2cAYDk0oVGXb4EJck4A@mail.gmail.com>
Date: Tue, 25 Feb 2014 23:42:58 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4C5E0A04-32C8-4CB5-ABDB-95E051389F52@colorremedies.com>
References: <CAKZK7uyXxnbX-i2f5Bp5ndOO9ia57j-qRmYRBUBi3i-TTgA53A@mail.gmail.com> <4100767A-7529-4AC0-9898-A55C13D14F18@colorremedies.com> <CAKZK7uxkTtOkrU-v+CN=OLvX_9v7+6N2cAYDk0oVGXb4EJck4A@mail.gmail.com>
To: Justin Brown <justin.brown@fandingo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 25, 2014, at 11:19 PM, Justin Brown <justin.brown@fandingo.org> wrote:

> Chris,
> 
> Thanks for the reply.
> 
>> Total includes metadata.
> 
> It still doesn't seem to add up:
> 
> ~$ btrfs fi df t
> Data, single: total=8.00MiB, used=0.00
> Data, RAID6: total=2.17TiB, used=2.17TiB
> System, single: total=4.00MiB, used=0.00
> System, RAID6: total=9.56MiB, used=192.00KiB
> Metadata, single: total=8.00MiB, used=0.00
> Metadata, RAID6: total=4.03GiB, used=3.07GiB
> 
> Nonetheless, the scrub finished shortly after I started typing this
> response. Total was ~2.7TB if I remember correctly.

What do you get for btfs fi show

> 
>> All of this looks like a conventional bad sector read error. It's concerning why there'd be a bad sector after having just written to it when putting all your data on this volume. What do you get for:
> 
>> smartctl -x /dev/sdd
> 
> ...
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x0001  2            0  Command failed due to ICRC error
> 0x0002  2            0  R_ERR response for data FIS
> 0x0003  2            0  R_ERR response for device-to-host data FIS
> 0x0004  2            0  R_ERR response for host-to-device data FIS
> 0x0005  2            0  R_ERR response for non-data FIS
> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> 0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
> 0x8000  4       185377  Vendor specific

You chopped out the important part. Post the whole thing.


>> smartctl -l scterc /dev/sdd
> 
> SCT Error Recovery Control:
>           Read: Disabled
>          Write: Disabled

It's possible for the drive recovery to take longer when reading from a troublesome sector than the SCSI command timer value, which is 30 seconds by default. This is a kernel function. You can check it with cat or change it with echo value > to /sys/block/<device-name>/device/timeout

You'd have to consult the model spec to find out what the drive's time out is, but you want the kernel to wait at least say, a second, longer than the drive. So if the drive waits up to 120 seconds, then have the kernel wait 121 seconds. Otherwise what happens is you get a reset instead of this:

end_request: I/O error, dev sdd, sector 1487873214

That's important because it's how to know what to write good data back to (once supported). If a reset happens first, this information is lost. So it's not related to this problem but you'll want to change the command timer value.

> 
>> btrfs device stats /dev/X
> 
> All drives except /dev/sdf1 have zeroes for all values. /dev/sdf1
> reports that same read error from the logs:
> 
> [/dev/sdf1].write_io_errs   0
> [/dev/sdf1].read_io_errs    1
> [/dev/sdf1].flush_io_errs   0
> [/dev/sdf1].corruption_errs 0
> [/dev/sdf1].generation_errs 0

Yeah I'm confused. Maybe the entire dmesg would be useful; or two separate ones:
dmesg | grep -i sdd
dmesg | grep -i sdf

Maybe there's another read error floating around here somewhere…


Chris Murphy


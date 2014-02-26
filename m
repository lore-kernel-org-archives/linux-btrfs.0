Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51905 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaBZGTm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 01:19:42 -0500
Received: by mail-ie0-f180.google.com with SMTP id ar20so325426iec.11
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 22:19:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4100767A-7529-4AC0-9898-A55C13D14F18@colorremedies.com>
References: <CAKZK7uyXxnbX-i2f5Bp5ndOO9ia57j-qRmYRBUBi3i-TTgA53A@mail.gmail.com>
	<4100767A-7529-4AC0-9898-A55C13D14F18@colorremedies.com>
Date: Wed, 26 Feb 2014 00:19:42 -0600
Message-ID: <CAKZK7uxkTtOkrU-v+CN=OLvX_9v7+6N2cAYDk0oVGXb4EJck4A@mail.gmail.com>
Subject: Re: Detailed RAID Status and Errors
From: Justin Brown <justin.brown@fandingo.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Thanks for the reply.

> Total includes metadata.

It still doesn't seem to add up:

~$ btrfs fi df t
Data, single: total=8.00MiB, used=0.00
Data, RAID6: total=2.17TiB, used=2.17TiB
System, single: total=4.00MiB, used=0.00
System, RAID6: total=9.56MiB, used=192.00KiB
Metadata, single: total=8.00MiB, used=0.00
Metadata, RAID6: total=4.03GiB, used=3.07GiB

Nonetheless, the scrub finished shortly after I started typing this
response. Total was ~2.7TB if I remember correctly.

> All of this looks like a conventional bad sector read error. It's concerning why there'd be a bad sector after having just written to it when putting all your data on this volume. What do you get for:

> smartctl -x /dev/sdd

...
SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x000a  2            1  Device-to-host register FISes sent due to a COMRESET
0x8000  4       185377  Vendor specific




> smartctl -l scterc /dev/sdd

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

> btrfs device stats /dev/X

All drives except /dev/sdf1 have zeroes for all values. /dev/sdf1
reports that same read error from the logs:

[/dev/sdf1].write_io_errs   0
[/dev/sdf1].read_io_errs    1
[/dev/sdf1].flush_io_errs   0
[/dev/sdf1].corruption_errs 0
[/dev/sdf1].generation_errs 0

> You should have btrfs-progs-3.12-1.fc20.x86_64, it's available since November.

I was performing this copy from live media and forgot to run updates
before starting. I've updated btrfs-progs to the newest version, which
matches what you provided. I'm running another scrub with the updated
btrfs-progs, and while it hasn't uncovered any errors yet, the scrub
won't be finished until tomorrow. (I know that won't do anything
besides indicate some kind of transient error or a problem with
0.20-rc1.) After that, I'll give balance a try to attempt to fix the
issue.

Thanks,
Justin

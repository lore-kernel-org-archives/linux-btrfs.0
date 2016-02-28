Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:47986 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809AbcB1AIc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 19:08:32 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aZouT-0001pZ-Kw
	for linux-btrfs@vger.kernel.org; Sun, 28 Feb 2016 01:08:29 +0100
Date: Sun, 28 Feb 2016 01:08:29 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160228000829.GT26042@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <1595760.q3He7oiP70@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1595760.q3He7oiP70@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 28, 2016 at 12:15:21AM +0100, Martin Steigerwald wrote:
> On Samstag, 27. Februar 2016 22:14:50 CET Marc Haber wrote:
> > I have again the issue of no space left on device while rebalancing
> > (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
> > 
> > mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
> > ERROR: error during balancing '/mnt/fanbtr': No space left on device
> > mh@fan:~$ sudo btrfs fi show /mnt/fanbtr
> > mh@fan:~$ sudo btrfs fi show -m
> > Label: 'fanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
> >         Total devices 1 FS bytes used 116.49GiB
> >         devid    1 size 417.19GiB used 177.06GiB path /dev/mapper/fanbtr
> 
> Hmmm, thats still a ton of space to allocate chunks from.
> 
> > mh@fan:~$ sudo btrfs fi df /mnt/fanbtr
> > Data, single: total=113.00GiB, used=112.77GiB
> > System, DUP: total=32.00MiB, used=48.00KiB
> > Metadata, DUP: total=32.00GiB, used=3.72GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> > mh@fan:~$
> > 
> > The filesystem was recently resized from 300 GB to 420 GB.
> > 
> > Why does btrfs fi show /mnt/fanbtr not give any output? Wy does btrfs
> > fi df /mnt/fanbtr say that my data space is only 113 GiB large?
> 
> Cause it is.
> 
> The "used" in "devid 1" line is btrfs fi sh is "data + 2x system + 2x metadata 
> = 113 GiB + 2 * 32 GiB + 2 * 32 MiB, i.e. what amount of the size of the 
> device is allocated for chunks.
> 
> The value one line above is what is allocated inside the chunks.
> 
> I.e. the line in "devid 1" is "total" of btrfs fi df summed up, and the line 
> above is "used" in btrfs fi df summed up. And… with more devices you have more 
> fun.

Why wouldn't btrfs allocate more data chunks from the ample free space?

> I suggest:
> 
> merkaba:~> btrfs fi usage -T /daten


[2/498]mh@fan:~$ sudo btrfs fi usage /mnt/fanbtr
Overall:
    Device size:                 417.19GiB
    Device allocated:            177.06GiB
    Device unallocated:          240.12GiB
    Device missing:                  0.00B
    Used:                        120.23GiB
    Free (estimated):            240.33GiB      (min: 120.27GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:113.00GiB, Used:112.79GiB
   /dev/mapper/fanbtr    113.00GiB

Metadata,DUP: Size:32.00GiB, Used:3.72GiB
   /dev/mapper/fanbtr     64.00GiB

System,DUP: Size:32.00MiB, Used:48.00KiB
   /dev/mapper/fanbtr     64.00MiB

[3/498]mh@fan:~$ sudo btrfs fi usage -T /mnt/fanbtr
Overall:
    Device size:                 417.19GiB
    Device allocated:            177.06GiB
    Device unallocated:          240.12GiB
    Device missing:                  0.00B
    Used:                        120.23GiB
    Free (estimated):            240.33GiB      (min: 120.27GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

                      Data      Metadata System
Id Path               single    DUP      DUP      Unallocated
-- ------------------ --------- -------- -------- -----------
 1 /dev/mapper/fanbtr 113.00GiB 64.00GiB 64.00MiB   240.12GiB
-- ------------------ --------- -------- -------- -----------
   Total              113.00GiB 32.00GiB 32.00MiB   240.12GiB
   Used               112.79GiB  3.72GiB 48.00KiB
[4/499]mh@fan:~$

> (this is actually the situation asking for hung task trouble with kworker 
> threads seeking for free space inside chunks, as no new chunks can be 
> allocated, lets hope kernel 4.4 finally really has fixes for this)

I am running a 4.4.2 kernel on the system in question.

> Adding a new device temporarily, doing the balance and then removing it.

I currently refuse to do this on a 400 GiB device that has more than
half of its capacity free. I do expect a modern filesystem to get out
of that situation without a manual intervention this invasive.

> Before that I´d try to balance the metadata chunks, cause 
> 
> > Metadata, DUP: total=32.00GiB, used=3.72GiB
> 
> 32 GiB chunks allocated, only 3,72 GiB used.

Why would I rebalance metadata if there is less than 20 % used?

[21/504]mh@fan:~$ sudo btrfs balance start -musage=5 /mnt/fanbtr
ERROR: error during balancing '/mnt/fanbtr': No space left on device
There may be more info in syslog - try dmesg | tail
[22/505]mh@fan:~$ sudo btrfs balance start -musage=1 /mnt/fanbtr
Done, had to relocate 56 out of 179 chunks
[23/506]mh@fan:~$ sudo btrfs balance start -musage=1 /mnt/fanbtr
Done, had to relocate 56 out of 179 chunks
[24/506]mh@fan:~$ sudo btrfs balance start -musage=1 /mnt/fanbtr
Done, had to relocate 56 out of 179 chunks
[25/506]mh@fan:~$ sudo btrfs balance start -musage=5 /mnt/fanbtr
Done, had to relocate 56 out of 179 chunks
[26/507]mh@fan:~$ sudo btrfs balance start -musage=50 /mnt/fanbtr
Done, had to relocate 56 out of 179 chunks
[27/508]mh@fan:~$ sudo btrfs balance start -musage=90 /mnt/fanbtr
Done, had to relocate 61 out of 179 chunks
[29/510]mh@fan:~$ sudo btrfs balance start -musage=90 /mnt/fanbtr
ERROR: error during balancing '/mnt/fanbtr': No space left on device
There may be more info in syslog - try dmesg | tail
[30/511]mh@fan:~$ sudo btrfs balance start -musage=90 /mnt/fanbtr
ERROR: error during balancing '/mnt/fanbtr': No space left on device
There may be more info in syslog - try dmesg | tail
[31/511]mh@fan:~$ sudo btrfs fi usage -T /mnt/fanbtr
Overall:
    Device size:                 417.19GiB
    Device allocated:            177.06GiB
    Device unallocated:          240.12GiB
    Device missing:                  0.00B
    Used:                        120.24GiB
    Free (estimated):            240.32GiB      (min: 120.26GiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

                      Data      Metadata System
Id Path               single    DUP      DUP      Unallocated
-- ------------------ --------- -------- -------- -----------
 1 /dev/mapper/fanbtr 113.00GiB 64.00GiB 64.00MiB   240.12GiB
-- ------------------ --------- -------- -------- -----------
   Total              113.00GiB 32.00GiB 32.00MiB   240.12GiB
   Used               112.80GiB  3.72GiB 48.00KiB
[32/512]mh@fan:~$

Why does the number of reallocated chunks not decrease, why does
-musage=90 finish the first time and throw out of space errors on
subsequent invocations, and why doesn't the balance change anything in
btrfs fi usage?

> Maybe that way you can gain more free space to have a full balance run.

Why would i need more free space? there are 240 GiB free!

> Also note that it is not necessary to do a full balance in case everything 
> works okayish.

The filesystem does not look healthy to me.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

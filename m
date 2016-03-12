Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:58194 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbcCLVOj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 16:14:39 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1aeqrt-0007Vq-85
	for linux-btrfs@vger.kernel.org; Sat, 12 Mar 2016 22:14:37 +0100
Date: Sat, 12 Mar 2016 22:14:37 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160312211437.GK2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
> I'd try to use -musage filter alone, in whatever increments work. So
> try 0. Then 5. If 5 fails, try 2. Increment until size is not much
> more than 2-3x used.

Here we go:

[7/506]mh@fan:~$ sudo btrfs balance -usage=0 /media/tempdisk
Done, had to relocate 32 out of 134 chunks
[8/507]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.33GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[9/508]mh@fan:~$ sudo btrfs balance start -musage=0 /media/tempdisk
Done, had to relocate 32 out of 134 chunks
[10/509]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.33GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[11/510]mh@fan:~$ sudo btrfs balance start -musage=0 /media/tempdisk
Done, had to relocate 36 out of 134 chunks
[12/511]mh@fan:~$ sudo btrfs balance fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.33GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[13/512]mh@fan:~$ sudo btrfs balance start -musage=10 /media/tempdisk
Done, had to relocate 41 out of 134 chunks
[14/513]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[15/514]mh@fan:~$ sudo btrfs balance start -musage=20 /media/tempdisk
Done, had to relocate 43 out of 134 chunks
[16/515]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[17/516]mh@fan:~$ sudo btrfs balance start -musage=30 /media/tempdisk
Done, had to relocate 48 out of 134 chunks

real    0m48.604s
user    0m0.008s
sys     0m15.756s
[18/517]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[19/518]mh@fan:~$ time sudo btrfs balance start -musage=40 /media/tempdisk
Done, had to relocate 49 out of 134 chunks

real    0m17.076s
user    0m0.000s
sys     0m5.188s
[20/519]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[21/520]mh@fan:~$ time sudo btrfs balance start -musage=50 /media/tempdisk
Done, had to relocate 49 out of 134 chunks

real    0m11.536s
user    0m0.004s
sys     0m3.512s
[22/521]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[23/522]mh@fan:~$ time sudo btrfs balance start -musage=60 /media/tempdisk
Done, had to relocate 49 out of 134 chunks

real    0m4.485s
user    0m0.008s
sys     0m0.664s
[24/523]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[25/524]mh@fan:~$ time sudo btrfs balance start -musage=70 /media/tempdisk
Done, had to relocate 50 out of 134 chunks

real    0m16.581s
user    0m0.012s
sys     0m5.456s
[26/525]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=26.50GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=3.33MiB
[27/526]mh@fan:~$ time sudo btrfs balance start -musage=80 /media/tempdisk
ERROR: error during balancing '/media/tempdisk': No space left on device
There may be more info in syslog - try dmesg | tail

real    0m16.775s
user    0m0.004s
sys     0m5.800s
[28/527]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=26.50GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=33.69MiB
[29/528]mh@fan:~$ time sudo btrfs balance start -musage=75 /media/tempdisk
ERROR: error during balancing '/media/tempdisk': No space left on device
There may be more info in syslog - try dmesg | tail

real    0m4.363s
user    0m0.004s
sys     0m0.600s
[30/529]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
[31/530]mh@fan:~$ time sudo btrfs balance start -musage=74 /media/tempdisk
Done, had to relocate 50 out of 134 chunks

real    0m4.546s
user    0m0.000s
sys     0m0.620s
[32/531]mh@fan:~$ sudo btrfs fi df /media/tempdisk/
Data, single: total=79.00GiB, used=78.32GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=27.00GiB, used=2.30GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

So one does not see a decrease in total Metadata size until -musage
has gone up to 70, then it decreases by half a gig. -musage=75 is the
first musage value that leads to the ENOSPC condition, with total
Metadata size going up to 27 GiB again, and -musage=74 being the
biggest musage value that finishs without ENOSPC, but no visible
decrease of total Metadata size.

Greetings
Marc


-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421

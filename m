Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36082 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbcDZQTC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 12:19:02 -0400
Received: by mail-lf0-f49.google.com with SMTP id u64so21875202lff.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 09:19:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <nfb2hr$6i0$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org>
	<57148B2E.6010904@cn.fujitsu.com>
	<nf73cv$7vh$1@ger.gmane.org>
	<571871FC.2010101@jp.fujitsu.com>
	<CAPmG0jZd7AaH+u52_gqBmke-3S=yH_i9Pmk1R=mOFmdnsj6BgQ@mail.gmail.com>
	<nfb2hr$6i0$1@ger.gmane.org>
Date: Tue, 26 Apr 2016 18:19:00 +0200
Message-ID: <CAPmG0jY5RRS_8YcECyCts6BEeJKT+74Uxr-2kitouruyBDwgfQ@mail.gmail.com>
Subject: Re: Question: raid1 behaviour on failure
From: Henk Slager <eye1tm@gmail.com>
To: Matthias Bodenbinder <matthias@bodenbinder.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 21, 2016 at 7:27 PM, Matthias Bodenbinder
<matthias@bodenbinder.de> wrote:
> Am 21.04.2016 um 13:28 schrieb Henk Slager:
>>> Can anyone explain this behavior?
>>
>> All 4 drives (WD20, WD75, WD50, SP2504C) get a disconnect twice in
>> this test. What is on WD20 is unclear to me, but the raid1 array is
>> {WD75, WD50, SP2504C}
>> So the test as described by Matthias is not what actually happens.
>> In fact, the whole btrfs fs is 'disconnected on the lower layers of
>> the kernel' but there is no unmount.  You can see the scsi items go
>> from 8?.0.0.x to
>> 9.0.0.x to 10.0.0.x. In the 9.0.0.x state, the tools show then 1 dev
>> missing (WD75), but in fact the whole fs state is messed up. So as
>> indicated by Anand already, it is a bad test and it is what one can
>> expect from an unpatched 4.4.0 kernel. ( I'm curious to know how md
>> raidX would handle this ).
>>
>> a) My best guess is that the 4 drives are in a USB connected drivebay
>> and that Matthias unplugged WD75 (so cut its power and SATA
>> connection), did the file copy trial and then plugged in the WD75
>> again into the drivebay. The (un)plug of a harddisk is then assumed to
>> trigger a USB link re-init by the chipset in the drivebay.
>>
>> b) Another possibility is that due to (un)plug of WD75 cause the host
>> USB chipset to re-init the USB link due to (too big?) changes in
>> electrical current. And likely separate USB cables and maybe some
>> SATA.
>>
>> c) Or some flaw in the LMDE2 distribution in combination with btrfs. I
>> don't what is in the  linux-image-4.4.0-0.bpo.1-amd64
>>
>
> Just to clarify my setup. I HDs are mounted into a FANTEC QB-35US3-6G case. According to the handbook it has "Hot-Plug for  USB / eSATA interface".
>
> It is equipped with 4 HDs. 3 of them are part of the raid1. The fourth HD is a 2 TB device with ext4 filesystem and no relevance for this thread.

It looks like a JMS567 + SATA port multipliers behaind it are used in
this drivebay. The command   lsusb -v  could show that. So your HW
setup is like JBOD, not RAID.

IMHO, using such a setup for software RAID (like btrfs RAID1)
fundamentally violates the concept of RAID (redundant array of
independent disks). It depends on where you define the system border
of the (independent) disks.
If it is at:

A) the 4 (or 3 disk in this case) SATA+power interfaces inside the drivebay or

B) inside the PC's chipset.

In case A) there is a shared removable link (USB) inside the
filesystem processing machine.
In case B) the disks aren't really independent as they share a
removable link (and as proven by the (un)plug of 1 device affecting
all others).

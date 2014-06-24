Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59856 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaFXEte (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 00:49:34 -0400
Received: by mail-qc0-f169.google.com with SMTP id c9so7027310qcz.14
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 21:49:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
 <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
 <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Tue, 24 Jun 2014 00:49:13 -0400
Message-ID: <CAB=7dhm=rj4wQF5CE1FNKXKMnrcXkJWYYkLqvf0WnzaM810qkA@mail.gmail.com>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Of course it could just be a bug so it's worth trying David's integration branch.
>
>I'll try that shortly.
>
>>         * Firmware Version: 0006
>>
>> Firmware 0007 is current for this SSD.
>
>I assume that's probably not something I should mess with right now
though, right?
>
>>  6  0x008  4             9821  Number of Hardware Resets
>>
>> Why is the hardware being reset so many times?
>
>What exactly is that stat measuring? This is a 3 year old laptop with
>a 3 year old SSD. The whole system certainly gets restarted more often
>than a desktop or server would, but not an average of 9 times a day.
>Probably not even a maximum of 9 times a day. Could that reset be
>something related to acpi?

Actually, now that I think about it, that may be related to the errors
I saw months ago. I had some bad blocks or something, and when the
system attempted to access them I would get a bunch of errors in the
logs. I believe one of the things the system would do was attempt to
reset the drive connection (maybe multiple times). So that could have
driven that number up substantially. The "Lifetime Power-On Resets" is
only 1033, which seems about right for the age of the drive.

I zeroed out the drive and ran every smartctl test on it I could find
and it never threw any more errors. I really pounded it, a good solid
week or so of scans and data writes. Finally decided that perhaps
those blocks went bad but didn't get properly marked as bad and
removed from active duty until I zeroed everything out.

Whatever the underlying issue was this time, I don't think it's
exactly the same, because in that previous scenario the problem blocks
would consistently throw errors. I couldn't get a clean dd image of
the drive. I had to use ddrescue and live with a few small gaps. But I
was still able to mount that rescued image (it was ext4) and get
pretty much all of the data back. This time I'm encountering no read
errors at the drive level and had no trouble creating the dd image.

I'll see if I can track down any of the smartctl results from back
then and compare the "Number of Hardware Resets" value, as well as
UDMA_CRC_Error_Count.

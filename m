Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33305 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbcDBFnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Apr 2016 01:43:47 -0400
Received: by mail-ig0-f182.google.com with SMTP id ma7so17497865igc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Apr 2016 22:43:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$68f59$f32b7e2a$86338be2$5ab70cec@cox.net>
References: <20160401134029.GH9342@torres.zugschlus.de>
	<pan$68f59$f32b7e2a$86338be2$5ab70cec@cox.net>
Date: Fri, 1 Apr 2016 23:43:46 -0600
Message-ID: <CAJCQCtR8RNJddBXAcTsbFN51YrwEDSz2Get45oQyJsP3o6xS-w@mail.gmail.com>
Subject: Re: Another ENOSPC situation
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 1, 2016 at 10:55 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Marc Haber posted on Fri, 01 Apr 2016 15:40:29 +0200 as excerpted:

>> [4/502]mh@swivel:~$ sudo btrfs fi usage /
>> Overall:
>>     Device size:                 600.00GiB
>>     Device allocated:            600.00GiB
>>     Device unallocated:            1.00MiB
>
> That's the problem right there.  The admin didn't do his job and spot the
> near full allocation issue


I don't yet agree this is an admin problem. This is the 2nd or 3rd
case we've seen only recently where there's plenty of space in all
chunk types and yet ENOSPC happens, seemingly only because there's no
unallocated space remaining. I don't know that this is a regression
for sure, but it sure seems like one.



>>
>> Data,single: Size:553.93GiB, Used:405.73GiB
>>    /dev/mapper/swivelbtr         553.93GiB
>>
>> Metadata,DUP: Size:23.00GiB, Used:3.83GiB
>>    /dev/mapper/swivelbtr          46.00GiB
>>
>> System,DUP: Size:32.00MiB, Used:112.00KiB
>>    /dev/mapper/swivelbtr          64.00MiB
>>
>> Unallocated:
>>    /dev/mapper/swivelbtr           1.00MiB
>> [5/503]mh@swivel:~$
>
> Both data and metadata have several GiB free, data ~140 GiB free, and
> metadata isn't into global reserve, so the system isn't totally wedged,
> only partially, due to the lack of unallocated space.

Unallocated space alone hasn't ever caused this that I can remember.
It's most often been totally full metadata chunks, with free space in
allocated data chunks, with no unallocated space out of which to
create another metadata chunk to write out changes.

There should be plenty of space for either a -dusage=1 or -musage=1
balance to free up a bunch of partially allocated chunks. Offhand I
don't think the profiles filter is helpful in this case.

OK so where I could be wrong is that I'm expecting balance doesn't
require allocated space to work. I'd expect that it can COW extents
from one chunk into another existing chunk (of the same type) and then
once that's successful, free up that chunk, i.e. revert it back to
unallocated. If balance can only copy into newly allocated chunks,
that seems like a big problem. I thought that problems had been fixed
a very long time ago.

And what we don't see from 'usage' that we will see from 'df' is the
GlobalReserve values. I'd like to see that.

Anyway, in the meantime there is a work around:

btrfs dev add

Just add a device, even if it's an 8GiB flash drive. But it can be a
spare space on a partition, or it can be a logical volume, or whatever
you want. That'll add some gigs of unallocated space. Now the balance
will work, or for absolutely sure there's a bug (and a new one because
this has always worked in the past). After whatever filtered or full
balance is done, make sure to 'btfs dev rem' and confirm it's gone
with 'btrfs fi show' before removing the device. It's a two device
volume until that device is successfully removed and is in something
of a fragile state until then because any loss of data on that 2nd
device has a good chance of face planting the file system.



-- 
Chris Murphy

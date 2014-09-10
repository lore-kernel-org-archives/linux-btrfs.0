Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:45020 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaIJWWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 18:22:18 -0400
Message-ID: <5410D0A8.6040204@inwind.it>
Date: Thu, 11 Sep 2014 00:28:56 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Sean Greenslade <sean@seangreenslade.com>
CC: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
References: <541043B8.7010601@barrowhillfarm.org.uk> <54109BCD.5000106@inwind.it> <20140910193212.GA2549@wheatley.student.rit.edu>
In-Reply-To: <20140910193212.GA2549@wheatley.student.rit.edu>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/10/2014 09:32 PM, Sean Greenslade wrote:
> On Wed, Sep 10, 2014 at 08:43:25PM +0200, Goffredo Baroncelli wrote:
>> May be that I am missing something obvious, however I have to ask which 
>> would be the purpose to balance a two disks RAID1 system.
>> The balance command should move the data between the disks in order to
>> avoid some disk full and other empty; but this assume that there is a
>> not symmetrical uses of the disks. Which is not the case for a RAID1/two
>> disks system.
> 
> Balancing is not necessarily about data distribution between two disks.
> You can balance a single disk BTRFS partition. It's more about balancing
> how the data / metadata chunks are allocated and used. It also (during a
> re-write of a chunk) honors the RAID rules of that chunk type.

True, I forgot that you can balance across the chunk
> 
>> *scrub
>> Regarding scrub, pay attention that some (consumer) disks are 
>> guarantee for a (not recoverable) error rate less than 1/10^14 [1] 
>> bit reads. 10^14 bit are something like 10TB. This means that if you 
>> read your system 5 times, you may got an error bit. I suppose 
>> that these are very conservative number, so the likelihood of an 
>> undetected error is (I hope)lower. But also I am inclined to think 
>> these number are evaluated in an ideal case (in term of temperature, 
>> voltage, vibration); this means that the true might be worse.
>>
>> So if you compare these numbers with your average throughput, 
>> you can estimate which is the likelihood of an error. Pay attention
>> that a scrub job means read all your data: If you have 1T of data,
>> and you performs a scrub each week, in three months you reach the 10^14
>> bit reads.....
>>
>> This explains the interest in higher redundancy level (raid 6 or more).
>>  
>> G.Baroncelli
> 
> I think there is a bit of misunderstanding here. Those disk error rates
> are latent media errors. They're a function of production quality of the
> platters and the amount of time the data rests on the drive. Reads do
> not affect this, and in fact, can actually help reduce the error rate. 

The WD datasheet says something different. It reports "Non-recoverable 
read errors per bits read" less than 1/10^14. They express the number of 
error in terms of number of bit reading.

You instead are saying that the error depends by the disk age.

These two sentence are very different.

( and of course all these values depend also by the product quality).
 
> When a hard drive does a read, it also reads the CRC values for the
> sector that it just read. If it matches, the drive passes it on as good
> data. If not, it attempts error correction on it. If it can correct the
> error, it will return the corrected data and (hopefully) re-write the
> data on the disk to fix the error "permanently." I use quotes because
> this could mean that that zone of media is damaged, and it will probably
> error again. The disk will eventually re-allocate a sector that
> repeatedly returns bad data. This is what you want to happen.

I think that there is two source of error:
- a platter/disk degradation (due to ageing, wearing...), which may require a 
sector relocation
- other sources of error which are not permanent and that may be corrected
by a 2nd read

I don't have any idea about which one is bigger (even I suspect the second).

> So doing reads, especially across the entire media surface, is a great
> way to make the disk perform these sector checks. But sometimes the disk
> cannot correct the error. 

I read this as: the error rate is greater than 1/10^14, but the CRC and
some multiple reading and sector remapping lower the error rate below 1/10^14.

If behind this there are a "dumb" drive which returns an error as soon as 
the CRC doesn't match, or a smart drive which retries several time until
it got a good value doesn't matter: the error rate is still 1/10^14.

> Then the controller (if it is well-behaved)
> will return a read error, or sometimes just bunk data. If the BTRFS
> scrub sees bad data, it will detect it with its checksums, and if in a
> RAID configuration, be able to locate a good copy of the data to
> restore. 
 
> Long story short, reads don't cause media errors, and scrubs help detect
> errors early.

Nobody told that a reading "cause" a media "error"; however assuming (this is how
I read the WD datasheet) the error rate constant, if you increase the number 
of reading then you have more errors.

May be that I was not clear, however I didn't want to say that "scrubbing reduces 
the life of disk", I wanted to point out that the size of the disk and the error
rate are becoming comparable.

> 
> --Sean
> 
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

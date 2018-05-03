Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34275 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbeECL2e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 May 2018 07:28:34 -0400
Received: by mail-io0-f182.google.com with SMTP id p124-v6so21211260iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 May 2018 04:28:34 -0700 (PDT)
Subject: Re: RAID56 - 6 parity raid
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Goffredo Baroncelli <kreijack@inwind.it>, waxhead@dirtcellar.net,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
 <99e79113-39ac-e67e-ff22-bfcfcdac00bc@gmail.com>
 <CAA91j0WbzCPkqhJc6T8M+MbuRD0KX=AtL3dSOck9Q3Y-TfkGVQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <595126ac-253a-2631-6097-41c62c98b4a3@gmail.com>
Date: Thu, 3 May 2018 07:28:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAA91j0WbzCPkqhJc6T8M+MbuRD0KX=AtL3dSOck9Q3Y-TfkGVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-03 04:11, Andrei Borzenkov wrote:
> On Wed, May 2, 2018 at 10:29 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> ...
>>
>> Assume you have a BTRFS raid5 volume consisting of 6 8TB disks (which gives
>> you 40TB of usable space).  You're storing roughly 20TB of data on it, using
>> a 16kB block size, and it sees about 1GB of writes a day, with no partial
>> stripe writes.  You, for reasons of argument, want to scrub it every week,
>> because the data in question matters a lot to you.
>>
>> With a decent CPU, lets say you can compute 1.5GB/s worth of checksums, and
>> can compute the parity at a rate of 1.25G/s (the ratio here is about the
>> average across the almost 50 systems I have quick access to check, including
>> a number of server and workstation systems less than a year old, though the
>> numbers themselves are artificially low to accentuate the point here).
>>
>> At this rate, scrubbing by computing parity requires processing:
>>
>> * Checksums for 20TB of data, at a rate of 1.5GB/s, which would take 13333
>> seconds, or 222 minutes, or about 3.7 hours.
>> * Parity for 20TB of data, at a rate of 1.25GB/s, which would take 16000
>> seconds, or 267 minutes, or roughly 4.4 hours.
>>
>> So, over a week, you would be spending 8.1 hours processing data solely for
>> data integrity, or roughly 4.8214% of your time.
>>
>> Now assume instead that you're doing checksummed parity:
>>
>> * Scrubbing data is the same, 3.7 hours.
>> * Scrubbing parity turns into computing checksums for 4TB of data, which
>> would take 3200 seconds, or 53 minutes, or roughly 0.88 hours.
> 
> Scrubbing must compute parity and compare with stored value to detect
> write hole. Otherwise you end up with parity having good checksum but
> not matching rest of data.
Yes, but that assumes we don't do anything to deal with the write hole, 
and it's been pretty much decided by the devs that they're going to try 
and close the write hole.


Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34597 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbeCNMCN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 08:02:13 -0400
Received: by mail-io0-f182.google.com with SMTP id e7so4093597ioj.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 05:02:13 -0700 (PDT)
Subject: Re: Ongoing Btrfs stability issues
To: kreijack@inwind.it, Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
 <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
 <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
 <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
 <5a12a7b7-6cf3-82f8-d5fa-2915fc3d6680@suse.com>
 <1520692153.24363.15.camel@scientia.net>
 <01ddb562-f1e2-25cf-0a8a-ffaa43b867d3@libero.it>
 <1520807872.4281.11.camel@scientia.net>
 <3fd8f21b-2e4d-3696-8e92-a20e4dda13ec@inwind.it>
 <1520891338.4266.16.camel@scientia.net>
 <d6e007af-7980-3d9b-a497-acb3be90dac9@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <96d34674-b1f0-25db-ba36-5a48f1b7c047@gmail.com>
Date: Wed, 14 Mar 2018 08:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <d6e007af-7980-3d9b-a497-acb3be90dac9@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-13 15:36, Goffredo Baroncelli wrote:
> On 03/12/2018 10:48 PM, Christoph Anton Mitterer wrote:
>> On Mon, 2018-03-12 at 22:22 +0100, Goffredo Baroncelli wrote:
>>> Unfortunately no, the likelihood might be 100%: there are some
>>> patterns which trigger this problem quite easily. See The link which
>>> I posted in my previous email. There was a program which creates a
>>> bad checksum (in COW+DATASUM mode), and the file became unreadable.
>> But that rather seems like a plain bug?!
> 
> You are right, unfortunately it seems that it is catalogate as WONT-FIX :(
> 
>> No reason that would conceptually make checksumming+notdatacow
>> impossible.
>>
>> AFAIU, the conceptual thin would be about:
>> - data is written in nodatacow
>>    => thus a checksum must be written as well, so write it
>> - what can then of course happen is
>>    - both csum and data are written => fine
>>    - csum is written but data not and then some crash => csum will show
>>      that => fine
>>    - data is written but csum not and then some crash => csum will give
>>      false positive
>>
>> Still better few false positives, as many unnoticed data corruptions
>> and no true raid repair.
> 
> A checksum mismatch, is returned as -EIO by a read() syscall. This is an event handled badly by most part of the programs.
> I.e. suppose that a page of a VM ram image file has a wrong checksum. When the VM starts, tries to read the page, got -EIO and aborts. It is even possible that it could not print which page is corrupted. In this case, how the user understand the problem, and what he could do ?
Check the kernel log on the host system, which should have an error 
message saying which block failed.  If the VM itself actually gets to 
the point of booting into an OS (and properly propagates things like 
-EIO to the guest environment like it should), that OS should also log 
where the error was.

Most of the reason user applications don't tell you where the error was 
is because the kernel already does it on any sensible system, and the 
kernel tells you _exactly_ where the error was (exact block and device 
that threw the error), which user applications can't really do (they 
generally can't get sufficiently low-level information to give you all 
the info the kernel does).
> 
>>
>>> Again, you are assuming that the likelihood of having a bad checksum
>>> is low. Unfortunately this is not true. There are pattern which
>>> exploits this bug with a likelihood=100%.
>>
>> Okay I don't understand why this would be so and wouldn't assume that
>> the IO pattern can affect it heavily... but I'm not really btrfs
>> expert.
>>
>> My blind assumption would have been that writing an extent of data
>> takes much longer to complete than writing the corresponding checksum.
> 
> The problem is the following: there is a time window between the checksum computation and the writing the data on the disk (which is done at the lower level via a DMA channel), where if the data is update the checksum would mismatch. This happens if we have two threads, where the first commits the data on the disk, and the second one updates the data (I think that both VM and database could behave so).
Though it only matters if you use O_DIRECT or the files in question are 
NOCOW.
> 
> In btrfs, a checksum mismatch creates an -EIO error during the reading. In a conventional filesystem (or a btrfs filesystem w/o datasum) there is no checksum, so this problem doesn't exist.
> 
> I am curious how ZFS solves this problem.
It doesn't support disabling COW or the O_DIRECT flag, so it just never 
has the problem in the first place.
> 
> However I have to point out that this problem is not solved by the COW. COW solved only the problem about an interrupted commit of the filesystem, where the data is update in place (so it is available by the user), but the metadata not.
COW is irrelevant if you're bypassing it.  It's only enforced for 
metadata so that you don't have to check the FS every time you mount it 
(because the way BTRFS uses it guarantees consistency of the metadata).
> 
>>
>> Even if not... I should be only a problem in case of a crash during
>> that,.. and than I'd still prefer to get the false positive than bad
>> data.
> 
> How you can know if it is a "bad data" or a "bad checksum" ?
You can't directly.  Just like you can't know which copy in a two-device 
MD RAID1 array is bad when they mismatch.

That's part of why I'm not all that fond of the idea of having checksums 
without COW, you need to verify the data using secondary means anyway, 
so why exactly should you waste time verifying it twice?
> 
>>
>> Anyway... it's not going to happen so the discussion is pointless.
>> I think people can probably use dm-integrity (which btw: does no CoW
>> either (IIRC) and still can provide integrity... ;-) ) to see whether
>> their data is valid.
>> No nice but since it won't change on btrfs, a possible alternative.
> 
> Even in this case I am curious about dm-integrity would sole this issue.
dm-integrity uses journaling, and actually based on the testing I've 
done, will typically have much worse performance than the overhead of 
just enabling COW on files on BTRFS and manually defragmenting them on a 
regular basis.

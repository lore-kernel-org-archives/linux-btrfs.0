Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([213.209.14.36]:48228 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752402AbeCMTg2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 15:36:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Ongoing Btrfs stability issues
To: Christoph Anton Mitterer <calestyo@scientia.net>
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
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <d6e007af-7980-3d9b-a497-acb3be90dac9@inwind.it>
Date: Tue, 13 Mar 2018 20:36:25 +0100
MIME-Version: 1.0
In-Reply-To: <1520891338.4266.16.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/12/2018 10:48 PM, Christoph Anton Mitterer wrote:
> On Mon, 2018-03-12 at 22:22 +0100, Goffredo Baroncelli wrote:
>> Unfortunately no, the likelihood might be 100%: there are some
>> patterns which trigger this problem quite easily. See The link which
>> I posted in my previous email. There was a program which creates a
>> bad checksum (in COW+DATASUM mode), and the file became unreadable.
> But that rather seems like a plain bug?!

You are right, unfortunately it seems that it is catalogate as WONT-FIX :(

> No reason that would conceptually make checksumming+notdatacow
> impossible.
> 
> AFAIU, the conceptual thin would be about:
> - data is written in nodatacow
>   => thus a checksum must be written as well, so write it
> - what can then of course happen is
>   - both csum and data are written => fine
>   - csum is written but data not and then some crash => csum will show
>     that => fine
>   - data is written but csum not and then some crash => csum will give
>     false positive
> 
> Still better few false positives, as many unnoticed data corruptions
> and no true raid repair.

A checksum mismatch, is returned as -EIO by a read() syscall. This is an event handled badly by most part of the programs. 
I.e. suppose that a page of a VM ram image file has a wrong checksum. When the VM starts, tries to read the page, got -EIO and aborts. It is even possible that it could not print which page is corrupted. In this case, how the user understand the problem, and what he could do ?


[....]

> 
>> Again, you are assuming that the likelihood of having a bad checksum
>> is low. Unfortunately this is not true. There are pattern which
>> exploits this bug with a likelihood=100%.
> 
> Okay I don't understand why this would be so and wouldn't assume that
> the IO pattern can affect it heavily... but I'm not really btrfs
> expert.
> 
> My blind assumption would have been that writing an extent of data
> takes much longer to complete than writing the corresponding checksum.

The problem is the following: there is a time window between the checksum computation and the writing the data on the disk (which is done at the lower level via a DMA channel), where if the data is update the checksum would mismatch. This happens if we have two threads, where the first commits the data on the disk, and the second one updates the data (I think that both VM and database could behave so).

In btrfs, a checksum mismatch creates an -EIO error during the reading. In a conventional filesystem (or a btrfs filesystem w/o datasum) there is no checksum, so this problem doesn't exist. 

I am curious how ZFS solves this problem.

However I have to point out that this problem is not solved by the COW. COW solved only the problem about an interrupted commit of the filesystem, where the data is update in place (so it is available by the user), but the metadata not.


> 
> Even if not... I should be only a problem in case of a crash during
> that,.. and than I'd still prefer to get the false positive than bad
> data.

How you can know if it is a "bad data" or a "bad checksum" ?


> 
> 
> Anyway... it's not going to happen so the discussion is pointless.
> I think people can probably use dm-integrity (which btw: does no CoW
> either (IIRC) and still can provide integrity... ;-) ) to see whether
> their data is valid.
> No nice but since it won't change on btrfs, a possible alternative.

Even in this case I am curious about dm-integrity would sole this issue.

> 
> 
> Cheers,
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

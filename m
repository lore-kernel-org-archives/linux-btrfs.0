Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33370 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753719AbeBVMls (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 07:41:48 -0500
Received: by mail-io0-f170.google.com with SMTP id n7so5894125iob.0
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Feb 2018 04:41:48 -0800 (PST)
Subject: Re: Status of FST and mount times
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "Ellis H. Wilson III" <ellisw@panasas.com>,
        linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
 <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
 <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
 <bcb18a10-3e87-66f7-63a4-b6f9906680ec@panasas.com>
 <93a21379-bb9b-7f44-a6b1-36b93ba0f926@mendix.com>
 <baa3898d-d636-012b-3262-8984006ee146@panasas.com>
 <32e974f6-3238-eae3-65d4-a2e748c72c3f@mendix.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <703e7894-00da-86d0-39dc-13518db81d9e@gmail.com>
Date: Thu, 22 Feb 2018 07:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <32e974f6-3238-eae3-65d4-a2e748c72c3f@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-21 10:56, Hans van Kranenburg wrote:
> On 02/21/2018 04:19 PM, Ellis H. Wilson III wrote:
>>
>> $ sudo btrfs fi df /mnt/btrfs
>> Data, single: total=3.32TiB, used=3.32TiB
>> System, DUP: total=8.00MiB, used=384.00KiB
>> Metadata, DUP: total=16.50GiB, used=15.82GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Ah, so allocated data space is 100% filled with data. That's very good
> yes. And it explains why you can't lower the amount of chunks by
> balancing. You're just moving around data and replacing full chunks with
> new full chunks. :]
> 
> Doesn't explain why it blows up the size of the extent tree though. I
> have no idea why that is.
This is just a guess, but I think it might have reordered extents within 
each chunk.  Any given extent can't span across a chunk boundary, so if 
the order changed, it may have split extents that had previously been 
full extents.  I'd be somewhat curious to see if defragmenting might 
help here (it should re-combine the split extents, though it will 
probably allocate a new chunk).


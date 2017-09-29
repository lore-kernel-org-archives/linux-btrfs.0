Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:47888 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdI2Lah (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 07:30:37 -0400
Received: by mail-it0-f67.google.com with SMTP id 85so1843142ith.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 04:30:37 -0700 (PDT)
Subject: Re: [PATCH v3 07/14] btrfs-progs: Doc/mkfs: Add extra condition for
 rootdir option
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz, kreijack@inwind.it,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170918072139.6300-8-quwenruo.btrfs@gmx.com>
 <7cec48bd-c007-618f-b361-d4425c757c5c@oracle.com>
 <trinity-eef9a61f-60ab-47a3-9771-d638cb0083c9-1506076766926@3c-app-mailcom-bs16>
 <9f598cb9-0267-158d-c54b-13f4372eadd5@gmail.com>
 <9652f4f4-b91c-0382-fa2a-01d45dde7fbb@gmx.com>
 <5e079410-cd64-3d40-8914-b3d48ecdebfd@gmail.com>
 <808d11d8-f22b-f26e-ba3f-7d148915db5a@gmx.com>
 <5b26f9dd-8bae-a35a-4920-4a617b52f9f7@oracle.com>
 <c0652f30-5ca7-b917-7f15-78dfdb2e1205@libero.it>
 <7af34399-f969-dfe5-d006-3e7fb293b9df@gmail.com>
 <20170927162032.GM31640@twin.jikos.cz>
 <287aaa56-f2a2-d44c-1068-ec6f87b7a2f3@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <581b42dc-eb3b-f3fa-b9d4-0a7868ca1d60@gmail.com>
Date: Fri, 29 Sep 2017 07:30:31 -0400
MIME-Version: 1.0
In-Reply-To: <287aaa56-f2a2-d44c-1068-ec6f87b7a2f3@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-27 20:00, Qu Wenruo wrote:
> 
> 
> On 2017年09月28日 00:20, David Sterba wrote:
>> On Mon, Sep 25, 2017 at 07:15:30AM -0400, Austin S. Hemmelgarn wrote:
>>> On 2017-09-24 10:08, Goffredo Baroncelli wrote:
>>>> On 09/24/2017 12:10 PM, Anand Jain wrote:
>>
>> A lot of points in this thread, let me address them here.
>>
>> I don't want to remove --rootdir functionality, the fix that's being
>> proposed removes the minimalization -- feature that was not well known,
>> but I understand it's useful (and already used).
>>
>> I'd like to fix that in another way, eg. as an option to mkfs or a
>> separate tool.
>>
>> I'm not worried about adding more code or code complexity. If we do it
>> right it's not a problem in the long run. But people for some reason
>> like to delete other people's code or functionality.
>>
>> Regarding guessing number of users, this is always hard. So if there's
>> one vocal enough to let us know about the usecase, it's IMHO good time
>> to explore the it, code-wise and documentation-wise, and fix it or
>> improve.
>>
>> So, what next. I'd like to get rid of the custom chunk allocator, namely
>> because of the known 1MB area misuse and duplication.
>>
>> Implementing the minimalization might need some preparatory work and I
>> don't have a realistic ETA now.
> 
> Well, if using over-reserve-then-shrink method, it could be done, 
> without much hassle.
It _should_ be possible to compute the exact size required though.  As 
outlined in one of my other replies, an absolute minimal filesystem 
should in theory consist of the following space usage:
1. 1MB (for the reserved space at the beginning).
2. However many superblocks it should have given the size.
3. The total amount of file data and extended attribute data to be 
included, rounding up for block size
4. The exact amount of metadata space needed to represent the tree from 
3, also rounding up for block size.
5. The exact amount of system chunk space needed to handle 3 and 4, plus 
enough room to allocate at least one more chunk of each type (to 
ultimately allow for resizing the filesystem if desired).
6. Exactly enough reserved metadata space to resize the FS 
(alternatively, the standard space for the GlobalReserve, which should 
be enough and then some).

Computing this is non-trivial for a human, and even with a computer 
requires knowledge of how the chunk allocator is implemented.  mkfs 
should have that knowledge though, so in theory it is reasonably well 
positioned to just compute this, allocate that much space, and then 
generate the filesystem.  The complaints I have about trying to do this 
manually in two passes are that:
1. Computing the above by hand is not easy.
2. Computing it by hand and then running mkfs on the resultant file 
doesn't work most of the time.

As a result, I would think this could easily be handled in the following 
steps:
1. Scan the contents of the --rootdir option to determine total size needed.
2. Compute the required allocation and allocate it.
3. Generate the filesystem image.

This has an inherent TOCTOU race, but it's one that a lot of archiving 
tools (tar being a prime example) already have, and it's not likely that 
people will hit it since you're not likely to be using a changing 
directory for --rootdir.
> 
> However ETA maybe delayed to middle of Oct, as I'm going to enjoy my 
> holiday during 1st Oct to 7th Oct.
Entirely understandable, enjoy your time off!


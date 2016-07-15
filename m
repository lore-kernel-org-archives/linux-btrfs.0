Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17522 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751054AbcGOPV3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 11:21:29 -0400
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5:
 take two
To: Andrei Borzenkov <arvidjaar@gmail.com>, <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
 <a0538df6-7e25-fae8-8ebd-b18120a1c516@fb.com> <578868EE.2030108@gmail.com>
 <2af4a9cc-bf09-680c-1743-530e521677b2@fb.com> <5788FCF4.2010908@gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <770b476b-ccc1-cd2f-384f-36af8f3ec7c0@fb.com>
Date: Fri, 15 Jul 2016 11:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <5788FCF4.2010908@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/15/2016 11:10 AM, Andrei Borzenkov wrote:
> 15.07.2016 16:20, Chris Mason пишет:
>>>>
>>>> Interesting, thanks for taking the time to write this up.  Is the
>>>> failure specific to scrub?  Or is parity rebuild in general also failing
>>>> in this case?
>>>>
>>>
>>> How do you rebuild parity without scrub as long as all devices appear to
>>> be present?
>>
>> If one block is corrupted, the crcs will fail and the kernel will
>> rebuild parity when you read the file.  You can also use balance instead
>> of scrub.
>>
>
> As we have seen recently, btrfs does not compute, stores or verifies
> checksum of RAID56 parity. So if parity is corrupted, the only way to
> detect and correct it is to use scrub. Balance may work by side effect,
> because it simply recomputes parity on new data, but it will not fix
> wrong parity on existing data.

Ah, I misread your question  Yes, this is definitely where scrub is the 
best tool.  But even if we have to add debugging to force parity 
recomputation, we should see if the problem is only in scrub or deeper.

-chris

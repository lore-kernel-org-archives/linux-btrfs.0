Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32115 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934311AbaGXUFV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 16:05:21 -0400
Message-ID: <53D166C6.2070403@fb.com>
Date: Thu, 24 Jul 2014 16:04:22 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: <linux-btrfs@vger.kernel.org>, Cody P Schafer <dev@codyps.com>,
        Marc MERLIN <marc@merlins.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
References: <1502954.OtX3SzjMKZ@merkaba> <1809953.ithLVmijbn@merkaba> <53D11F2B.1070008@fb.com> <1557956.045aK4K0qS@merkaba>
In-Reply-To: <1557956.045aK4K0qS@merkaba>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/24/2014 02:49 PM, Martin Steigerwald wrote:
> Am Donnerstag, 24. Juli 2014, 10:58:51 schrieb Chris Mason:
>> On 07/23/2014 06:47 PM, Martin Steigerwald wrote:
>>> Am Dienstag, 15. Juli 2014, 17:08:27 schrieb Martin Steigerwald:
>>>> Am Dienstag, 15. Juli 2014, 09:21:40 schrieb Chris Mason:
>>>>> On 07/14/2014 05:58 PM, Martin Steigerwald wrote:
>>>>>> Am Montag, 14. Juli 2014, 16:12:22 schrieb Chris Mason:
>>>>>>> On 07/14/2014 11:10 AM, Martin Steigerwald wrote:
>>>>>>>> Am Montag, 14. Juli 2014, 17:04:22 schrieben Sie:
>>>>>>>>> Hi!
>>>>>>>>>
>>>>>>>>> While with 3.16-rc3 and rc4 I didn´t have a BTRFS hang in several
>>>>>>>>> days
>>>>>>>>> of
>>>>>>>>> usage, with 3-16-rc5 I had a hang again. Less than a hour since
>>>>>>>>> booting
>>>>>>>>> it.
>>>>>>>>>
>>>>>>>>> Since the hang bug I and others had with 3.15 and upto 3.16-rc2
>>>>>>>>> usually
>>>>>>>>> didn´t happen that quickly after boot and since backtrace looks a
>>>>>>>>> bit
>>>>>>>>> different from what I have in memory, I post this in a new thread.
>>>>>>>>> See thread "Blocked tasks on 3.15.1" for a discussion of previous
>>>>>>>>> hang
>>>>>>>>> issues.
>>>>>>>>
>>>>>>>> Probably good to add some basic information on the filesystem:
>>>>>>> Do you have compression enabled?  I wasn't able to nail down the
>>>>>>> 3.15.1
>>>>>>> hang before vacation attacked me, but I'm hoping to track it down
>>>>>>> today.
>>>>>>
>>>>>> Yes. I have.
>>>>>>
>>>>>> It just hung again while I was playing PlaneShift.
>>>>>>
>>>>>> Back to 3.16-rc4 as rc5 seems to be broke here.
>>>>>
>>>>> The btrfs hang you're hitting goes back to 3.15.  So 3.16-rc4 vs rc5
>>>>> shouldn't be a factor.  Are you hitting other problems with 3.16?
>>>>
>>>> So far for this day 3.16-rc4 behaves nicely. With 3.16-rc5 I had a BTRFS
>>>> hang twice yesterday. 3.16-rc4 before also behaved nicely for several
>>>> days
>>>> or well about a week here.
>>>
>>> 3.16-rc4 now hung as well…
>>
>> Liu Bo has a promising patch:
>>
>> https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/4618421/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=CJPREifRDOxlzhYeURx75h33LGU7YemJsNeLP%2FvXCv8%3D%0A&s=8fb0a70afce09530f16ea66a47d2af07966706b21281a7142d86256979013bab
>>
>> Please give it a shot.  There's a second deadlock reading the free space
>> cache, I'm still working on that one too.
> 
> Now running 3.16-rc6 + current git + this patch.
> 
> It may take some time tough cause during compiling the kernel BTRFS hung 
> again, which caused loss of KDE Baloo desktop search file index and parts of a 
> mail I wrote in KMail.
> 
> Since the patch mentioned ENOSPC issues but the filesystem has enough free 
> space according to df I shrunk the trees with

Thanks for giving it a try.  The ENOSPC mentioned here is looking for a
contiguous extent, so it's easily possible to trigger that enospc
without actually being full.

-chris

Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58796 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbcDYBZ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Apr 2016 21:25:27 -0400
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
To: Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160322133812.GK8095@twin.jikos.cz> <56F1FEAF.2070806@cn.fujitsu.com>
 <20160324134217.GP29764@twin.jikos.cz> <56F496AA.9000102@cn.fujitsu.com>
 <20160404165517.GD3412@twin.jikos.cz>
 <CAD=QJKjvKVZTdqVVZJGtve+9teRXgGpv4chY_NV7P5BuFwB1Gw@mail.gmail.com>
 <57049D24.80300@cn.fujitsu.com>
 <CAD=QJKgJ9JAgZAOSivJTL-bcLbdkP6UqGb0i6g=fS9j6XKtcLA@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1071b71a-95b7-0083-6fcb-2e551e64fa46@cn.fujitsu.com>
Date: Mon, 25 Apr 2016 09:25:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAD=QJKgJ9JAgZAOSivJTL-bcLbdkP6UqGb0i6g=fS9j6XKtcLA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Nicholas D Steeves wrote on 2016/04/22 18:14 -0400:
> Hi Qu,
>
> On 6 April 2016 at 01:22, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Nicholas D Steeves wrote on 2016/04/05 23:47 -0400:
>>>
>>> It is unlikely that I will use dedupe, but I imagine your work will
>>> apply tot he following wishlist:
>>>
>>> 1. Allow disabling of memory-backend hash via a kernel argument,
>>> sysctl, or mount option for those of us have ECC RAM.
>>>      * page_cache never gets pushed to swap, so this should be safe, no?
>>
>> And why it's related to ECC RAM? To avoid memory corruption which will
>> finally lead to file corruption?
>> If so, it makes sense.
>
> Yes, my assumption is that a system with ECC will either correct the
> error, or that an uncorrectable event will trigger the same error
> handling procedure as if the software checksum failed.
>
>> Also I didn't get the point when you mention page_cache.
>> For hash pool, we didn't use page cache. We just use kmalloc, which won't be
>> swapped out.
>> For file page cache, it's not affected at all.
>
> My apologies, I'm still very new to this, and my "point" only
> demonstrates my lack of understanding.  Thank you for directing me to
> the kmalloc-related sections.
>
>>> 2. Implementing an intelligent cache so that it's possible to offset
>>> the cost of hashing the most actively read data.  I'm guessing there's
>>> already some sort of weighed cache eviction algorithm in place, but I
>>> don't yet know how to look into it, let alone enough to leverage it...
>>
>>
>> I not quite a fan of such intelligent but complicated cache design.
>> The main problem is we are putting police into kernel space.
>>
>> Currently, either use last-recent-use in-memory backend, or use all-in
>> ondisk backend.
>> For user want more precious control on which file/dir shouldn't go through
>> dedupe, they have the btrfs prop to set per-file flag to avoid dedupe.
>
> I'm looking into a project for some (hopefully) safe,
> low-hanging-fruit read optimisations, and read that
>
> Qu Wenruo wrote on 2016/04/05 11:08 +0800:
>> In-memory backend is much like an experimental field for new ideas,
>> as it won't affect on-disk format at all."
>
> Do you think that last-recent-use in-memory backend could be used in
> this way?  Specifically, I'm wondering the even|odd PID method of
> choosing which disk to read from could be replaced with the following
> method for rotational disks:
>
> The last-recent-use in-memory backend stores the value of last
> allocation group (and/or transaction ID, or something else), with an
> attached value of which disk did the IO.  I imagine it's possible to
> minimize seeks by choosing the disk by getting the absolute value
> difference between requested_location and last-recent-use_location of
> each disk with a simple a static_cast.

For allocation group, did you mean chunk or block group?

>
> Would the addition of that value pair (recent-use_location, disk) keep
> things simple and maybe prove to be useful, or is last-recent-use
> in-memory the wrong place for it?

Maybe I missed something, but it doesn't seem to have something to do 
with inband dedupe.
It looks more like a RAID read optimization.

And I'm not familiar with btrfs RAID, but it seems to be that btrfs 
doesn't have anything smart for balancing bio request.
So it may makes sense.

But you also mentioned "each disk", if you are going to do it at disk 
basis, then it may not make any sense, as we already have block level 
scheduler, which will do bio merge/re-order to improve performance.

It would be better if you can provide a clearer view on what you are 
going to do.
For example, at RAID level or at block device level.

Thanks,
Qu

>
> Thank you for taking the time to reply,
> Nicholas



> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


